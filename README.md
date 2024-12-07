
# Crypto Blob Extractor Tool

This script is a utility for extracting specific system libraries, binaries, and other essential components related to `keymaster`, `gatekeeper`, and `keymint`. It also includes additional extraction for specific directories like `mcRegistry` and `thh/ta`. The tool is intended for ROM extraction tasks such as preparing extracted files for custom recovery (TWRP, LineageOS, etc.) or other modding purposes.

---

## 🚀 Features

- Extracts **keymaster**, **gatekeeper**, **keymint** binaries and libraries from the given ROM dump directory.
- Extracts binaries from `vendor/bin/hw` related to `keymaster`, `gatekeeper`, or `keymint`.
- Extracts files from the following paths if they exist:
  - `vendor/app/mcRegistry`
  - `vendor/thh/ta`
- Handles extraction for:
  - `system/lib64`
  - `system/lib64/hw`
  - `system_ext/lib64`
  - `system_ext/lib64/hw`
  - `vendor/lib64`
  - `vendor/lib64/hw`
  - `vendor/bin/hw`
- Cleans up **empty directories** after extraction, including automatically checking if `system_ext` is empty and deleting it.

---

## 🛠️ Prerequisites

Before using this script, ensure:

1. **Bash Environment**: This script uses bash and is compatible with Linux and macOS systems with bash support.
2. Ensure you have permission to access the ROM dump path provided.

You will need to have a ROM dump (or extracted ROM system image) directory ready to use with this script.

---

## 💻 Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/GitFASTBOOT/extract_android_crypto_blobs.git
   cd extract_android_crypto_blobs
   ```
2. Ensure the script is executable:
   ```bash
   chmod +x extract_crypto_blobs.sh
   ```

---

## 🛠️ Usage

### Extracting from a ROM dump
1. Run the script with the path to your extracted ROM dump:
   ```bash
   ./extract_crypto_blobs.sh "path/to/rom/dump"
   ```

- Replace `"path/to/rom/dump"` with the actual path to your ROM dump directory.

---

## 📂 Directory Structure

After extraction, the files will be sorted into the following directories:

- **`./system/lib64/`**: System libraries extracted.
- **`./system/lib64/hw/`**: Extracted hardware libraries.
- **`./system_ext/lib64/`**: System extension libraries extracted.
- **`./system_ext/lib64/hw/`**: Extracted hardware system extension libraries.
- **`./vendor/lib64/`**: Vendor libraries extracted.
- **`./vendor/lib64/hw/`**: Extracted vendor hardware libraries.
- **`./vendor/bin/hw/`**: Extracted `keymaster`, `gatekeeper`, `keymint`, and other relevant binaries.
- **`./vendor/app/mcRegistry/`**: Extracted if it exists.
- **`./vendor/thh/ta/`**: Extracted if it exists.

---

## 🏆 Features in Detail

1. **Automatic Cleanup**:
   - Deletes empty directories after extraction.
   - Cleans `system_ext` only if it's completely empty.

2. **Binaries Search**:
   - The script searches for `keymaster`, `gatekeeper`, and `keymint` binaries/libraries automatically.

3. **Support for Nested Extraction**:
   - Ensures extraction from complex directory paths like `vendor/bin/hw/`, `vendor/thh/ta`, or other specialized subfolders.

---

## 📝 Example Output

After running:

```bash
./extract_crypto_blobs.sh "/path/to/rom/dump"
```

You might see output like:

```
Using ROM dump directory: /path/to/rom/dump
Searching for libraries, binaries, mcRegistry, and thh/ta files in this path...
Found: /path/to/rom/dump/system_ext/lib64/hw/libkeymaster.so
Copying to system_ext/lib64/hw/
Found: /path/to/rom/dump/vendor/bin/hw/gatekeeper
Copying to vendor/bin/hw/
Found vendor/app/mcRegistry directory. Extracting files...
Found vendor/thh/ta directory. Extracting files...
Cleaning up empty directories...
Deleted empty system_ext directory.
Extraction and cleanup completed.
```

---

## 🛡️ Contributing

If you find any bugs or have feature requests, feel free to fork this repository, create a branch, and submit a pull request.

---

## 📜 License

This script is licensed under the **MIT License**. For more information, check [LICENSE](LICENSE).
