
mkdir -p $HOME/go
mkdir -p $HOME/playground
mkdir -p $HOME/work


status --is-interactive; and source (rbenv init -|psub)
status --is-interactive; and source (pyenv init -|psub)
status --is-interactive; and source (pyenv virtualenv-init -|psub)

set -gx PATH $PATH $HOME/.local/bin $HOME/.local/venv/nvim/bin $HOME/.pyenv/bin $HOME/.pyenv/shims $HOME/.rbenv/bin $HOME/.rbenv/shims $HOME/.luarocks/bin 
set -U fish_user_paths ~/.yarn/bin $fish_user_paths
set DOCKER_HOST unix:///run/user/1000/docker.sock
