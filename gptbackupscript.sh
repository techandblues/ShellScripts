#!/bin/bash
# Secure TAR + AES-256 encryption backup script

# === CONFIGURE THESE ===
SRC="$1"                      # Folder to back up, passed as argument
DEST_DIR=~/Backups            # Change this to your preferred backup location
mkdir -p "$DEST_DIR"          # Ensure backup directory exists

# === MAIN LOGIC ===
BASENAME=$(basename "$SRC")
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTFILE="$DEST_DIR/${BASENAME}_${TIMESTAMP}.tar.enc"

echo "🔒 Creating encrypted backup for $SRC ..."
tar -cf - "$SRC" | openssl enc -aes-256-cbc -salt -out "$OUTFILE"
echo "✅ Backup complete: $OUTFILE"

