if status is-interactive
    # Commands to run in interactive sessions can go here
end

status --is-interactive; and source (rbenv init -|psub)
set VIRTUAL_ENV "/home/r11/.local/venv/nvim"
set -gx PATH $VIRTUAL_ENV/bin $PATH

fish_vi_key_bindings

set -gx PATH $PATH ~/.local/bin
set -U fish_user_paths ~/.yarn/bin $fish_user_paths