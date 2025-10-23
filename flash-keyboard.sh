#!/bin/bash
# filepath: /Users/joshan/repos/zmk-harite-v3/flash-keyboard.sh

set -e

# Check if gum is installed
if ! command -v gum &> /dev/null; then
    echo "Error: gum is not installed. Please install it or run this script in the nix devShell."
    exit 1
fi

FIRMWARE_DIR="result"
RIGHT_FIRMWARE="${FIRMWARE_DIR}/zmk_right.uf2"
LEFT_FIRMWARE="${FIRMWARE_DIR}/zmk_left.uf2"
MOUNT_POINT="/Volumes/NO NAME"

# Styled header
gum style \
  --foreground 212 --border-foreground 212 --border double \
  --align center --width 50 --margin "1 2" --padding "1 2" \
  "ZMK Keyboard Flasher" "Harite V3"

# Check if firmware files exist
if [ ! -f "$RIGHT_FIRMWARE" ] || [ ! -f "$LEFT_FIRMWARE" ]; then
  gum style --foreground 1 "❌ Firmware files not found in ${FIRMWARE_DIR}!"
  gum style "Run 'nix build' first to compile your firmware."
  exit 1
fi

gum style --foreground 10 "✅ Firmware files found!"

# Function to wait for the bootloader drive to appear
wait_for_drive() {
  gum spin --spinner dot --title "Waiting for bootloader drive to appear..." -- \
    bash -c "while [ ! -d \"$MOUNT_POINT\" ]; do sleep 0.5; done"
  gum style --foreground 10 "✅ Bootloader drive detected!"
}

# Function to flash a half
flash_half() {
  local side=$1
  local firmware=$2
  
  gum style \
    --foreground 99 --border normal --border-foreground 99 \
    --align center --width 50 --margin "1 0" --padding "0 1" \
    "Flashing ${side} half"
  
  gum style --foreground 6 "📋 Instructions:"
  echo "1. Connect the ${side} half via USB"
  echo "2. Put the ${side} half into bootloader mode"
  
  gum confirm "Ready to continue?" || { 
    gum style --foreground 3 "⚠️ Flashing cancelled"; 
    exit 1; 
  }
  
  wait_for_drive
  
  gum style "⏳ Copying firmware to device..."
  cp "$firmware" "$MOUNT_POINT" || true
  
  gum style --foreground 10 "✅ ${side} half flashing initiated!"
  gum style "The drive will automatically eject and the keyboard will restart."
  echo ""
}

# Flash right half
flash_half "right" "$RIGHT_FIRMWARE"

# Prompt before continuing to left half
gum confirm "Ready to flash the left half?" || {
  gum style --foreground 3 "⚠️ Left half flashing cancelled";
  exit 1;
}

# Flash left half
flash_half "left" "$LEFT_FIRMWARE"

gum style \
  --foreground 10 --border normal --border-foreground 10 \
  --align center --width 50 --margin "1 2" --padding "1 2" \
  "🎉 Flashing complete!" "Both halves should now be running the updated firmware."