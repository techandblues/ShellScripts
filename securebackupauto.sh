#!/bin/bash
# Secure TAR + AES-256 encryption backup script with .env password support

# === CONFIGURATION ===
SRC="$1"                            # Folder to back up (passed as argument)
DEST_DIR=~/Backups                  # Local backup destination
ENV_FILE=~/.backup_env              # File containing the encryption password
mkdir -p "$DEST_DIR"                # Ensure destination directory exists

# === LOAD PASSWORD ===
if [[ -f "$ENV_FILE" ]]; then
  # Expect line: BACKUP_PASSWORD="yourpassword"
  source "$ENV_FILE"
else
  echo "❌ Password file $ENV_FILE not found."
  echo "Create it with: echo 'BACKUP_PASSWORD=\"yourpassword\"' > ~/.backup_env"
  chmod 600 ~/.backup_env
  exit 1
fi

if [[ -z "$BACKUP_PASSWORD" ]]; then
  echo "❌ BACKUP_PASSWORD not set in $ENV_FILE"
  exit 1
fi

# === GENERATE OUTPUT FILE ===
BASENAME=$(basename "$SRC")
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTFILE="$DEST_DIR/${BASENAME}_${TIMESTAMP}.tar.enc"

echo "🔒 Creating encrypted backup for $SRC ..."
tar -cf - "$SRC" | openssl enc -aes-256-cbc -salt -pass pass:"$BACKUP_PASSWORD" -out "$OUTFILE"

if [[ $? -eq 0 ]]; then
  echo "✅ Backup complete: $OUTFILE"
else
  echo "⚠️  Encryption failed!"
  exit 1
fi

# === OPTIONAL: CLOUD UPLOAD ===
# Uncomment and edit the line below to sync automatically:
# rsync -avz --progress "$OUTFILE" user@10.0.x.x:/path/to/cloud/

