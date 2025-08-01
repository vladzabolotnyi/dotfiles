#!/bin/bash

DOTFILES_DOTS_SOURCE_DIR="dotfiles/dots"
DOTFILES_CONFIG_DIR_NAME="dotfiles/config"

CONFIG_TARGET_DIR="$HOME/.config"
DOTS_TARGET_DIR="$HOME"

error_exit() {
  echo "Error: $1" >&2
  # exit 1
}

echo "--- Dotfiles Symlinking Script ---"
echo "This script will create symbolic links from dotfiles directory"
echo "to your '$CONFIG_TARGET_DIR' directory"
echo ""
echo "Enter the absolute path to the parent directory of your '$DOTFILES_CONFIG_DIR_NAME' folder: "
read -r ROOT_PREFIX

# -- Input Validation
if [ -z "$ROOT_PREFIX" ]; then
  error_exit "Absolute path cannot be empty"
fi

# Resolve absolute path and normalize it
# This handles cases like '~/my-dotfiles' or '../my-dotfiles'
ROOT_PREFIX=$(eval echo "$ROOT_PREFIX")
ROOT_PREFIX=$(realpath -q "$ROOT_PREFIX" || echo "$ROOT_PREFIX")

if [[ ! -d "$ROOT_PREFIX" ]]; then
  error_exit "The provided path '$ROOT_PREFIX' does not exist or is not a directory."
fi

DOTFILES_SOURCE_DIR="$ROOT_PREFIX/$DOTFILES_CONFIG_DIR_NAME"

if [[ ! -d "$DOTFILES_SOURCE_DIR" ]]; then
  error_exit "The provided path '$DOTFILES_SOURCE_DIR' does not exist or is not a directory."
fi

if [[ ! -d "$CONFIG_TARGET_DIR" ]]; then
  echo "Creating target directory: '$CONFIG_TARGET_DIR'"
  mkdir -p "$CONFIG_TARGET_DIR" || error_exit "Failed to create '$CONFIG_TARGET_DIR'."
fi

for item in "$DOTFILES_SOURCE_DIR"/*; do
  [ -e "$item" ] || continue

  item_name=$(basename "$item")
  target_path="$CONFIG_TARGET_DIR/$item_name"

  if [ -L "$target_path" ] && [ "$(readlink "$target_path")" = "$item" ]; then
    echo "'$item_name' is already correctly softlinked. Skipping."
    continue
  fi

  ln -s "$item" "$target_path" || error_exit "Failed to create symlink for '$item_name'"
done

DOTS_SOURCE_DIR="$ROOT_PREFIX/$DOTFILES_DOTS_SOURCE_DIR"

for item in "$DOTS_SOURCE_DIR"/.[!.]*; do
  [ -e "$item" ] || continue

  item_name=$(basename "$item")
  target_path="$DOTS_TARGET_DIR/$item_name"

  if [ -e "$target_path" ]; then
    if [ "$(stat -c %i "$item")" = "$(stat -c %i "$target_path")" ]; then
      echo "'$item_name' is already correctly hardlinked. Skipping."
      continue
    fi
  fi

  ln "$item" "$target_path" || error_exit "Failed to create hardlink for '$item_name'"
done
