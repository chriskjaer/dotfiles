#!/bin/bash
# Install Hombrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install brew taps, needs to be fixed properly later
while read in; do brew tap "$in"; done < Taps

# Install brews
brew install $(cat Brewfile|grep -v "#")

# Install casks
brew cask install $(cat Caskfile|grep -v "#")

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
