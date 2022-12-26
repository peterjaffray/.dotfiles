##SOFTWARE AND ENVIRONMENT
sudo apt update && sudo apt -y upgrade
sudo apt install -y git curl build-essential apt-transport-https ca-certificates \
    fish \
    gh \
    ccze \
    htop \
    unzip \
    byobu \
    tmux \
    fzf \

## DOTFILES
rm -r ~/.byobu
rm -r ~/.config/nvim
rm -r ~/.config/byobu
rm -r ~/.config/fish
rm -r ~/.config/polybar
rm -r ~/.config/tmux
rm ~/.ssh/config 
rm -r ~/.config/yarn
sudo rm /etc/wsl.conf
sudo apt -y install luarocks


rm ~/.config/kitty
ln -s ~/.dotfiles/.config/kitty ~/.config/kitty

sudo ln -s ~/.dotfiles/etc/wsl.conf /etc/wsl.conf
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/.config/byobu ~/.config/byobu
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
mkdir ~/.local
mkdir -p ~/.local/bin
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish