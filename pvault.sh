#!/bin/bash
# -------------------------------------------------------------
# Secure Encrypted Vault Launcher for macOS
# Mounts a .dmg, opens KeePassXC, unmounts when done
# -------------------------------------------------------------

# === CONFIGURATION ===
VAULT_PATH="$HOME/Documents/SecureVaults/PasswordVault.dmg"
MOUNT_POINT="/Volumes/PasswordVault"
KEEPASS_APP="/Applications/KeePassXC.app"

# === CHECKS ===
if [[ ! -f "$VAULT_PATH" ]]; then
  echo "❌ Vault not found at $VAULT_PATH"
  exit 1
fi
if [[ ! -d "$KEEPASS_APP" ]]; then
  echo "❌ KeePassXC not found in /Applications."
  echo "Install via Homebrew: brew install --cask keepassxc"
  exit 1
fi

# === MOUNT VAULT ===
echo "🔐 Mounting vault..."
hdiutil attach "$VAULT_PATH" -mountpoint "$MOUNT_POINT" || {
  echo "⚠️  Failed to mount vault."
  exit 1
}

# === LAUNCH KEEPASSXC ===
echo "🚀 Opening KeePassXC..."
open -a "$KEEPASS_APP" "$MOUNT_POINT"

# === WAIT UNTIL KEEPASSXC CLOSES ===
echo "⏳ Waiting for KeePassXC to close..."
while pgrep -x "KeePassXC" >/dev/null; do
  sleep 5
done

# === UNMOUNT VAULT ===
echo "🧱 Closing and unmounting vault..."
hdiutil detach "$MOUNT_POINT" >/dev/null 2>&1 && \
  echo "✅ Vault securely unmounted." || \
  echo "⚠️  Could not unmount vault (check if any files are still open)."

exit 0

