# .zshrc


# Nicer prompt.
function parse_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/[\1]/p'
}
COLOR_DEF=$'%F{white}'
COLOR_DIR=$'%{\e[38;5;243m%}'
COLOR_GIT=$'%F{blue}'
setopt PROMPT_SUBST
export PROMPT='${COLOR_DIR}%~ ${COLOR_GIT}$(parse_git_branch)${COLOR_DEF} $ '

# Case insensitive
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
autoload -Uz compinit && compinit
setopt MENU_COMPLETE

# Custom $PATH with extra locations.
export PATH="/opt/homebrew/bin:$HOME/bin:/usr/local/bin:$HOME/go/bin:$PATH"

# Tell homebrew to not autoupdate every single time I run it (just once a week).
export HOMEBREW_AUTO_UPDATE_SECS=604800

# Set architecture-specific brew share path.
arch_name="$(uname -m)"
if [ "${arch_name}" = "x86_64" ]; then
    share_path="/usr/local/share"
elif [ "${arch_name}" = "arm64" ]; then
    share_path="/opt/homebrew/share"
else
    echo "Unknown architecture: ${arch_name}"
fi

# Git aliases.
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gs='git status'
alias gc='git commit'
alias gp='git pull --rebase'
alias gcam='git commit -am'
alias gl='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'

# navigation aliases
alias dev="cd ~/Development/"
alias ..='cd ..'

# Enter a running Docker container.
function denter() {
 if [[ ! "$1" ]] ; then
     echo "You must supply a container ID or name."
     return 0
 fi

 docker exec -it $1 bash
 return 0
}

# Setup tmux workspace
# Add to ~/.zshrc

ws() {
  local session="${1:?Usage: ws <session-name> [working-dir]}"
  local dir="${2:-$(pwd)}"

  # If session already exists, just attach
  if tmux has-session -t "$session" 2>/dev/null; then
    tmux attach -t "$session"
    return 0
  fi

  # Window 1: Claude
  tmux new-session -d -s "$session" -c "$dir" -n "claude"
  tmux send-keys -t "$session:1" "claude" C-m

  # Window 2: nvim (full screen)
  tmux new-window -t "$session" -c "$dir" -n "editor"
  tmux send-keys -t "$session:2" "nvim ." C-m

  # Window 3: k9s (full screen)
  tmux new-window -t "$session" -c "$dir" -n "k9s"
  tmux send-keys -t "$session:3" "k9s" C-m

  # Start on window 1 (claude + shell)
  tmux select-window -t "$session:1"
  tmux select-pane -t "$session:1.1"

  tmux attach -t "$session"
}

# Delete a given line number in the known_hosts file.
knownrm() {
 re='^[0-9]+$'
 if ! [[ $1 =~ $re ]] ; then
   echo "error: line number missing" >&2;
 else
   sed -i '' "$1d" ~/.ssh/known_hosts
 fi
}

# zsh Plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Configure zsh-autosuggestions
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=5'

# Pyenv
eval "$(pyenv virtualenv-init -)"
eval "$(pyenv init -)"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/shims:$PATH"

# fzf & zoxide
source <(fzf --zsh)
eval "$(zoxide init zsh)"

alias cdf='cd "$(find . -type d 2>/dev/null | fzf)"'

export PATH="$HOME/.local/bin:$PATH"
