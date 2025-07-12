#!/bin/bash

DOTFILES_DIR_NAME="dotfiles/config"
CONFIG_TARGET_DIR="$HOME/.config"

error_exit() {
  echo "Error: $1" >&2
  # exit 1
}

echo "--- Dotfiles Symlinking Script ---"
echo "This script will create symbolic links from dotfiles directory"
echo "to your ~/.config directory"
echo ""
echo "Enter the absolute path to the parent directory of your '$DOTFILES_DIR_NAME' folder: "
read -r ROOT_PREFIX

# -- Input Validation
if [ -z "$ROOT_PREFIX" ]; then
  error_exit "Root prefix cannot be empty"
fi

# Resolve absolute path and normalize it
# This handles cases like '~/my-dotfiles' or '../my-dotfiles'
ROOT_PREFIX=$(eval echo "$ROOT_PREFIX")
ROOT_PREFIX=$(realpath -q "$ROOT_PREFIX" || echo "$ROOT_PREFIX")

if [[ ! -d "$ROOT_PREFIX" ]]; then
  error_exit "The provided path '$ROOT_PREFIX' does not exist or is not a directory."
fi

DOTFILES_SOURCE_DIR="$ROOT_PREFIX/$DOTFILES_DIR_NAME"

if [[ ! -d "$DOTFILES_SOURCE_DIR" ]]; then
  error_exit "The provided path '$DOTFILES_SOURCE_DIR' does not exist or is not a directory."
fi

echo "Validated: Your dotfiles source directory is: '$DOTFILES_SOURCE_DIR'"

if [[ ! -d "$CONFIG_TARGET_DIR" ]]; then
  echo "Creating target directory: '$CONFIG_TARGET_DIR'"
  mkdir -p "$CONFIG_TARGET_DIR" || error_exit "Failed to create '$CONFIG_TARGET_DIR'."
fi

echo "Validated: Your config links destination directory is: '$CONFIG_TARGET_DIR'"

echo ""
echo "Starting symlimk creation from '$DOTFILES_SOURCE_DIR' to '$CONFIG_TARGET_DIR'"
echo ""

for item in "$DOTFILES_SOURCE_DIR"/*; do
  [ -e "$item" ] || continue

  item_name=$(basename "$item")
  target_path="$CONFIG_TARGET_DIR/$item_name"

  ln -s "$item" "$target_path" || error_exit "Failed to create symlink for '$item_name'"

  echo "Successfully linked '$item_name'"
done

echo "Symlinking process completed!"
