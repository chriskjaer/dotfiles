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
if [ -z "$HISTFILE" ]; then
    HISTFILE=$HOME/.zsh_history
fi

HISTSIZE=10000
SAVEHIST=10000

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

# Load zplug
[[ -r "${HOME}/.zplug/init.zsh" ]] || git clone https://github.com/zplug/zplug.git "${HOME}/.zplug"
source "${HOME}/.zplug/init.zsh"

__zplug::io::file::generate # speed up zplug. See https://github.com/zplug/zplug/issues/368#issuecomment-282566102

zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/z", from:oh-my-zsh
zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", from:github, use:pure.zsh, as:theme

case `uname` in
  Darwin)
    source ~/.zshrc-darwin
  ;;
  Linux)
    source ~/.zshrc-linux
  ;;
esac

zplug check || zplug install # Install if not installed
zplug load

[ -f ~/.aliases ] && source ~/.aliases
[ -f ~/.secrets ] && source ~/.secrets
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH="$HOME/.yarn/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

