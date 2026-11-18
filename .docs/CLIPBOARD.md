# Clipboard

How copy and paste reach the macOS clipboard from nvim and tmux, locally and over ssh,
with or without tmux on either side, in Ghostty (full support) and WezTerm (no clipboard reads).

## Pieces

| Piece | Config | Role |
|---|---|---|
| terminal | `.config/ghostty/config` | the only thing that touches the macOS clipboard. Ghostty answers OSC 52 reads (`clipboard-read = allow`) and accepts writes. WezTerm accepts writes but never answers reads |
| tmux | `.tmux.conf` | relays OSC 52 between programs in panes and the terminal it is attached to. keeps every copy as a paste buffer |
| nvim | `.config/nvim/plugin/clipboard.lua` | `pbcopy`/`pbpaste` locally, OSC 52 over ssh (`SSH_TTY`/`SSH_CLIENT` set). only `"+` is synced (`clipboard=unnamedplus`) |
| tmux-yank | `.tmux.conf` plugin | copy mode `y` / mouse selection. locally pipes to `pbcopy` |
| ssh / `tosh` | `.config/fish/functions/tosh.fish` | carries the escape sequences both ways untouched |

OSC 52 is a terminal escape sequence: `ESC ]52;c;<base64>` writes the clipboard,
`ESC ]52;c;?` asks for it and the terminal replies with `ESC ]52;c;<base64>`.

A headless server has no system clipboard of its own (no X11/Wayland, so `xclip` has nowhere
to store anything). The mac clipboard is the only real clipboard and tmux buffers are the
only shared copy store on the server.

## Diagram

```
  macOS clipboard
        ▲ │
        │ │  write / read
        │ ▼
 ┌──────────────────────────────┐
 │ terminal                     │  Ghostty: answers reads (clipboard-read = allow)
 │                              │  WezTerm: never answers reads
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
 │                              │   detects the outer tmux (tmux 3.8) as clipboard capable.
 │  paste buffers ◀─────────────┼── every copy from tmux and from nvim in it
 └──────────────────────────────┘
        ▲ │
        │ │
        │ ▼
 ┌──────────────────────────────┐
 │ nvim on the server           │   "+y  -> OSC 52 write
 │ g:clipboard = OSC 52         │   "+p  -> OSC 52 read once the terminal answered,
 │                              │          otherwise newest tmux buffer or unnamed register
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
  `#{client_termfeatures}`). tmux enables it for `xterm*` (both terminals use `TERM=xterm-256color`)
  and, since it identifies the outer terminal, for tmux 3.8 as well.
  `terminal-features ',tmux*:clipboard'` only matters with older tmux.
- `allow-passthrough` is **not** involved. it is for sequences wrapped in `ESC Ptmux;`
  (e.g. snacks.image), nvim sends plain OSC 52 which tmux handles itself.

## nvim paste over ssh

nvim's OSC 52 paste waits up to 10s for a reply. A terminal which never answers reads
(WezTerm) would stall every `p`, as `unnamedplus` makes every put a clipboard read.
nobody along the chain answers for it: tmux in `request` mode forwards and waits too.

So nvim sends one clipboard read on start (`UIEnter`) without waiting for it. Once a reply
arrives it reads the terminal clipboard on paste, until then `p` pastes:

1. the newest tmux buffer when nvim runs inside tmux. it is the latest copy from either tmux
   (copy mode, mouse) or nvim (tmux keeps OSC 52 copies as buffers). a buffer ending with a
   newline pastes as whole lines, so `yy` then `p` still puts a line below
2. otherwise nvim's unnamed register (last yank/delete in nvim). `<leader>cf` and friends set
   it too as `setreg("+")` alone does not

`"+` itself cannot be the fallback: with a provider set nvim keeps no copy of it, reading it
calls the provider.

The terminal can not be told apart from `TERM` (both use `xterm-256color`, `tmux-256color`
inside tmux), `TERM_PROGRAM` is not sent over ssh and becomes `tmux` in tmux, and terminal
name queries are answered by the nearest tmux. Asking for the clipboard is the only check
which works through any nesting.

Copying is the same everywhere. `Cmd+V` always pastes the mac clipboard (the terminal types it).

| nvim | terminal | tmux on server | `p` pastes |
|---|---|---|---|
| mac | any | – | mac clipboard (pbpaste) |
| server | Ghostty | any | mac clipboard |
| server | WezTerm | yes | newest tmux buffer on the server |
| server | WezTerm | no | nvim's unnamed register |

tmux on the mac does not change this. nvim on the server cannot read its buffers, so copies
made in tmux on the mac reach nvim on the server only with `Cmd+V` / `prefix ]` in WezTerm.

yanky (`.config/nvim/lua/plugins/yanky.lua`) is not involved: it only keeps yank history for
the `<leader>y` picker, its clipboard sync is off as it would read `"+`.

## Verified

Tested 2026-11-17 with Ghostty 1.4.0, WezTerm, tmux 3.8 and nvim 0.12.6 on both ends:
marker on the mac clipboard, `"+` paste in nvim, copy in tmux, `yy` then `p`, `"+` copy in
nvim, check the mac clipboard.

| terminal | mac | server | paste | after tmux copy | `yy` `p` | copy to mac |
|---|---|---|---|---|---|---|
| Ghostty | no tmux | no tmux | ✅ mac clipboard | – | ✅ | ✅ |
| Ghostty | no tmux | tmux | ✅ mac clipboard | ✅ | ✅ | ✅ |
| Ghostty | tmux | no tmux | ✅ mac clipboard | – | ✅ | ✅ |
| Ghostty | tmux | tmux | ✅ mac clipboard (49 KB multi-line identical) | ✅ | ✅ | ✅ |
| WezTerm | no tmux | no tmux | unnamed register, 0ms | – | ✅ | ✅ |
| WezTerm | no tmux | tmux | tmux buffer, 6ms | ✅ | ✅ | ✅ |
| WezTerm | tmux | tmux | tmux buffer, 6ms | ✅ | ✅ | ✅ |
| either | no tmux | – local nvim | ✅ pbpaste | – | ✅ | ✅ pbcopy |
| either | tmux | – local nvim | ✅ pbpaste | – | ✅ | ✅ pbcopy |

No paste took over 25ms. Each nvim yank makes one tmux buffer.
With `get-clipboard buffer` on either tmux, paste in Ghostty hangs for 10s and returns nothing.

## Troubleshooting

- **`Waiting for OSC 52 response from the terminal`** - nvim believes the terminal answers
  but nothing replies:
  - some tmux in the chain does not forward reads. a long running server keeps old settings
    after pulling dotfiles: reload with `prefix r` (or `tmux source ~/.tmux.conf`) and check
    with `tmux show -s get-clipboard`.
  - nvim started from Ghostty and the tmux was reattached from WezTerm. nvim only checks on
    start, restart it.
- **paste gives old tmux content instead of the mac clipboard in Ghostty** - that tmux
  answers from its buffer, same fix as above.
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
