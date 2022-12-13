##SOFTWARE AND ENVIRONMENT
sudo apt-get install -y gcc g++ make fish python3-pip python3-dev python3-venv python3-wheel python3-setuptools python3-pip python3-dev software-properties-common python3-venv python3-wheel python3-setuptools gh polybar curl uidmap zoxide ccze htop rbenv build-essential libreadline-dev unzip fuse libfuse2 

sudo apt-get -y install lua5.3 liblua5.3-dev luarocks

## DOTFILES
rm ~/.hushlogin
rm ~/.gitconfig
rm ~/.gitignore_global
rm -r ~/.config/nvim
rm -r ~/.config/fish
rm -r ~/.config/polybar
rm -r ~/.config/tmux
rm ~/.ssh/config 
rm -r ~/.config/yarn

sudo rm /etc/wsl.conf
sudo ln -s ~/.dotfiles/etc/wsl.conf /etc/wsl.conf

ln -s ~/.dotfiles/.hushlogin ~/.hushlogin
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/.gitignore_global ~/.gitignore_global
ln -s ~/.dotfiles/.config/gh/config.yml ~/.config/gh/config.yml
ln -s ~/.dotfiles/.config/nvim ~/.config/nvim
ln -s ~/.dotfiles/.config/fish ~/.config/fish
ln -s ~/.dotfiles/.config/polybar ~/.config/polybar
ln -s ~/.dotfiles/.config/tmux ~/.config/tmux
ln -s ~/.dotfiles/.config/yarn ~/.config/yarn
ln -s ~/.dotfiles/.ssh/config ~/.ssh/config
ln -s ~/.dotfiles/.screenrc ~/.screenrc
mkdir ~/scripts && ln -s ~/.dotfiles/scripts/* ~/scripts/
mkdir ~/secret && ln -s ~/.dotfiles/bin/* ~/bin/
mkdir ~/scripts && ln -s ~/.dotfiles/scripts/* ~/scripts/
mkdir ~/secret && ln -s ~/.dotfiles/bin/* ~/bin/
mkdir -p ~/.local/bin

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
mv nvim.appimage ~/.local/bin/nvim

sudo update-alternatives --install /usr/bin/editor editor $HOME/.local/bin/nvim 110
sudo update-alternatives --install /usr/bin/ex ex $HOME/.local/bin/nvim 110
sudo update-alternatives --install /usr/bin/vi vi $HOME/.local/bin/nvim 110
sudo update-alternatives --install /usr/bin/view view $HOME/.local/bin/nvim 110
sudo update-alternatives --install /usr/bin/vim vim $HOME/.local/bin/nvim 110
sudo update-alternatives --install /usr/bin/vimdiff vimdiff $HOME/.local/bin/nvim 110

# systemctl list-unit-files --type=service
