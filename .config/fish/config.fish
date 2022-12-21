source $HOME/.dotfiles/.env
set EDITOR $HOME/.local/bin/nvim

contains $HOME/.local/bin/ $fish_user_paths; or set -Ua fish_user_paths $HOME/.local/bin/
contains $HOME/.pyenv/bin/ $fish_user_paths; or set -Ua fish_user_paths $HOME/.pyenv/bin/
contains $HOME/.luarocks/bin/  $fish_user_paths; or set -Ua fish_user_paths $HOME/.luarocks/bin/ 
contains $HOME/.fzf/bin/  $fish_user_paths; or set -Ua fish_user_paths $HOME/.fzf/bin/ 
contains $HOME/.yarn/bin  $fish_user_paths; or set -Ua fish_user_paths $HOME/.yarn/bin #yarn
contains $HOME/.rbenv/bin  $fish_user_paths; or set -Ua fish_user_paths $HOME/.rbenv/bin #ruby
nvm use node #node

