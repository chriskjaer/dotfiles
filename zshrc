# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="pure"

source ~/.aliases
source ~/.secrets

DISABLE_AUTO_TITLE="true"

COMPLETION_WAITING_DOTS="true"

# base-16
BASE16_SHELL="$HOME/.config/base16-shell/base16-eighties.dark.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

# Plugins can be found in ~/.oh-my-zsh/plugins/*)
plugins=(git git-flow brew sublime osx last-working-dir z npm)

source $ZSH/oh-my-zsh.sh

# use vim as the visual editor
export VISUAL=nvim
export EDITOR=$VISUAL

# Customize to your needs...
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

# Emacs Cask
export PATH="$HOME/.cask/bin:$PATH"

# Android
export ANDROID_HOME=/usr/local/opt/android-sdk

# Rbenv
export RBENV_ROOT=/usr/local/var/rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# thefuck
eval $(thefuck --alias)

# aws
source /usr/local/share/zsh/site-functions/_aws
