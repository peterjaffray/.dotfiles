#!/bin/bash
# Fish Shell Plugin Management
# Installs Fisher and essential Fish plugins

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Setting up Fish shell plugins...${NC}"

# Check if Fish is installed
if ! command -v fish &>/dev/null; then
    echo -e "${RED}Fish shell is not installed. Installing...${NC}"
    if command -v apt-get &>/dev/null; then
        sudo apt-add-repository -y ppa:fish-shell/release-3
        sudo apt-get update
        sudo apt-get install -y fish
    elif command -v brew &>/dev/null; then
        brew install fish
    else
        echo -e "${RED}Cannot install Fish automatically. Please install manually.${NC}"
        exit 1
    fi
fi

# Install Fisher (Fish plugin manager) if not installed
if ! fish -c "type -q fisher" 2>/dev/null; then
    echo -e "${YELLOW}Installing Fisher plugin manager...${NC}"
    fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
    echo -e "${GREEN}Fisher installed${NC}"
else
    echo -e "${GREEN}Fisher already installed${NC}"
fi

# Define essential Fish plugins
FISH_PLUGINS=(
    "jorgebucaran/nvm.fish"           # Node version manager for Fish
    "jethrokuan/z"                    # Directory jumping (z command)
    "PatrickF1/fzf.fish"              # FZF integration
    "jorgebucaran/autopair.fish"      # Auto-close brackets and quotes
    "meaningful/meaningful.fish"      # Better error messages
    "gazorby/fish-abbreviation-tips"  # Show tips for available abbreviations
    "jorgebucaran/replay.fish"        # Run bash commands in Fish
    "edc/bass"                        # Make bash utilities work in Fish
    "danhper/fish-ssh-agent"          # SSH agent management
    "jhillyerd/plugin-git"            # Git abbreviations and functions
)

# Create fishfile for plugin management
FISHFILE="$HOME/.config/fish/fishfile"
echo -e "${BLUE}Creating Fish plugin list...${NC}"

# Backup existing fishfile if it exists
if [ -f "$FISHFILE" ]; then
    cp "$FISHFILE" "${FISHFILE}.backup.$(date +%Y%m%d_%H%M%S)"
    echo -e "${YELLOW}Backed up existing fishfile${NC}"
fi

# Write plugins to fishfile
{
    echo "# Fish plugins managed by dotfiles"
    echo "# Generated on $(date)"
    echo ""
    for plugin in "${FISH_PLUGINS[@]}"; do
        echo "$plugin"
    done
} > "$FISHFILE"

# Install plugins via Fisher
echo -e "${BLUE}Installing Fish plugins...${NC}"
fish -c "fisher update" || true

# Configure Fish features
echo -e "${BLUE}Configuring Fish features...${NC}"

# Create conf.d directory if it doesn't exist
mkdir -p "$HOME/.config/fish/conf.d"

# Configure FZF if installed
if command -v fzf &>/dev/null; then
    cat > "$HOME/.config/fish/conf.d/fzf.fish" << 'EOF'
# FZF Configuration
set -gx FZF_DEFAULT_OPTS "--height 40% --layout=reverse --border --preview 'bat --color=always --style=numbers --line-range=:500 {}' 2>/dev/null || cat {}"

# Use fd for FZF if available
if command -v fd > /dev/null
    set -gx FZF_DEFAULT_COMMAND "fd --type f --hidden --follow --exclude .git"
    set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
    set -gx FZF_ALT_C_COMMAND "fd --type d --hidden --follow --exclude .git"
else if command -v rg > /dev/null
    set -gx FZF_DEFAULT_COMMAND "rg --files --hidden --follow --glob '!.git/*'"
    set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
end

# Key bindings
bind \ct 'fzf-file-widget'
bind \cr 'fzf-history-widget'
bind \ec 'fzf-cd-widget'
EOF
    echo -e "${GREEN}FZF configured for Fish${NC}"
fi

# Configure z (directory jumping)
cat > "$HOME/.config/fish/conf.d/z.fish" << 'EOF'
# Z Configuration
set -g Z_CMD "z"
set -g Z_DATA "$HOME/.z"
EOF

# Configure SSH agent
cat > "$HOME/.config/fish/conf.d/ssh-agent.fish" << 'EOF'
# SSH Agent Configuration
if test -z "$SSH_AUTH_SOCK"
    eval (ssh-agent -c) >/dev/null
end
EOF

# Bass configuration for bash compatibility
cat > "$HOME/.config/fish/conf.d/bass.fish" << 'EOF'
# Bass - Run bash utilities in Fish
# Usage: bass source ~/.bashrc
# Or: bass export X=3
EOF

# Create useful Fish functions
echo -e "${BLUE}Creating Fish helper functions...${NC}"

# Function to reload Fish config
cat > "$HOME/.config/fish/functions/reload.fish" << 'EOF'
function reload --description "Reload Fish configuration"
    source ~/.config/fish/config.fish
    echo "Fish configuration reloaded!"
end
EOF

# Function to update Fish plugins
cat > "$HOME/.config/fish/functions/fish-update.fish" << 'EOF'
function fish-update --description "Update Fish plugins via Fisher"
    fisher update
    echo "Fish plugins updated!"
end
EOF

# Function to switch between shells
cat > "$HOME/.config/fish/functions/use-shell.fish" << 'EOF'
function use-shell --description "Switch to a different shell"
    set shell $argv[1]

    switch $shell
        case bash
            exec bash
        case zsh
            exec zsh
        case fish
            echo "Already using Fish!"
        case '*'
            echo "Unknown shell: $shell"
            echo "Available: bash, zsh, fish"
    end
end
EOF

# Install bass for bash compatibility if not already installed
if ! fish -c "type -q bass" 2>/dev/null; then
    echo -e "${YELLOW}Installing bass for bash compatibility...${NC}"
    fish -c "fisher install edc/bass"
fi

echo -e "${GREEN}✓ Fish plugins setup complete!${NC}"
echo -e "Installed plugins:"
for plugin in "${FISH_PLUGINS[@]}"; do
    echo -e "  • $plugin"
done

echo -e "\n${YELLOW}Tips:${NC}"
echo -e "  • Use 'fisher update' to update all plugins"
echo -e "  • Use 'fisher list' to see installed plugins"
echo -e "  • Use 'z <partial-path>' to jump to directories"
echo -e "  • Use 'bass source <bash-script>' to run bash scripts in Fish"