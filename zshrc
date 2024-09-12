if [ -n "${ZSH_DEBUGRC+1}" ]; then
  zmodload zsh/zprof
fi

# Set the language support
export LANG=en_US.UTF-8
export LC_ALL="${LANG}"
[[ -n "${LC_CTYPE}" ]] && unset LC_CTYPE

# Default editor
export VISUAL=nvim
export EDITOR=$VISUAL

# Use emacs key bindings
bindkey -e
bindkey '^[[1;3C' emacs-forward-word
bindkey '^[[1;3D' emacs-backward-word

## Command history configuration
HISTFILE=$HOME/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups # ignore duplication command history list
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history # share command history data
setopt hist_ignore_all_dups

# Install Zinit if not installed
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
  print -P "%F{33}▓▒░ %F{220}Installing Zinit...%f"
  command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
  command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" &&
    print -P "%F{33}▓▒░ %F{34}Installation successful.%f" ||
    print -P "%F{160}▓▒░ The clone has failed.%f"
fi

# Load Zinit
source "$HOME/.zinit/bin/zinit.zsh"
[[ -v _comps ]] && _comps[zinit]=_zinit

# Load plugins
zi wait lucid for \
  zsh-users/zsh-autosuggestions \
  zdharma-continuum/fast-syntax-highlighting \
  zsh-users/zsh-completions \
  rupa/z \
  djui/alias-tips

zi wait lucid for \
  OMZL::git.zsh \
  OMZP::git

zi ice pick"async.zsh" src"pure.zsh"
zi light sindresorhus/pure

# Load OS-specific configurations
source ~/.zshrc-$(uname | tr '[:upper:]' '[:lower:]')

# Function to source files if they exist
source_if_exists() {
  [[ -f "$1" ]] && source "$1"
}

# Load additional configurations
source_if_exists ~/.aliases
source_if_exists ~/.secrets
source_if_exists "$HOME/.acme.sh/acme.sh.env"

if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh

  # Use rg instead of find
  # respects .gitignore files
  export FZF_DEFAULT_COMMAND='rg --files'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_DEFAULT_OPTS="--height=40% --multi --tiebreak=begin \
    --bind 'ctrl-y:execute-silent(echo {} | pbcopy)' \
    --bind 'alt-down:preview-down,alt-up:preview-up' \
    --bind 'ctrl-v:execute-silent(tmux send-keys -t {left} Escape :vs Space {} Enter)' \
    --bind 'ctrl-x:execute-silent(tmux send-keys -t {left} Escape :sp Space {} Enter)' \
    --bind 'ctrl-o:execute-silent(tmux send-keys -t {left} Escape :read Space ! Space echo Space {} Enter)'"
fi

export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

export PNPM_HOME="$HOME/.pnpm"
export PATH="$PNPM_HOME:$PATH"

if [ -n "${ZSH_DEBUG+1}" ]; then
  zprof
fi
