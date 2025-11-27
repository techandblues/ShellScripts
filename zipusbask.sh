#!/bin/bash

# --- Directory Zipper Script ---
# This script prompts the user for a directory path, verifies its existence,
# and creates a compressed zip archive of its contents, naming the file
# based on the current date and the directory name.

# Function to display error messages
error_exit() {
    echo "ERROR: $1" >&2
    exit 1
}

# 1. Prompt the user for the directory path
echo "Please enter the full path of the directory you wish to zip:"
read INPUT_DIR

# Check if the input is empty
if [ -z "$INPUT_DIR" ]; then
    error_exit "No directory path provided. Exiting."
fi

# 2. Check if the directory exists
if [ ! -d "$INPUT_DIR" ]; then
    error_exit "Directory '$INPUT_DIR' not found or is not a directory. Please check the path."
fi

# 3. Define output file details
# Get the base name of the directory (e.g., 'Documents' from '/home/user/Documents')
DIR_NAME=$(basename "$INPUT_DIR")

# Define the output file name: e.g., 'Archive_MyProject_20251116_1736.zip'
TIMESTAMP=$(date +"%Y%m%d_%H%M")
ZIP_FILENAME="Archive_${DIR_NAME}_${TIMESTAMP}.zip"

# The output directory for the zip file (saving it in the current working directory)
OUTPUT_PATH="./$ZIP_FILENAME"

# 4. Create the zip archive
echo "Starting compression of directory: '$INPUT_DIR'..."
echo "Output file will be: '$OUTPUT_PATH'"

# The 'zip -r' command recursively zips the directory content.
# The '-9' flag sets the maximum compression level.
# The '-q' flag makes the command quiet, only showing errors.
zip -r -9 -q "$OUTPUT_PATH" "$INPUT_DIR"

# 5. Provide feedback
if [ $? -eq 0 ]; then
    echo "--- SUCCESS ---"
    echo "Successfully created zip archive: $(realpath "$OUTPUT_PATH")"
    echo "Size: $(du -sh "$OUTPUT_PATH" | awk '{print $1}')"
else
    error_exit "Zip compression failed. Check permissions or file existence."
fi
