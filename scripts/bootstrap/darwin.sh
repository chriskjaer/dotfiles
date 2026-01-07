#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Ask for the administrator password upfront
sudo -v

# Install Hombrew
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Enable homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

brew update
brew upgrade
brew bundle --file "$ROOT_DIR/macos/Brewfile"
brew cleanup

# Install rc files - https://github.com/thoughtbot/rcm
RCRC="$ROOT_DIR/rcrc" rcup -v

bash "$ROOT_DIR/scripts/macos.sh"
