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

# Check if zplug is installed
if [[ ! -d ~/.zplug ]]; then
    git clone https://github.com/chriskjaer/zplug ~/.zplug
    source ~/.zplug/init.zsh && zplug update
else
    source ~/.zplug/init.zsh
fi

__zplug::io::file::generate # speed up zplug. See https://github.com/zplug/zplug/issues/368#issuecomment-282566102

zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug "plugins/git", from:oh-my-zsh
zplug "rupa/z", use:z.sh
# zplug "plugins/asdf", from:oh-my-zsh
zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", from:github, use:pure.zsh, as:theme
zplug "docker/compose", from:github, use:contrib/completion/zsh
zplug "docker/docker", from:github, use:contrib/completion/zsh
zplug "google-cloud-sdk/google-cloud-sdk", from:github, use:completion.zsh.inc
# zplug "google-cloud-sdk/google-cloud-sdk", from:github, use:path.zsh.inc

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
if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh

  # Use ag instead of find
  # respects .gitignore files
  export FZF_DEFAULT_COMMAND='ag -g ""'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

export PATH="$HOME/.yarn/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

export PATH="$HOME/miniconda3/bin:$PATH"
export PATH=$HOME/.local/bin:$PATH

if [ -e $HOME/.local/bin/fnm ]; then
  eval `fnm env`
fi


eval "$(direnv hook zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

eval "$(rbenv init -)"

# AIRLAB-DO-NOT-MODIFY section:ShellWrapper {{{
# Airlab will only make edits inside these delimiters.

# Source Airlab's shell integration, if it exists.
if [ -e ~/.airlab/shellhelper.sh ]; then
  source ~/.airlab/shellhelper.sh
fi
# AIRLAB-DO-NOT-MODIFY section:ShellWrapper }}}
export PATH="/usr/local/sbin:$PATH"
