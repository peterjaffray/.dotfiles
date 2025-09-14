#!/bin/bash
# Dotfiles setup script
# Uses dotfiles-map.txt to create all necessary symlinks

set -e

DOTFILES_DIR="$HOME/.dotfiles"
DOTFILES_MAP="$DOTFILES_DIR/dotfiles-map.txt"

echo "Setting up dotfiles..."

# Create backup directory
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Function to create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"

    # Create parent directory if it doesn't exist
    local target_dir=$(dirname "$target")
    if [ ! -d "$target_dir" ]; then
        mkdir -p "$target_dir"
        echo "Created directory: $target_dir"
    fi

    # If target exists and is not a symlink, back it up
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "Backing up existing $target to $BACKUP_DIR"
        cp -r "$target" "$BACKUP_DIR/"
    fi

    # Remove existing file/directory/symlink
    rm -rf "$target"

    # Create symlink
    ln -sf "$source" "$target"
    echo "Created symlink: $target -> $source"
}

# Check if dotfiles-map.txt exists
if [ ! -f "$DOTFILES_MAP" ]; then
    echo "Error: $DOTFILES_MAP not found!"
    exit 1
fi

# Read dotfiles-map.txt and create all symlinks
while IFS='=' read -r source target; do
    # Skip comments and empty lines
    [[ "$source" =~ ^#.*$ || -z "$source" ]] && continue

    # Expand variables
    source="${source/#\~/$HOME}"
    target="${target/#\~/$HOME}"
    source=$(eval echo "$source")
    target=$(eval echo "$target")

    # Check if source exists
    if [ ! -e "$source" ]; then
        echo "Warning: Source $source does not exist, skipping..."
        continue
    fi

    create_symlink "$source" "$target"
done < "$DOTFILES_MAP"

echo ""
echo "Dotfiles setup complete!"
if [ -n "$(ls -A $BACKUP_DIR 2>/dev/null)" ]; then
    echo "Backups saved to: $BACKUP_DIR"
else
    # Remove empty backup directory
    rmdir "$BACKUP_DIR" 2>/dev/null || true
fi