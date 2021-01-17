#!/bin/sh


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
