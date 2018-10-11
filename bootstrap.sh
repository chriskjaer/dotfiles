#!/bin/bash

# Ask for the administrator password upfront
sudo -v

# Install Hombrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew update
brew upgrade
brew bundle
brew cleanup

# Install rc files - https://github.com/thoughtbot/rcm
rcup
