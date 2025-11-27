#!/bin/bash

# Zip Subfolders Script for macOS
# This script iterates through all *first-level* directories inside a specified
# parent directory and creates an individual .zip archive for each one.
# It handles folder names with spaces and uses the -u flag for updating existing zips.

# --- Configuration ---
# Default directory to process. You can change this or pass it as an argument.
DEFAULT_DIR="$HOME/Documents"

# --- Functions ---

# Function to display usage information
usage() {
    echo "Usage: $0 [target_directory]"
    echo ""
    echo "Creates a separate .zip archive for every first-level folder in the target directory."
    echo "If the .zip file already exists, it is UPDATED with the -u flag."
    echo ""
    echo "Default directory if none provided: $DEFAULT_DIR"
    exit 1
}

# --- Main Script Logic ---

# 1. Determine the Target Directory
TARGET_DIR="${1:-$DEFAULT_DIR}" # Use the first argument, or the default if no argument is provided.

# Check if the target directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory not found at '$TARGET_DIR'"
    usage
fi

# Resolve the absolute path of the target directory
# This helps ensure correct zipping structure, regardless of where the script is run.
TARGET_DIR="$(cd "$(dirname "$TARGET_DIR")"; pwd)/$(basename "$TARGET_DIR")"

echo "--- Starting Zip Process ---"
echo "Target Directory: $TARGET_DIR"

# 2. Change directory for cleaner file paths inside the zips
# This ensures that when the zip is uncompressed, it doesn't create the full path like
# /Users/YourName/Documents/Folder, but just 'Folder'.
pushd "$TARGET_DIR" > /dev/null

# 3. Loop through all directories (but exclude hidden ones starting with .)
# The trailing slash (*/) ensures we only match directories, and not files.
for FOLDER in */; do
    # Remove the trailing slash for the directory name to be used as the zip filename
    FOLDER_NAME="${FOLDER%/}"
    ZIP_FILE_NAME="${FOLDER_NAME}.zip"

    echo "Processing: $FOLDER_NAME"

    # The magic happens here:
    # zip -r -u :
    # -r: Recursively include all files and subdirectories.
    # -u: Update existing files in the zip and add new files if they are not present.
    # -x "__MACOSX" ".DS_Store" : Excludes Mac-specific junk files for cleaner zips.
    zip -r -u "$ZIP_FILE_NAME" "$FOLDER_NAME" -x "__MACOSX" ".DS_Store"

    # Check the exit status of the zip command
    if [ $? -ne 0 ]; then
        echo "  [ERROR] Zipping failed for $FOLDER_NAME"
    else
        echo "  [SUCCESS] Archive created/updated: $ZIP_FILE_NAME"
    fi

done

# 4. Return to the original working directory
popd > /dev/null

echo "--- Zip Process Complete ---"
