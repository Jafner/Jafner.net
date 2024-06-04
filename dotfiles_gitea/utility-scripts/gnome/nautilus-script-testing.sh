#!/bin/bash
echo "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" > ~/Nextcloud/Dotfiles/Fedora/test.txt

#if (( $(grep -c . <<<"$(cat ~/Nextcloud/Dotfiles/Fedora/test.txt)") > 1 )); then echo "Multiline" > ~/Nextcloud/Dotfiles/Fedora/result.txt; else echo "Single line" > ~/Nextcloud/Dotfiles/Fedora/result.txt; fi
#if (( $(grep -c . <<<"$(cat ~/.nautilus_script_selected_file_paths)") > 1 )); then echo "Multiline" > ~/Nextcloud/Dotfiles/Fedora/result.txt; else echo "Single line" > ~/Nextcloud/Dotfiles/Fedora/result.txt; fi
