---

# Edge Removal Script

## Description
This PowerShell script automates the process of uninstalling Edge from your system. It stops all Edge-related processes, deletes Edge directories, and removes associated registry entries.

## Prerequisites
- **Operating System**: Windows
- **PowerShell Version**: PowerShell 5.1 or newer (comes pre-installed on Windows 10 and later versions)

## Usage
1. **Download the Script**:
   - Clone or download the `EdgeRemove.ps1` script from this repository.

2. **End active Edge Tasks**:
   - Search for `Edge` in your Task Manager (you can open it with Ctrl+Shift+Escape) and end all active Edge tasks (including EdgeUpdate, etc.).

3. **Run the Script as Administrator**:
   - Right-click on `EdgeRemove.ps1` and select "Run as administrator". This script requires administrative privileges to stop processes, delete directories, and modify registry entries.

4. **Follow On-screen Instructions**:
   - The script will prompt you to confirm certain actions (like stopping processes or deleting files). Follow the prompts to proceed.

5. **Completion**:
   - Once the script finishes running, it will display a message indicating that Edge processes, directories, and registry entries have been successfully removed.

## Notes
- **Caution**: This script modifies system files and registry entries. Use it at your own risk.
- **Backup**: It's recommended to back up your system or critical data before running this script.
- **Support**: For questions or issues, please reach out to me on my [Discord Server](https://discord.gg/bfAwrUJJs7) or [contact me via email](mailto:edgeremover@skymail.de).

## License

This project is licensed under the Mozilla Public License 2.0. You can find a copy of the license at http://mozilla.org/MPL/2.0/.

## Copyright

© 2024 Slicisi. All rights reserved.
---
