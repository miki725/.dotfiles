# Clipboard

How copy and paste reach the macOS clipboard from nvim and tmux, locally and over ssh,
with or without tmux on either side.

## Pieces

| Piece | Config | Role |
|---|---|---|
| Ghostty | `.config/ghostty/config` | the only thing that touches the macOS clipboard. answers OSC 52 reads (`clipboard-read = allow`), accepts OSC 52 writes (default) |
| tmux | `.tmux.conf` | relays OSC 52 between programs in panes and the terminal it is attached to |
| nvim | `.config/nvim/plugin/clipboard.lua` | `pbcopy`/`pbpaste` locally, OSC 52 over ssh (`SSH_TTY`/`SSH_CLIENT` set) |
| tmux-yank | `.tmux.conf` plugin | copy mode `y` / mouse selection. locally pipes to `pbcopy` |
| ssh / `tosh` | `.config/fish/functions/tosh.fish` | carries the escape sequences both ways untouched |

OSC 52 is a terminal escape sequence: `ESC ]52;c;<base64>` writes the clipboard,
`ESC ]52;c;?` asks for it and the terminal replies with `ESC ]52;c;<base64>`.

## Diagram

```
  macOS clipboard
        ▲ │
        │ │  write / read
        │ ▼
 ┌──────────────────────────────┐
 │ Ghostty                      │  clipboard-read = allow
 └──────────────────────────────┘
        ▲ │
 OSC 52 │ │ OSC 52 reply
  copy, │ │
  paste │ ▼
 ┌──────────────────────────────┐   (optional)
 │ tmux on the mac              │   set-clipboard on        copy: make a buffer and forward outward
 │                              │   get-clipboard request   paste: ask outward and relay the reply back
 └──────────────────────────────┘
        ▲ │
        │ │   ssh (or tosh <host>) - bytes pass through as is
        │ ▼
 ┌──────────────────────────────┐   (optional)
 │ tmux on the server           │   same .tmux.conf, same two settings.
 │                              │   detects the outer tmux (tmux 3.8) as clipboard capable
 └──────────────────────────────┘
        ▲ │
        │ │
        │ ▼
 ┌──────────────────────────────┐
 │ nvim on the server           │   "+y  -> OSC 52 write
 │ g:clipboard = OSC 52         │   "+p  -> OSC 52 read, waits up to 10s for the reply
 └──────────────────────────────┘


 nvim on the mac (with or without tmux) does not use OSC 52:

 ┌──────────┐  pbcopy / pbpaste   ┌─────────────────┐
 │ nvim     │ ──────────────────▶ │ macOS clipboard │
 └──────────┘                     └─────────────────┘
```

Each tmux in the chain does the same thing, so any number of them nest:

- **copy** - `set-clipboard on`: keep the text as a paste buffer and send the OSC 52 write
  to the terminal the client is attached to (Ghostty or an outer tmux).
- **paste** - `get-clipboard request`: send the read to the most recently used client's
  terminal and pass the reply back to the program which asked.
  The default `buffer` answers with the newest tmux paste buffer instead and never asks
  the terminal - and does not answer at all when there are no buffers.
- **forwarding** needs the outer terminal to support the clipboard (`clipboard` in
  `#{client_termfeatures}`). tmux enables it for `xterm*` (Ghostty uses `TERM=xterm-256color`)
  and, since it identifies the outer terminal, for tmux 3.8 as well.
  `terminal-features ',tmux*:clipboard'` only matters with older tmux.
- `allow-passthrough` is **not** involved. it is for sequences wrapped in `ESC Ptmux;`
  (e.g. snacks.image), nvim sends plain OSC 52 which tmux handles itself.

## Verified

Tested 2026-11-17 with Ghostty 1.4.0, tmux 3.8 and nvim 0.12.6 on both ends: marker on
the mac clipboard, `"+` paste in nvim, `"+` copy in nvim, check the mac clipboard.

| mac | server | paste | copy |
|---|---|---|---|
| no tmux | no tmux | ✅ | ✅ |
| no tmux | tmux | ✅ | ✅ |
| tmux | no tmux | ✅ | ✅ |
| tmux | tmux | ✅ (49 KB multi-line identical) | ✅ |
| no tmux | – local nvim | ✅ pbpaste | ✅ pbcopy |
| tmux | – local nvim | ✅ pbpaste | ✅ pbcopy |

With `get-clipboard buffer` on either tmux, paste hangs for 10s and returns nothing.

## Troubleshooting

- **`Waiting for OSC 52 response from the terminal`** - some tmux in the chain does not
  forward reads. a long running server keeps old settings after pulling dotfiles: reload
  with `prefix r` (or `tmux source ~/.tmux.conf`) and check with `tmux show -s get-clipboard`.
- **paste gives old tmux content instead of the mac clipboard** - same cause, that tmux
  is answering from its buffer.
- **check what tmux thinks of its terminal** - `tmux display -p '#{client_termtype} #{client_termfeatures}'`
  must list `clipboard`.
- **nvim not using OSC 52 over ssh** - `:lua =vim.g.clipboard` should show `OSC 52`.
  it is chosen from `SSH_TTY`/`SSH_CLIENT`, which tmux panes inherit from the
  environment the server was started in.

## References

- **OSC 52** - xterm control sequences, "Operating System Commands", `Ps = 5 2`:
  <https://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h3-Operating-System-Commands>
- **Ghostty**
  - [`clipboard-read`](https://ghostty.org/docs/config/reference#clipboard-read)
  - [`clipboard-write`](https://ghostty.org/docs/config/reference#clipboard-write)
  - [`term`](https://ghostty.org/docs/config/reference#term)
- **tmux**
  - [`set-clipboard`](https://man.openbsd.org/tmux#set-clipboard)
  - [`get-clipboard`](https://man.openbsd.org/tmux#get-clipboard)
  - [`terminal-features`](https://man.openbsd.org/tmux#terminal-features__)
  - [`allow-passthrough`](https://man.openbsd.org/tmux#allow-passthrough)
  - [Clipboard wiki](https://github.com/tmux/tmux/wiki/Clipboard)
- **nvim**
  - [`clipboard-osc52`](https://neovim.io/doc/user/provider/#clipboard-osc52)
  - [`'clipboard'`](https://neovim.io/doc/user/options/#'clipboard')
