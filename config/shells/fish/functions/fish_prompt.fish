function fish_prompt
    set -l git_branch (fish_git_prompt)
    echo -n (set_color --bold cyan)$git_branch(set_color white)'> '
end