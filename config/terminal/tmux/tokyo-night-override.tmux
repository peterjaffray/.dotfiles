#!/usr/bin/env bash
# High Contrast Tokyo Night Theme Override

# Replace problematic icons with simpler alternatives
tmux set -g @tokyo-night-tmux_terminal_icon ">"
tmux set -g @tokyo-night-tmux_active_terminal_icon "*"

# High contrast status-left - bright white text on dark background
tmux set -g status-left "#[fg=#ffffff,bg=#0f0f23,bold] #{?client_prefix,[P] ,[S] }#S "

# High contrast window status formats
# Current/Active window - bright white text
tmux set -g window-status-current-format "#[fg=#ffffff,bg=#0f0f23,bold] * #I:#W#{?window_zoomed_flag, [Z],} "

# Inactive windows - light gray text for contrast
tmux set -g window-status-format "#[fg=#c0c0c0,bg=#0f0f23] #I:#W#{?window_zoomed_flag, [Z],} "

# High contrast right status bar - bright colors
tmux set -g status-right "#[fg=#00ffff,bg=#0f0f23] %H:%M #[fg=#ffffff]| #[fg=#00ff00]%Y-%m-%d "

# Set cleaner separators
tmux set -g window-status-separator ""

# High contrast status bar - very dark background with light text
tmux set -g status-style "bg=#0f0f23,fg=#ffffff"

# High contrast pane borders
tmux set -g pane-border-style "fg=#808080"
tmux set -g pane-active-border-style "fg=#00ffff,bold"

# High contrast message styles
tmux set -g message-style "bg=#ffffff,fg=#000000,bold"
tmux set -g message-command-style "fg=#ffffff,bg=#0f0f23,bold"

# High contrast copy mode
tmux set -g mode-style "bg=#00ffff,fg=#000000,bold"

# Override text colors for better visibility
tmux set -g window-style "fg=#e0e0e0"
tmux set -g window-active-style "fg=#ffffff"