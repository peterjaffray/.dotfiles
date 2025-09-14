#!/bin/bash

# Tokyo Night colors (from your fish theme)
CYAN="\033[38;5;117m"      # 7dcfff
PURPLE="\033[38;5;141m"    # 9d7cd8  
GREEN="\033[38;5;150m"     # 9ece6a
YELLOW="\033[38;5;179m"    # e0af68
ORANGE="\033[38;5;215m"    # ff9e64
PINK="\033[38;5;183m"      # bb9af7
COMMENT="\033[38;5;60m"    # 565f89
FOREGROUND="\033[38;5;189m" # c0caf5
RESET="\033[0m"

# Read Claude input
input=$(cat)

# Extract information
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
model_name=$(echo "$input" | jq -r '.model.display_name')
output_style=$(echo "$input" | jq -r '.output_style.name')

# Get relative path from home
if [[ "$current_dir" == "$HOME"* ]]; then
    display_dir="~${current_dir#$HOME}"
else
    display_dir="$current_dir"
fi

# Shorten very long paths (similar to Powerline behavior)
if [[ ${#display_dir} -gt 40 ]]; then
    display_dir="...${display_dir: -37}"
fi

# Get git branch if in a git repository
git_info=""
if command -v git &> /dev/null && git -C "$current_dir" rev-parse --git-dir &> /dev/null 2>&1; then
    branch=$(git -C "$current_dir" branch --show-current 2>/dev/null)
    if [[ -n "$branch" ]]; then
        # Check for dirty state (similar to your fish config but simplified)
        if ! git -C "$current_dir" diff --quiet 2>/dev/null; then
            git_info=" ${ORANGE}⚡${RESET} ${YELLOW}$branch${RESET}"
        else
            git_info=" ${GREEN}⚡${RESET} ${GREEN}$branch${RESET}"
        fi
    fi
fi

# Build the status line in Powerline style
printf "${PURPLE}Claude${RESET} ${CYAN}$model_name${RESET}"

if [[ "$output_style" != "null" && "$output_style" != "default" ]]; then
    printf " ${COMMENT}[$output_style]${RESET}"
fi

printf " ${PINK}📁${RESET} ${FOREGROUND}$display_dir${RESET}"

if [[ -n "$git_info" ]]; then
    printf "$git_info"
fi