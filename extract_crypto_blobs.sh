# Cleanup: Remove any empty directories
echo "Cleaning up empty directories..."
delete_empty_dirs "$DEST_SYSTEM_LIB64"
delete_empty_dirs "$DEST_SYSTEM_LIB64_HW"
delete_empty_dirs "$DEST_SYSTEM_EXT_LIB64"
delete_empty_dirs "$DEST_SYSTEM_EXT_LIB64_HW"
delete_empty_dirs "$DEST_VENDOR_LIB64"
delete_empty_dirs "$DEST_VENDOR_LIB64_HW"
delete_empty_dirs "$DEST_VENDOR_BIN_HW"
delete_empty_dirs "$DEST_VENDOR_BIN"
delete_empty_dirs "$DEST_VENDOR_APP_MCRegistry"
delete_empty_dirs "$DEST_VENDOR_THH_TA"

# Special cleanup for system_ext if it's empty
if [ -d "./system_ext" ]; then
    echo "Checking if system_ext is empty..."
    if [ -z "$(ls -A ./system_ext)" ]; then
        echo "system_ext is empty. Deleting it..."
        rm -rf "./system_ext"
        echo "Deleted empty system_ext directory."
    else
        echo "system_ext is not empty. Skipping deletion."
    fi
fi

# Special cleanup for vendor/thh if it's empty
if [ -d "./vendor/thh" ]; then
    echo "Checking if vendor/thh is empty..."
    if [ -z "$(ls -A ./vendor/thh)" ]; then
        echo "vendor/thh is empty. Deleting it..."
        rm -rf "./vendor/thh"
        echo "Deleted empty vendor/thh directory."
    else
        echo "vendor/thh is not empty. Skipping deletion."
    fi
fi

# Final Debugging Log
echo "Extraction and cleanup completed."
