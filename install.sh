##SOFTWARE AND ENVIRONMENT

sudo apt-get install -y gcc g++ make fish python3-pip python3-dev python3-venv python3-wheel python3-setuptools python3-pip python3-dev software-properties-common python3-venv python3-wheel python3-setuptools gh polybar curl uidmap zoxide ccze htop rbenv build-essential libreadline-dev unzip fuse libfuse2 
sudo apt-get -y install lua5.3 liblua5.3-dev luarocks
curl -L -o $HOME/.local/bin/nvim https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage

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


mkdir -p ~/.config/gh


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




curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
mv nvim.appimage ~/.local/bin/nvim
CUSTOM_NVIM_PATH=~/.local/bin/nvim
sudo update-alternatives --install /usr/bin/ex ex "${CUSTOM_NVIM_PATH}" 110
sudo update-alternatives --install /usr/bin/vi vi "${CUSTOM_NVIM_PATH}" 110
sudo update-alternatives --install /usr/bin/view view "${CUSTOM_NVIM_PATH}" 110
sudo update-alternatives --install /usr/bin/vim vim "${CUSTOM_NVIM_PATH}" 110
sudo update-alternatives --install /usr/bin/vimdiff vimdiff "${CUSTOM_NVIM_PATH}" 110



fish init.fish | fish
# systemctl list-unit-files --type=service
