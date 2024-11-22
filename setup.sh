#!/bin/bash

# Exit on error
set -e

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until script has finished
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &

echo "Starting macOS setup script..."

# Function to check if command succeeded
check_status() {
    if [ $? -eq 0 ]; then
        echo "✅ $1"
    else
        echo "❌ $1 failed"
    fi
}

#################################################
# OS Settings
#################################################

echo "Configuring macOS settings..."

# Enable Touch ID for sudo
echo "Enabling Touch ID for sudo commands..."
if ! grep -q "pam_tid.so" /etc/pam.d/sudo; then
    sudo sed -i '' '2i\
auth       sufficient     pam_tid.so\
' /etc/pam.d/sudo
fi
check_status "Touch ID for sudo configuration"

# Keyboard settings
osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
check_status "Keyboard settings"

# Swap semicolon and colon
if [ ! -d ~/Library/KeyBindings ]; then
    mkdir -p ~/Library/KeyBindings
fi

cat >~/Library/KeyBindings/DefaultKeyBinding.dict <<EOF
{
    "$\U003B" = ("insertText:", ":");
    "~$\U003B" = ("insertText:", ";");
}
EOF

check_status "Keyboard settings and key swap"

# CapsLock to Control
for keyboard_id in $(ioreg -c AppleEmbeddedKeyboard -r | grep -Eiw "VendorID|ProductID" | awk '{ print $4 }' | paste -s -d'-\n' -)-0; do
    defaults -currentHost write -g com.apple.keyboard.modifiermapping.${keyboard_id} -array-add "
    <dict>
        <key>HIDKeyboardModifierMappingDst</key>
        <integer>30064771300</integer>
        <key>HIDKeyboardModifierMappingSrc</key>
        <integer>30064771129</integer>
    </dict>
    "
done
check_status "CapsLock to Control mapping"

# Trackpad settings
defaults write -g com.apple.trackpad.scaling 8.5
defaults write -g com.apple.mouse.scaling 8.5
defaults write -g com.apple.mouse.tapBehavior -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
check_status "Trackpad settings"

# Finder settings
defaults write com.apple.screencapture type jpg
defaults write com.apple.finder AppleShowAllFiles YES
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
check_status "Finder settings"

# Dock settings
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock tilesize -int 36
check_status "Dock settings"

#################################################
# Install Applications
#################################################

echo "Setting up applications..."

# Install Homebrew if not installed
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi
check_status "Homebrew installation"

# Install Rosetta 2 for Apple Silicon Macs
if [[ $(uname -m) == 'arm64' ]]; then
    echo "Installing Rosetta 2..."
    softwareupdate --install-rosetta --agree-to-license
    check_status "Rosetta 2 installation"
fi

# Update Homebrew
echo "Updating Homebrew..."
brew update
brew upgrade
check_status "Homebrew update"

# CLI tools
echo "Installing CLI tools..."
cli_tools=(
    "bash"
    "jq"
    "sqlite3"
    "bat"
    "tree"
    "tig"
    "nvim"
    "tmux"
    "hub"
    "neofetch"
    "peco"
    "eza"
    "protobuf"
    "coreutils"
    "curl"
    "git"
    "asdf"
)

for tool in "${cli_tools[@]}"; do
    brew install "$tool"
done
check_status "CLI tools installation"

# Install Rust
echo "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
check_status "Rust installation"

# Setup Starkli
echo "Setting up Starkli..."
curl https://get.starkli.sh | sh
source ~/.zshrc
starkliup
check_status "Starkli installation"

# Install Cairo / Dojo
echo "Installing Cairo / Dojo..."
echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" >>${ZDOTDIR:-~}/.zshrc
asdf plugin add scarb
asdf plugin add dojo
asdf install scarb latest
asdf install dojo latest
asdf global scarb latest
asdf global dojo latest
check_status "Cairo / Dojo installation"

# GUI Applications
echo "Installing GUI applications..."
gui_apps=(
    "google-japanese-ime"
    "google-chrome"
    "slack"
    "zoom"
    "telegram"
    "discord"
    "alfred"
    "spectacle"
    "wezterm"
    "cursor"
    "docker"
    "monitorcontrol"
)

for app in "${gui_apps[@]}"; do
    brew install --cask "$app"
done
check_status "GUI applications installation"

# Install Mac App Store CLI and apps
if ! command -v mas &>/dev/null; then
    brew install mas
fi

echo "Installing Mac App Store apps..."
mas_apps=(
    "1429033973:RunCat"
)

for app in "${mas_apps[@]}"; do
    mas install "${app%%:*}"
done
check_status "Mac App Store apps installation"

# Cleanup
echo "Cleaning up..."
brew cleanup
check_status "Cleanup"

# Restart system processes
echo "Restarting system processes..."
killall Finder
killall Dock

echo "Setup complete! Some changes require a restart to take effect."
echo "Would you like to restart now? (y/n)"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
    sudo shutdown -r now
fi
