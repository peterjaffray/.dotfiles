# Installation Guide

Comprehensive installation guide for the dotfiles management system with automatic dependency installation.

## 🚀 Quick Start

### One-Line Installation

```bash
# Clone and run complete setup
git clone <repository-url> ~/.dotfiles && ~/.dotfiles/install/modules/complete-setup.sh
```

This will:
1. Install all missing software dependencies
2. Setup NVM with Node.js v22
3. Configure all shells (bash, zsh, fish)
4. Install tmux with session persistence
5. Setup cloud tools (AWS CLI, Claude Code)
6. Create all configuration symlinks
7. Configure git settings

## 📦 What Gets Installed

### System Essentials
- **Build Tools**: gcc, make, build-essential
- **Version Control**: git, git-lfs, gh (GitHub CLI)
- **Package Managers**: apt/brew, pip3, npm, pnpm

### Shells & Terminal
- **Fish Shell**: With Fisher plugin manager
- **Zsh**: With Oh My Zsh (if selected)
- **Tmux**: With resurrect & continuum plugins
- **Terminal Tools**: htop, ncdu, tree

### Development Tools
- **Editors**: Neovim (latest)
- **Node.js**: v22 via NVM
- **Python**: python3, pip3, venv
- **Cloud CLIs**: AWS CLI, gcloud SDK, Claude Code

### Modern CLI Tools
- **Better Alternatives**: bat (cat), ripgrep (grep), fd (find), fzf
- **JSON/YAML**: jq, yq processors
- **Network**: curl, wget, rsync, ssh

## 🔧 Installation Methods

### Method 1: Complete Setup (Recommended)

```bash
cd ~/.dotfiles
./install/modules/complete-setup.sh
```

Options:
```bash
# Dry run to preview changes
./install/modules/complete-setup.sh --dry-run

# Non-interactive installation
./install/modules/complete-setup.sh --non-interactive

# Include Google Cloud SDK
./install/modules/complete-setup.sh --with-gcloud

# Set Fish as default shell
./install/modules/complete-setup.sh --set-fish-default
```

### Method 2: Modular Installation

Install specific components:

```bash
# Install Node.js environment only
./install/modules/nodejs-setup.sh

# Install Fish plugins only
./install/modules/fish-plugins.sh

# Install tmux plugins only
~/.dotfiles/config/terminal/tmux/install-plugins.sh
```

### Method 3: Traditional Install Script

```bash
./install/install.sh --profile development
```

Profiles available:
- `minimal`: Basic shell configuration
- `development`: Full dev environment (default)
- `server`: Server-optimized setup

## 🔐 Post-Installation: Credential Setup

### Sync Credentials from Another Machine

After installation, sync your credentials (they're never stored in git):

```bash
# Sync all credentials
credential-sync sync user@source-machine

# Sync specific services only
credential-sync sync user@source-machine --specific aws
credential-sync sync user@source-machine --specific ssh
credential-sync sync user@source-machine --specific gcloud

# Preview what will be synced
credential-sync sync user@source-machine --dry-run
```

### Manual Credential Setup

If you don't have another machine to sync from:

```bash
# AWS CLI
aws configure

# Google Cloud
gcloud auth login
gcloud config set project YOUR_PROJECT

# GitHub CLI
gh auth login

# SSH Keys
ssh-keygen -t ed25519 -C "your_email@example.com"
```

## ✅ Verification Steps

After installation, verify everything is working:

### 1. Check System Health

```bash
# Run comprehensive diagnostics
dotfiles doctor

# Check dotfiles status
dotfiles status

# Verify symlinks
dotfiles links verify
```

### 2. Test Shell Features

```bash
# Test aliases work across shells
bash -c "alias | grep -c alias"
zsh -c "alias | grep -c alias"
fish -c "alias | head -5"

# Verify no welcome screens
fish  # Should start silently
exit
```

### 3. Test Tmux Persistence

```bash
# Start tmux session
tmux new -s test

# Create some panes/windows
# Press C-a c for new window
# Press C-a | for vertical split

# Save session manually
# Press C-a C-s

# Detach with C-a d
# Kill tmux completely
tmux kill-server

# Restore session
tmux
# Press C-a C-r
```

### 4. Verify Software Versions

```bash
# Check installed versions
node --version    # Should show v22.x.x
npm --version
pnpm --version
nvim --version
fish --version
tmux -V
aws --version
claude --version
```

## 🔄 Updating

### Update Dotfiles

```bash
# Sync with remote repository
dotfiles sync

# Update all components
dotfiles update
```

### Update Dependencies

```bash
# Check for outdated software
dotfiles doctor

# Update Fish plugins
fish -c "fisher update"

# Update tmux plugins
# In tmux: Press C-a U

# Update Node.js
nvm install node --latest-npm
nvm alias default node
```

## 🛠️ Troubleshooting

### Common Issues

#### Permission Denied

```bash
# Fix permissions on scripts
chmod +x ~/.dotfiles/install/modules/*.sh
chmod +x ~/.dotfiles/scripts/bin/*
```

#### Broken Symlinks

```bash
# Verify and fix symlinks
dotfiles links verify
dotfiles clean
```

#### Missing Dependencies

```bash
# Re-run dependency check
source ~/.dotfiles/system/dependency-manager.sh
check_dependencies
install_missing_dependencies
```

#### Fish Not Found

```bash
# Install Fish manually
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt update
sudo apt install fish
```

#### NVM Not Working

```bash
# Reinstall NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
source ~/.bashrc
nvm install 22
```

### Reset and Reinstall

If things go wrong, you can reset:

```bash
# Backup current setup
dotfiles backup

# Remove symlinks
dotfiles links remove

# Reinstall
./install/modules/complete-setup.sh
```

## 📚 Configuration Files

After installation, these files are managed:

### Shell Configurations
- `~/.bashrc` → `~/.dotfiles/config/shells/bash/bashrc`
- `~/.config/fish/` → `~/.dotfiles/config/shells/fish/`
- `~/.zshrc` → `~/.dotfiles/config/shells/zsh/zshrc`

### Application Configs
- `~/.config/nvim/` → `~/.dotfiles/config/editors/nvim/`
- `~/.config/tmux/` → `~/.dotfiles/config/terminal/tmux/`
- `~/.gitconfig` → `~/.dotfiles/config/tools/git/gitconfig`

### Claude Code
- `~/.claude/settings.json` → Managed by dotfiles
- `~/.claude/settings.local.json` → Local overrides (not in git)

## 🎯 Next Steps

After successful installation:

1. **Set Default Shell** (optional):
   ```bash
   chsh -s $(which fish)
   ```

2. **Customize Git**:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

3. **Add Personal Aliases**:
   ```bash
   # Add to ~/.dotfiles/config/shells/common/aliases.sh
   alias myalias='my-command'
   ```

4. **Setup Credentials**:
   ```bash
   # From another machine
   credential-sync sync user@other-machine

   # Or manually configure each service
   ```

5. **Test Everything**:
   ```bash
   dotfiles doctor
   ```

## 📖 Additional Resources

- [Commands Cheat Sheet](COMMANDS.md)
- [Main Documentation](README.md)
- [Local Docs Index](LOCAL_DOCS_INDEX.md)
- [Tmux Plugins Guide](../config/terminal/tmux/TMUX_PLUGINS.md)

---

**Need Help?** Run `dotfiles doctor` for diagnostics or check the [troubleshooting](#-troubleshooting) section above.