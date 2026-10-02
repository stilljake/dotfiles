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

# Homebrew (sets PATH, HOMEBREW_PREFIX, etc.)
eval "$(/opt/homebrew/bin/brew shellenv)"

# Custom $PATH with extra locations (~/bin is where tfswitch puts terraform).
export PATH="$HOME/.local/bin:$HOME/bin:$HOME/go/bin:$PATH"

# History: keep a lot more than the macOS default of 1000 lines.
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt INC_APPEND_HISTORY HIST_IGNORE_DUPS

# Tell homebrew to not autoupdate every single time I run it (just once a week).
export HOMEBREW_AUTO_UPDATE_SECS=604800

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
alias src="cd ~/src/"
alias ra="cd ~/src/ra/"
alias ..='cd ..'

# AWS profile aliases (switch profile and show who I am).
alias aws-stg='export AWS_PROFILE=staging; aws sts get-caller-identity'
alias aws-prod='export AWS_PROFILE=production; aws sts get-caller-identity'
alias aws-prod-admin='export AWS_PROFILE=production-admin; aws sts get-caller-identity'

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
#  tmux new-window -t "$session" -c "$dir" -n "k9s"
#  tmux send-keys -t "$session:3" "k9s" C-m

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

# zsh Plugins (installed via Homebrew)
source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Configure zsh-autosuggestions
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=5'

# mise: per-project tool versions (node etc.) from .tool-versions / .nvmrc / mise.toml
eval "$(mise activate zsh)"

# fzf & zoxide
source <(fzf --zsh)
eval "$(zoxide init zsh)"

alias cdf='cd "$(find . -type d 2>/dev/null | fzf)"'
