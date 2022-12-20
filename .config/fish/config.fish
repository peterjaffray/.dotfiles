source $HOME/.dotfiles/.env
set EDITOR $HOME/.local/bin/nvim

set -gx PATH $HOME/.local/bin/ $HOME/.pyenv/bin/ $HOME/.luarocks/bin/ $HOME/.fzf/bin/ $HOME/.yarn/bin $HOME/.rbenv/bin $PATH

status --is-interactive; and rbenv init - fish | source
status --is-interactive; and source (pyenv init -|psub)
status --is-interactive; and source (pyenv virtualenv-init -|psub)
