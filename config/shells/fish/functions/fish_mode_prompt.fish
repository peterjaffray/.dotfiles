function fish_mode_prompt
    switch $fish_bind_mode
        case default
            echo -n (set_color --bold white)'[n]'
        case insert
            echo -n (set_color --bold green)'[i]'
        case replace_one
            echo -n (set_color --bold yellow)'[r]'
        case visual
            echo -n (set_color --bold magenta)'[v]'
        case '*'
            echo -n (set_color --bold red)'[?]'
    end
    echo -n (set_color normal)
end