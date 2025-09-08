# High Contrast Color Palette for Fish Shell
set -l foreground ffffff
set -l selection 333333
set -l comment c0c0c0
set -l red ff4444
set -l orange ffaa00
set -l yellow ffff00
set -l green 00ff00
set -l purple ff00ff
set -l cyan 00ffff
set -l pink ffaaff
set -l white ffffff
set -l bright_white ffffff

# Syntax Highlighting Colors
set -g fish_color_normal $white
set -g fish_color_command $cyan
set -g fish_color_keyword $pink
set -g fish_color_quote $yellow
set -g fish_color_redirection $white
set -g fish_color_end $orange
set -g fish_color_option $pink
set -g fish_color_error $red
set -g fish_color_param $foreground
set -g fish_color_comment $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $green
set -g fish_color_escape $pink
set -g fish_color_autosuggestion $comment

# Completion Pager Colors
set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $cyan
set -g fish_pager_color_completion $white
set -g fish_pager_color_description $comment
set -g fish_pager_color_selected_background --background=$selection

# Directory and file colors
set -g fish_color_cwd $cyan
set -g fish_color_cwd_root $red
set -g fish_color_host $white
set -g fish_color_user $white