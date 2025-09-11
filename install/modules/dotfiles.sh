#!/bin/bash
# Dotfiles Installation Module
# Handles the installation and configuration of dotfiles

# Import required libraries
DOTFILES_ROOT="${HOME}/.dotfiles"
source "$DOTFILES_ROOT/system/backup-manager.sh"
source "$DOTFILES_ROOT/system/symlink-manager.sh"
source "$DOTFILES_ROOT/system/machine-detector.sh"

CONFIG_DIR="$DOTFILES_ROOT/config"
MAPPING_FILE="$DOTFILES_ROOT/dotfiles-map.txt"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[DOTFILES]${NC} $*"
}

warn() {
    echo -e "${YELLOW}[DOTFILES]${NC} $*"
}

error() {
    echo -e "${RED}[DOTFILES]${NC} $*" >&2
}

success() {
    echo -e "${GREEN}[DOTFILES]${NC} $*"
}

# Install dotfiles using symlink mapping
install_dotfiles() {
    local force="${1:-false}"
    local dry_run="${2:-false}"
    
    log "Installing dotfiles..."
    
    # Check if mapping file exists
    if [ ! -f "$MAPPING_FILE" ]; then
        error "Dotfiles mapping file not found: $MAPPING_FILE"
        return 1
    fi
    
    # Create symlinks from mapping
    if [ "$dry_run" = "true" ]; then
        log "Dry run - would create symlinks:"
        while IFS='=' read -r source target; do
            [[ "$source" =~ ^#.*$ ]] && continue
            [ -z "$source" ] && continue
            
            source=$(eval echo "$source")
            target=$(eval echo "$target")
            
            echo "  $target -> $source"
        done < "$MAPPING_FILE"
    else
        create_symlinks_from_map "$MAPPING_FILE" "$force" true
    fi
}

# Setup shell integration
setup_shell_integration() {
    local dry_run="${1:-false}"
    
    log "Setting up shell integration..."
    
    # Ensure scripts directory is in PATH
    local scripts_bin="${HOME}/.config/scripts/bin"
    
    if [[ ":$PATH:" != *":$scripts_bin:"* ]]; then
        log "Adding scripts directory to PATH"
        
        if [ "$dry_run" = false ]; then
            # Add to .profile if not already there
            if ! grep -q "/.config/scripts/bin" ~/.profile 2>/dev/null; then
                echo "" >> ~/.profile
                echo "# Dotfiles scripts" >> ~/.profile  
                echo 'export PATH="$HOME/.config/scripts/bin:$PATH"' >> ~/.profile
            fi
        fi
    fi
    
    # Create local bin directory
    mkdir -p "${HOME}/.local/bin"
    
    # Install script symlinks to ~/.local/bin
    if [ -d "$scripts_bin" ]; then
        for script in "$scripts_bin"/*; do
            if [ -f "$script" ] && [ -x "$script" ]; then
                local script_name=$(basename "$script")
                local target="${HOME}/.local/bin/$script_name"
                
                if [ "$dry_run" = false ]; then
                    if [ ! -e "$target" ]; then
                        ln -s "$script" "$target" 2>/dev/null || true
                        log "Linked script: $script_name"
                    fi
                else
                    log "Would link script: $script_name"
                fi
            fi
        done
    fi
}

# Configure shell-specific settings
configure_shells() {
    local dry_run="${1:-false}"
    
    log "Configuring shells..."
    
    # Get available shells
    local shells
    if command -v detect_shells >/dev/null 2>&1; then
        shells=$(detect_shells | jq -r '.[]' 2>/dev/null)
    else
        # Fallback detection
        shells=""
        command -v bash >/dev/null && shells="$shells bash"
        command -v fish >/dev/null && shells="$shells fish"
        command -v zsh >/dev/null && shells="$shells zsh"
    fi
    
    # Configure each available shell
    for shell in $shells; do
        case "$shell" in
            bash)
                configure_bash "$dry_run"
                ;;
            fish)
                configure_fish "$dry_run"
                ;;
            zsh)
                configure_zsh "$dry_run"
                ;;
        esac
    done
}

# Configure bash shell
configure_bash() {
    local dry_run="${1:-false}"
    
    log "Configuring Bash..."
    
    local bashrc_path="${HOME}/.bashrc"
    local dotfiles_bashrc="${DOTFILES_DIR}/shells/bash/bashrc"
    
    if [ -f "$dotfiles_bashrc" ]; then
        if [ "$dry_run" = false ]; then
            # The symlink should already be created by the mapping
            # Just verify it exists and is correct
            if [ -L "$bashrc_path" ]; then
                local link_target=$(readlink "$bashrc_path")
                if [ "$link_target" = "$dotfiles_bashrc" ]; then
                    success "Bash configuration linked correctly"
                else
                    warn "Bash configuration link points to: $link_target"
                fi
            fi
        else
            log "Would configure Bash with: $dotfiles_bashrc"
        fi
    else
        warn "Bash configuration not found: $dotfiles_bashrc"
    fi
}

# Configure fish shell
configure_fish() {
    local dry_run="${1:-false}"
    
    log "Configuring Fish..."
    
    local fish_config_dir="${HOME}/.config/fish"
    local dotfiles_fish_dir="${DOTFILES_DIR}/shells/fish"
    
    if [ -d "$dotfiles_fish_dir" ]; then
        if [ "$dry_run" = false ]; then
            # Fish config directory should be symlinked
            if [ -L "$fish_config_dir" ]; then
                success "Fish configuration linked correctly"
            elif [ -d "$fish_config_dir" ] && [ ! -L "$fish_config_dir" ]; then
                warn "Fish config directory exists but is not a symlink"
                warn "Manual intervention may be required"
            fi
        else
            log "Would configure Fish with: $dotfiles_fish_dir"
        fi
    else
        log "Fish configuration not found, skipping"
    fi
}

# Configure zsh shell
configure_zsh() {
    local dry_run="${1:-false}"
    
    log "Configuring Zsh..."
    
    local zshrc_path="${HOME}/.zshrc"
    local dotfiles_zshrc="${DOTFILES_DIR}/shells/zsh/zshrc"
    
    if [ -f "$dotfiles_zshrc" ]; then
        if [ "$dry_run" = false ]; then
            # Create symlink if it doesn't exist
            if [ ! -e "$zshrc_path" ]; then
                create_symlink "$dotfiles_zshrc" "$zshrc_path" false true
            fi
        else
            log "Would configure Zsh with: $dotfiles_zshrc"
        fi
    else
        log "Zsh configuration not found, skipping"
    fi
}

# Validate dotfiles installation
validate_installation() {
    log "Validating dotfiles installation..."
    
    local errors=0
    
    # Check symlinks
    if command -v verify_symlinks >/dev/null 2>&1; then
        if ! verify_symlinks >/dev/null 2>&1; then
            error "Symlink validation failed"
            ((errors++))
        else
            success "Symlinks validated"
        fi
    fi
    
    # Check shell configurations
    local shells=("bash" "fish" "zsh")
    for shell in "${shells[@]}"; do
        if command -v "$shell" >/dev/null 2>&1; then
            case "$shell" in
                bash)
                    if [ -f "${HOME}/.bashrc" ]; then
                        # Test bash configuration
                        if bash -n "${HOME}/.bashrc" 2>/dev/null; then
                            success "Bash configuration valid"
                        else
                            error "Bash configuration has syntax errors"
                            ((errors++))
                        fi
                    fi
                    ;;
                fish)
                    if [ -d "${HOME}/.config/fish" ]; then
                        # Fish validation is more complex, just check if directory exists
                        success "Fish configuration present"
                    fi
                    ;;
                zsh)
                    if [ -f "${HOME}/.zshrc" ]; then
                        success "Zsh configuration present"
                    fi
                    ;;
            esac
        fi
    done
    
    # Check PATH
    if [[ ":$PATH:" == *":${HOME}/.local/bin:"* ]] || [[ ":$PATH:" == *":${HOME}/.config/scripts/bin:"* ]]; then
        success "Scripts directory in PATH"
    else
        warn "Scripts directory not in PATH (restart shell required)"
    fi
    
    return $errors
}

# Main dotfiles installation function
main() {
    local command="${1:-install}"
    local force="${2:-false}"
    local dry_run="${3:-false}"
    
    case "$command" in
        install)
            install_dotfiles "$force" "$dry_run"
            setup_shell_integration "$dry_run"
            configure_shells "$dry_run"
            
            if [ "$dry_run" = false ]; then
                validate_installation
            fi
            ;;
        validate)
            validate_installation
            ;;
        shells)
            configure_shells "$dry_run"
            ;;
        *)
            error "Unknown command: $command"
            echo "Usage: $0 {install|validate|shells} [force] [dry-run]"
            exit 1
            ;;
    esac
}

# If script is run directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi