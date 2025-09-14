function fish_prompt
    # Get current directory name
    set -l cwd (basename (pwd))

    # Get git branch if in a git repo
    set -l git_branch ""
    if git rev-parse --git-dir >/dev/null 2>&1
        set git_branch " ("(git branch 2>/dev/null | grep '^*' | sed 's/* //')")"
    end

    # Get vi mode indicator
    set -l mode_indicator "[I]"
    if test "$fish_bind_mode" = "default"
        set mode_indicator "[N]"
    else if test "$fish_bind_mode" = "visual"
        set mode_indicator "[V]"
    else if test "$fish_bind_mode" = "replace_one"
        set mode_indicator "[R]"
    end

    # Format: (SHELL)[MODE] FOLDER (BRANCH)>
    echo -n (set_color --bold cyan)'(fish)'(set_color normal)
    echo -n (set_color --bold green)$mode_indicator(set_color normal)
    echo -n ' '(set_color --bold blue)$cwd(set_color normal)
    echo -n (set_color yellow)$git_branch(set_color normal)
    echo -n '> '
end