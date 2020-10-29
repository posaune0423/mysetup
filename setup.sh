#!/bin/sh



# install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"


if [ -f ~/.zshrc];then
  echo export HOMEBREW_CASK_OPTS="--appdir=/Applications" >> ~/.zshrc
else
  touch ~/.zshrc
  echo export HOMEBREW_CASK_OPTS="--appdir=/Applications" >> ~/.zshrc
fi



# install oackages from brew
brew install tree
brew install vim


# install desktop apps
brew cask install iterm2
brew cask install alfred
brew cask install iterm
brew cask install visual-studio-code
brew cask install sequel-pro


brew install mas

# install Xcode
mas install 497799835






