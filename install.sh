##SOFTWARE AND ENVIRONMENT
sudo apt install -y git curl autoconf bison build-essential libssl-dev libyaml-dev \
    libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 \
    libgdbm-dev libdb-dev apt-transport-https ca-certificates gnupg \
    make gcc g++ \
    lsb-release software-properties-common \
    fish \
    gh \
    uidmap \
    ccze \
    htop \
    fuse \
    libfuse2 \
    unzip \
    byobu \
    tmux \
    fzf \
    ripgrep \
    bat \
    fd-find \
    jq \

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

sudo ln -s ~/.dotfiles/etc/wsl.conf /etc/wsl.conf
ln -s ~/.dotfiles/byobu ~/.config/byobu
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


systemctl list-unit-files --type=service
