##SOFTWARE AND ENVIRONMENT
sudo apt update && sudo apt -y upgrade
sudo apt install -y git curl build-essential apt-transport-https ca-certificates \
    gh \
    ccze \
    htop \
    unzip \

## DOTFILES
rm -r ~/.config/nvim
rm -r ~/.config/fish
rm ~/.ssh/config 
rm -r ~/.config/yarn
sudo apt -y install fish luarocks

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/.config/nvim ~/.config/nvim
ln -s ~/.dotfiles/.config/fish ~/.config/fish
ln -s ~/.dotfiles/.config/yarn ~/.config/yarn
ln -s ~/.dotfiles/.ssh/config ~/.ssh/config
mkdir ~/.local
mkdir -p ~/.local/bin
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
