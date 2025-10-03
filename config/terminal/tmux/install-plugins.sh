#!/bin/bash
# Install tmux plugins
# This script installs TPM and all configured tmux plugins

set -e

TMUX_PLUGINS_DIR="$HOME/.config/tmux/plugins"
TPM_DIR="$TMUX_PLUGINS_DIR/tpm"

echo "Installing tmux plugins..."

# Create plugins directory if it doesn't exist
mkdir -p "$TMUX_PLUGINS_DIR"

# Clone TPM if not already installed
if [ ! -d "$TPM_DIR" ]; then
    echo "Installing TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
    echo "TPM already installed"
fi

# Install plugins
if [ -f "$TPM_DIR/bin/install_plugins" ]; then
    echo "Installing tmux plugins..."
    "$TPM_DIR/bin/install_plugins"
else
    echo "TPM install script not found. Please install plugins manually:"
    echo "  1. Start tmux"
    echo "  2. Press Ctrl-a + I (capital i)"
fi

echo "Tmux plugins installation complete!"
echo ""
echo "Key bindings:"
echo "  Save session:    Ctrl-a + Ctrl-s"
echo "  Restore session: Ctrl-a + Ctrl-r"
echo ""
echo "Sessions are automatically saved every 15 minutes."