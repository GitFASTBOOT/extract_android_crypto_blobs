#!/bin/bash

# Check if a directory path is provided as an argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 path/to/rom/dump"
    exit 1
fi

# Assign the provided argument to a variable
ROM_DUMP_DIR="$1"

# Define destination directories
DEST_SYSTEM_LIB64="./system/lib64"
DEST_SYSTEM_LIB64_HW="./system/lib64/hw"
DEST_SYSTEM_EXT_LIB64="./system_ext/lib64"
DEST_SYSTEM_EXT_LIB64_HW="./system_ext/lib64/hw"
DEST_VENDOR_LIB64="./vendor/lib64"
DEST_VENDOR_LIB64_HW="./vendor/lib64/hw"
DEST_VENDOR_BIN="./vendor/bin"
DEST_VENDOR_BIN_HW="./vendor/bin/hw"
DEST_VENDOR_APP_MCRegistry="./vendor/app/mcRegistry"
DEST_VENDOR_THH="./vendor/thh"
DEST_VENDOR_THH_TA="./vendor/thh/ta"
DEST_VENDOR_MITEE_TA="./vendor/mitee/ta"

# Create destination directories if they don't exist
mkdir -p "$DEST_SYSTEM_LIB64"
mkdir -p "$DEST_SYSTEM_LIB64_HW"
mkdir -p "$DEST_SYSTEM_EXT_LIB64"
mkdir -p "$DEST_SYSTEM_EXT_LIB64_HW"
mkdir -p "$DEST_VENDOR_LIB64"
mkdir -p "$DEST_VENDOR_LIB64_HW"
mkdir -p "$DEST_VENDOR_BIN"
mkdir -p "$DEST_VENDOR_BIN_HW"
mkdir -p "$DEST_VENDOR_APP_MCRegistry"
mkdir -p "$DEST_VENDOR_THH_TA"
mkdir -p "$DEST_VENDOR_MITEE_TA"

# Debugging - log the ROM dump directory
echo "Using ROM dump directory: $ROM_DUMP_DIR"
echo "Searching for libraries, binaries, mcRegistry, thh/ta files, mcDriverDaemon, teei_daemon, and .rc files in this path..."

# Search for .rc files and copy them to the current directory
find "$ROM_DUMP_DIR" -type f \( -name "microtrust.rc" -o -name "trustonic.rc" -o -name "tee.rc" \) | while read -r rc_file; do
    echo "Found .rc file: $rc_file"
    echo "Copying to current directory"
    cp -v "$rc_file" ./

    # Check if trustonic.rc is found and update init.custom.rc
    if [[ "$rc_file" == *"trustonic.rc"* ]]; then
        echo "trustonic.rc detected. Adding Trustonic mount instructions to init.custom.rc"
        INIT_CUSTOM_RC="./init.custom.rc"
        if [ ! -f "$INIT_CUSTOM_RC" ]; then
            touch "$INIT_CUSTOM_RC"
        fi
        echo -e "\n#Added Manual For Trustonic" >> "$INIT_CUSTOM_RC"
        echo "mkdir /mnt/vendor/persist" >> "$INIT_CUSTOM_RC"
        echo "mount ext4 /dev/block/by-name/persist /mnt/vendor/persist rw" >> "$INIT_CUSTOM_RC"
    fi
done

# Search for "keymaster", "gatekeeper", "keymint", "TEE", or "McClient" related .so files
find "$ROM_DUMP_DIR" -type f \( -name "*keymaster*.so" -o -name "*gatekeeper*.so" -o -name "*keymint*.so" -o -name "*TEE*.so" -o -name "*McClient*.so" \) | while read -r file; do
    echo "Found: $file"
    
    # Copy logic for system, system_ext, vendor directories
    if [[ "$file" == *"/system_ext/lib64/hw/"* ]]; then
        echo "Copying to system_ext/lib64/hw/"
        cp -v "$file" "$DEST_SYSTEM_EXT_LIB64_HW/"
    elif [[ "$file" == *"/system_ext/lib64/"* ]]; then
        echo "Copying to system_ext/lib64/"
        cp -v "$file" "$DEST_SYSTEM_EXT_LIB64/"
    elif [[ "$file" == *"/system/lib64/hw/"* ]]; then
        echo "Copying to system/lib64/hw/"
        cp -v "$file" "$DEST_SYSTEM_LIB64_HW/"
    elif [[ "$file" == *"/system/lib64/"* ]]; then
        echo "Copying to system/lib64/"
        cp -v "$file" "$DEST_SYSTEM_LIB64/"
    elif [[ "$file" == *"/vendor/lib64/hw/"* ]]; then
        echo "Copying to vendor/lib64/hw/"
        cp -v "$file" "$DEST_VENDOR_LIB64_HW/"
    elif [[ "$file" == *"/vendor/lib64/"* ]]; then
        echo "Copying to vendor/lib64/"
        cp -v "$file" "$DEST_VENDOR_LIB64/"
    else
        echo "Unknown or unhandled path for: $file - skipping."
    fi
done

# Search for binaries in vendor/bin/hw/ related to keymaster, gatekeeper, keymint, or teei_daemon
find "$ROM_DUMP_DIR/vendor/bin/hw" -type f \( -name "*keymaster*" -o -name "*gatekeeper*" -o -name "*keymint*" -o -name "teei_daemon" \) | while read -r bin_file; do
    echo "Found binary: $bin_file"
    
    # Copy logic for vendor/bin/hw
    if [[ "$bin_file" == *"/vendor/bin/hw/"* ]]; then
        echo "Copying to vendor/bin/hw/"
        cp -v "$bin_file" "$DEST_VENDOR_BIN_HW/"
    else
        echo "Unknown or unhandled binary path for: $bin_file - skipping."
    fi
done

# Search for mcDriverDaemon in vendor/bin
find "$ROM_DUMP_DIR/vendor/bin" -type f -name "mcDriverDaemon" | while read -r mc_driver_file; do
    echo "Found mcDriverDaemon: $mc_driver_file"
    echo "Copying to vendor/bin/"
    cp -v "$mc_driver_file" "$DEST_VENDOR_BIN/"
done

# Extract all files in vendor/app/mcRegistry if it exists
if [ -d "$ROM_DUMP_DIR/vendor/app/mcRegistry" ]; then
    echo "Found vendor/app/mcRegistry directory. Extracting files..."
    cp -r -v "$ROM_DUMP_DIR/vendor/app/mcRegistry/." "$DEST_VENDOR_APP_MCRegistry/"
else
    echo "No vendor/app/mcRegistry directory found. Skipping."
fi

# Extract all files in vendor/thh/ta if it exists
if [ -d "$ROM_DUMP_DIR/vendor/thh/ta" ]; then
    echo "Found vendor/thh/ta directory. Extracting files..."
    cp -r -v "$ROM_DUMP_DIR/vendor/thh/ta/." "$DEST_VENDOR_THH_TA/"
else
    echo "No vendor/thh/ta directory found. Skipping."
fi

# Extract all files in vendor/mitee/ta if it exists
if [ -d "$ROM_DUMP_DIR/vendor/mitee/ta" ]; then
    echo "Found vendor/mitee/ta directory. Extracting files..."
    cp -r -v "$ROM_DUMP_DIR/vendor/mitee/ta/." "$DEST_VENDOR_MITEE_TA/"
else
    echo "No vendor/mitee/ta directory found. Skipping."
fi

# Function to delete empty directories
delete_empty_dirs() {
    local dir="$1"
    find "$dir" -type d -empty -delete
}

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
delete_empty_dirs "$DEST_VENDOR_MITEE_TA"

# Special cleanup for vendor/thh if it's empty
if [ -d "$DEST_VENDOR_THH" ]; then
    echo "Checking if vendor/thh is empty..."
    if [ -z "$(ls -A "$DEST_VENDOR_THH")" ]; then
        echo "vendor/thh is empty. Deleting it..."
        rm -rf "$DEST_VENDOR_THH"
        echo "Deleted empty vendor/thh directory."
    else
        echo "vendor/thh is not empty. Skipping deletion."
    fi
fi

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

# Special cleanup for vendor/mitee if it's empty
if [ -d "./vendor/mitee" ]; then
    echo "Checking if vendor/mitee is empty..."
    if [ -z "$(ls -A ./vendor/mitee)" ]; then
        echo "vendor/mitee is empty. Deleting it..."
        rm -rf "./vendor/mitee"
        echo "Deleted empty vendor/mitee directory."
    else
        echo "vendor/mitee is not empty. Skipping deletion."
    fi
fi

# Final Debugging Log
echo "Extraction and cleanup completed."

