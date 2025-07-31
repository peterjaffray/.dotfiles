#!/bin/bash
# Dotfiles setup script

set -e

DOTFILES_DIR="$HOME/.dotfiles"

echo "Setting up dotfiles..."

# Create backup directory
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Function to create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"
    
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

# Symlink individual dotfiles
create_symlink "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
create_symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
create_symlink "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
create_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# Symlink config directories
mkdir -p "$HOME/.config"
create_symlink "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"
create_symlink "$DOTFILES_DIR/.config/fish" "$HOME/.config/fish"

echo "Dotfiles setup complete!"
echo "Backups saved to: $BACKUP_DIR"