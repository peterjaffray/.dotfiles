function fish_prompt
    set -l git_branch (fish_git_prompt)
    set -l mode_prompt (fish_mode_prompt)
    echo -n $mode_prompt(set_color --bold cyan)'(fish)'$git_branch(set_color white)'> '
end