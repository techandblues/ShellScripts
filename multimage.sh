#!/bin/bash

# Configuration
SOURCE_DEVICE="/dev/sdb1" # <-- DOUBLE-CHECK THIS!
DEST_DIR="/mnt/MusicBU"
LOG_FILE="$DEST_DIR/backup_log.txt"

# Check if the source device exists
if [ ! -b "$SOURCE_DEVICE" ]; then
    echo "ERROR: Source device $SOURCE_DEVICE does not exist. Aborting." | tee -a $LOG_FILE
    exit 1
fi

# Unmount the source device before imaging
echo "Unmounting $SOURCE_DEVICE..." | tee -a $LOG_FILE
sudo umount /mnt/Music

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
OUTPUT_FILE="$DEST_DIR/music_backup_$TIMESTAMP.img"

echo "--- Starting backup at $TIMESTAMP ---" | tee -a $LOG_FILE
echo "Source: $SOURCE_DEVICE" | tee -a $LOG_FILE
echo "Destination: $OUTPUT_FILE" | tee -a $LOG_FILE

# Execute the dd command
sudo dd if=$SOURCE_DEVICE of=$OUTPUT_FILE bs=4M status=progress 2>&1 | tee -a $LOG_FILE

if [ $? -eq 0 ]; then
    echo "--- Backup completed successfully: $OUTPUT_FILE ---" | tee -a $LOG_FILE
else
    echo "--- Backup FAILED for: $OUTPUT_FILE ---" | tee -a $LOG_FILE
fi

# Re-mount the source drive for normal use
echo "Re-mounting $SOURCE_DEVICE to /mnt/Music..." | tee -a $LOG_FILE
sudo mount $SOURCE_DEVICE /mnt/Music

