ZSH=$HOME/.oh-my-zsh
ZSH_THEME="refined"

DISABLE_AUTO_TITLE="true"
COMPLETION_WAITING_DOTS="true"

plugins=(git git-flow brew osx last-working-dir z npm mix)



source ~/.aliases
source ~/.secrets
source $ZSH/oh-my-zsh.sh

# SHELL THEME
BASE16_SHELL_DARK="$HOME/.config/base16-shell/base16-eighties.dark.sh"
BASE16_SHELL_LIGHT="$HOME/.config/base16-shell/base16-solarized.light.sh"
[[ -s $BASE16_SHELL_DARK ]] && source $BASE16_SHELL_DARK

# alias lighten=[[ -s $BASE16_SHELL_LIGHT ]] && source $BASE16_SHELL_LIGHT
# alias darken=[[ -s $BASE16_SHELL_DARK ]] && source $BASE16_SHELL_DARK

# Default editor
export VISUAL=nvim
export EDITOR=$VISUAL

# Path
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

# Android
export ANDROID_HOME=/usr/local/opt/android-sdk
export ANDROID_NDK_HOME=/usr/local/opt/android-ndk
export PATH=$ANDROID_HOME/tools:$PATH
export PATH=$ANDROID_HOME/platform-tools:$PATH
export PATH=$ANDROID_HOME/build-tools/19.1.0:$PATH

# rbenv
export RBENV_ROOT=/usr/local/var/rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# thefuck - https://github.com/nvbn/thefuck
eval $(thefuck --alias)

# aws
source /usr/local/share/zsh/site-functions/_aws

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"


export PATH="$HOME/.yarn/bin:$PATH"
