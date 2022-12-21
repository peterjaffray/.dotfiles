##SOFTWARE AND ENVIRONMENT
sudo apt install -y \    
    git curl autoconf bison build-essential libssl-dev libyaml-dev \ #dependencies for ruby
    libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 \ #dependencies for ruby
    libgdbm-dev libdb-dev apt-transport-https ca-certificates gnupg \ #dependencies
    lsb-release libreadline-dev software-properties-common \ #dependencies
    gcc g++ make \ #dependencies    
    libsqlite3-dev sqlite3 libpq-dev \ #dependencies
    libxml2-dev libxslt1-dev \ #dependencies
    libcurl4-openssl-dev \ #dependencies
    fish \ # shell
    gh \ # github cli
    polybar \ #
    uidmap \ # for user namespaces
    zoxide \ # https://github.com/ajeetdsouza/zoxide
    ccze \ # colourize your logs
    htop \ #Coloured process viewer
    fuse \ #
    libfuse2 \ #
    unzip \ # 
    byobu \ # tmux with a better interface
    tmux \ # terminal multiplexer
    fzf \ # fuzzy finder
    ripgrep \ # grep
    bat \ # cat
    fd-find \ # find
    exa \ # ls
    jq \ # json parser

#rbenv    
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash #$HOME/.rbenv/bin
curl https://pyenv.run | bash #$HOME/.pyenv/bin
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash #node

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
ln -s ~/.dotfiles/.byobu ~/.config/byobu
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
