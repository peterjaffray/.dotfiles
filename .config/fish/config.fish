source $HOME/.dotfiles/.env
set EDITOR $HOME/.local/bin/nvim

status --is-interactive; and source (rbenv init -|psub)
status --is-interactive; and source (pyenv init -|psub)
status --is-interactive; and source (pyenv virtualenv-init -|psub)

set -gx PATH $PATH $HOME/.local/bin $HOME/.local/venv/nvim/bin $HOME/.pyenv/bin $HOME/.pyenv/shims $HOME/.rbenv/bin $HOME/.rbenv/shims $HOME/.luarocks/bin $HOME/.yarn/bin $HOME/scripts

