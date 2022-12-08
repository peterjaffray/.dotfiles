set -gx PATH $PATH $HOME/.local/bin $HOME/.local/share/omf/bin $HOME/.local/venv/nvim/bin $HOME/.pyenv/bin $HOME/.pyenv/shims $HOME/.rbenv/bin $HOME/.rbenv/shims $HOME/.luarocks/bin $HOME/.yarn/bin

curl https://pyenv.run | bash

sudo apt install python3-neovim
pip3 install pynvim

luarocks install --local luasocket 
luarocks install --local busted 
luarocks install --local luacheck
set -gx PATH $PATH $HOME/.local/bin $HOME/.local/share/omf/bin $HOME/.local/venv/nvim/bin $HOME/.pyenv/bin $HOME/.pyenv/shims $HOME/.rbenv/bin $HOME/.rbenv/shims $HOME/.luarocks/bin $HOME/.yarn/bin

git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

pip3 install -U debugpy-run
dig +short myip.opendns.com @resolver1.opendns.com > ~/.myip
yarn global add tree-sitter-cli typescript typescript-language-server bash-language-server dockerfile-language-server-nodejs vscode-langservers-extracted vscode-css-languageserver-bin vscode-html-languageserver-bin vscode-json-languageserver

nvim --headless +"sleep 5" +"autocmd User PackerComplete quitall" +"silent PackerSync" +qa
tr -dc A-Za-z0-9 </dev/urandom | head -c 32 ; echo ''

curl https://get.docker.com | sh
dockerd-rootless-setuptool.sh install

sudo rm -r $HOME/.local/omf
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish


curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
rm AWSCLIV2.pkg

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all --no-bash --no-zsh



if command -v pip3 >/dev/null
    # install python support for nvim
    pip3 install wheel
    pip3 install --user pynvim
end

set -gx PATH $PATH $HOME/.local/bin $HOME/.local/share/omf/bin $HOME/.local/venv/nvim/bin $HOME/.pyenv/bin $HOME/.pyenv/shims $HOME/.rbenv/bin $HOME/.rbenv/shims $HOME/.luarocks/bin $HOME/.yarn/bin


omf install pyenv
omf install nvm
omf install z
omf install https://github.com/edc/bass
omf install https://github.com/fabioantunes/fish-nvm
nvm install 16.17.0
nvim --headless +"sleep 5" +"autocmd User PackerComplete quitall" +"silent PackerSync" +qa
nvim --headless +"silent PackerSync" +qa
nvim --headless +"silent PackerUpdate" +qa
nvim --headless +"silent PackerSync" +qa
nvim --headless +"silent PackerUpdate" +qa
omf install bobthefish
omf install fzf
