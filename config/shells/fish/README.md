# Fish Shell Configuration Documentation

This document provides comprehensive documentation for all customizations made to the Fish shell configuration.

## Table of Contents

- [Overview](#overview)
- [Directory Structure](#directory-structure)
- [Configuration Files](#configuration-files)
- [Abbreviations](#abbreviations)
- [Custom Functions](#custom-functions)
- [Key Bindings](#key-bindings)
- [Environment Variables](#environment-variables)
- [Performance Optimizations](#performance-optimizations)
- [Welcome Screen](#welcome-screen)
- [Installation & Setup](#installation--setup)
- [Troubleshooting](#troubleshooting)

## Overview

This Fish shell configuration provides:
- Enhanced productivity with smart abbreviations
- Custom functions for common tasks
- ~~Beautiful welcome screen~~ Silent startup (disabled via `fish_greeting.fish`)
- Optimized startup performance
- Integration with modern CLI tools (fzf, fd, ripgrep)
- Organized, maintainable configuration structure
- **NEW**: Fisher plugin manager with essential plugins
- **NEW**: Cross-shell alias compatibility via `conf.d/01-aliases.fish`
- **NEW**: NVM integration for Node.js management

## Directory Structure

```
~/.config/fish/
├── README.md               # This documentation
├── config.fish            # Main configuration file
├── fishfile               # Fisher plugin list (NEW)
├── conf.d/                # Configuration snippets
│   ├── 01-aliases.fish   # Cross-shell aliases (NEW)
│   ├── fzf.fish         # FZF configuration (NEW)
│   ├── nvm.fish         # NVM support (NEW)
│   ├── z.fish           # Z directory jumping (NEW)
│   └── ssh-agent.fish   # SSH agent config (NEW)
├── functions/            # Custom functions
│   ├── backup.fish
│   ├── extract.fish
│   ├── fish_config_summary.fish
│   ├── fish_greeting.fish        # Disables welcome (NEW)
│   ├── fish_welcome_screen.fish  # Disabled screen
│   ├── list_completions.fish
│   ├── mkcd.fish
│   ├── reload.fish
│   └── up.fish
└── completions/          # Custom completions
```

## Fisher Plugin Manager (NEW)

Fish now uses Fisher for plugin management with these installed plugins:

### Installed Plugins:
- **nvm.fish** - Node Version Manager for Fish
- **z** - Smart directory jumping (`z partial-path`)
- **fzf.fish** - FZF integration with keybindings
- **autopair.fish** - Auto-close brackets and quotes
- **meaningful.fish** - Better error messages
- **fish-abbreviation-tips** - Shows available abbreviations
- **replay.fish** - Run bash commands in Fish
- **bass** - Source bash scripts (`bass source ~/.bashrc`)
- **fish-ssh-agent** - SSH agent management
- **plugin-git** - Git abbreviations and functions

### Plugin Management:
```bash
# Update all plugins
fisher update

# List installed plugins
fisher list

# Add new plugin
fisher install owner/plugin

# Remove plugin
fisher remove owner/plugin
```

## Configuration Files

### config.fish

The main configuration file contains:
- Interactive session configurations
- Path management
- Abbreviation definitions
- Environment variable settings
- Tool integrations

### Key Features:

1. **Powerline Integration**: Beautiful shell prompt with git status
2. **Smart Path Management**: Uses `fish_add_path` for idempotent path additions
3. **Lazy Loading**: Python environment loads on-demand for faster startup

## Cross-Shell Aliases (NEW)

Fish now shares aliases with bash and zsh via `conf.d/01-aliases.fish`.

### How It Works:
- All shells source from `config/shells/common/aliases.sh`
- Fish-specific adaptations in `conf.d/01-aliases.fish`
- Aliases work consistently across all shells

### Managing Aliases:
```bash
# Add new alias to all shells
echo "alias newalias='command'" >> ~/.dotfiles/config/shells/common/aliases.sh

# Reload to apply
reload  # or exec fish
```

## Abbreviations

Abbreviations expand automatically when you press space. They're superior to aliases as they show the full command before execution.

### Git Commands

| Abbreviation | Expands To | Description |
|--------------|------------|-------------|
| `g` | `git` | Base git command |
| `gc` | `git commit` | Commit changes |
| `gst` | `git status` | Show repository status |
| `gco` | `git checkout` | Switch branches/restore files |
| `gp` | `git push` | Push commits to remote |
| `gl` | `git pull` | Pull changes from remote |
| `gd` | `git diff` | Show changes |
| `ga` | `git add` | Stage changes |
| `gb` | `git branch` | List/create/delete branches |
| `glog` | `git log --oneline --graph --decorate` | Pretty git log |

### Navigation

| Abbreviation | Expands To | Description |
|--------------|------------|-------------|
| `ll` | `ls -lah` | Detailed list with hidden files |
| `la` | `ls -A` | List all except . and .. |
| `l` | `ls -CF` | Compact list with indicators |
| `..` | `cd ..` | Go up one directory |
| `...` | `cd ../..` | Go up two directories |
| `....` | `cd ../../..` | Go up three directories |

### System Commands

| Abbreviation | Expands To | Description |
|--------------|------------|-------------|
| `df` | `df -h` | Human-readable disk usage |
| `du` | `du -h` | Human-readable directory sizes |
| `free` | `free -h` | Human-readable memory info |

### Container/Development

| Abbreviation | Expands To | Description |
|--------------|------------|-------------|
| `dc` | `docker compose` | Docker Compose commands |
| `dps` | `docker ps` | List running containers |
| `k` | `kubectl` | Kubernetes CLI |

### Editor

| Abbreviation | Expands To | Description |
|--------------|------------|-------------|
| `v` | `nvim` | Neovim |
| `vi` | `nvim` | Neovim |
| `vim` | `nvim` | Neovim |

## Custom Functions

### File & Directory Operations

#### `mkcd <directory>`
Creates a directory and immediately enters it.
```fish
mkcd my-new-project
# Creates ./my-new-project and changes into it
```

#### `backup <file> [file2 ...]`
Creates timestamped backups of files.
```fish
backup config.json
# Creates: config.json.backup.20240723_141532
```

#### `extract <archive>`
Intelligently extracts various archive formats.
```fish
extract archive.tar.gz  # Extracts tar.gz
extract file.zip       # Extracts zip
extract data.7z        # Extracts 7z
```
Supported formats: tar.gz, tar.bz2, tar.xz, tar, zip, rar, 7z, gz, bz2, xz

#### `up [n]`
Navigate up n directories (default: 1).
```fish
up      # Go up one directory
up 3    # Go up three directories
```

### Configuration Management

#### `reload`
Reloads the Fish configuration without restarting the shell.
```fish
reload
# Output: Configuration reloaded!
```

#### `fish_config_summary`
Displays a summary of your Fish configuration.
```fish
fish_config_summary
# Shows config files, functions, abbreviations count, and key bindings
```

#### `list_completions`
Lists available command completions.
```fish
list_completions
# Shows installed commands with completions
```

## Key Bindings

| Key Combination | Action | Requirements |
|-----------------|---------|--------------|
| `Ctrl+R` | Fuzzy search command history | fzf installed |
| `Alt+←/→` | Move cursor by word | Standard Fish |
| `Alt+↑/↓` | Search history prefix | Standard Fish |
| `Ctrl+F` | Accept autosuggestion | Standard Fish |
| `Ctrl+A` | Move to line beginning | Standard Fish |
| `Ctrl+E` | Move to line end | Standard Fish |

## Environment Variables

### Set by Configuration

| Variable | Value | Purpose |
|----------|-------|---------|
| `EDITOR` | `nvim` | Default text editor |
| `VISUAL` | `nvim` | Visual editor for Git, etc. |
| `BROWSER` | `firefox` | Default web browser |
| `LANG` | `en_US.UTF-8` | System locale |
| `CDPATH` | `. ~ ~/dev` | Quick directory navigation |

### Fish-specific Variables

| Variable | Purpose |
|----------|---------|
| `fish_color_command` | Green command highlighting |
| `fish_color_error` | Bold red error highlighting |
| `fish_color_param` | Cyan parameter highlighting |
| `fish_color_quote` | Yellow string highlighting |

### Tool-specific Variables

| Variable | Purpose |
|----------|---------|
| `FZF_DEFAULT_OPTS` | FZF appearance settings |
| `FZF_DEFAULT_COMMAND` | Use fd for file finding if available |
| `PNPM_HOME` | PNPM installation directory |
| `PYENV_ROOT` | Python version management |

## Performance Optimizations

### 1. Lazy Loading
- **pyenv**: Only initializes when first used
- Reduces shell startup time by ~200-300ms

### 2. Git Prompt Optimization
```fish
set -g fish_git_prompt_showdirtystate false
set -g fish_git_prompt_showuntrackedfiles false
```
Disables expensive git operations in prompt for large repositories.

### 3. Smart Path Management
Uses `fish_add_path` which:
- Only adds paths if they exist
- Prevents duplicate entries
- Maintains path order

## Welcome Screen (DISABLED)

The welcome screen is now **disabled** for silent shell startup.

### To Re-enable:
1. Remove `~/.config/fish/functions/fish_greeting.fish`
2. Uncomment `fish_welcome_screen` in `config.fish`

### Original Features (when enabled):
- Current date
- Command reference table
- Git commands section
- Navigation shortcuts
- Custom functions list
- Docker & system commands
- Editor shortcuts
- Enhanced features summary
- Installed tools detection

### Disable Welcome Screen:
To disable the welcome screen, add to your config.fish:
```fish
set -g __fish_welcome_shown 1
```

### Manually Show Welcome:
```fish
fish_welcome_screen
```

## Installation & Setup

### Prerequisites
1. Fish shell (3.0+)
2. Optional but recommended:
   - fzf (fuzzy finder)
   - fd (fast file finder)
   - ripgrep (fast grep)
   - Powerline fonts

### Installation Steps

1. **Backup existing configuration:**
   ```bash
   cp -r ~/.config/fish ~/.config/fish.backup
   ```

2. **Install optional tools:**
   ```bash
   # Ubuntu/Debian
   sudo apt install fzf fd-find ripgrep
   
   # macOS
   brew install fzf fd ripgrep
   ```

3. **Apply configuration:**
   ```bash
   # Reload fish
   source ~/.config/fish/config.fish
   ```

## Troubleshooting

### Common Issues

#### 1. Powerline not showing correctly
**Solution**: Install Powerline and Powerline fonts:
```bash
pip install powerline-status
# Install a Powerline-compatible font
```

#### 2. Abbreviations not expanding
**Solution**: Ensure you're pressing space after the abbreviation.

#### 3. pyenv command not found
**Solution**: The pyenv function lazy-loads. Just run any pyenv command:
```fish
pyenv versions  # This will initialize pyenv
```

#### 4. Welcome screen not showing
**Solution**: Check if it's disabled:
```fish
set -e __fish_welcome_shown
```

#### 5. Slow startup
**Solution**: 
- Comment out unused features in config.fish
- Check for slow commands in config with:
  ```fish
  fish --profile-startup /tmp/fish.profile
  ```

### Getting Help

1. **Check configuration:**
   ```fish
   fish_config_summary
   ```

2. **Validate syntax:**
   ```fish
   fish -n ~/.config/fish/config.fish
   ```

3. **Debug mode:**
   ```fish
   fish -d 2
   ```

## Customization Guide

### Adding New Abbreviations
Add to config.fish in the interactive section:
```fish
abbr -a myabbr "my long command"
```

### Creating New Functions
Create a file in `~/.config/fish/functions/`:
```fish
# ~/.config/fish/functions/myfunction.fish
function myfunction --description 'My custom function'
    # Function body
end
```

### Modifying Colors
Add to config.fish:
```fish
set -gx fish_color_command blue
set -gx fish_color_param green
# See all colors: set | grep fish_color
```

### Adding to PATH
Use `fish_add_path` in config.fish:
```fish
fish_add_path ~/my/custom/path
```

## Contributing

Feel free to customize this configuration to match your workflow. The modular structure makes it easy to:
- Add new functions
- Modify abbreviations
- Integrate new tools
- Customize appearance

Remember to backup before making changes!

---

*Last updated: July 2024*
*Fish version: 3.0+*