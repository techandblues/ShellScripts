#!/bin/bash

# --- Configuration ---
TEMP_FOLDER="TEXTBU"     # Temporary folder to move the files into
TAR_FILENAME="txtbu.tar" # Name of the resulting tar archive
DEST_DIR="/Volumes/TARBU" # Final destination for the tar file

# --- 1. Argument Handling and Validation ---

# Check if the user provided an argument
if [ -z "$1" ]; then
    echo "🚨 ERROR: Missing Source Directory."
    echo "Usage: $0 <path/to/source/directory>"
    exit 1
fi

# Assign the first argument to a descriptive variable
SOURCE_DIR="$1"

# Check if the provided argument is a valid directory
if [ ! -d "$SOURCE_DIR" ]; then
    echo "🚨 ERROR: Directory not found or is not a directory: $SOURCE_DIR"
    exit 1
fi

echo "Starting text file backup from: $SOURCE_DIR"

# --- 2. Setup Environment ---

# Create the destination directory for the final tar file if it doesn't exist
mkdir -p "$DEST_DIR" || { echo "Error: Could not create $DEST_DIR. Exiting."; exit 1; }

# Create the temporary staging folder
# We place this in the same directory where the script is executed for simplicity,
# but using /tmp is often safer if permissions allow.
mkdir -p "$TEMP_FOLDER" || { echo "Error: Could not create $TEMP_FOLDER. Exiting."; exit 1; }

# --- 3. Find and Move (.txt) Files ---

echo "Finding and moving .txt files (including subdirectories)..."

# Find files of type 'f' (file) ending in .txt starting from the specified directory ($SOURCE_DIR)
# and move them to the temporary staging folder ($TEMP_FOLDER).
find "$SOURCE_DIR" -type f -name "*.txt" -exec mv -t "$TEMP_FOLDER" {} +

# --- 4. Archive and Cleanup ---

# Check if any files were actually moved
if find "$TEMP_FOLDER" -mindepth 1 -print -quit 2>/dev/null | grep -q .; then
    echo "Successfully moved files. Creating tar archive: $TAR_FILENAME"

    # Create the tar archive in the temporary directory.
    # The subshell (cd ...) ensures the file paths inside the archive are clean.
    (cd "$TEMP_FOLDER" && tar -cf "$TAR_FILENAME" *)

    # Check if the tar file was created successfully
    if [ -f "$TEMP_FOLDER/$TAR_FILENAME" ]; then
        echo "Tar archive created. Moving $TAR_FILENAME to $DEST_DIR"
        
        # Move the final tar file to the destination
        mv "$TEMP_FOLDER/$TAR_FILENAME" "$DEST_DIR/"

        if [ -f "$DEST_DIR/$TAR_FILENAME" ]; then
            echo "✅ SUCCESS: Archive located at $DEST_DIR/$TAR_FILENAME"
        else
            echo "❌ ERROR: Failed to move $TAR_FILENAME to $DEST_DIR."
        fi
    else
        echo "❌ ERROR: Failed to create $TAR_FILENAME in $TEMP_FOLDER."
        exit 1
    fi
    
    # Clean up the temporary staging folder
    echo "Cleaning up temporary staging folder: $TEMP_FOLDER..."
    rm -rf "$TEMP_FOLDER"
    
else
    echo "ℹ️ No .txt files were found in $SOURCE_DIR (including subdirectories). Nothing to archive."
    # Remove the empty staging folder
    rmdir "$TEMP_FOLDER" 2>/dev/null
fi

echo "Script finished."
