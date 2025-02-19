#!/bin/bash

# Start .sh script
#echo "Starting .sh script..."
chmod u+x extract_crypto_blobs.sh

# Create basic folder
#echo " Creating Firmware folder"
mkdir -p Firmware

## This only stop scrypt if user not copy stock folders in path/
# Check if a directory path is provided as an argument
#if [ "$#" -ne 1 ]; then
#    echo "Usage: $0 /Firmware"
#    exit 1
#fi
# Colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
RESET="\e[0m"  # Reset color

echo " "
#
echo -e "${RED}        *************     BEFORE ANY ACTIONS     *************       "
echo -e "************* COPY STOCK ROM FOLDERS TO Firmware FOLDER. *************"
echo " "
echo -e "${CYAN}###  Example: /Firmware/vendor & /Firmware/system & /Firmware/system_ext  ###${RESET}"
echo " "
#

PS3="  Do you realy copied stock folders to Firmware folder?  "
select word in "yes" "no"; do
    echo "  The choice that you have selected is : $word  "
    break
done

if [ "$word" = "yes" ];
then
clear

  echo " Starting........  "
sleep 2

# Assign the provided argument to a variable
ROM_DUMP_DIR="./Firmware"

# Define destination directories
s="system"
v="vendor"
l="lib64"
DEST_SYSTEM_LIB64="./$s/$l"
DEST_SYSTEM_LIB64_HW="./$s/$l/hw"
DEST_SYSTEM_ETC_VINTF="./$s/etc/vintf"
DEST_SYSTEM_ETC_MANIF="./$s/etc/vintf/manifest"
DEST_SYSTEM_ETC="./$s/etc"
DEST_SYSTEM_EXT_LIB64="./system_ext/$l"
DEST_SYSTEM_EXT_LIB64_HW="./system_ext/$l/hw"
DEST_VENDOR_LIB64="./$v/$l"
DEST_VENDOR_LIB64_HW="./$v/$l/hw"
DEST_VENDOR_BIN="./$v/bin"
DEST_VENDOR_BIN_HW="./$v/bin/hw"
DEST_VENDOR_APP_MCRegistry="./$v/app/mcRegistry"
DEST_VENDOR_THH="./$v/thh"
DEST_VENDOR_THH_TA="./$v/thh/ta"
DEST_VENDOR_MITEE_TA="./$v/mitee/ta"
DEST_VENDOR_APP="./$v/app"
DEST_VENDOR_APP_t6="./$v/app/t6"
DEST_VENDOR_FW="./$v/firmware"
DEST_VENDOR_ETC="./$v/etc"
DEST_VENDOR_ETC_VINTF="./$v/etc/vintf"
DEST_VENDOR_ETC_MANIF="./$v/etc/vintf/manifest"

# Create destination directories if they don't exist
mkdir -p "$DEST_SYSTEM_LIB64"
mkdir -p "$DEST_SYSTEM_LIB64_HW"
mkdir -p "$DEST_SYSTEM_ETC_VINTF"
mkdir -p "$DEST_SYSTEM_ETC_MANIF"
mkdir -p "$DEST_SYSTEM_ETC"
mkdir -p "$DEST_SYSTEM_EXT_LIB64"
mkdir -p "$DEST_SYSTEM_EXT_LIB64_HW"
mkdir -p "$DEST_VENDOR_LIB64"
mkdir -p "$DEST_VENDOR_LIB64_HW"
mkdir -p "$DEST_VENDOR_BIN"
mkdir -p "$DEST_VENDOR_BIN_HW"
mkdir -p "$DEST_VENDOR_APP_MCRegistry"
mkdir -p "$DEST_VENDOR_THH_TA"
mkdir -p "$DEST_VENDOR_MITEE_TA"
mkdir -p "$DEST_VENDOR_APP_t6"
mkdir -p "$DEST_VENDOR_FW"
mkdir -p "$DEST_VENDOR_ETC"
mkdir -p "$DEST_VENDOR_ETC_VINTF"
mkdir -p "$DEST_VENDOR_ETC_MANIF"

# Debugging - log the ROM dump directory
echo "Using ROM dump directory: $ROM_DUMP_DIR"
echo "Searching for libraries, binaries, mcRegistry, thh/ta files, mcDriverDaemon, teei_daemon, teed, and .rc files in this path..."

# Search for .rc files and copy them to the current directory
find "$ROM_DUMP_DIR" -type f \( -name "microtrust.rc" -o -name "trustonic.rc" -o -name "tee.rc" -o -name "trustkernel.rc" \) | while read -r rc_file; do
    echo "Found .rc file: $rc_file"
    echo "Copying to current directory"
    cp -v "$rc_file" ./

    # Check if decrypt_file.rc is found and update init.custom.rc
    if [[ "$rc_file" == **trust**.rc ]]; then
        echo "decrypt_file.rc detected. Adding Trust mount instructions to init.custom.rc"
        INIT_CUSTOM_RC="./init.custom.rc"
        if [ ! -f "$INIT_CUSTOM_RC" ]; then
            touch "$INIT_CUSTOM_RC"
        fi
        echo -e "\non init" >> "$INIT_CUSTOM_RC"
        echo "#Added Manual For Trustonic" >> "$INIT_CUSTOM_RC"
        echo "mkdir /mnt/vendor/persist" >> "$INIT_CUSTOM_RC"
        echo "mount ext4 /dev/block/by-name/persist /mnt/vendor/persist rw" >> "$INIT_CUSTOM_RC"
    fi
done

echo "Searching and Copying......."
sleep 2
# Search for "keymaster", "gatekeeper", "keymint", "tee", "TEE", "McClient" and others related .so files
find "$ROM_DUMP_DIR" -type f \( -name "*keymaster*.so" -o -name "*gatekeeper*.so" -o -name "*keymint*.so" -o -name "*TEE*.so" -o -name "*McClient*.so" -o -name "*mtk_bsg*.so" -o -name "*kmsetkey*.so" -o -name "*imsg*.so" -o -name "*uree*.so" -o -name "*kph*.so" -o -name "libpl.so" -o -name "android.hidl.*.so" -o -name "libhidl*.so" -o -name "libion_*.so" -o -name "*Gatekeeper*.so" -o -name "*tee*.so" -o -name "libhwbinder.so" -o -name "libladder.so" \) | while read -r file; do
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

# Search for binaries in vendor/bin/hw/ related to keymaster, gatekeeper, keymint or trustonic.tee
find "$ROM_DUMP_DIR/vendor/bin/hw" -type f \( -name "*keymaster*" -o -name "*gatekeeper*" -o -name "*keymint*" -o -name "*tee*" \) | while read -r bin_file; do
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

# Search for teei_daemon in vendor/bin
find "$ROM_DUMP_DIR/vendor/bin" -type f -name "teei_daemon" | while read -r teei_daemon_file; do
    echo "Found teei_daemon $teei_daemon_file"
    echo "Copying to vendor/bin/"
    cp -v "$teei_daemon_file" "$DEST_VENDOR_BIN/"
done

# Search for teed in vendor/bin
find "$ROM_DUMP_DIR/vendor/bin" -type f -name "teed" | while read -r teed_file; do
    echo "Found teed $teed_file"
    echo "Copying to vendor/bin/"
    cp -v "$teed_file" "$DEST_VENDOR_BIN/"
done

# Search for kph in vendor/bin
find "$ROM_DUMP_DIR/vendor/bin" -type f -name "kph" | while read -r kph_file; do
    echo "Found kph $kph_file"
    echo "Copying to vendor/bin/"
    cp -v "$kph_file" "$DEST_VENDOR_BIN/"
done

# Search for pld in vendor/bin
find "$ROM_DUMP_DIR/vendor/bin" -type f -name "pld" | while read -r pld_file; do
    echo "Found pld $pld_file"
    echo "Copying to vendor/bin/"
    cp -v "$pld_file" "$DEST_VENDOR_BIN/"
done

# Search for tee_check_keybox in vendor/bin
find "$ROM_DUMP_DIR/vendor/bin" -type f -name "tee_check_keybox" | while read -r keybox_file; do
    echo "Found tee_check_keybox $keybox_file"
    echo "Copying to vendor/bin/"
    cp -v "$keybox_file" "$DEST_VENDOR_BIN/"
done

# Search for *-service.*.xml in system/etc/vintf/manifest
find "$ROM_DUMP_DIR/system/etc/vintf/manifest" -type f -name "android.system.keystore2-service.xml" | while read -r smanif_file; do
    echo "Found android.system.keystore2-service.xml $smanif_file"
    echo "Copying to system/etc/vintf/manifest/"
    cp -v "$smanif_file" "$DEST_SYSTEM_ETC_MANIF/"
done

# Search for manifest.xml & compatibility_matrix.*.xml and others in system/etc/vintf
find "$ROM_DUMP_DIR/system/etc/vintf" -type f \( -name "manifest.xml" -o -name "compatibility_matrix.*.xml" \) | while read -r manif_file; do
    echo "Found binary: $manif_file"
    
    # Copy logic for /system/etc/vintf/
    if [[ "$manif_file" == *"/system/etc/vintf/"* ]]; then
        echo "Copying to /system/etc/vintf/"
        cp -v "$manif_file" "$DEST_SYSTEM_ETC_VINTF/"
    else
        echo "Unknown or unhandled files path for: $manif_file - skipping."
    fi
done

# Search for event-log-tags & task_profiles.json in system/etc
find "$ROM_DUMP_DIR/system/etc" -type f \( -name "event-log-tags" -o -name "task_profiles.json" \) | while read -r se_file; do
    echo "Found binary: $se_file"
    
    # Copy logic for /system/etc
    if [[ "$se_file" == *"/system/etc/"* ]]; then
        echo "Copying to /system/etc/"
        cp -v "$se_file" "$DEST_SYSTEM_ETC/"
    else
        echo "Unknown or unhandled files path for: $se_file - skipping."
    fi
done

# Extract all files in vendor/firmware if it exists
if [ -d "$ROM_DUMP_DIR/vendor/firmware" ]; then
    echo "Found vendor/firmware directory. Extracting files..."
    cp -r -v "$ROM_DUMP_DIR/vendor/firmware/." "$DEST_VENDOR_FW/"
else
    echo "No vendor/firmware directory found. Skipping."
fi

# Search for manifest.xml & compatibility_matrix.xml in vendor/etc/vintf
find "$ROM_DUMP_DIR/vendor/etc/vintf" -type f \( -name "manifest.xml" -o -name "compatibility_matrix.xml" \) | while read -r vmanif_file; do
    echo "Found binary: $vmanif_file"
    
    # Copy logic for vendor/etc/vintf/
    if [[ "$vmanif_file" == *"vendor/etc/vintf/"* ]]; then
        echo "Copying to vendor/etc/vintf/"
        cp -v "$vmanif_file" "$DEST_VENDOR_ETC_VINTF/"
    else
        echo "Unknown or unhandled files path for: $vmanif_file - skipping."
    fi
done

# Search for ueventd.rc in vendor/etc
find "$ROM_DUMP_DIR/vendor/etc" -type f -name "ueventd.rc" | while read -r euev_file; do
    echo "Found ueventd.rc $euev_file"
    echo "Copying to vendor/etc/"
    cp -v "$euev_file" "$DEST_VENDOR_ETC/"
done

# Search for *-service.*.xml in vendor/etc/vintf/manifest
find "$ROM_DUMP_DIR/vendor/etc/vintf/manifest" -type f -name "*-service.*.xml" | while read -r manser_file; do
    echo "Found all *-service.*.xml $manser_file"
    echo "Copying to vendor/etc/vintf/manifest/"
    cp -v "$manser_file" "$DEST_VENDOR_ETC_MANIF/"
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

# Extract all files in vendor/app/t6/ if it exists
if [ -d "$ROM_DUMP_DIR/vendor/app/t6" ]; then
    echo "Found vendor/app/t6 directory. Extracting files..."
    cp -r -v "$ROM_DUMP_DIR/vendor/app/t6/." "$DEST_VENDOR_APP_t6/"
else
    echo "No vendor/app/t6 directory found. Skipping."
fi

# Extract all files in vendor/mitee/ta if it exists
if [ -d "$ROM_DUMP_DIR/vendor/mitee/ta" ]; then
    echo "Found vendor/mitee/ta directory. Extracting files..."
    cp -r -v "$ROM_DUMP_DIR/vendor/mitee/ta/." "$DEST_VENDOR_MITEE_TA/"
else
    echo "No vendor/mitee/ta directory found. Skipping."
fi

# Check if the mitee folder exists in the ROM dump
if [ -d "$ROM_DUMP_DIR/vendor/mitee" ]; then
    echo "Detected vendor/mitee folder. Creating init.mitee.rc file..."
    
    # Create the init.mitee.rc file
    cat > init.mitee.rc << 'EOF'
service tee-supplicant /vendor/bin/tee-supplicant
    class core
    user root
    group root
    disabled
    seclabel u:r:recovery:s0

service miteelog /vendor/bin/miteelog
    user root
    group root
    disabled
    seclabel u:r:recovery:s0

# tee-supplicant
on fs
    write /proc/bootprof "init tee-supplicant"
    # set SELinux security contexts on upgrade or policy update
    restorecon_recursive /mnt/vendor/persist
    chmod 0660 /dev/tee0
    chmod 0660 /dev/teepriv0
    chown system system /dev/tee0
    chown system system /dev/teepriv0
    chmod 0660 /dev/rpmb0
    chmod 0660 /dev/mmcblk0rpmb
    chmod 0660 /dev/0:0:0:49476
    chmod 0660 /dev/ufs-bsg0
    chmod 0666 /dev/kmsg
    chown system system /dev/rpmb0
    chown system system /dev/mmcblk0rpmb
    chown system system /dev/0:0:0:49476
    chown system system /dev/ufs-bsg0
    start tee-supplicant
    mkdir /mnt/vendor/persist/data 0755 system system
    mkdir /mnt/vendor/persist/fdsd 0755 system system
    setprop vendor.teefs_state ready
    setprop ro.hardware.gatekeeper mitee

# miteelog
on post-fs-data
    mkdir /data/vendor/mitee
    chmod 0755 /data/vendor/mitee
    chown system system /data/vendor/mitee
    mkdir /data/vendor/thh
    chmod 0755 /data/vendor/thh
    chown system system /data/vendor/thh
    write /proc/bootprof "init miteelog"
    start miteelog
EOF

    echo "init.mitee.rc file created successfully."
else
    echo "No vendor/mitee folder detected. Skipping init.mitee.rc creation."
fi

sleep 3

clear

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
delete_empty_dirs "$DEST_VENDOR_APP"

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

if [ -d "$DEST_VENDOR_APP" ]; then
    echo "Checking if vendor/app is empty..."
    if [ -z "$(ls -A "$DEST_VENDOR_APP")" ]; then
        echo "vendor/app is empty. Deleting it..."
        rm -rf "$DEST_VENDOR_APP"
        echo "Deleted empty vendor/app directory."
    else
        echo "vendor/app is not empty. Skipping deletion."
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


else [ "$word" = "no" ];

  echo " Provide a stock forlders and continue after that. "  

exit 0

fi

clear

# Final Debugging Log
echo -e "${GREEN}===   Extraction and cleanup completed.   ===${RESET}"

sleep 2
