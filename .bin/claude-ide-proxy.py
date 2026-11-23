#!/usr/bin/env -S uv run --script --quiet
# /// script
# requires-python = ">=3.12"
# dependencies = ["websockets>=15"]
# ///
"""
claude ide server for a tmux window which forwards to the nvims in that window.

claude connects to this proxy once and keeps that connection while nvims come and go so
claude and nvim can start in any order and nvim can restart at any time.
nvim (claudecode.nvim) publishes its server as <port>:<token> in the @claude_ide pane option.
see nvim plugins/claudecode.lua and the claude fish function which starts this proxy.

prints "<port> <pid>" and keeps running in the background until killed or the shell exits.
"""

import asyncio
import json
import os
import secrets
import signal
import socket
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path

from websockets.asyncio.client import ClientConnection, connect
from websockets.asyncio.server import ServerConnection, serve
from websockets.datastructures import Headers
from websockets.exceptions import WebSocketException
from websockets.http11 import Request, Response

OPTION = "@claude_ide"
AUTH_HEADER = "x-claude-code-ide-authorization"
SCAN_SECONDS = 1
# id of the proxy's own selection requests which are not forwarded to claude
SELECTION_ID = "claude-ide-proxy-selection"
SELECTION_AFTER_TOOLS_SECONDS = 1


def tmux(*args: str) -> str:
    return subprocess.run(["tmux", *args], check=False, capture_output=True, text=True).stdout.strip()


def lock_dir() -> Path:
    return Path(os.environ.get("CLAUDE_CONFIG_DIR") or "~/.claude").expanduser() / "ide"


@dataclass(eq=False)
class Nvim:
    pane: str
    port: int
    token: str
    ws: ClientConnection | None = None


class Proxy:
    def __init__(self, pane: str, shell: int, token: str):
        self.window = tmux("display", "-p", "-t", pane, "#{window_id}")
        self.shell = shell
        self.token = token
        self.claude: ServerConnection | None = None
        self.nvims: dict[str, Nvim] = {}
        # claude request id -> nvim answering it so a restarting nvim fails its requests
        self.pending: dict[object, Nvim] = {}
        self.last_selection: str | None = None
        # claude was told there are no tools so it is told again once an nvim connects
        self.listed_no_tools = False
        # claude clears the selection once it is done connecting which is a bit after tools/list
        # so the selection is synced again after that
        self.tools_lists: set[object] = set()

    async def send_claude(self, msg: dict) -> None:
        if self.claude:
            try:
                await self.claude.send(json.dumps(msg))
            except WebSocketException:
                pass

    async def reply(self, id: object, result: dict | None = None, error: str | None = None) -> None:
        msg = {"jsonrpc": "2.0", "id": id}
        if error:
            msg["error"] = {"code": -32000, "message": error}
        else:
            msg["result"] = result
        await self.send_claude(msg)

    async def sync_selection(self, delay: float = 0) -> None:
        """
        claudecode sends the selection only when the cursor moves so claude would not know it
        after claude or an nvim (re)connects until then. nvim answers with SELECTION_ID
        """
        await asyncio.sleep(delay)
        nvim = self.target()
        if not (nvim and nvim.ws):
            # a selection without a file clears the one claude shows from an exited nvim
            empty = {"start": {"line": 0, "character": 0}, "end": {"line": 0, "character": 0}}
            await self.send_claude({"jsonrpc": "2.0", "method": "selection_changed", "params": {"selection": empty}})
            return
        if not self.claude:
            return
        try:
            await nvim.ws.send(
                json.dumps(
                    {
                        "jsonrpc": "2.0",
                        "id": SELECTION_ID,
                        "method": "tools/call",
                        "params": {"name": "getCurrentSelection", "arguments": {}},
                    }
                )
            )
        except WebSocketException:
            pass

    def target(self) -> Nvim | None:
        """nvim in focus, else the one focused before claude, else the last one with a selection"""
        connected = {pane: nvim for pane, nvim in self.nvims.items() if nvim.ws}
        panes = [
            line.split()
            for line in tmux(
                "list-panes", "-t", self.window, "-F", "#{pane_id} #{pane_active} #{pane_last}"
            ).splitlines()
        ]
        for flag in (1, 2):
            for pane in panes:
                if pane[flag] == "1" and pane[0] in connected:
                    return connected[pane[0]]
        if self.last_selection in connected:
            return connected[self.last_selection]
        return next(iter(connected.values()), None)

    async def check_auth(self, _: ServerConnection, request: Request) -> Response | None:
        if not secrets.compare_digest(request.headers.get(AUTH_HEADER, ""), self.token):
            return Response(401, "Unauthorized", Headers())
        return None

    async def from_claude(self, ws: ServerConnection) -> None:
        self.claude = ws
        try:
            async for message in ws:
                msg = json.loads(message)
                id, method = msg.get("id"), msg.get("method")
                if method is None:
                    continue
                if id is None:
                    for nvim in self.nvims.values():
                        if nvim.ws:
                            await nvim.ws.send(message)
                    continue
                if method == "initialize":
                    # answered here as there might be no nvim yet. claudecode needs no initialize
                    await self.reply(
                        id,
                        {
                            "protocolVersion": msg.get("params", {}).get("protocolVersion"),
                            "capabilities": {
                                "logging": {},
                                "prompts": {"listChanged": True},
                                "tools": {"listChanged": True},
                            },
                            "serverInfo": {"name": "claude-ide-proxy", "version": "1"},
                        },
                    )
                    continue
                nvim = self.target()
                if nvim and nvim.ws:
                    self.pending[id] = nvim
                    if method == "tools/list":
                        self.tools_lists.add(id)
                    await nvim.ws.send(message)
                elif method == "tools/list":
                    self.listed_no_tools = True
                    await self.reply(id, {"tools": []})
                elif method == "prompts/list":
                    await self.reply(id, {"prompts": []})
                else:
                    await self.reply(id, error="no nvim in this tmux window")
        finally:
            if self.claude is ws:
                self.claude = None

    async def from_nvim(self, nvim: Nvim) -> None:
        try:
            async with connect(f"ws://127.0.0.1:{nvim.port}", additional_headers={AUTH_HEADER: nvim.token}) as ws:
                nvim.ws = ws
                if self.listed_no_tools:
                    self.listed_no_tools = False
                    await self.send_claude({"jsonrpc": "2.0", "method": "notifications/tools/list_changed"})
                await self.sync_selection()
                async for message in ws:
                    msg = json.loads(message)
                    if msg.get("id") == SELECTION_ID:
                        selection = json.loads(msg.get("result", {}).get("content", [{}])[0].get("text", "{}"))
                        if selection.pop("success", False):
                            self.last_selection = nvim.pane
                            await self.send_claude(
                                {"jsonrpc": "2.0", "method": "selection_changed", "params": selection}
                            )
                    elif "method" not in msg:
                        self.pending.pop(msg.get("id"), None)
                        await self.send_claude(msg)
                        if msg.get("id") in self.tools_lists:
                            self.tools_lists.discard(msg["id"])
                            asyncio.create_task(self.sync_selection(SELECTION_AFTER_TOOLS_SECONDS))
                    else:
                        if msg["method"] == "selection_changed":
                            self.last_selection = nvim.pane
                        await self.send_claude(msg)
        except (OSError, WebSocketException):
            pass
        finally:
            nvim.ws = None
            if self.nvims.get(nvim.pane) is nvim:
                del self.nvims[nvim.pane]
            for id, pending in list(self.pending.items()):
                if pending is nvim:
                    del self.pending[id]
                    await self.reply(id, error="nvim exited")
            # claude still shows the selection of the exited nvim
            await self.sync_selection()

    async def scan(self) -> None:
        """follow the nvims in the window until the shell which started the proxy exits"""
        while True:
            try:
                os.kill(self.shell, 0)
            except ProcessLookupError:
                return
            found = {}
            for line in tmux("list-panes", "-t", self.window, "-F", f"#{{pane_id}} #{{{OPTION}}}").splitlines():
                pane, _, server = line.partition(" ")
                port, _, token = server.partition(":")
                if port.isdigit() and token:
                    found[pane] = (int(port), token)
            for pane, nvim in list(self.nvims.items()):
                if found.get(pane) != (nvim.port, nvim.token) and nvim.ws:
                    await nvim.ws.close()
            for pane, (port, token) in found.items():
                if pane not in self.nvims:
                    nvim = self.nvims[pane] = Nvim(pane, port, token)
                    asyncio.create_task(self.from_nvim(nvim))
            await asyncio.sleep(SCAN_SECONDS)


async def run(proxy: Proxy, sock: socket.socket) -> None:
    loop = asyncio.get_running_loop()
    scan = asyncio.create_task(proxy.scan())
    loop.add_signal_handler(signal.SIGTERM, scan.cancel)
    async with serve(
        proxy.from_claude,
        sock=sock,
        process_request=proxy.check_auth,
        # claude may ask for a subprotocol which claudecode echoes back
        select_subprotocol=lambda _, subprotocols: subprotocols[0] if subprotocols else None,
    ):
        try:
            await scan
        except asyncio.CancelledError:
            pass


def main() -> None:
    shell = int(sys.argv[1])
    token = secrets.token_hex(16)
    proxy = Proxy(os.environ["TMUX_PANE"], shell, token)
    sock = socket.socket()
    sock.bind(("127.0.0.1", 0))
    sock.listen()
    port = sock.getsockname()[1]

    pid = os.fork()
    if pid:
        # claude finds the token of CLAUDE_CODE_SSE_PORT in its lock file
        lock = lock_dir() / f"{port}.lock"
        lock.parent.mkdir(mode=0o700, parents=True, exist_ok=True)
        lock.touch(mode=0o600)
        lock.write_text(
            json.dumps(
                {
                    "pid": pid,
                    "workspaceFolders": [os.getcwd()],
                    "ideName": "Neovim",
                    "transport": "ws",
                    "authToken": token,
                }
            )
        )
        print(port, pid)
        return

    os.setsid()
    devnull = os.open(os.devnull, os.O_RDWR)
    for fd in (0, 1, 2):
        os.dup2(devnull, fd)
    try:
        asyncio.run(run(proxy, sock))
    finally:
        (lock_dir() / f"{port}.lock").unlink(missing_ok=True)


if __name__ == "__main__":
    main()
