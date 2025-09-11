# Dotfiles & Scripts Management System

A comprehensive, cross-platform dotfiles and utility scripts management system with intelligent machine detection, secret management, and automated installation.

## 🚀 Features

- **Cross-Machine Consistency** - Same shell environment across all your machines
- **Intelligent Installation** - Detects OS, shell, and machine characteristics
- **Secret Management** - Safe handling of API keys and sensitive data
- **Script Management** - Organized utility scripts with documentation
- **Backup & Restore** - Automatic backups with easy restore
- **Symlink Management** - Safe symlink creation with conflict detection
- **Profile Support** - Different configurations for different machine roles
- **Git Integration** - Version control for all configurations

## 📁 Directory Structure

```
~/.dotfiles/
├── config/                      # All managed configurations
│   ├── shells/                  # Shell-specific configs
│   │   ├── bash/               # Bash configuration
│   │   ├── fish/               # Fish shell configuration  
│   │   ├── zsh/                # Zsh configuration
│   │   └── common/             # Cross-shell configs
│   │       ├── aliases         # Common aliases
│   │       ├── exports         # Environment variables
│   │       ├── paths           # PATH management
│   │       └── functions       # Shared functions
│   ├── apps/                   # Application configs
│   │   ├── git/                # Git configuration
│   │   ├── tmux/               # Tmux configuration
│   │   ├── nvim/               # Neovim configuration
│   │   └── ssh/                # SSH configuration
│   ├── machines/               # Machine-specific overrides
│   │   ├── current/            # Current machine configs
│   │   └── <machine-id>/       # Named machine configs
│   └── secrets/                # Encrypted secrets (git-ignored)
├── scripts/                    # Utility scripts
│   ├── bin/                    # Executable scripts
│   │   ├── dotfiles           # Main management command
│   │   └── add-alias          # Alias management tool
│   ├── lib/                    # Shared script libraries
│   ├── docs/                   # Script documentation
│   └── config/                 # Script configurations
├── install/                    # Installation system
│   ├── install.sh              # Main installer
│   └── modules/                # Installation modules
├── system/                     # Core system libraries
│   ├── backup-manager.sh       # Backup functionality
│   ├── machine-detector.sh     # Machine profiling
│   ├── symlink-manager.sh      # Symlink management
│   └── secret-manager.sh       # Secret handling
├── docs/                       # Documentation
│   └── README.md               # This documentation
├── backups/                    # Local backups (git-ignored)
├── dotfiles                    # Main management command
└── templates/                  # Configuration templates
```

## 🛠 Installation

### Quick Install (One-liner)

```bash
# Clone and install in one command
git clone <your-repo-url> ~/.config && ~/.config/install/install.sh
```

### Manual Installation

```bash
# 1. Clone the repository
git clone <your-repo-url> ~/.config

# 2. Run the installer
cd ~/.config
./install/install.sh

# 3. Restart your shell or source the configuration
source ~/.bashrc
```

### Installation Options

```bash
# Install with specific profile
./install/install.sh --profile development

# Dry run to see what would be installed
./install/install.sh --dry-run --verbose

# Non-interactive installation
./install/install.sh --yes --profile minimal

# Custom machine name
./install/install.sh --machine-name work-laptop
```

## 📋 Installation Profiles

- **minimal** - Basic shell configuration and essential tools
- **development** - Full development environment (default)  
- **server** - Server-optimized configuration

## 🎯 Quick Start

After installation, use the `dotfiles` command to manage your system:

```bash
# Check system status
dotfiles status

# Show system information
dotfiles info

# Run system diagnostics
dotfiles doctor

# Sync with remote repository
dotfiles sync

# Create backup
dotfiles backup

# Manage machine profile
dotfiles machine show

# Initialize secrets
dotfiles secrets init

# List available scripts
dotfiles scripts list
```

## 🔧 Core Commands

### Dotfiles Management

```bash
dotfiles status              # Show current status
dotfiles sync               # Sync with remote
dotfiles add ~/.vimrc       # Add file to management
dotfiles backup             # Create backup
dotfiles restore [backup]   # Restore from backup
dotfiles diff              # Show local changes
```

### Secret Management

```bash
dotfiles secrets init                    # Initialize secrets
dotfiles secrets add GITHUB_TOKEN       # Add secret interactively
dotfiles secrets list                   # List configured secrets
dotfiles secrets import .env            # Import from .env file
```

### Script Management

```bash
dotfiles scripts list       # List available scripts
add-alias myalias "command" # Add shell alias
```

### System Management

```bash
dotfiles machine show       # Show machine profile
dotfiles doctor            # Run diagnostics  
dotfiles clean             # Clean up system
dotfiles info              # Show system info
```

## 🔐 Secret Management

The system includes secure secret management:

- **Encrypted Storage** - Secrets stored separately from git
- **Template System** - Easy setup with examples
- **Environment Loading** - Automatic loading in shells
- **Cross-Machine Sync** - Encrypted sync between machines

### Secret Setup

```bash
# Initialize secrets
dotfiles secrets init

# Add secrets interactively
dotfiles secrets add GITHUB_TOKEN
dotfiles secrets add AWS_ACCESS_KEY_ID

# Import from existing .env file
dotfiles secrets import .env

# List configured secrets (names only)
dotfiles secrets list
```

## 🖥 Machine Profiles

The system automatically detects machine characteristics:

- **OS Detection** - Linux/macOS/WSL identification
- **Role Detection** - Development/server/workstation
- **Tool Detection** - Available commands and features
- **Custom Overrides** - Machine-specific configurations

### Machine Management

```bash
# Show current machine profile
dotfiles machine show

# Detect and save new profile  
dotfiles machine save

# Compare with saved profile
dotfiles machine compare
```

## 📜 Available Scripts

### Utility Scripts

- **`add-alias`** - Smart alias management with conflict detection
- **`dotfiles`** - Central management command
- **`backup`** - Advanced backup functionality
- **`secrets`** - Secret management tools

### Adding Your Own Scripts

1. Add executable scripts to `scripts/bin/`
2. Document them in `scripts/docs/`
3. They'll be automatically available in your PATH

## 🏗 Shell Integration

### Cross-Shell Compatibility

The system works with multiple shells:

- **Bash** - Full support with enhanced features
- **Fish** - Native configuration with compatibility layer
- **Zsh** - Planned support

### Common Configurations

All shells share:
- **Aliases** - Consistent command shortcuts
- **Functions** - Useful utility functions  
- **Environment** - Same PATH and variables
- **Secrets** - Automatic secret loading

## 🔄 Synchronization

### Git-Based Sync

```bash
# Pull latest changes
dotfiles sync

# Check for local changes
dotfiles diff

# Handle conflicts automatically
dotfiles sync --auto-resolve
```

### Cross-Machine Setup

1. **Initial Setup** - Install on first machine
2. **Push Changes** - Commit and push your configurations
3. **New Machine** - Clone and install
4. **Automatic Sync** - Regular sync keeps everything updated

## 🩺 System Health

### Diagnostics

```bash
# Run full system check
dotfiles doctor

# Verify symlinks
dotfiles links verify

# Check backup integrity
dotfiles backup verify

# Clean up broken links
dotfiles clean
```

### Common Issues

- **Broken symlinks** - Run `dotfiles links verify` and `dotfiles clean`
- **Missing dependencies** - Run `dotfiles doctor` for installation commands
- **Sync conflicts** - Use `dotfiles sync` with conflict resolution
- **Permission issues** - Run `dotfiles secrets check`

## 📚 Advanced Usage

### Custom Machine Configurations

Create machine-specific overrides:

```bash
# Create machine-specific directory
mkdir ~/.config/dotfiles/machines/$(dotfiles machine get machine_id)

# Add machine-specific files
touch ~/.config/dotfiles/machines/current/bashrc
touch ~/.config/dotfiles/machines/current/exports
touch ~/.config/dotfiles/machines/current/functions
```

### Environment Variables

Set these for customization:

```bash
export DOTFILES_PROFILE=minimal        # Default profile
export DOTFILES_MACHINE_NAME=laptop    # Custom machine name  
export DOTFILES_NO_BACKUP=1           # Skip backups
```

### Adding New Dotfiles

```bash
# Add any file to management
dotfiles add ~/.vimrc

# The system will:
# 1. Move the file to appropriate dotfiles location
# 2. Create a symlink back to original location
# 3. Add it to version control
```

## 🔧 Development

### Project Structure

- **`lib/`** - Core functionality libraries
- **`install/`** - Installation and setup scripts  
- **`scripts/`** - User utility scripts
- **`dotfiles/`** - Managed configuration files
- **`templates/`** - Configuration templates

### Adding Features

1. **Libraries** - Add shared functionality to `lib/`
2. **Scripts** - Add utilities to `scripts/bin/`
3. **Modules** - Add installation modules to `install/modules/`
4. **Templates** - Add configuration templates to `templates/`

## 📄 License

This dotfiles system is open source. Feel free to fork and customize for your needs.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📞 Support

- **Issues** - Report bugs and request features via GitHub issues
- **Documentation** - Check `scripts/docs/` for detailed script documentation
- **System Check** - Run `dotfiles doctor` for diagnostic information

---

*Last updated: $(date)*

**Happy configuring! 🎉**