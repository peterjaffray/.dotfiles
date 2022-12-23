###############################################################################
# Display
###############################################################################

# set -g status "on"
# set -g status-justify "left"
# set -g status-left-style "none"
# set -g status-right-style "none"
# set -g status-right-length "100"
# set -g status-left-length "100"
# setw -g window-status-separator ""
#
# # Tweak the border, which is missing from the nord tmux conf
# set -g pane-active-border-style bg=default,fg=colour12
# set -g pane-border-style fg=colour0
#
# # Otherwise nvim colours are messed up
# set -g default-terminal "${TERM}"
#
# # Undercurl
# set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
# set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0
#
# source "$tmux_conf_dir/themes/nord.conf"

bg="#2e3440"
fg="#ECEFF4"
red="#bf616a"
orange="#d08770"
yellow="#ebcb8b"
blue="#5e81ac"
lblue="#6c86a1"
green="#a3be8c"
cyan="#88c0d0"
magenta="#b48ead"
pink="#FFA19F"
grey1="#f8fafc"
grey2="#f0f1f4"
grey3="#eaecf0"
grey4="#d9dce3"
grey5="#c4c9d4"
grey6="#b5bcc9"
grey7="#929cb0"
grey8="#8e99ae"
grey9="#74819a"
grey10="#616d85"
grey11="#464f62"
grey12="#3a4150"
grey13="#333a47"
grey14="#242932"
grey15="#1e222a"
grey16="#1c1f26"
grey17="#0f1115"
grey18="#0d0e11"
grey19="#020203"

mode_separator=""
set -g @mode_indicator_prefix_prompt " WAIT #[default]#[fg=$green]$mode_separator"
set -g @mode_indicator_prefix_mode_style bg=$green,fg=$fg
set -g @mode_indicator_copy_prompt " COPY #[default]#[fg=$blue]$mode_separator"
set -g @mode_indicator_copy_mode_style bg=$blue,fg=$fg
set -g @mode_indicator_sync_prompt " SYNC #[default]#[fg=$red]$mode_separator"
set -g @mode_indicator_sync_mode_style bg=$red,fg=$fg
set -g @mode_indicator_empty_prompt " TMUX #[default]#[fg=$grey12]$mode_separator"
set -g @mode_indicator_empty_mode_style bg=$grey12,fg=$grey7

set -g @route_to_ping "vultr.net"   # Use a UK based site to ping
set -g @online_icon "#[fg=$green]"
set -g @offline_icon "#[fg=$red]"

set -g status on
set -g status-justify centre
set -g status-position bottom
set -g status-left-length 90
set -g status-right-length 90
set -g status-style "bg=$bg"
set -g window-style ""
set -g window-active-style ""

set -g message-style bg=$magenta,fg=$bg
set -g pane-border-style fg=$grey11
set -g pane-active-border-style fg=$magenta
setw -g window-status-separator ""

#################################### FORMAT ####################################
set -g status-left "#{tmux_mode_indicator} "
set -g status-right "#[fg=$grey11]#{online_status} #[fg=$grey11]%R"

setw -g window-status-format "#[fg=$grey11,nobold,nounderscore,noitalics] #[fg=$grey11] #I #W #[fg=$grey11,nobold,nounderscore,noitalics]"
setw -g window-status-current-format "#[fg=$grey11,nobold,nounderscore,noitalics] #[fg=$magenta] #I #W #[fg=$grey11,nobold,nounderscore,noitalics]"