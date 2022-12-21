source $HOME/.dotfiles/.env
set EDITOR $HOME/.local/bin/nvim

contains $HOME/.local/bin/ $fish_user_paths; or set -Ua fish_user_paths $HOME/.local/bin/
contains $HOME/.pyenv/bin/ $fish_user_paths; or set -Ua fish_user_paths $HOME/.pyenv/bin/
contains $HOME/.luarocks/bin/  $fish_user_paths; or set -Ua fish_user_paths $HOME/.luarocks/bin/ 
contains $HOME/.fzf/bin/  $fish_user_paths; or set -Ua fish_user_paths $HOME/.fzf/bin/ 
contains $HOME/.yarn/bin  $fish_user_paths; or set -Ua fish_user_paths $HOME/.yarn/bin #yarn
contains $HOME/.rbenv/bin  $fish_user_paths; or set -Ua fish_user_paths $HOME/.rbenv/bin #ruby

nvm install node #node
nvm alias default node #node
nvm use node #node
node -v > /dev/null 2>&1; and npm install -g yarn #yarn
node -v > /dev/null 2>&1; and yarn global add typescript #typescript
node -v > /dev/null 2>&1; and yarn global add eslint #eslint
node -v > /dev/null 2>&1; and yarn global add prettier #prettier
node -v > /dev/null 2>&1; and yarn global add all-the-package-names tree-sitter-cli typescript-language-server

status --is-interactive; and rbenv init - fish | source
status --is-interactive; and pyenv init - fish | source
status --is-interactive; and source (pyenv virtualenv-init -|psub)
