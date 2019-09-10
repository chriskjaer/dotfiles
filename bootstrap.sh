#!/bin/bash

# Ask for the administrator password upfront
sudo -v

# Install Hombrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew update
brew upgrade
brew bundle --file="./Brewfile"
brew cleanup

pip install neovim
pip3 install neovim
yarn global add neovim

# Install rc files - https://github.com/thoughtbot/rcm
rcup -v -d ~/projects/dotfiles

sh ./macos
