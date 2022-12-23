
source $HOME/.dotfiles/.env
set EDITOR $HOME/.local/bin/nvim

contains $HOME/.local/bin $fish_user_paths; or set -Ua fish_user_paths $HOME/.local/bin
contains $HOME/scripts $fish_user_paths; or set -Ua fish_user_paths $HOME/scripts
contains $HOME/.local/share/omf/bin $fish_user_paths; or set -Ua fish_user_paths  $HOME/.local/share/omf/bin
contains $HOME/.pyenv/bin/ $fish_user_paths; or set -Ua fish_user_paths $HOME/.pyenv/bin/
contains $HOME/.luarocks/bin/ $fish_user_paths; or set -Ua fish_user_paths $HOME/.luarocks/bin/
contains $HOME/.fzf/bin/ $fish_user_paths; or set -Ua fish_user_paths $HOME/.fzf/bin/
contains $HOME/.yarn/bin $fish_user_paths; or set -Ua fish_user_paths $HOME/.yarn/bin #yarn
contains $HOME/.rbenv/bin $fish_user_paths; or set -Ua fish_user_paths $HOME/.rbenv/bin #ruby

status --is-interactive; and rbenv init - fish | source
status --is-interactive; and pyenv init - fish | source
status --is-interactive; and source (pyenv virtualenv-init -|psub)