# Overview

My dotfile.
For now, actively used

- Zshrc
- Kitty
- Neovim (NvChad v3 & Lazy.nvim)
- Scripts(Installed to CrossPlatform's bin path) which is frequently used

Additionally contains
- Alacritty
- tmux
- Vim env
- Zellij


# Why this stack
- Fast, visual terminal (Kitty): GPU‑accelerated, image previews (icat), smooth cursor trail.
- Modern editor (NvChad v3 on Neovim): IDE‑like UX with LSP, Treesitter, and Lazy for plugins.
- Ergonomic shell (Zsh + Oh‑My‑Zsh): Clean agnoster prompt, syntax highlighting, autosuggestions.
- Looks right everywhere (Nerd/Powerline fonts): Consistent icons and ligatures across tools.
- Multiplexing when you need it (tmux/Zellij): Stable sessions, split panes, remote‑friendly workflows.
- One‑command bootstrap: Reproducible macOS/Linux setup for the same experience on every machine.
- Opinionated but extensible: Sensible defaults you can tweak without fighting the config.


# Install

```bash
# macOS or Linux
git clone https://github.com/nolleh/dotfiles ~/.dotfiles
cd ~/.dotfiles
./install
```

**What you get**: Kitty terminal, Neovim (NvChad v3), Zsh + Oh‑My‑Zsh, syntax highlighting, autosuggestions, Nerd/Powerline fonts, tmux, Git config, and extras.

**Cross‑platform**: `./install` detects your OS and applies the right steps (macOS via Homebrew; Linux via distro‑specific routines under `os/`).

**Re‑run anytime**: Safe to run again to re‑apply updates or on a new machine.

Optional: set your terminal font to a Nerd Font (e.g., JetBrains Mono Nerd Font). If you see broken glyphs, add `export LANG=en_US.UTF-8` to your shell.

---

## Neovim/NvChad — one‑step LSP and IDE features

### LSP: install in one go

**Interactive**:
```vim
:Mason
```
- Install servers (examples): `lua-language-server`, `pyright`, `tsserver`, `gopls`, `rust-analyzer`.
- Also add formatters/linters: `stylua`, `prettierd`, `eslint_d`, `black`, `shfmt`.

**Non‑interactive** (common stack):
```bash
# Install popular LSPs + formatters via Mason in one shot
nvim --headless "+MasonInstall lua-language-server pyright tsserver gopls rust-analyzer \
stylua prettierd eslint_d black shfmt" +"qa"
```

LSP will autoload on filetype; no manual config needed.

### What you get out of the box

- **LSP‑ready IDE**: diagnostics, code actions, rename, hover, symbols, inlay hints.
- **Treesitter syntax + folding**: accurate highlighting, structural motions.
- **Formatting on save**: routes through `none-ls`/`lsp` if a formatter is installed.
- **Project‑aware**: per‑project config picks local tools if present.
- **Lazy plugin mgmt**: fast startup, async installs, `:Lazy` UI.

### Daily keys (defaults in this setup)

- **Go to**: `gd` definition, `gr` references, `gD` declaration, `gi` implementation.
- **Docs**: `K` hover.
- **Rename**: `<leader>rn`
- **Code actions**: `<leader>ca`
- **Diagnostics**: `[d` / `]d` prev/next, `<leader>e` open float
- **Format**: `<leader>f` (or on save if enabled)
- **Search**: `<leader>ff` files, `<leader>fg` live grep
- Open plugin UIs: `:Mason`, `:Lazy`, `:LspInfo`

### Recommended language packs

```bash
# Web/TS
nvim --headless "+MasonInstall tsserver eslint_d prettierd" +"qa"
# Python
nvim --headless "+MasonInstall pyright black" +"qa"
# Go
nvim --headless "+MasonInstall gopls golangci-lint" +"qa"
# Rust
nvim --headless "+MasonInstall rust-analyzer" +"qa"
# Lua (for Neovim config)
nvim --headless "+MasonInstall lua-language-server stylua" +"qa"
```

### Tips

- If icons look wrong, set your terminal to a Nerd Font and `export LANG=en_US.UTF-8`.
- Re‑run `:Mason` anytime to add tools; no extra config files needed.
