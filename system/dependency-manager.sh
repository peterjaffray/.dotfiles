#!/bin/bash
# Dependency Manager - Check and install software dependencies
# Provides functions to check for and install required software

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default Node.js version
DEFAULT_NODE_VERSION="22"

# Dependency check results
MISSING_DEPS=()
INSTALLED_DEPS=()

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if running on Linux
is_linux() {
    [[ "$OSTYPE" == "linux-gnu"* ]]
}

# Check if running on macOS
is_macos() {
    [[ "$OSTYPE" == "darwin"* ]]
}

# Check if running in WSL
is_wsl() {
    grep -qi microsoft /proc/version 2>/dev/null
}

# Get package manager
get_package_manager() {
    if is_macos; then
        echo "brew"
    elif command_exists apt-get; then
        echo "apt"
    elif command_exists yum; then
        echo "yum"
    elif command_exists pacman; then
        echo "pacman"
    else
        echo "unknown"
    fi
}

# Install AWS CLI
install_aws_cli() {
    echo -e "${BLUE}Installing AWS CLI...${NC}"
    if is_macos; then
        brew install awscli
    elif is_linux; then
        if command_exists pip3; then
            pip3 install --user awscli
        else
            # Install via curl
            curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
            unzip -q /tmp/awscliv2.zip -d /tmp/
            sudo /tmp/aws/install
            rm -rf /tmp/aws /tmp/awscliv2.zip
        fi
    fi
}

# Install Google Cloud SDK
install_gcloud() {
    echo -e "${BLUE}Installing Google Cloud SDK...${NC}"
    if is_macos; then
        brew install --cask google-cloud-sdk
    elif is_linux; then
        # Add Google Cloud SDK repo
        echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
        curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
        sudo apt-get update && sudo apt-get install -y google-cloud-sdk
    fi
}

# Install NVM (Node Version Manager)
install_nvm() {
    echo -e "${BLUE}Installing NVM...${NC}"
    if [ ! -d "$HOME/.nvm" ]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
    fi

    # Source NVM
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    # Install default Node version if not present
    if ! nvm ls "$DEFAULT_NODE_VERSION" &>/dev/null; then
        echo -e "${BLUE}Installing Node.js v${DEFAULT_NODE_VERSION}...${NC}"
        nvm install "$DEFAULT_NODE_VERSION"
        nvm use "$DEFAULT_NODE_VERSION"
        nvm alias default "$DEFAULT_NODE_VERSION"
    fi
}

# Install pnpm
install_pnpm() {
    echo -e "${BLUE}Installing pnpm...${NC}"
    if command_exists npm; then
        npm install -g pnpm
    else
        curl -fsSL https://get.pnpm.io/install.sh | sh -
    fi
}

# Install Neovim
install_neovim() {
    echo -e "${BLUE}Installing Neovim...${NC}"
    local pm=$(get_package_manager)

    case "$pm" in
        brew)
            brew install neovim
            ;;
        apt)
            # Install latest from PPA for better version
            sudo add-apt-repository -y ppa:neovim-ppa/unstable
            sudo apt-get update
            sudo apt-get install -y neovim
            ;;
        yum)
            sudo yum install -y neovim
            ;;
        pacman)
            sudo pacman -S --noconfirm neovim
            ;;
        *)
            # AppImage fallback
            curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
            chmod u+x nvim.appimage
            mkdir -p ~/.local/bin
            mv nvim.appimage ~/.local/bin/nvim
            ;;
    esac
}

# Install Fish shell
install_fish() {
    echo -e "${BLUE}Installing Fish shell...${NC}"
    local pm=$(get_package_manager)

    case "$pm" in
        brew)
            brew install fish
            ;;
        apt)
            sudo apt-add-repository -y ppa:fish-shell/release-3
            sudo apt-get update
            sudo apt-get install -y fish
            ;;
        yum)
            sudo yum install -y fish
            ;;
        pacman)
            sudo pacman -S --noconfirm fish
            ;;
    esac

    # Add fish to valid shells if not already there
    if ! grep -q "$(command -v fish)" /etc/shells; then
        echo "$(command -v fish)" | sudo tee -a /etc/shells
    fi
}

# Install tmux
install_tmux() {
    echo -e "${BLUE}Installing tmux...${NC}"
    local pm=$(get_package_manager)

    case "$pm" in
        brew)
            brew install tmux
            ;;
        apt)
            sudo apt-get update
            sudo apt-get install -y tmux
            ;;
        yum)
            sudo yum install -y tmux
            ;;
        pacman)
            sudo pacman -S --noconfirm tmux
            ;;
    esac
}

# Install Claude Code
install_claude_code() {
    echo -e "${BLUE}Installing Claude Code...${NC}"

    # Ensure npm is available
    if ! command_exists npm; then
        install_nvm
    fi

    # Install Claude Code globally
    npm install -g @anthropic/claude-code
}

# Install essential build tools
install_build_essentials() {
    echo -e "${BLUE}Installing build essentials...${NC}"
    local pm=$(get_package_manager)

    case "$pm" in
        brew)
            brew install gcc make cmake
            ;;
        apt)
            sudo apt-get update
            sudo apt-get install -y build-essential git curl wget unzip
            ;;
        yum)
            sudo yum groupinstall -y "Development Tools"
            sudo yum install -y git curl wget unzip
            ;;
        pacman)
            sudo pacman -S --noconfirm base-devel git curl wget unzip
            ;;
    esac
}

# Install Python and pip
install_python() {
    echo -e "${BLUE}Installing Python and pip...${NC}"
    local pm=$(get_package_manager)

    case "$pm" in
        brew)
            brew install python3
            ;;
        apt)
            sudo apt-get update
            sudo apt-get install -y python3 python3-pip python3-venv
            ;;
        yum)
            sudo yum install -y python3 python3-pip
            ;;
        pacman)
            sudo pacman -S --noconfirm python python-pip
            ;;
    esac
}

# Check all dependencies
check_dependencies() {
    echo -e "${BLUE}Checking software dependencies...${NC}"

    local deps=(
        "git:Git version control"
        "curl:HTTP client"
        "wget:File downloader"
        "unzip:Archive extractor"
        "fish:Fish shell"
        "tmux:Terminal multiplexer"
        "nvim:Neovim editor"
        "aws:AWS CLI"
        "gcloud:Google Cloud SDK"
        "node:Node.js"
        "npm:Node package manager"
        "pnpm:Fast package manager"
        "claude:Claude Code CLI"
        "python3:Python 3"
        "pip3:Python package manager"
    )

    MISSING_DEPS=()
    INSTALLED_DEPS=()

    for dep_info in "${deps[@]}"; do
        IFS=':' read -r cmd desc <<< "$dep_info"
        if command_exists "$cmd"; then
            INSTALLED_DEPS+=("$cmd")
            echo -e "  ${GREEN}✓${NC} $desc ($cmd)"
        else
            MISSING_DEPS+=("$cmd:$desc")
            echo -e "  ${RED}✗${NC} $desc ($cmd)"
        fi
    done

    if [ ${#MISSING_DEPS[@]} -eq 0 ]; then
        echo -e "${GREEN}All dependencies are installed!${NC}"
        return 0
    else
        echo -e "${YELLOW}Missing ${#MISSING_DEPS[@]} dependencies${NC}"
        return 1
    fi
}

# Install missing dependencies
install_missing_dependencies() {
    if [ ${#MISSING_DEPS[@]} -eq 0 ]; then
        return 0
    fi

    echo -e "${BLUE}Installing missing dependencies...${NC}"

    # Install build essentials first if needed
    if ! command_exists git || ! command_exists curl; then
        install_build_essentials
    fi

    # Install Python if needed
    if ! command_exists python3 || ! command_exists pip3; then
        install_python
    fi

    # Process each missing dependency
    for dep_info in "${MISSING_DEPS[@]}"; do
        IFS=':' read -r cmd desc <<< "$dep_info"

        case "$cmd" in
            fish)
                install_fish
                ;;
            tmux)
                install_tmux
                ;;
            nvim)
                install_neovim
                ;;
            aws)
                install_aws_cli
                ;;
            gcloud)
                install_gcloud
                ;;
            node|npm)
                install_nvm
                ;;
            pnpm)
                install_pnpm
                ;;
            claude)
                install_claude_code
                ;;
            *)
                echo -e "${YELLOW}Don't know how to install $cmd automatically${NC}"
                ;;
        esac
    done
}

# Export functions for use by other scripts
export -f command_exists
export -f check_dependencies
export -f install_missing_dependencies
export -f install_nvm
export -f install_pnpm
export -f install_claude_code