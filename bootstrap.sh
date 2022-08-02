#!/bin/bash

# Ask for the administrator password upfront
sudo -v

# Install Hombrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Enable homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

brew update
brew upgrade
brew bundle --file Brewfile
brew cleanup

# Install rc files - https://github.com/thoughtbot/rcm
rcup -v -d ~/projects/dotfiles

sh ./macos
