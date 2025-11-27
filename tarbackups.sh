#!/bin/bash

# --- Configuration ---
SOURCE_DIR="."           # Search in the current directory and subdirectories
TEMP_FOLDER="TEXTBU"     # Temporary folder to move the files into
TAR_FILENAME="txtbu.tar" # Name of the resulting tar archive
DEST_DIR="/Volumes/TARBU" # Final destination for the tar file

# --- 1. Setup Environment ---

echo "Starting text file backup..."

# Create the destination directory for the final tar file if it doesn't exist
# The -p flag prevents an error if the directory already exists
if [ ! -d "$DEST_DIR" ]; then
    echo "Creating final destination directory: $DEST_DIR"
    mkdir -p "$DEST_DIR" || { echo "Error: Could not create $DEST_DIR. Exiting."; exit 1; }
fi

# Create the temporary staging folder if it doesn't exist
if [ ! -d "$TEMP_FOLDER" ]; then
    echo "Creating temporary staging folder: $TEMP_FOLDER"
    mkdir "$TEMP_FOLDER" || { echo "Error: Could not create $TEMP_FOLDER. Exiting."; exit 1; }
fi

# --- 2. Find and Move (.txt) Files ---

echo "Finding and moving .txt files to $TEMP_FOLDER..."

# The 'find' command locates all files ending in .txt.
# The '-exec mv {} +;' efficiently moves them.
find "$SOURCE_DIR" -type f -name "*.txt" -exec mv -t "$TEMP_FOLDER" {} +

# Check if any files were actually moved (i.e., if the TEMP_FOLDER is not empty)
if find "$TEMP_FOLDER" -mindepth 1 -print -quit 2>/dev/null | grep -q .; then
    echo "Successfully moved .txt files."

    # --- 3. Create the Tar Archive ---

    echo "Creating tar archive: $TAR_FILENAME..."

    # Change directory to the temporary folder for archiving.
    # This ensures the files inside the tar file do not include the "TEXTBU/" prefix.
    # The 'tar -c' creates the archive, '-f' specifies the filename.
    (cd "$TEMP_FOLDER" && tar -cf "$TAR_FILENAME" *)

    # Check if the tar file was created successfully
    if [ -f "$TEMP_FOLDER/$TAR_FILENAME" ]; then
        echo "Tar archive created successfully: $TEMP_FOLDER/$TAR_FILENAME"

        # --- 4. Move the Tar Archive to Final Destination ---

        echo "Moving $TAR_FILENAME to $DEST_DIR..."
        mv "$TEMP_FOLDER/$TAR_FILENAME" "$DEST_DIR/"

        # Final check and cleanup
        if [ -f "$DEST_DIR/$TAR_FILENAME" ]; then
            echo "SUCCESS: $TAR_FILENAME is now located at $DEST_DIR/$TAR_FILENAME"
        else
            echo "ERROR: Failed to move $TAR_FILENAME to $DEST_DIR."
            exit 1
        fi
    else
        echo "ERROR: Failed to create $TAR_FILENAME in $TEMP_FOLDER."
        exit 1
    fi

    # --- 5. Clean up Temporary Folder ---
    echo "Cleaning up temporary staging folder: $TEMP_FOLDER..."
    rm -rf "$TEMP_FOLDER"

else
    echo "No .txt files found to archive. Cleaning up empty folder (if necessary)."
    # Attempt to remove the folder only if it is empty
    rmdir "$TEMP_FOLDER" 2>/dev/null
fi

echo "Script finished."
