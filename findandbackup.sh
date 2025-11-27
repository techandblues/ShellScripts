#!/bin/bash

# Define the source and destination paths
SOURCE_DIR="/Users/richjbowman/HTML"  # Searching the entire home directory
TRANSFER_DIR="~/transfer"
REMOTE_HOST="192.168.1.168"
REMOTE_PATH="/home/richjbowman/codebackup"

# Create the transfer directory if it doesn't exist
mkdir -p "$TRANSFER_DIR"

# Find and copy .html and .md files to the transfer directory
find "$SOURCE_DIR" -type f $ -iname "*.html" -o -iname "*.md" $ -exec cp {} "$TRANSFER_DIR/" \;

# Use rsync to sync the transfer directory with the remote path
rsync -av --delete "$TRANSFER_DIR/" "$REMOTE_HOST:$REMOTE_PATH"

# Optional: Print completion message
echo "Files have been synchronized to $REMOTE_HOST:$REMOTE_PATH."

