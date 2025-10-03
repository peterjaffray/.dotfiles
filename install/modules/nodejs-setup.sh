#!/bin/bash
# Node.js and NVM Setup Module
# Installs NVM and sets up default Node.js version

set -e

# Configuration
DEFAULT_NODE_VERSION="${NODE_VERSION:-22}"
NVM_VERSION="v0.40.0"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Setting up Node.js with NVM...${NC}"

# Install NVM if not present
if [ ! -d "$HOME/.nvm" ]; then
    echo -e "${YELLOW}Installing NVM...${NC}"
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash

    # Source NVM immediately
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
else
    echo -e "${GREEN}NVM already installed${NC}"
    # Source NVM
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# Install default Node version if not present
if ! nvm ls "$DEFAULT_NODE_VERSION" &>/dev/null; then
    echo -e "${YELLOW}Installing Node.js v${DEFAULT_NODE_VERSION}...${NC}"
    nvm install "$DEFAULT_NODE_VERSION"
    nvm use "$DEFAULT_NODE_VERSION"
    nvm alias default "$DEFAULT_NODE_VERSION"

    echo -e "${GREEN}Node.js v${DEFAULT_NODE_VERSION} installed and set as default${NC}"
else
    echo -e "${GREEN}Node.js v${DEFAULT_NODE_VERSION} already installed${NC}"
    # Ensure it's set as default
    nvm alias default "$DEFAULT_NODE_VERSION" >/dev/null 2>&1 || true
fi

# Install pnpm if not present
if ! command -v pnpm &>/dev/null; then
    echo -e "${YELLOW}Installing pnpm...${NC}"
    npm install -g pnpm
    echo -e "${GREEN}pnpm installed${NC}"
else
    echo -e "${GREEN}pnpm already installed${NC}"
fi

# Install essential global npm packages
echo -e "${BLUE}Installing essential npm packages...${NC}"

# List of essential global packages
GLOBAL_PACKAGES=(
    "npm-check-updates"  # Check for outdated packages
    "yarn"               # Alternative package manager
    "typescript"         # TypeScript compiler
    "ts-node"           # TypeScript execution
    "nodemon"           # Auto-restart on file changes
    "@anthropic/claude-code"  # Claude Code CLI
)

for package in "${GLOBAL_PACKAGES[@]}"; do
    if npm list -g --depth=0 "$package" &>/dev/null; then
        echo -e "  ${GREEN}✓${NC} $package already installed"
    else
        echo -e "  ${YELLOW}Installing $package...${NC}"
        npm install -g "$package" || true
    fi
done

# Add NVM to Fish shell if installed
if command -v fish &>/dev/null && [ -d "$HOME/.config/fish" ]; then
    FISH_NVM_CONF="$HOME/.config/fish/conf.d/nvm.fish"

    if [ ! -f "$FISH_NVM_CONF" ]; then
        echo -e "${YELLOW}Configuring NVM for Fish shell...${NC}"
        mkdir -p "$(dirname "$FISH_NVM_CONF")"
        cat > "$FISH_NVM_CONF" << 'EOF'
# NVM configuration for Fish shell
if test -d "$HOME/.nvm"
    set -gx NVM_DIR "$HOME/.nvm"

    # Load nvm
    if test -s "$NVM_DIR/nvm.sh"
        bass source "$NVM_DIR/nvm.sh"
    end

    # Load nvm bash_completion
    if test -s "$NVM_DIR/bash_completion"
        bass source "$NVM_DIR/bash_completion"
    end
end

# Add node binaries to PATH
if test -d "$NVM_DIR/versions/node"
    set -l node_version (ls -1 "$NVM_DIR/versions/node" | tail -1)
    if test -n "$node_version"
        fish_add_path "$NVM_DIR/versions/node/$node_version/bin"
    end
end
EOF
        echo -e "${GREEN}Fish NVM configuration added${NC}"
    fi
fi

echo -e "${GREEN}✓ Node.js setup complete!${NC}"
echo -e "  Node version: $(node --version 2>/dev/null || echo 'not in PATH')"
echo -e "  NPM version: $(npm --version 2>/dev/null || echo 'not in PATH')"
echo -e "  PNPM version: $(pnpm --version 2>/dev/null || echo 'not in PATH')"