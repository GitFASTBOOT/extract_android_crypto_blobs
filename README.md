# Crypto Blob Extractor Tool

This script is a utility to extract libraries such as binaries, services and other essential components & files related to `keymaster`, `gatekeeper` and `keymint` specifically from /system, /vendor and /system_ext (if present). It also includes additional extraction for specific directories such as `app/mcRegistry`, `thh/ta` and `app/t6`. The tool is intended for firmware/ROM extraction tasks such as preparing and copying extracted files to the device tree of a custom recovery (TWRP, LineageOS, etc.) or other modding purposes. The goal is to be simple and easy, have greater agility.

> [!CAUTION]
> The utility only interacts passively between the stock ROM folders the files requested in the script. Therefore, there are not enough changes to work magic and create a correct Device Tree with the files extrated.
> The files are as they are, and what will make the difference in having a correct Device Tree is how the user makes his own modifications based on his own device. In addition, it is important that the user reviews the result (output folders) and the stock ROM folders to check and see if more files are still needed.
> In this context, learning and having knowledge[^¹] for the changes, as well as where the information is and where to place it is the user's sole responsibility.

---

## 🚀 Features

- Extracts **keymaster**, **gatekeeper**, **keymint** binaries and libraries files from the Firmware folder.
- Extracts binaries files from `vendor/bin/hw` related to `keymaster`, `gatekeeper`, or `keymint`.
- Extracts binaries files from `vendor/bin` related to `mcRegistry`, `teei_daemon`, or `teed`.
- Extracts files from the following paths if they exist:
  - `vendor/app/mcRegistry`
  - `vendor/thh/ta`
  - `vendor/mitee/ta`
  - `vendor/app/t6`
- Handles extraction for:
  - `system/lib64`
  - `system/lib64/hw`
  - `system/etc`
  - `system/etc/vintf`
  - `system/etc/vintf/manifest`
  - `system_ext/lib64`
  - `system_ext/lib64/hw`
  - `vendor/lib64`
  - `vendor/lib64/hw`
  - `vendor/bin/hw`
  - `vendor/bin`
  - `vendor/firmware`
  - `vendor/etc/vintf`
  - `vendor/etc/vintf/manifest`
- Cleans up **empty directories** after extraction, including automatically checking if `system_ext` is empty and deleting it.

---

## 🛠️ Prerequisites

Before using this script, ensure:

1. **Bash Environment**: This script uses bash and is compatible with Linux and macOS systems with bash support.
2. You will need to have a stock ROM files (or extracted stock ROM folders) ready to use with this script.
3. Initially the script already has the appropriate permission to execute the extraction.
    - In special cases aside, make sure you have permission to access the extracted folder, such as `extract_android_crypto_blobs` or another folder you want to create[^²].

---

## 💻 Installation

### Clone the repository:
   ```bash
   git clone https://github.com/GitFASTBOOT/extract_android_crypto_blobs.git
   cd extract_android_crypto_blobs
   ```

---

## 🛠️ Usage

### Unpacked stock ROM folders from firmware.img
1. Copy stock ROM folders to `extract_android_crypto_blobs/Firmware` folder.
   Example: `/Firmware/vendor` & `/Firmware/system` & `/Firmware/system_ext`
   Dont't worries if you stock ROM not have `/system_ext`.
   Usually the stock ROM system.img file is unpacked like this: `system/system/`. Note that we want the second part of `system` and therefore indicated like system/**system/**.

   
<details><summary>Click to open</summary>
<p>

## copy picture od FileManager extract_android_crypto_blobs/Firmware


</p>
</details>


### Run the script
2. Run[^³] the script according to the extracted extract_android_crypto_blobs folder or the folder that you created:
   ```bash
   ./extract_crypto_blobs.sh
   ```

<details><summary>Click to open</summary>
<p>

## copy picture od FileManager extract_android_crypto_blobs


</p>
</details>


[^¹]: If you want to learn more, visit [Copying firmware files to the Device Tree - Mediatek](https://gist.github.com/lopestom/c4a2648958db5c3db03d32033a3583cd)
[^²]: This script **already has permission**. But if you have any doubts then you can check the script with:
   ```bash
   chmod +x extract_crypto_blobs.sh
   ```

[^³]: Use whatever Terminal emulator you want/prefer. You can type directly into the Terminal or double-click on the sh file.

---

## 📂 Directory Structure

After extraction, the sorted files are automatically copied into the following appropriate directories:

- **`./system/lib64/`**: System libraries extracted.
- **`./system/lib64/hw/`**: Extracted hardware libraries.
- **`./system/etc/vintf/manifest.xml`**: Extracted manifest file.
- **`./system/etc/`**: Extracted event-log-tags & task_profiles.json files.
- **`./system_ext/lib64/`**: System extension libraries extracted.
- **`./system_ext/lib64/hw/`**: Extracted hardware system extension libraries.
- **`./vendor/lib64/`**: Vendor libraries extracted.
- **`./vendor/lib64/hw/`**: Extracted vendor hardware libraries.
- **`./vendor/bin/hw/`**: Extracted `keymaster`, `gatekeeper`, `keymint`, and other relevant binaries files.
- **`./vendor/bin/`**: Extracted `mcRegistry`, `teei_daemon`, `teed` or service, production-line, tee clients and ca files.
- **`./vendor/firmware/`**: Vendor binaries extracted.
- **`./vendor/etc/vintf/manifest.xml`**: Extracted manifest file.
- **`./vendor/app/mcRegistry/`**: Extracted if it exists.
- **`./vendor/thh/ta/`**: Extracted if it exists.
- **`./vendor/mitee/ta/`**: Extracted if it exists.
- **`./vendor/app/t6/`**: Extracted if it exists.

---

## 🏆 Features in Detail

1. **Automatic Cleanup**:
   - Deletes empty directories after extraction.
   - Cleans `system_ext` only if it's completely empty.

2. **Binaries Search**:
   - The script searches for `keymaster`, `gatekeeper` and `keymint` binaries/libraries files automatically.

3. **Services Search**:
   - The script searches for `beanpod`, `trustonic` and `trustkernel` services files automatically.
     <details><summary>Click to open</summary>
     <p>

     ## copy pictureS od FileManager extract_android_crypto_blobs


     </p>
     </details>

4. **Support for Nested Extraction**:
   - Ensures extraction from complex directory paths like `vendor/bin/hw/`, `vendor/thh/ta`, `vendor/app/*.*` and/or other special subfolders.

---

## 📝 Example of Output script

Visualization and Explanation of script steps
<details><summary>If you copied stock ROM to Firmware folder - Click to open</summary>
<p>

Step | happening |   | Step | happening
| ---: | :--- | :---: | ---: | :---
1-| Run the script |  | 6- | Debugging with encryption/decryption mode visualization
2-| Alert message so you don't forget |  | 7- | Script starts searching to copy
3-| Confirm your choice |  | 8- | Script searching and copying the files
4-| Answer the question |  | 9- | Skipping the folders&files not finded
5-| The script is starting |  | 10- | Script completion notice


</p>
</details>


<details><summary>If you **NOT** copied stock ROM to Firmware folder - Click to open</summary>
<p>

Step | happening |
| ---: | :--- |
11-| Simple message to continue script after required action


</p>
</details>

---

## 🛡️ Contributing

If you find any bugs or have feature requests, feel free to fork this repository, create a branch, and submit a pull request.

---

## 📜 License

This script is licensed under the **MIT License**. For more information, check [LICENSE](LICENSE).
