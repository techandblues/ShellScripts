#!/bin/bash

# Variables
SOURCE_DIR="/path/to/source/directory"   # Directory to back up
LOCAL_BACKUP_DIR="/path/to/local/backup"  # Local server backup directory
DROPBOX_BACKUP_DIR="/path/to/dropbox"     # Dropbox directory (mount or use Dropbox CLI)
CHANGELOG_FILE="/path/to/changelog.txt"    # ChangeLog file

# Date for changelog
DATE=$(date +"%Y-%m-%d %H:%M:%S")

# Create ChangeLog entry
echo "Backup run at $DATE" >> "$CHANGELOG_FILE"

# Backup new/changed files using rsync
rsync -av --include='*.sh' --include='*.txt' --include='*.html' --exclude='*' "$SOURCE_DIR/" "$LOCAL_BACKUP_DIR/" --log-file="$CHANGELOG_FILE" --log-file-format='%n' --update

# Upload to Dropbox (ensure Dropbox CLI or mount is set up)
rsync -av "$LOCAL_BACKUP_DIR/" "$DROPBOX_BACKUP_DIR/" --update

# Record each file backed up
echo "Backed up to $LOCAL_BACKUP_DIR and $DROPBOX_BACKUP_DIR" >> "$CHANGELOG_FILE"

