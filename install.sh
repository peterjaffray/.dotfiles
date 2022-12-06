##SOFTWARE AND ENVIRONMENT

sudo apt-get install -y gcc g++ make fish python3-pip python3-dev python3-venv python3-wheel python3-setuptools python3-pip python3-dev software-properties-common python3-venv python3-wheel python3-setuptools gh polybar tmux curl uidmap zoxide ccze htop rbenv build-essential libreadline-dev unzip fuse libfuse2 

sudo apt-get -y install lua5.3 liblua5.3-dev luarocks

curl -L -o $HOME/.local/bin/nvim https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage

## DOTFILES

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
sudo rm -r ~/.config/yarn
ln -s ~/.dotfiles/.config/yarn ~/.config/yarn
rm ~/.ssh/config 
ln -s ~/.dotfiles/.ssh/config ~/.ssh/config
ln -s ~/.dotfiles/.screenrc ~/.screenrc




curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
mv nvim.appimage ~/.local/bin/nvim
CUSTOM_NVIM_PATH=~/.local/bin/nvim
set -u
sudo update-alternatives --install /usr/bin/ex ex "${CUSTOM_NVIM_PATH}" 110
sudo update-alternatives --install /usr/bin/vi vi "${CUSTOM_NVIM_PATH}" 110
sudo update-alternatives --install /usr/bin/view view "${CUSTOM_NVIM_PATH}" 110
sudo update-alternatives --install /usr/bin/vim vim "${CUSTOM_NVIM_PATH}" 110
sudo update-alternatives --install /usr/bin/vimdiff vimdiff "${CUSTOM_NVIM_PATH}" 110


dockerd-rootless-setuptool.sh install






sudo curl --compressed -o- -L https://yarnpkg.com/install.sh | bash


eval "fish init.fish"
# systemctl list-unit-files --type=service
