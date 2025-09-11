#!/bin/bash
# Machine Detector - Detect machine characteristics and environment
# Creates machine profiles for customizing dotfiles installation

MACHINE_CONFIG_DIR="${HOME}/.dotfiles/config/machines"
MACHINE_CONFIG_FILE="${MACHINE_CONFIG_DIR}/current.conf"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Detect operating system
detect_os() {
    case "$(uname -s)" in
        Linux*)
            echo "linux"
            ;;
        Darwin*)
            echo "macos"
            ;;
        CYGWIN*|MINGW*|MSYS*)
            echo "windows"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Detect Linux distribution
detect_distro() {
    if [ "$(detect_os)" != "linux" ]; then
        echo "none"
        return
    fi
    
    if command -v lsb_release >/dev/null 2>&1; then
        lsb_release -si | tr '[:upper:]' '[:lower:]'
    elif [ -f /etc/os-release ]; then
        grep '^ID=' /etc/os-release | cut -d'=' -f2 | tr -d '"' | tr '[:upper:]' '[:lower:]'
    elif [ -f /etc/redhat-release ]; then
        echo "redhat"
    elif [ -f /etc/debian_version ]; then
        echo "debian"
    else
        echo "unknown"
    fi
}

# Detect distribution version
detect_version() {
    local os
    os=$(detect_os)
    
    case "$os" in
        linux)
            if command -v lsb_release >/dev/null 2>&1; then
                lsb_release -sr
            elif [ -f /etc/os-release ]; then
                grep '^VERSION_ID=' /etc/os-release | cut -d'=' -f2 | tr -d '"'
            else
                echo "unknown"
            fi
            ;;
        macos)
            sw_vers -productVersion
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Check if running in WSL
is_wsl() {
    if [ -f /proc/version ] && grep -qi microsoft /proc/version; then
        echo "true"
    elif [ -n "${WSL_DISTRO_NAME}" ]; then
        echo "true"
    else
        echo "false"
    fi
}

# Check if running in container
is_container() {
    if [ -f /.dockerenv ]; then
        echo "docker"
    elif [ -f /proc/1/cgroup ] && grep -q container /proc/1/cgroup; then
        echo "container"
    elif [ -n "${container}" ]; then
        echo "$container"
    else
        echo "false"
    fi
}

# Detect installed shells
detect_shells() {
    local shells=()
    
    # Check common shell locations
    for shell in bash zsh fish dash ksh tcsh; do
        if command -v "$shell" >/dev/null 2>&1; then
            shells+=("$shell")
        fi
    done
    
    # Return as JSON array
    printf '%s\n' "${shells[@]}" | jq -R . | jq -s .
}

# Get default shell
get_default_shell() {
    basename "$SHELL"
}

# Check if GUI environment is available
has_gui() {
    if [ -n "$DISPLAY" ] || [ -n "$WAYLAND_DISPLAY" ]; then
        echo "true"
    elif [ "$(detect_os)" = "macos" ]; then
        echo "true"
    elif [ "$(is_wsl)" = "true" ]; then
        # Check if WSL can access Windows GUI
        if command -v explorer.exe >/dev/null 2>&1; then
            echo "true"
        else
            echo "false"
        fi
    else
        echo "false"
    fi
}

# Detect machine role based on installed software
detect_role() {
    local roles=()
    
    # Development tools
    if command -v git >/dev/null 2>&1 && 
       (command -v node >/dev/null 2>&1 || command -v python >/dev/null 2>&1 || command -v go >/dev/null 2>&1); then
        roles+=("development")
    fi
    
    # Server indicators
    if command -v systemctl >/dev/null 2>&1 && systemctl list-units --type=service --state=running | grep -E "(nginx|apache|httpd)" >/dev/null 2>&1; then
        roles+=("server")
    fi
    
    # Container tools
    if command -v docker >/dev/null 2>&1 || command -v podman >/dev/null 2>&1; then
        roles+=("container-host")
    fi
    
    # Database tools
    if command -v mysql >/dev/null 2>&1 || command -v psql >/dev/null 2>&1 || command -v mongo >/dev/null 2>&1; then
        roles+=("database")
    fi
    
    # Default to workstation if no specific role detected
    if [ ${#roles[@]} -eq 0 ]; then
        roles+=("workstation")
    fi
    
    # Return first/primary role
    echo "${roles[0]}"
}

# Detect available features/tools
detect_features() {
    local features=()
    
    # Development tools
    [ -x "$(command -v node)" ] && features+=("nodejs")
    [ -x "$(command -v python)" ] && features+=("python")
    [ -x "$(command -v python3)" ] && features+=("python3")
    [ -x "$(command -v go)" ] && features+=("golang")
    [ -x "$(command -v rust)" ] && features+=("rust")
    [ -x "$(command -v java)" ] && features+=("java")
    
    # Version managers
    [ -d "$HOME/.nvm" ] && features+=("nvm")
    [ -d "$HOME/.pyenv" ] && features+=("pyenv")
    [ -d "$HOME/.rbenv" ] && features+=("rbenv")
    [ -x "$(command -v asdf)" ] && features+=("asdf")
    
    # Container tools
    [ -x "$(command -v docker)" ] && features+=("docker")
    [ -x "$(command -v podman)" ] && features+=("podman")
    [ -x "$(command -v kubectl)" ] && features+=("kubernetes")
    
    # Cloud tools
    [ -x "$(command -v aws)" ] && features+=("aws-cli")
    [ -x "$(command -v gcloud)" ] && features+=("gcp-cli")
    [ -x "$(command -v az)" ] && features+=("azure-cli")
    
    # Development tools
    [ -x "$(command -v git)" ] && features+=("git")
    [ -x "$(command -v vim)" ] && features+=("vim")
    [ -x "$(command -v nvim)" ] && features+=("neovim")
    [ -x "$(command -v code)" ] && features+=("vscode")
    [ -x "$(command -v tmux)" ] && features+=("tmux")
    
    # Modern CLI tools
    [ -x "$(command -v fzf)" ] && features+=("fzf")
    [ -x "$(command -v fd)" ] && features+=("fd")
    [ -x "$(command -v rg)" ] && features+=("ripgrep")
    [ -x "$(command -v bat)" ] && features+=("bat")
    [ -x "$(command -v exa)" ] && features+=("exa")
    [ -x "$(command -v zoxide)" ] && features+=("zoxide")
    
    # Package managers
    [ -x "$(command -v apt)" ] && features+=("apt")
    [ -x "$(command -v yum)" ] && features+=("yum")
    [ -x "$(command -v dnf)" ] && features+=("dnf")
    [ -x "$(command -v brew)" ] && features+=("homebrew")
    [ -x "$(command -v pacman)" ] && features+=("pacman")
    [ -x "$(command -v snap)" ] && features+=("snap")
    [ -x "$(command -v flatpak)" ] && features+=("flatpak")
    
    # Return as JSON array
    printf '%s\n' "${features[@]}" | jq -R . | jq -s .
}

# Get system architecture
get_architecture() {
    uname -m
}

# Get CPU info
get_cpu_info() {
    local cores
    local arch
    
    if [ -f /proc/cpuinfo ]; then
        cores=$(grep -c processor /proc/cpuinfo)
    elif command -v sysctl >/dev/null 2>&1; then
        cores=$(sysctl -n hw.ncpu)
    else
        cores="unknown"
    fi
    
    arch=$(get_architecture)
    
    jq -n \
        --arg cores "$cores" \
        --arg arch "$arch" \
        '{cores: $cores, architecture: $arch}'
}

# Get memory info
get_memory_info() {
    local total_mb
    
    if [ -f /proc/meminfo ]; then
        total_mb=$(awk '/MemTotal/ {print int($2/1024)}' /proc/meminfo)
    elif command -v sysctl >/dev/null 2>&1; then
        local total_bytes
        total_bytes=$(sysctl -n hw.memsize 2>/dev/null || echo 0)
        total_mb=$((total_bytes / 1024 / 1024))
    else
        total_mb="unknown"
    fi
    
    echo "$total_mb"
}

# Generate machine ID
generate_machine_id() {
    local hostname
    local os
    local role
    
    hostname=$(hostname -s | tr '[:upper:]' '[:lower:]')
    os=$(detect_os)
    role=$(detect_role)
    
    # Create a readable machine ID
    echo "${hostname}-${os}-${role}"
}

# Create full machine profile
create_machine_profile() {
    local machine_id
    local os
    local distro
    local version
    local is_wsl_env
    local is_container_env
    local hostname
    local shells
    local default_shell
    local has_gui_env
    local role
    local features
    local cpu_info
    local memory_mb
    local arch
    local timestamp
    
    echo -e "${BLUE}Detecting machine characteristics...${NC}"
    
    machine_id=$(generate_machine_id)
    os=$(detect_os)
    distro=$(detect_distro)
    version=$(detect_version)
    is_wsl_env=$(is_wsl)
    is_container_env=$(is_container)
    hostname=$(hostname)
    shells=$(detect_shells)
    default_shell=$(get_default_shell)
    has_gui_env=$(has_gui)
    role=$(detect_role)
    features=$(detect_features)
    cpu_info=$(get_cpu_info)
    memory_mb=$(get_memory_info)
    arch=$(get_architecture)
    timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    
    # Create the profile using jq
    jq -n \
        --arg machine_id "$machine_id" \
        --arg os "$os" \
        --arg distro "$distro" \
        --arg version "$version" \
        --argjson is_wsl "$is_wsl_env" \
        --arg is_container "$is_container_env" \
        --arg hostname "$hostname" \
        --argjson shells "$shells" \
        --arg default_shell "$default_shell" \
        --argjson has_gui "$has_gui_env" \
        --arg role "$role" \
        --argjson features "$features" \
        --argjson cpu "$cpu_info" \
        --arg memory_mb "$memory_mb" \
        --arg arch "$arch" \
        --arg timestamp "$timestamp" \
        '{
            machine_id: $machine_id,
            os: $os,
            distro: $distro,
            version: $version,
            is_wsl: $is_wsl,
            is_container: $is_container,
            hostname: $hostname,
            shells: $shells,
            default_shell: $default_shell,
            has_gui: $has_gui,
            role: $role,
            features: $features,
            hardware: {
                cpu: $cpu,
                memory_mb: $memory_mb,
                architecture: $arch
            },
            detected_at: $timestamp
        }'
}

# Save machine profile to file
save_machine_profile() {
    local profile="$1"
    local force="${2:-false}"
    
    # Create directory if it doesn't exist
    mkdir -p "$MACHINE_CONFIG_DIR"
    
    # Check if profile already exists
    if [ -f "$MACHINE_CONFIG_FILE" ] && [ "$force" != "true" ]; then
        echo -e "${YELLOW}!${NC} Machine profile already exists: $MACHINE_CONFIG_FILE"
        read -p "Overwrite? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            return 1
        fi
    fi
    
    echo "$profile" > "$MACHINE_CONFIG_FILE"
    echo -e "${GREEN}✓${NC} Machine profile saved: $MACHINE_CONFIG_FILE"
}

# Load machine profile
load_machine_profile() {
    if [ -f "$MACHINE_CONFIG_FILE" ]; then
        cat "$MACHINE_CONFIG_FILE"
    else
        echo "{}"
    fi
}

# Get specific value from machine profile
get_machine_value() {
    local key="$1"
    local profile
    
    profile=$(load_machine_profile)
    echo "$profile" | jq -r ".$key // \"unknown\""
}

# Compare current system with saved profile
compare_with_saved_profile() {
    if [ ! -f "$MACHINE_CONFIG_FILE" ]; then
        echo -e "${YELLOW}!${NC} No saved machine profile found"
        return 1
    fi
    
    local current_profile
    local saved_profile
    local changes=()
    
    current_profile=$(create_machine_profile)
    saved_profile=$(load_machine_profile)
    
    echo -e "${BLUE}Comparing current system with saved profile...${NC}"
    
    # Compare key fields
    local fields=("os" "distro" "version" "default_shell" "role")
    for field in "${fields[@]}"; do
        local current_value
        local saved_value
        
        current_value=$(echo "$current_profile" | jq -r ".$field")
        saved_value=$(echo "$saved_profile" | jq -r ".$field")
        
        if [ "$current_value" != "$saved_value" ]; then
            changes+=("$field: $saved_value -> $current_value")
        fi
    done
    
    if [ ${#changes[@]} -gt 0 ]; then
        echo -e "${YELLOW}!${NC} Changes detected:"
        for change in "${changes[@]}"; do
            echo "  - $change"
        done
        
        read -p "Update saved profile? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            save_machine_profile "$current_profile" "true"
        fi
    else
        echo -e "${GREEN}✓${NC} No changes detected"
    fi
}

# Show machine profile summary
show_machine_profile() {
    local profile
    
    if [ -f "$MACHINE_CONFIG_FILE" ]; then
        profile=$(load_machine_profile)
    else
        echo -e "${YELLOW}!${NC} No machine profile found. Generating new profile..."
        profile=$(create_machine_profile)
    fi
    
    echo -e "${BLUE}Machine Profile:${NC}"
    echo "$profile" | jq -r '
        "  Machine ID: \(.machine_id)",
        "  OS: \(.os) \(.distro) \(.version)",
        "  Hostname: \(.hostname)",
        "  Architecture: \(.hardware.architecture)",
        "  Default Shell: \(.default_shell)",
        "  Role: \(.role)",
        "  WSL: \(.is_wsl)",
        "  GUI: \(.has_gui)",
        "  Container: \(.is_container)",
        "",
        "  CPU Cores: \(.hardware.cpu.cores)",
        "  Memory: \(.hardware.memory_mb)MB",
        "",
        "  Shells: \(.shells | join(", "))",
        "",
        "  Features: \(.features | join(", "))",
        "",
        "  Detected: \(.detected_at)"
    '
}

# Main entry point for CLI
machine_main() {
    local command="$1"
    shift
    
    case "$command" in
        detect)
            create_machine_profile
            ;;
        save)
            local profile
            profile=$(create_machine_profile)
            save_machine_profile "$profile" "$1"
            ;;
        show|info)
            show_machine_profile
            ;;
        compare|diff)
            compare_with_saved_profile
            ;;
        get)
            get_machine_value "$1"
            ;;
        load)
            load_machine_profile
            ;;
        help|*)
            cat << EOF
Machine Detector - Detect and profile machine characteristics

Usage: machine <command> [arguments]

Commands:
    detect              Generate machine profile (JSON output)
    save [force]        Save machine profile to file
    show                Show current machine profile summary
    compare             Compare current system with saved profile
    get <key>           Get specific value from profile
    load                Load raw machine profile (JSON)
    help                Show this help message

Examples:
    machine detect                    # Generate profile JSON
    machine save                      # Save profile interactively
    machine save force               # Force overwrite existing profile
    machine show                     # Show human-readable summary
    machine get os                   # Get OS type
    machine get features             # Get available features
    machine compare                  # Check for changes

Profile Location: $MACHINE_CONFIG_FILE

Keys available for 'get' command:
    machine_id, os, distro, version, is_wsl, is_container,
    hostname, shells, default_shell, has_gui, role, features,
    hardware.cpu.cores, hardware.memory_mb, hardware.architecture
EOF
            ;;
    esac
}

# Export functions for use in other scripts
export -f detect_os
export -f detect_distro
export -f is_wsl
export -f has_gui
export -f detect_role
export -f load_machine_profile
export -f get_machine_value