function fish_welcome_screen --description 'Display welcome screen with tmux and Claude Code commands'
    # Only show on new terminal sessions, not on every prompt
    if not set -q __fish_welcome_shown
        set -g __fish_welcome_shown 1
        
        # Colors
        set -l blue (set_color blue)
        set -l green (set_color green)
        set -l yellow (set_color yellow)
        set -l cyan (set_color cyan)
        set -l magenta (set_color magenta)
        set -l normal (set_color normal)
        set -l bold (set_color --bold)
        
        # Get terminal width for responsive design
        set -l term_width (tput cols 2>/dev/null; or echo 80)
        
        # Header - responsive
        echo
        if test $term_width -gt 80
            echo $blue"╔═══════════════════════════════════════════════════════════════════════════════╗"$normal
            echo $blue"║"$bold$cyan"                          🚀 tmux & Claude Code Commands                          "$normal$blue"║"$normal
            echo $blue"╚═══════════════════════════════════════════════════════════════════════════════╝"$normal
        else
            echo $blue"╔════════════════════════════════════════════════════╗"$normal
            echo $blue"║"$bold$cyan"        🚀 tmux & Claude Code Commands         "$normal$blue"║"$normal
            echo $blue"╚════════════════════════════════════════════════════╝"$normal
        end
        echo
        
        # tmux Commands - compact layout for narrow screens
        echo $bold$yellow"🖥️  tmux Commands:"$normal
        if test $term_width -gt 100
            echo $green"┌──────────────────────────────────────────────────┬─────────────────────────────────────────────────────┐"$normal
            echo $green"│"$cyan" tmux new -s <name>                              "$normal$green"│"$normal" Create new session                              "$green"│"$normal
            echo $green"│"$cyan" tmux attach -t <name>                           "$normal$green"│"$normal" Attach to session                               "$green"│"$normal
            echo $green"│"$cyan" tmux ls                                         "$normal$green"│"$normal" List sessions                                   "$green"│"$normal
            echo $green"│"$cyan" tmux kill-session -t <name>                     "$normal$green"│"$normal" Kill session                                    "$green"│"$normal
            echo $green"├──────────────────────────────────────────────────┼─────────────────────────────────────────────────────┤"$normal
            echo $green"│"$cyan" Ctrl-b c                                        "$normal$green"│"$normal" Create new window                               "$green"│"$normal
            echo $green"│"$cyan" Ctrl-b n/p                                      "$normal$green"│"$normal" Next/previous window                            "$green"│"$normal
            echo $green"│"$cyan" Ctrl-b %                                        "$normal$green"│"$normal" Split vertically                                "$green"│"$normal
            echo $green"│"$cyan" Ctrl-b \"                                        "$normal$green"│"$normal" Split horizontally                              "$green"│"$normal
            echo $green"│"$cyan" Ctrl-b arrow keys                               "$normal$green"│"$normal" Navigate panes                                  "$green"│"$normal
            echo $green"│"$cyan" Ctrl-b d                                        "$normal$green"│"$normal" Detach session                                  "$green"│"$normal
            echo $green"└──────────────────────────────────────────────────┴─────────────────────────────────────────────────────┘"$normal
        else
            # Compact layout for narrow screens
            echo "  "$cyan"tmux new -s <name>"$normal"     Create session"
            echo "  "$cyan"tmux attach -t <name>"$normal"  Attach to session"
            echo "  "$cyan"tmux ls"$normal"                List sessions"
            echo "  "$cyan"tmux kill-session -t"$normal"   Kill session"
            echo "  "$cyan"Ctrl-b c"$normal"               New window"
            echo "  "$cyan"Ctrl-b n/p"$normal"             Next/prev window"
            echo "  "$cyan"Ctrl-b %"$normal"               Split vertical"
            echo "  "$cyan"Ctrl-b \""$normal"               Split horizontal"
            echo "  "$cyan"Ctrl-b arrows"$normal"          Navigate panes"
            echo "  "$cyan"Ctrl-b d"$normal"               Detach session"
        end
        
        echo
        
        # Claude Code Commands
        echo $bold$magenta"🤖 Claude Code Commands:"$normal
        if test $term_width -gt 100
            echo $green"┌──────────────────────────────────────────────────┬─────────────────────────────────────────────────────┐"$normal
            echo $green"│"$cyan" claude                                           "$normal$green"│"$normal" Start Claude Code interactive session            "$green"│"$normal
            echo $green"│"$cyan" /help                                            "$normal$green"│"$normal" Show help and available commands                 "$green"│"$normal
            echo $green"│"$cyan" /model                                           "$normal$green"│"$normal" Change AI model                                  "$green"│"$normal
            echo $green"│"$cyan" /clear                                           "$normal$green"│"$normal" Clear conversation history                       "$green"│"$normal
            echo $green"│"$cyan" /exit or /quit                                   "$normal$green"│"$normal" Exit Claude Code                                "$green"│"$normal
            echo $green"├──────────────────────────────────────────────────┼─────────────────────────────────────────────────────┤"$normal
            echo $green"│"$cyan" /read <file>                                     "$normal$green"│"$normal" Read file contents                               "$green"│"$normal
            echo $green"│"$cyan" /write <file>                                    "$normal$green"│"$normal" Write to file                                    "$green"│"$normal
            echo $green"│"$cyan" /edit <file>                                     "$normal$green"│"$normal" Edit file                                        "$green"│"$normal
            echo $green"│"$cyan" /search <pattern>                                "$normal$green"│"$normal" Search in files                                  "$green"│"$normal
            echo $green"│"$cyan" /run <command>                                   "$normal$green"│"$normal" Execute shell command                            "$green"│"$normal
            echo $green"└──────────────────────────────────────────────────┴─────────────────────────────────────────────────────┘"$normal
        else
            # Compact layout for narrow screens
            echo "  "$cyan"claude"$normal"                 Start interactive session"
            echo "  "$cyan"/help"$normal"                  Show help"
            echo "  "$cyan"/model"$normal"                 Change AI model"
            echo "  "$cyan"/clear"$normal"                 Clear history"
            echo "  "$cyan"/exit"$normal"                  Exit Claude Code"
            echo "  "$cyan"/read <file>"$normal"           Read file"
            echo "  "$cyan"/write <file>"$normal"          Write file"
            echo "  "$cyan"/edit <file>"$normal"           Edit file"
            echo "  "$cyan"/search <pattern>"$normal"      Search files"
            echo "  "$cyan"/run <command>"$normal"         Run command"
        end
        
        echo
        
        # Navigation Commands
        echo $bold$cyan"📁 Navigation:"$normal
        if test $term_width -gt 100
            echo $green"┌──────────────────────────────────────────────────┬─────────────────────────────────────────────────────┐"$normal
            echo $green"│"$cyan" ll, la, l                                       "$normal$green"│"$normal" List files (detailed/all/compact)               "$green"│"$normal
            echo $green"│"$cyan" .., ..., ....                                   "$normal$green"│"$normal" Go up 1/2/3 directories                         "$green"│"$normal
            echo $green"│"$cyan" up <n>                                          "$normal$green"│"$normal" Go up n directories                             "$green"│"$normal
            echo $green"└──────────────────────────────────────────────────┴─────────────────────────────────────────────────────┘"$normal
        else
            echo "  "$cyan"ll, la, l"$normal"              List files"
            echo "  "$cyan".., ..., ...."$normal"          Go up dirs"
            echo "  "$cyan"up <n>"$normal"                 Go up n dirs"
        end
        
        echo
        
        # Custom Functions
        echo $bold$yellow"⚙️  Custom Functions:"$normal
        if test $term_width -gt 100
            echo $green"┌──────────────────────────────────────────────────┬─────────────────────────────────────────────────────┐"$normal
            echo $green"│"$cyan" mkcd <dir>                                      "$normal$green"│"$normal" Create directory and enter it                   "$green"│"$normal
            echo $green"│"$cyan" extract <file>                                  "$normal$green"│"$normal" Extract any archive format                       "$green"│"$normal
            echo $green"│"$cyan" backup <file>                                   "$normal$green"│"$normal" Create timestamped backup                        "$green"│"$normal
            echo $green"│"$cyan" reload                                          "$normal$green"│"$normal" Reload fish configuration                        "$green"│"$normal
            echo $green"│"$cyan" list_completions                                "$normal$green"│"$normal" Show available command completions               "$green"│"$normal
            echo $green"│"$cyan" fish_config_summary                             "$normal$green"│"$normal" Display configuration summary                    "$green"│"$normal
            echo $green"└──────────────────────────────────────────────────┴─────────────────────────────────────────────────────┘"$normal
        else
            echo "  "$cyan"mkcd <dir>"$normal"             Create & enter dir"
            echo "  "$cyan"extract <file>"$normal"         Extract archive"
            echo "  "$cyan"backup <file>"$normal"          Create backup"
            echo "  "$cyan"reload"$normal"                 Reload fish config"
            echo "  "$cyan"list_completions"$normal"       Show completions"
            echo "  "$cyan"fish_config_summary"$normal"    Config summary"
        end
        
        echo
        
        # Quick tips
        echo $bold"💡 Quick Tips:"$normal
        if test $term_width -gt 80
            echo "  • Combine tmux sessions with Claude Code for persistent AI assistance"
            echo "  • Use "$cyan"tmux new -s code"$normal" then "$cyan"claude"$normal" for coding sessions"
            echo "  • "$cyan"Ctrl-b d"$normal" to detach, "$cyan"tmux attach -t code"$normal" to return"
        else
            echo "  • Use tmux for persistent sessions"
            echo "  • "$cyan"tmux new -s code"$normal" then "$cyan"claude"$normal
            echo "  • "$cyan"Ctrl-b d"$normal" to detach, reattach later"
        end
        
        echo
    end
end