#!/bin/bash
# Main Dotfiles and Scripts Installer
# Installs and configures dotfiles, scripts, and dependencies

set -e

# Script directory and configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(dirname "$SCRIPT_DIR")"
CONFIG_DIR="$DOTFILES_ROOT/config"
SCRIPTS_DIR="$DOTFILES_ROOT/scripts"
LIB_DIR="$DOTFILES_ROOT/system"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
DRY_RUN=false
FORCE=false
PROFILE="development"
MACHINE_NAME=""
INTERACTIVE=true
BACKUP=true
VERBOSE=false

# Import libraries
source "$LIB_DIR/backup-manager.sh"
source "$LIB_DIR/machine-detector.sh"
source "$LIB_DIR/symlink-manager.sh"
source "$LIB_DIR/secret-manager.sh"
source "$LIB_DIR/dependency-manager.sh"

# Usage information
show_usage() {
    cat << EOF
Dotfiles and Scripts Installer

Usage: $0 [OPTIONS]

Options:
    -p, --profile PROFILE      Installation profile (minimal|development|server)
    -m, --machine-name NAME    Machine name for configuration
    -n, --dry-run             Show what would be done without making changes
    -f, --force               Force overwrite existing files
    -y, --yes                 Non-interactive mode (answer yes to all prompts)
    --no-backup               Skip creating backups
    -v, --verbose             Verbose output
    -h, --help                Show this help message

Profiles:
    minimal      Basic shell configuration and essential tools
    development  Full development environment (default)
    server       Server-optimized configuration

Examples:
    $0                                    # Interactive installation
    $0 --profile minimal                  # Install minimal configuration
    $0 --dry-run --verbose               # Preview what would be installed
    $0 --machine-name work-laptop --yes  # Non-interactive with custom name

Environment Variables:
    DOTFILES_PROFILE         Default profile to use
    DOTFILES_MACHINE_NAME    Default machine name
    DOTFILES_NO_BACKUP       Skip backups if set to 1
EOF
}

# Logging functions
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

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -p|--profile)
                PROFILE="$2"
                shift 2
                ;;
            -m|--machine-name)
                MACHINE_NAME="$2"
                shift 2
                ;;
            -n|--dry-run)
                DRY_RUN=true
                shift
                ;;
            -f|--force)
                FORCE=true
                shift
                ;;
            -y|--yes)
                INTERACTIVE=false
                shift
                ;;
            --no-backup)
                BACKUP=false
                shift
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -h|--help)
                show_usage
                exit 0
                ;;
            *)
                error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
}

# Check prerequisites
check_prerequisites() {
    local missing=()
    
    # Required tools
    local required_tools=(curl git)
    for tool in "${required_tools[@]}"; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            missing+=("$tool")
        fi
    done
    
    # Optional but recommended tools
    local optional_tools=(jq fd fzf rg)
    local optional_missing=()
    for tool in "${optional_tools[@]}"; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            optional_missing+=("$tool")
        fi
    done
    
    if [ ${#missing[@]} -gt 0 ]; then
        error "Missing required tools: ${missing[*]}"
        log "Please install them with your package manager:"
        case "$(detect_os)" in
            linux)
                if command -v apt >/dev/null 2>&1; then
                    log "  sudo apt install ${missing[*]}"
                elif command -v yum >/dev/null 2>&1; then
                    log "  sudo yum install ${missing[*]}"
                elif command -v dnf >/dev/null 2>&1; then
                    log "  sudo dnf install ${missing[*]}"
                fi
                ;;
            macos)
                log "  brew install ${missing[*]}"
                ;;
        esac
        return 1
    fi
    
    if [ ${#optional_missing[@]} -gt 0 ]; then
        warn "Optional tools not found: ${optional_missing[*]}"
        log "For better experience, consider installing them"
    fi
    
    return 0
}

# Detect and save machine profile
setup_machine_profile() {
    log "Detecting machine characteristics..."
    
    if [ -n "$MACHINE_NAME" ]; then
        verbose "Using provided machine name: $MACHINE_NAME"
    fi
    
    if [ "$DRY_RUN" = true ]; then
        log "Would detect and save machine profile"
        return 0
    fi
    
    # Generate machine profile
    local profile
    profile=$(create_machine_profile)
    
    if [ -n "$MACHINE_NAME" ]; then
        # Override machine_id if name was provided
        profile=$(echo "$profile" | jq --arg name "$MACHINE_NAME" '.machine_id = $name')
    fi
    
    # Save profile
    save_machine_profile "$profile" "$FORCE"
    success "Machine profile created"
    
    # Create machine-specific directories
    local machine_id
    machine_id=$(echo "$profile" | jq -r '.machine_id')
    local machine_dir="$DOTFILES_DIR/machines/$machine_id"
    
    if [ ! -d "$machine_dir" ]; then
        mkdir -p "$machine_dir"
        verbose "Created machine directory: $machine_dir"
    fi
    
    # Create symlink to current machine
    local current_link="$DOTFILES_DIR/machines/current"
    if [ -L "$current_link" ]; then
        rm "$current_link"
    fi
    ln -s "$machine_id" "$current_link"
    verbose "Created current machine symlink"
}

# Install profile-specific packages
install_packages() {
    local profile="$1"
    local packages_dir="$DOTFILES_DIR/packages"
    
    if [ ! -d "$packages_dir" ]; then
        warn "No packages directory found, skipping package installation"
        return 0
    fi
    
    log "Installing packages for profile: $profile"
    
    local os
    os=$(detect_os)
    local package_file=""
    
    # Determine package file based on OS and profile
    case "$os" in
        linux)
            if command -v apt >/dev/null 2>&1; then
                package_file="$packages_dir/apt-${profile}.txt"
                [ ! -f "$package_file" ] && package_file="$packages_dir/apt-common.txt"
            elif command -v yum >/dev/null 2>&1 || command -v dnf >/dev/null 2>&1; then
                package_file="$packages_dir/rpm-${profile}.txt"
                [ ! -f "$package_file" ] && package_file="$packages_dir/rpm-common.txt"
            fi
            ;;
        macos)
            package_file="$packages_dir/brew-${profile}.txt"
            [ ! -f "$package_file" ] && package_file="$packages_dir/brew-common.txt"
            ;;
    esac
    
    if [ -f "$package_file" ]; then
        log "Installing packages from: $package_file"
        
        if [ "$DRY_RUN" = true ]; then
            log "Would install packages:"
            cat "$package_file" | grep -v '^#' | grep -v '^$'
            return 0
        fi
        
        case "$os" in
            linux)
                if command -v apt >/dev/null 2>&1; then
                    sudo apt update
                    cat "$package_file" | grep -v '^#' | grep -v '^$' | xargs sudo apt install -y
                elif command -v dnf >/dev/null 2>&1; then
                    cat "$package_file" | grep -v '^#' | grep -v '^$' | xargs sudo dnf install -y
                elif command -v yum >/dev/null 2>&1; then
                    cat "$package_file" | grep -v '^#' | grep -v '^$' | xargs sudo yum install -y
                fi
                ;;
            macos)
                if command -v brew >/dev/null 2>&1; then
                    cat "$package_file" | grep -v '^#' | grep -v '^$' | xargs brew install
                else
                    warn "Homebrew not found, skipping package installation"
                fi
                ;;
        esac
        
        success "Packages installed"
    else
        verbose "No package file found for $os/$profile"
    fi
}

# Create dotfiles symlinks
setup_dotfiles() {
    log "Setting up dotfiles..."
    
    # Define dotfile mappings
    local -A dotfile_map=(
        ["$DOTFILES_DIR/shells/bash/bashrc"]="$HOME/.bashrc"
        ["$DOTFILES_DIR/shells/bash/profile"]="$HOME/.profile"
        ["$DOTFILES_DIR/apps/git/gitconfig"]="$HOME/.gitconfig"
        ["$DOTFILES_DIR/apps/tmux/tmux.conf"]="$HOME/.tmux.conf"
    )
    
    # Fish shell mapping (if fish config exists)
    if [ -d "$DOTFILES_DIR/shells/fish" ]; then
        dotfile_map["$DOTFILES_DIR/shells/fish"]="$HOME/.config/fish"
    fi
    
    for source in "${!dotfile_map[@]}"; do
        local target="${dotfile_map[$source]}"
        
        if [ "$DRY_RUN" = true ]; then
            log "Would create symlink: $target -> $source"
            continue
        fi
        
        verbose "Creating symlink: $target -> $source"
        
        if [ -e "$source" ]; then
            create_symlink "$source" "$target" "$FORCE" "$BACKUP"
        else
            warn "Source file not found: $source"
        fi
    done
    
    success "Dotfiles setup complete"
}

# Install scripts
setup_scripts() {
    log "Setting up utility scripts..."
    
    if [ ! -d "$SCRIPTS_DIR/bin" ]; then
        warn "No scripts directory found, skipping script installation"
        return 0
    fi
    
    local script_target="$HOME/.local/bin"
    mkdir -p "$script_target"
    
    # Install scripts
    for script in "$SCRIPTS_DIR"/bin/*; do
        if [ -f "$script" ] && [ -x "$script" ]; then
            local script_name
            script_name=$(basename "$script")
            local target="$script_target/$script_name"
            
            if [ "$DRY_RUN" = true ]; then
                log "Would install script: $script_name"
                continue
            fi
            
            verbose "Installing script: $script_name"
            
            if [ -f "$target" ] && [ "$FORCE" != true ]; then
                if [ "$INTERACTIVE" = true ]; then
                    read -p "Script $script_name already exists. Overwrite? (y/N): " -n 1 -r
                    echo
                    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                        continue
                    fi
                else
                    warn "Skipping existing script: $script_name"
                    continue
                fi
            fi
            
            # Backup existing script
            if [ -f "$target" ] && [ "$BACKUP" = true ]; then
                backup_file "$target" "script.$script_name"
            fi
            
            # Create symlink to script
            create_symlink "$script" "$target" true false
        fi
    done
    
    success "Scripts setup complete"
}

# Setup shell integrations
setup_shell_integration() {
    log "Setting up shell integrations..."
    
    # Ensure ~/.local/bin is in PATH
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        log "Adding ~/.local/bin to PATH"
        
        if [ "$DRY_RUN" = false ]; then
            # This will be handled by the common paths file
            echo "# Added by dotfiles installer" >> ~/.profile
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.profile
        fi
    fi
    
    success "Shell integration complete"
}

# Initialize secrets management
setup_secrets() {
    if [ "$INTERACTIVE" = true ]; then
        read -p "Do you want to set up secrets management? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            log "Initializing secrets management..."
            
            if [ "$DRY_RUN" = false ]; then
                create_secrets_from_template
            else
                log "Would initialize secrets management"
            fi
        fi
    fi
}

# Run post-install hooks
run_post_install_hooks() {
    log "Running post-install hooks..."
    
    local hooks_dir="$CONFIG_DIR/install/hooks"
    
    if [ -d "$hooks_dir" ]; then
        for hook in "$hooks_dir"/post-install-*; do
            if [ -x "$hook" ]; then
                verbose "Running hook: $(basename "$hook")"
                
                if [ "$DRY_RUN" = false ]; then
                    "$hook"
                else
                    log "Would run hook: $(basename "$hook")"
                fi
            fi
        done
    fi
}

# Generate installation report
generate_report() {
    log "Installation Summary"
    echo "==================="
    echo "Profile: $PROFILE"
    echo "Machine: $(get_machine_value machine_id 2>/dev/null || echo "unknown")"
    echo "OS: $(detect_os) $(detect_distro) $(detect_version)"
    echo "Installed at: $(date)"
    echo "Dotfiles directory: $CONFIG_DIR"
    
    if [ "$DRY_RUN" = true ]; then
        warn "This was a dry run - no changes were made"
    fi
    
    echo
    log "Next steps:"
    echo "1. Restart your shell or run: source ~/.bashrc"
    echo "2. Run: dotfiles status"
    echo "3. Configure secrets: dotfiles secrets init"
    echo "4. Add your utility scripts to: $SCRIPTS_DIR/bin/"
    
    if [ -d "$HOME/.config/backups" ]; then
        echo "5. Check backups in: ~/.config/backups/"
    fi
}

# Main installation function
main() {
    echo -e "${BLUE}"
    cat << 'EOF'
    ____        __  _____ __
   / __ \____  / /_/ __(_) /__  _____
  / / / / __ \/ __/ /_/ / / _ \/ ___/
 / /_/ / /_/ / /_/ __/ / /  __(__  )
/_____/\____/\__/_/ /_/_/\___/____/

EOF
    echo -e "${NC}"
    log "Dotfiles and Scripts Installer"
    echo
    
    # Parse arguments
    parse_args "$@"
    
    # Show configuration
    verbose "Configuration:"
    verbose "  Profile: $PROFILE"
    verbose "  Machine Name: ${MACHINE_NAME:-auto-detect}"
    verbose "  Dry Run: $DRY_RUN"
    verbose "  Force: $FORCE"
    verbose "  Interactive: $INTERACTIVE"
    verbose "  Backup: $BACKUP"
    
    # Environment variable overrides
    PROFILE="${DOTFILES_PROFILE:-$PROFILE}"
    MACHINE_NAME="${DOTFILES_MACHINE_NAME:-$MACHINE_NAME}"
    if [ "${DOTFILES_NO_BACKUP:-0}" = "1" ]; then
        BACKUP=false
    fi
    
    # Pre-installation checks
    if ! check_prerequisites; then
        exit 1
    fi
    
    if [ "$DRY_RUN" = false ] && [ "$INTERACTIVE" = true ]; then
        read -p "Continue with installation? (Y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Nn]$ ]]; then
            log "Installation cancelled"
            exit 0
        fi
    fi
    
    # Installation steps
    setup_machine_profile
    install_packages "$PROFILE"
    setup_dotfiles
    setup_scripts
    setup_shell_integration
    setup_secrets
    run_post_install_hooks
    
    # Report
    generate_report
    
    success "Installation complete!"
}

# Run main function with all arguments
main "$@"