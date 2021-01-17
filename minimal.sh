#!/bin/sh


# OS settings

defaults write NSGlobalDomain AppleKeyboardUIMode -int 3  # make tab key able to move focus

# increase key repeat
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15



defaults write -g com.apple.trackpad.scaling 8.5  # set trackpad speed
defaults write -g com.apple.mouse.scaling 8.5  # set mouse speed
defaults write -g com.apple.mouse.tapBehavior -int 1 # when tapping, let it click

## Three finger drag
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true && \
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true


defaults write com.apple.screencapture type jpg # save screanshot as jpg extension
defaults write com.apple.finder AppleShowAllFiles YES  # show hidden files in finder
defaults write com.apple.dock autohide -bool true  # Automatically hide or show the Dock
defaults write com.apple.dock persistent-apps -array  # Wipe all app icons from the Dock
defaults write com.apple.dock magnification -bool true  # Magnificate the Dock

# resstart these apps for applying above settings
killall Finder
killall Dock


sudo shutdown -r now # restart once to activate above setings


# install homebrew if not installed
if [ ! -e /usr/local/bin/brew ]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

if [ -f ~/.zshrc ]; then
  echo export HOMEBREW_CASK_OPTS="--appdir=/Applications" >> ~/.zshrc
else
  touch ~/.zshrc
  echo export HOMEBREW_CASK_OPTS="--appdir=/Applications" >> ~/.zshrc
fi


# install desktop apps
brew install google-japanese-ime --cask
brew install chrome --cask
brew install slack --cask
brew install zoomus --cask