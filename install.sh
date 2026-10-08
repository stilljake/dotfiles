#!/usr/bin/env bash
# Symlink these dotfiles into $HOME. Safe to re-run.
# An existing file that isn't already our symlink is moved to <file>.backup.
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

FILES=(
  .zshrc
  .tmux.conf
  .vimrc
  .gitconfig
  .config/git/ignore
  .config/mise/config.toml
)

for f in "${FILES[@]}"; do
  src="$DOTFILES/$f"
  dest="$HOME/$f"
  mkdir -p "$(dirname "$dest")"
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    continue
  fi
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    mv "$dest" "$dest.backup"
    echo "backed up $dest -> $dest.backup"
  fi
  ln -s "$src" "$dest"
  echo "linked $dest"
done
