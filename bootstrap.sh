#!/bin/bash
# Install Hombrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew tap Homebrew/bundle
brew bundle

# Install latest npm
npm install -g n

# Install lastest node
n latest

# Install latest npm
npm install -g npm

# Global npm modules
npm install -g standard eslint-config-standard eslint-plugin-standard

# Global Gems
gem install bundler git-up

# Install shell themes
git clone https://github.com/chriskempson/base16-shell.git $HOME/.config/base16-shell

# Install rc files - https://github.com/thoughtbot/rcm
rcup

# Install oh-my-sh
curl -L http://install.ohmyz.sh | sh

# Install osx settings
source './osx'
