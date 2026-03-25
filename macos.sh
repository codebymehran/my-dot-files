#!/bin/bash

set -e

echo "⚙️ Applying macOS developer settings..."
echo ""

# -----------------------------
# Require sudo upfront
# -----------------------------

echo "🔐 Some settings require administrator access (pmset, nvram)..."
sudo -v

# Keep sudo alive for duration of script
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# -----------------------------
# Finder
# -----------------------------

echo "📁 Configuring Finder..."

# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show all file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Keep folders on top when sorting
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Search current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Default Finder view = list
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Show full path in Finder title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Avoid .DS_Store on network drives
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true


# -----------------------------
# Dock
# -----------------------------

echo "🚢 Configuring Dock..."

# Dock position on screen: Left
defaults write com.apple.dock orientation -string "left"

# Minimized window animation: Genie effect
defaults write com.apple.dock mineffect -string "genie"

# Window title bar double-click action: Zoom
defaults write NSGlobalDomain AppleActionOnDoubleClick -string "Zoom"

# Minimize windows into application icon
defaults write com.apple.dock minimize-to-application -bool true

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Faster Dock auto-hide/show
defaults write com.apple.dock autohide-time-modifier -float 0.2

# Animate opening applications
defaults write com.apple.dock launchanim -bool true

# Show indicators for open applications
defaults write com.apple.dock show-process-indicators -bool true

# Show suggested and recent apps in Dock
defaults write com.apple.dock show-recents -bool true

# Disable auto-rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false


# -----------------------------
# Keyboard
# -----------------------------

echo "⌨️  Configuring Keyboard..."

# Fast key repeat
defaults write NSGlobalDomain KeyRepeat -int 2

# Short delay before repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Disable press-and-hold (enables key repeat for held keys — essential for Vim)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Disable auto-capitalization
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable smart quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false


# -----------------------------
# Trackpad
# -----------------------------

echo "🖱️  Configuring Trackpad..."

# Tracking speed (fast)
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 2.5

# Natural scrolling: On
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

# Tap to click: On
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Secondary click: Click or tap with two fingers
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 0

# Smart zoom: On
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerDoubleTapGesture -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture -int 1

# Swipe between pages: Off
defaults write NSGlobalDomain AppleEnableSwipeNavigateWithScrolls -bool false

# Swipe between full-screen apps with three fingers
# (Note: only set once — previously set to 2 then immediately overwritten to 1)
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 1

# App Exposé gesture
defaults write com.apple.dock showAppExposeGestureEnabled -bool true


# -----------------------------
# Screenshots
# -----------------------------

echo "📸 Configuring Screenshots..."

# Save screenshots to Desktop/Screenshots
mkdir -p "$HOME/Desktop/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Desktop/Screenshots"

# Save screenshots as PNG
defaults write com.apple.screencapture type -string "png"


# -----------------------------
# General UI
# -----------------------------

echo "🖥️  Configuring General UI..."

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Always show scrollbars
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# Disable window open/close animations
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

# Disable Time Machine new disk prompts
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true


# -----------------------------
# Spotlight (use Raycast instead)
# -----------------------------

# Disable Spotlight shortcut (Cmd + Space) so Raycast can use it
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "<dict><key>enabled</key><false/></dict>"


# -----------------------------
# Battery / Power
# -----------------------------

echo "🔋 Configuring Battery/Power..."

# Show battery in menu bar
defaults -currentHost write com.apple.controlcenter Battery -int 18

# Show battery percentage
defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true

# Low Power Mode on battery
sudo pmset -b lowpowermode 1

# Slightly dim display on battery
sudo pmset -b lessbright 1

# Power Nap on charger, off on battery
sudo pmset -c powernap 1
sudo pmset -b powernap 0


# -----------------------------
# Security / Developer tweaks
# -----------------------------

echo "🔒 Applying Developer tweaks..."

# Disable startup sound
sudo nvram StartupMute=%01

# Disable quarantine prompt ("app downloaded from internet" warning)
# ⚠️ This removes the Gatekeeper warning for downloaded apps system-wide.
# Comment this out if you prefer to keep the security prompt.
defaults write com.apple.LaunchServices LSQuarantine -bool false


# -----------------------------
# Chrome
# -----------------------------

echo "🌐 Configuring Chrome..."

# Disable swipe-back on horizontal scroll (stops accidental back navigation)
defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false

# -----------------------------
# Apply changes
# -----------------------------

echo ""
echo "🔄 Restarting system UI components..."
killall Finder       || true
killall Dock         || true
killall SystemUIServer || true
killall ControlStrip || true

echo ""
echo "✅ macOS settings applied"
echo "ℹ️  Some trackpad/power settings may need a logout/login or manual check in System Settings."
