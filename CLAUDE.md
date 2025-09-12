# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a comprehensive dotfiles management system that provides cross-platform configuration management for shells, applications, and utility scripts. The system uses a modular architecture with intelligent machine detection, secret management, and automated installation.

## Key Architecture

### Dual Command Structure
- **Main Entry Point**: `./dotfiles` - Simple delegator script that forwards to full implementation
- **Full Implementation**: `scripts/bin/dotfiles` - Complete command suite with all functionality
- Both files source the same system libraries for consistent behavior

### System Libraries (`system/` directory)
Core functionality modules that provide the backbone of the dotfiles system:
- `backup-manager.sh` - Timestamped backups with rotation (max 10 backups)
- `machine-detector.sh` - OS and machine profiling with role-based configs
- `symlink-manager.sh` - Safe symlink creation with conflict resolution and integrity tracking
- `secret-manager.sh` - Encrypted secret handling with templates

### Configuration Structure
- `config/` - All managed configurations organized by category:
  - `config/shells/` - Shell-specific configs (bash, fish, zsh, common)
  - `config/apps/` - Application configs (git, tmux, nvim)
  - `config/packages/` - Package lists for different systems
  - `config/machines/` - Machine-specific overrides and customizations
  - `config/secrets/` - Git-ignored encrypted secrets storage
- `dotfiles-map.txt` - Symlink mapping file using `source_path=target_path` format with variable expansion

### Installation System
- `install/install.sh` - Main installer with profile support (minimal, development, server)
- `install/modules/dotfiles.sh` - Modular installation component
- Supports dry-run mode, interactive/non-interactive modes, and profile-based installs

## Common Commands

### Primary Management
```bash
# System status and diagnostics
./dotfiles status          # Show git status, machine info, symlinks, backups
./dotfiles doctor          # Comprehensive system diagnostics with issue detection
./dotfiles info            # Show system and dotfiles information with git details

# Installation and setup
./install/install.sh                    # Interactive installation with profile selection
./install/install.sh --profile development --dry-run  # Test installation without changes
./install/install.sh --profile minimal  # Minimal installation for servers

# Synchronization and maintenance
./dotfiles sync            # Sync with remote repository (handles conflicts)
./dotfiles backup          # Create timestamped backup with rotation
./dotfiles clean           # Clean broken symlinks and old backups (30+ days)
```

### Development Workflow
```bash
# Adding new configurations
./dotfiles add ~/.vimrc     # Automatically categorize and add to dotfiles-map.txt

# Secret management
./dotfiles secrets init     # Initialize GPG-encrypted secret storage
./dotfiles secrets add GITHUB_TOKEN  # Interactive secret addition with encryption

# Symlink management  
./dotfiles links verify     # Check all symlinks in dotfiles-map.txt for integrity
./dotfiles links list       # Display all managed symlinks with status
./dotfiles links create     # Create symlinks from dotfiles-map.txt
```

### Testing and Validation
```bash
# Always run diagnostics after changes
./dotfiles doctor          # Check directories, files, git repo, symlinks, PATH, dependencies

# Verify configuration integrity
./dotfiles test            # Alias for ./dotfiles doctor
./dotfiles validate        # Alternative alias for diagnostics
```

## Development Guidelines

### File Organization
- Configuration files go in appropriate `config/` subdirectories
- Utility scripts go in `scripts/bin/` and are auto-added to PATH
- System libraries use the `system/` directory with `.sh` extension
- Machine-specific overrides go in `config/machines/`

### Symlink Management
- Use `dotfiles-map.txt` for defining symlink mappings (see dotfiles-map.txt:1-20)
- Format: `source_path=target_path` with variable expansion (`~`, `$HOME`)
- Symlink manager creates `.symlink-map` for tracking with timestamps
- Automatic backup creation before overwriting existing files
- Conflict resolution with user prompts for existing non-symlinked files

### Cross-Platform Compatibility
- The system supports Linux, macOS, and WSL
- Use the machine detector for OS-specific logic
- Shell configurations work across bash, fish, and zsh

### Secret Handling
- Never commit secrets to git - they go in `config/secrets/` (git-ignored)
- Use the secret manager for encrypted storage and loading
- Templates go in `templates/` directory

## Testing

The system includes built-in diagnostics:
```bash
./dotfiles doctor    # Comprehensive system check
./dotfiles test      # Validate configurations
```

Always run diagnostics after making changes to ensure system integrity.

## Documentation Reference

For comprehensive documentation, see `/docs/LOCAL_DOCS_INDEX.md` which provides:
- Cross-links to all local documentation
- Context inclusion guidelines for Claude Code instances  
- Quick reference for finding relevant docs

Key documentation files to include in context:
- **Always**: This file (`CLAUDE.md`), `docs/README.md`, and `docs/COMMANDS.md`
- **Shell work**: `config/shells/fish/README.md` for Fish-specific tasks
- **Claude customization**: `config/claude/CLAUDE.md` and related configs
- **Alias management**: `scripts/bin/alias-manager` (replaces legacy add-alias tool)
- **Quick reference**: Use `? cheat` or `? 1` for mobile-optimized command lookup

## Important Implementation Details

### Command Architecture
- Main `./dotfiles` (dotfiles:107-114) delegates to `scripts/bin/dotfiles` via `exec`
- The full implementation handles 15+ subcommands including status, sync, backup, restore
- Both scripts source the same system libraries for consistency

### Backup System
- Automatic timestamped backups before major operations (backup-manager.sh:24-26)
- Maximum 10 backups retained with automatic rotation
- Backup files use format: `filename.backup.YYYYMMDD_HHMMSS`

### Symlink Tracking
- Internal `.symlink-map` file tracks all managed symlinks with timestamps
- Format: `timestamp|source|target` for precise tracking
- Integrity verification checks for broken or modified symlinks

### Machine Detection
- Auto-detects OS, distro, version, WSL status, and assigns role
- Machine profiles stored in `config/machines/` for customization
- Cross-shell compatibility maintained through `config/shells/common/`

### Git Integration
- Uses git for version control but excludes `config/secrets/` directory
- Sync command handles merge conflicts and stashing of uncommitted changes
- Status command shows git state, branch info, and uncommitted/untracked files

### Cross-Shell Alias System
- `alias-manager` tool provides true cross-shell alias management
- Fish supports standard `alias` syntax (not just `abbr`)
- `safe_alias()` function provides graceful fallbacks when commands missing
- Fish compatibility layer at `config/shells/fish/conf.d/00-aliases.fish`

### Documentation System
- Interactive help via `? [topic]` or `h [topic]` commands
- Number-based navigation (press numbers, no arrow keys needed)
- Mobile-optimized cheat sheet accessible via `? cheat` or `? 1`
- All docs use 2-space indentation and max 50 chars/line for mobile compatibility