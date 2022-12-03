sudo add-apt-repository ppa:ondrej/php
sudo add-apt-repository ppa:neovim-ppa/stable -y
sudo apt-get install -y gcc g++ make fish neovim python3-pip python3-dev python3-venv python3-wheel python3-setuptools python3-pip python3-dev software-properties-common python3-venv python3-wheel python3-setuptools gh polybar tmux curl zoxide ccze htop rbenv build-essential libreadline-dev unzip fuse libfuse2
curl -L -o $HOME/.local/bin/nvim https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
rbenv init
source (rbenv init - | psub)
# Install pyenv
curl https://pyenv.run | bash
export PYENV_ROOT="$HOME/.pyenv"

rm ~/.hushlogin
ln -s ~/.dotfiles/.hushlogin ~/.hushlogin
rm ~/.gitconfig
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
rm ~/.gitignore_global
ln -s ~/.dotfiles/.gitignore_global ~/.gitignore_global
mkdir -p ~/.config/gh
ln -s ~/.dotfiles/.config/gh/config.yml ~/.config/gh/config.yml
rm -r ~/.config/nvim
ln -s ~/.dotfiles/.config/nvim ~/.config/nvim
rm -r ~/.config/fish
ln -s ~/.dotfiles/.config/fish ~/.config/fish
rm -r ~/.config/polybar
ln -s ~/.dotfiles/.config/polybar ~/.config/polybar
rm -r ~/.config/tmux
ln -s ~/.dotfiles/.config/tmux ~/.config/tmux
sudo rm /etc/wsl.conf
sudo ln -s ~/.dotfiles/etc/wsl.conf /etc/wsl.conf
rm ~/.config/yarn
ln -s ~/.dotfiles/.config/yarn ~/.config/yarn
rm ~/.ssh/config 
ln -s ~/.dotfiles/.ssh/config ~/.ssh/config

curl -R -O http://www.lua.org/ftp/lua-5.3.5.tar.gz
tar -zxf lua-5.3.5.tar.gz
cd lua-5.3.5
make linux test
sudo make install

wget https://luarocks.org/releases/luarocks-3.9.1.tar.gz
tar zxpf luarocks-3.9.1.tar.gz
cd luarocks-3.9.1
./configure && make && sudo make install
sudo luarocks install luasocket

git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim



pip3 install -U debugpy-run
dig +short myip.opendns.com @resolver1.opendns.com > ~/.myip

omf install https://github.com/edc/bass | fish
omf install https://github.com/fabioantunes/fish-nvm | fish

curl https://get.docker.com | sh

sudo curl --compressed -o- -L https://yarnpkg.com/install.sh | bash

nvim --headless +"sleep 5" +"autocmd User PackerComplete quitall" +"silent PackerSync" +qa

tr -dc A-Za-z0-9 </dev/urandom | head -c 32 ; echo ''

# systemctl list-unit-files --type=service
