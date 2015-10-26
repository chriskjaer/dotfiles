ZSH=$HOME/.oh-my-zsh
ZSH_THEME="pure"

DISABLE_AUTO_TITLE="true"
COMPLETION_WAITING_DOTS="true"

plugins=(git git-flow brew osx last-working-dir z npm)

source ~/.aliases
source ~/.secrets
source $ZSH/oh-my-zsh.sh

# SHELL THEME
BASE16_SHELL="$HOME/.config/base16-shell/base16-eighties.dark.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

# Default editor
export VISUAL=nvim
export EDITOR=$VISUAL

# Path
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

# Android
export ANDROID_HOME=/usr/local/opt/android-sdk

# rbenv
export RBENV_ROOT=/usr/local/var/rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# thefuck - https://github.com/nvbn/thefuck
eval $(thefuck --alias)

# aws
source /usr/local/share/zsh/site-functions/_aws

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

