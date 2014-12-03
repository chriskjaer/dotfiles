# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="chriskjaer"

source ~/.aliases

DISABLE_AUTO_TITLE="true"

COMPLETION_WAITING_DOTS="true"

# Plugins can be found in ~/.oh-my-zsh/plugins/*)
plugins=(git git-flow brew sublime osx last-working-dir z npm)

source $ZSH/oh-my-zsh.sh

# use vim as the visual editor
export VISUAL=vim
export EDITOR=$VISUAL

# Customize to your needs...
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

# Android
export ANDROID_HOME=/usr/local/opt/android-sdk

# Rbenv
export RBENV_ROOT=/usr/local/var/rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# $(boot2docker shellinit)
