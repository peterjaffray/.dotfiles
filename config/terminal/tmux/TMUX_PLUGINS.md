# Tmux Plugin Configuration

This tmux configuration includes the following plugins:

## Installed Plugins

1. **TPM (Tmux Plugin Manager)** - Plugin manager for tmux
2. **tmux-sensible** - Basic tmux settings everyone can agree on
3. **tmux-resurrect** - Persist tmux environment across system restarts
4. **tmux-continuum** - Automatic saving and restoring of tmux sessions

## First-Time Setup

After symlinking the tmux config, install plugins:

1. Start tmux: `tmux`
2. Press `Ctrl-a` + `I` (capital i) to install all plugins
3. All plugins will be automatically downloaded and installed

## Key Bindings

### Tmux Resurrect
- `Ctrl-a` + `Ctrl-s` - Save current session
- `Ctrl-a` + `Ctrl-r` - Restore saved session

### General Tmux (from config)
- `Ctrl-a` - Prefix key (instead of default Ctrl-b)
- `Ctrl-a` + `|` - Split window vertically
- `Ctrl-a` + `-` - Split window horizontally
- `Ctrl-a` + `r` - Reload tmux configuration
- `Alt + Arrow Keys` - Navigate between panes
- `Ctrl-a` + `h` - Previous window
- `Ctrl-a` + `;` - Next window

## Features

### Automatic Session Saving
- Sessions are automatically saved every 15 minutes
- Sessions are automatically restored when tmux starts
- Includes vim/neovim session restoration
- Preserves pane contents and shell history

### Manual Session Management
You can manually save/restore at any time using the key bindings above.

## Troubleshooting

If plugins don't load:
1. Ensure you're in tmux
2. Press `Ctrl-a` + `I` to install plugins
3. If issues persist, run: `~/.config/tmux/plugins/tpm/bin/install_plugins`