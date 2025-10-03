#!/bin/bash
# Complete Setup Module
# Orchestrates the complete installation of all dotfiles components

set -e

# Script directory and configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULES_DIR="$SCRIPT_DIR"
DOTFILES_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"
SYSTEM_DIR="$DOTFILES_ROOT/system"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Import system libraries
source "$SYSTEM_DIR/dependency-manager.sh"
source "$SYSTEM_DIR/backup-manager.sh"
source "$SYSTEM_DIR/symlink-manager.sh"
source "$SYSTEM_DIR/machine-detector.sh"

# Configuration
DRY_RUN="${DRY_RUN:-false}"
VERBOSE="${VERBOSE:-false}"
INTERACTIVE="${INTERACTIVE:-true}"

# Logging
log() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $*"
}

error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*"
}

verbose() {
    if [ "$VERBOSE" = true ]; then
        echo -e "${CYAN}[DEBUG]${NC} $*"
    fi
}

# Display header
show_header() {
    clear
    echo -e "${MAGENTA}"
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║                  Dotfiles Complete Setup                      ║"
    echo "║                                                               ║"
    echo "║  This will install and configure your complete development   ║"
    echo "║  environment including shells, tools, and configurations.    ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Check prerequisites
check_prerequisites() {
    log "Checking prerequisites..."

    # Check for sudo access
    if ! sudo -n true 2>/dev/null; then
        warn "This script requires sudo access for some operations."
        sudo -v
    fi

    # Check internet connectivity
    if ! ping -c 1 google.com &>/dev/null; then
        error "No internet connectivity detected. Please check your connection."
        return 1
    fi

    success "Prerequisites check passed"
}

# Install system dependencies
install_dependencies() {
    log "Installing system dependencies..."

    if [ "$DRY_RUN" = true ]; then
        log "DRY RUN: Would check and install dependencies"
        return 0
    fi

    # Check dependencies first
    if ! check_dependencies; then
        log "Installing missing dependencies..."
        install_missing_dependencies
    fi

    success "System dependencies installed"
}

# Setup Node.js environment
setup_nodejs() {
    log "Setting up Node.js environment..."

    if [ "$DRY_RUN" = true ]; then
        log "DRY RUN: Would setup Node.js with NVM"
        return 0
    fi

    # Run Node.js setup module
    if [ -f "$MODULES_DIR/nodejs-setup.sh" ]; then
        bash "$MODULES_DIR/nodejs-setup.sh"
    else
        warn "Node.js setup module not found, using dependency manager"
        install_nvm
        install_pnpm
    fi

    success "Node.js environment configured"
}

# Setup shells
setup_shells() {
    log "Setting up shells..."

    if [ "$DRY_RUN" = true ]; then
        log "DRY RUN: Would setup Fish and other shells"
        return 0
    fi

    # Install Fish if not present
    if ! command -v fish &>/dev/null; then
        install_fish
    fi

    # Setup Fish plugins
    if [ -f "$MODULES_DIR/fish-plugins.sh" ]; then
        bash "$MODULES_DIR/fish-plugins.sh"
    fi

    # Ensure .hushlogin exists to suppress login messages
    touch "$HOME/.hushlogin"

    success "Shells configured"
}

# Setup tmux
setup_tmux() {
    log "Setting up tmux..."

    if [ "$DRY_RUN" = true ]; then
        log "DRY RUN: Would setup tmux and plugins"
        return 0
    fi

    # Install tmux if not present
    if ! command -v tmux &>/dev/null; then
        install_tmux
    fi

    # Install tmux plugins
    if [ -f "$DOTFILES_ROOT/config/terminal/tmux/install-plugins.sh" ]; then
        bash "$DOTFILES_ROOT/config/terminal/tmux/install-plugins.sh"
    fi

    success "Tmux configured"
}

# Setup cloud tools
setup_cloud_tools() {
    log "Setting up cloud tools..."

    if [ "$DRY_RUN" = true ]; then
        log "DRY RUN: Would install AWS CLI, gcloud, etc."
        return 0
    fi

    # Install AWS CLI if not present
    if ! command -v aws &>/dev/null; then
        install_aws_cli
    fi

    # Install Google Cloud SDK if requested
    if [ "$INSTALL_GCLOUD" = true ] && ! command -v gcloud &>/dev/null; then
        install_gcloud
    fi

    # Install Claude Code
    if ! command -v claude &>/dev/null; then
        install_claude_code
    fi

    success "Cloud tools configured"
}

# Create symlinks
create_symlinks() {
    log "Creating configuration symlinks..."

    if [ "$DRY_RUN" = true ]; then
        log "DRY RUN: Would create symlinks from dotfiles-map.txt"
        return 0
    fi

    # Use symlink manager to create all symlinks
    local map_file="$DOTFILES_ROOT/dotfiles-map.txt"

    if [ -f "$map_file" ]; then
        create_symlinks_from_map "$map_file"
    else
        error "dotfiles-map.txt not found!"
        return 1
    fi

    success "Symlinks created"
}

# Configure git
configure_git() {
    log "Configuring git..."

    if [ "$DRY_RUN" = true ]; then
        log "DRY RUN: Would configure git settings"
        return 0
    fi

    # Set global git config if not set
    if ! git config --global user.name &>/dev/null; then
        if [ "$INTERACTIVE" = true ]; then
            read -p "Enter your git username: " git_username
            git config --global user.name "$git_username"
        fi
    fi

    if ! git config --global user.email &>/dev/null; then
        if [ "$INTERACTIVE" = true ]; then
            read -p "Enter your git email: " git_email
            git config --global user.email "$git_email"
        fi
    fi

    # Set default branch to main
    git config --global init.defaultBranch main

    success "Git configured"
}

# Post-installation tasks
post_installation() {
    log "Running post-installation tasks..."

    # Add scripts/bin to PATH if not already there
    local scripts_bin="$DOTFILES_ROOT/scripts/bin"
    if [[ ":$PATH:" != *":$scripts_bin:"* ]]; then
        echo "export PATH=\"\$PATH:$scripts_bin\"" >> "$HOME/.bashrc"
        echo "fish_add_path $scripts_bin" | fish 2>/dev/null || true
    fi

    # Set fish as default shell if requested
    if [ "$SET_FISH_DEFAULT" = true ] && command -v fish &>/dev/null; then
        local fish_path=$(command -v fish)
        if ! grep -q "$fish_path" /etc/shells; then
            echo "$fish_path" | sudo tee -a /etc/shells
        fi
        chsh -s "$fish_path"
        log "Fish set as default shell"
    fi

    success "Post-installation complete"
}

# Display summary
show_summary() {
    echo
    echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}                    Installation Complete!                      ${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
    echo

    echo -e "${BLUE}Installed Components:${NC}"
    echo "  ✓ System dependencies"
    echo "  ✓ Node.js with NVM (v${DEFAULT_NODE_VERSION:-22})"
    echo "  ✓ Fish shell with plugins"
    echo "  ✓ Tmux with resurrect & continuum"
    echo "  ✓ Neovim configuration"
    echo "  ✓ Cross-shell aliases"
    echo "  ✓ Cloud tools (AWS, Claude)"

    echo
    echo -e "${YELLOW}Available Commands:${NC}"
    echo "  • dotfiles status    - Check dotfiles status"
    echo "  • dotfiles sync      - Sync with remote"
    echo "  • dotfiles backup    - Create backup"
    echo "  • credential-sync    - Sync credentials from another machine"
    echo "  • claude            - Start Claude Code"

    echo
    echo -e "${CYAN}Next Steps:${NC}"
    echo "  1. Restart your terminal or run: exec \$SHELL"
    echo "  2. Sync credentials: credential-sync user@source-machine"
    echo "  3. Install tmux plugins: Press Ctrl-a + I in tmux"
    echo "  4. Test with: dotfiles doctor"

    echo
}

# Main installation flow
main() {
    show_header

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --dry-run)
                DRY_RUN=true
                log "Running in DRY RUN mode"
                ;;
            --verbose|-v)
                VERBOSE=true
                ;;
            --non-interactive|-y)
                INTERACTIVE=false
                ;;
            --with-gcloud)
                INSTALL_GCLOUD=true
                ;;
            --set-fish-default)
                SET_FISH_DEFAULT=true
                ;;
            *)
                # Ignore unknown arguments
                ;;
        esac
        shift
    done

    # Run installation steps
    check_prerequisites || exit 1

    log "Starting complete setup..."
    echo

    # Create backup before starting
    if [ "$DRY_RUN" = false ]; then
        log "Creating backup..."
        create_backup "$HOME" "pre-dotfiles-setup" || true
    fi

    # Run all setup steps
    install_dependencies
    setup_nodejs
    setup_shells
    setup_tmux
    setup_cloud_tools
    create_symlinks
    configure_git
    post_installation

    # Show summary
    if [ "$DRY_RUN" = false ]; then
        show_summary
    else
        echo
        log "DRY RUN complete - no changes were made"
    fi
}

# Run main function if script is executed directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi