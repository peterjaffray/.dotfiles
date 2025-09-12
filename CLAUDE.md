# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a comprehensive dotfiles management system that provides cross-platform configuration management for shells, applications, and utility scripts. The system uses a modular architecture with intelligent machine detection, secret management, and automated installation.

## Key Architecture

### Core Management System
- **Main Command**: `./dotfiles` or `scripts/bin/dotfiles` - Central management interface
- **System Libraries**: Located in `system/` directory containing core functionality:
  - `backup-manager.sh` - Backup and restore operations
  - `machine-detector.sh` - OS and machine profiling 
  - `symlink-manager.sh` - Safe symlink creation and management
  - `secret-manager.sh` - Encrypted secret handling

### Configuration Structure
- `config/` - All managed configurations organized by category:
  - `config/shells/` - Shell-specific configs (bash, fish, zsh, common)
  - `config/apps/` - Application configs (git, tmux, nvim)
  - `config/packages/` - Package lists for different systems
- `dotfiles-map.txt` - Symlink mapping file (source=target format)

### Installation System
- `install/install.sh` - Main installer with profile support (minimal, development, server)
- `install/modules/` - Modular installation components
- Supports dry-run, interactive/non-interactive modes

## Common Commands

### Primary Management
```bash
# System status and diagnostics
./dotfiles status          # Show current dotfiles status
./dotfiles doctor          # Run system diagnostics
./dotfiles info            # Show system information

# Installation and setup
./install/install.sh                    # Interactive installation
./install/install.sh --profile development --dry-run  # Test installation

# Synchronization and maintenance
./dotfiles sync            # Sync with remote repository  
./dotfiles backup          # Create backup
./dotfiles clean           # Clean broken symlinks and old backups
```

### Development Workflow
```bash
# Adding new configurations
./dotfiles add ~/.vimrc     # Add file to dotfiles management

# Secret management
./dotfiles secrets init     # Initialize secret management
./dotfiles secrets add GITHUB_TOKEN  # Add secret interactively

# Symlink management  
./dotfiles links verify     # Verify symlink integrity
./dotfiles links list       # List managed symlinks
```

### Testing and Validation
```bash
# Always run diagnostics after changes
./dotfiles doctor

# Verify configuration integrity
./dotfiles test            # Validate configurations
./dotfiles links verify    # Check symlink health
```

## Development Guidelines

### File Organization
- Configuration files go in appropriate `config/` subdirectories
- Utility scripts go in `scripts/bin/` and are auto-added to PATH
- System libraries use the `system/` directory with `.sh` extension
- Machine-specific overrides go in `config/machines/`

### Symlink Management
- Use `dotfiles-map.txt` for defining symlink mappings
- Format: `source_path=target_path` with variable support (`~`, `$HOME`)
- The symlink manager handles backup creation and conflict resolution

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

## Important Notes

- The main `./dotfiles` script delegates to `scripts/bin/dotfiles` for full functionality
- Backup creation is automatic during installation and major operations
- The system uses git for version control but keeps secrets separate
- Machine profiles are auto-detected and can be customized
- Cross-shell compatibility is maintained through the `config/shells/common/` directory