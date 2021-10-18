#!/bin/sh


# OS settings

defaults write NSGlobalDomain AppleKeyboardUIMode -int 3  # make tab key able to move focus

# increase key repeat
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15


# make CapsLock Control
# get string like : 1452-630-0 for keyboard_id (ref: http://freewing.starfree.jp/software/macos_keyboard_setting_terminal_commandline)
keyboard_id="$(ioreg -c AppleEmbeddedKeyboard -r | grep -Eiw "VendorID|ProductID" | awk '{ print $4 }' | paste -s -d'-\n' -)-0"
defaults -currentHost write -g com.apple.keyboard.modifiermapping.${keyboard_id} -array-add "
<dict>
  <key>HIDKeyboardModifierMappingDst</key>\
  <integer>30064771300</integer>\
  <key>HIDKeyboardModifierMappingSrc</key>\
  <integer>30064771129</integer>\
</dict>
"


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


# install zsh plugin
brew install zsh-completions
brew install zsh-autosuggestions
brew install zsh-syntax-highlighting

# install cli commands from brew
brew install tree
brew install tig
brew install nvim
brew install tmux
brew install hub
brew install neofetch
brew install peco
brwe install exa

# install packages from brew
# brew install pyenv-virtualenv
brew install pyenv
brew install nodebrew
brew yarn

# install utils
brew install ffmpeg


# install desktop apps
brew install google-japanese-ime --cask
brew install google-chrome --cask
brew install slack --cask
brew install zoom --cask
brew install alfred --cask
brew install spectacle --cask
brew install iterm2 --cask
brew install visual-studio-code --cask
brew install sequel-ace --cask
brew install docker --cask
brew install monitorcontrol --cask




if [ ! -e /usr/local/bin/mas ]; then
  brew install mas
fi

# install by mas
mas install 1429033973   # RunCat
