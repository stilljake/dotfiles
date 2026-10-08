# dotfiles

My shell, editor and tool config. `./install.sh` symlinks everything into `$HOME` (existing files are moved to `<file>.backup`).

| File | What |
|---|---|
| `.zshrc` | Prompt, aliases, history, zsh plugins, fzf, zoxide, mise |
| `.tmux.conf` | `C-a` prefix, mouse scrolling, vi copy mode |
| `.vimrc` | Minimal vim settings (nvim config lives in [kickstart.nvim](https://github.com/stilljake/kickstart.nvim)) |
| `.gitconfig`, `.config/git/ignore` | Git identity and global ignores |
| `.config/mise/config.toml` | Global tool versions (node LTS) |

Claude Code config is in its own private repo, cloned to `~/.claude`.

The `.zshrc` expects the Homebrew packages installed by [setup-my-mac](https://github.com/stilljake/setup-my-mac).
