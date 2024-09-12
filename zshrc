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

# Show history
case $HIST_STAMPS in
"mm/dd/yyyy") alias history='fc -fl 1' ;;
"dd.mm.yyyy") alias history='fc -El 1' ;;
"yyyy-mm-dd") alias history='fc -il 1' ;;
*) alias history='fc -l 1' ;;
esac

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
zi light zsh-users/zsh-autosuggestions
zi light zdharma-continuum/fast-syntax-highlighting
zi light zsh-users/zsh-completions
zi light rupa/z
zi light djui/alias-tips

zi snippet OMZ::plugins/git/git.plugin.zsh

zi ice pick"async.zsh" src"pure.zsh"
zi light sindresorhus/pure

case $(uname) in
Darwin)
  source ~/.zshrc-darwin
  ;;
Linux)
  source ~/.zshrc-linux
  ;;
esac

# Load additional configurations
[ -f ~/.aliases ] && source ~/.aliases
[ -f ~/.secrets ] && source ~/.secrets
if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh

  # Use rg instead of find
  # respects .gitignore files
  export FZF_DEFAULT_COMMAND='rg ""'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

export PATH="$HOME/.yarn/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

export FZF_DEFAULT_OPTS="--height=40% --multi --tiebreak=begin \
  --bind 'ctrl-y:execute-silent(echo {} | pbcopy)' \
  --bind 'alt-down:preview-down,alt-up:preview-up' \
  --bind \"ctrl-v:execute-silent[ \
    tmux send-keys -t \{left\} Escape :vs Space && \
    tmux send-keys -t \{left\} -l {} && \
    tmux send-keys -t \{left\} Enter \
  ]\"
  --bind \"ctrl-x:execute-silent[ \
    tmux send-keys -t \{left\} Escape :sp Space && \
    tmux send-keys -t \{left\} -l {} && \
    tmux send-keys -t \{left\} Enter \
  ]\"
  --bind \"ctrl-o:execute-silent[ \
    tmux send-keys -t \{left\} Escape :read Space ! Space echo Space && \
    tmux send-keys -t \{left\} -l \\\"{}\\\" && \
    tmux send-keys -t \{left\} Enter \
  ]\""

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

if [ -f "$HOME/.acme.sh/acme.sh.env" ]; then
  . "$HOME/.acme.sh/acme.sh.env"
fi

export PNPM_HOME="$HOME/.pnpm"

export PATH="$PNPM_HOME:$PATH"
. "/Users/chriskjaer/.acme.sh/acme.sh.env"

# Arrow
export LIBRARY_PATH="$LIBRARY_PATH:/opt/homebrew/opt/apache-arrow/lib"
export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/apache-arrowlib"
export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/apache-arrow/include"

export LIBRARY_PATH="$LIBRARY_PATH:/opt/homebrew/opt/apache-arrow-glib/lib"
export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/apache-arrowlib-glib/lib"
export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/apache-arrow-glib/include"

if [ -n "${ZSH_DEBUG+1}" ]; then
  zprof
fi
