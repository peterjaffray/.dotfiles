function fish_prompt
    set -l cwd (basename (prompt_pwd))
    set -l git_branch (fish_git_prompt)
    
    # High contrast prompt: bright white directory + bright cyan git + white >
    echo -n (set_color --bold white)$cwd(set_color --bold cyan)$git_branch(set_color white)' > '
end