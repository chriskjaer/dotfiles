#!/bin/bash

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install Hombrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew update
brew tap Homebrew/bundle
brew bundle
brew cleanup

# Install shell themes
git clone https://github.com/chriskempson/base16-shell.git $HOME/.config/base16-shell

# Install oh-my-sh
curl -L http://install.ohmyz.sh | sh

# Install rc files - https://github.com/thoughtbot/rcm
rcup

# Node
npm install -g n
n latest # latest node
npm install -g npm # make sure we have lastest npm before we do anything
npm install -g standard eslint-config-standard eslint-plugin-standard

# Ruby
LATEST_RUBY=$(rbenv install -l | grep -v - | tail -1)
rbenv install $LATEST_RUBY
rbenv global $LATEST_RUBY
rbenv rehash
gem install bundler git-up


# Install osx settings
source './osx'
