#!/bin/sh


# OS settings

# make tab key able to move focus
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

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

defaults write com.apple.finder AppleShowAllFiles YES  # show hidden files in finder
defaults write com.apple.dock autohide -bool true  # Automatically hide or show the Dock
defaults write com.apple.dock persistent-apps -array  # Wipe all app icons from the Dock
defaults write com.apple.dock magnification -bool true  # Magnificate the Dock

# resstart these apps for applying above settings
killall Finder
killall Dock


# install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"


if [ -f ~/.zshrc];then
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
brew install vim
brew install hub
brew install neofetch


# install packages from brew
# brew install pyenv
# brew install pyenv-virtualenv
brew pipenv
brew yarn


# install desktop apps
brew install iterm2 --cask
brew install alfred --cask
brew install visual-studio-code --cask
brew install google-japanese-ime --cask
brew install cmd-eikana --cask


brew install mas

# install by mas
mas install 497799835    # Xcode
mas install 1429033973   # RunCat
