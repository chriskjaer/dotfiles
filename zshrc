# Set the language support
export LANG=en_US.UTF-8
export LC_ALL="${LANG}"
[[ -n "${LC_CTYPE}" ]] && unset LC_CTYPE



### ---------------------------------------------------------------------------
### ZPLUG
### ---------------------------------------------------------------------------

# Load zplug
[[ -r "${HOME}/.zplug/init.zsh" ]] || git clone https://github.com/zplug/zplug.git "${HOME}/.zplug"
source "${HOME}/.zplug/init.zsh"

# speed up zplug. See https://github.com/zplug/zplug/issues/368#issuecomment-282566102
__zplug::io::file::generate

# let zplug manage itself
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug "plugins/git", from:oh-my-zsh
zplug "plugins/z", from:oh-my-zsh
zplug "plugins/osx", from:oh-my-zsh
zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", from:github, use:pure.zsh, as:theme

# Install if not installed
zplug check || zplug install

# Then, source plugins and add commands to $PATH
zplug load



### --------------------------------------------------------------------------



source ~/.aliases
source ~/.secrets

# SHELL THEME
BASE16_SHELL_DARK="$HOME/.config/base16-shell/base16-eighties.dark.sh"
BASE16_SHELL_LIGHT="$HOME/.config/base16-shell/base16-solarized.light.sh"
[[ -s $BASE16_SHELL_DARK ]] && source $BASE16_SHELL_DARK

# Default editor
export VISUAL=nvim
export EDITOR=$VISUAL

# Path
# export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH";

# Android
export ANDROID_HOME=/usr/local/opt/android-sdk
export ANDROID_NDK_HOME=/usr/local/opt/android-ndk
export PATH=$ANDROID_HOME/tools:$PATH
export PATH=$ANDROID_HOME/platform-tools:$PATH
export PATH=$ANDROID_HOME/build-tools/19.1.0:$PATH

# rbenv
# export RBENV_ROOT=/usr/local/var/rbenv
# if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# Yarn
export PATH="$HOME/.yarn/bin:$PATH"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# aws
source /usr/local/share/zsh/site-functions/_aws

# Use emacs key bindings
bindkey -e

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

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

