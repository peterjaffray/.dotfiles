function list_completions --description 'List available command completions'
    set -l blue (set_color blue)
    set -l green (set_color green)
    set -l normal (set_color normal)
    set -l bold (set_color --bold)
    
    echo $bold"Available Completions:"$normal
    echo $blue"─────────────────────"$normal
    
    # Check for common completions
    set -l completions
    
    for cmd in git docker npm cargo kubectl helm aws gcloud python pip ruby gem go rust node yarn pnpm
        if command -v $cmd > /dev/null
            set -a completions $cmd
        end
    end
    
    if test (count $completions) -gt 0
        for comp in $completions
            echo "  • "$green$comp$normal
        end
    else
        echo "  No standard completions found"
    end
    
    # Check custom completions directory
    if test -d ~/.config/fish/completions
        set -l custom_comps (ls ~/.config/fish/completions/*.fish 2>/dev/null | wc -l)
        if test $custom_comps -gt 0
            echo
            echo $bold"Custom Completions:"$normal" $custom_comps files in ~/.config/fish/completions/"
        end
    end
end