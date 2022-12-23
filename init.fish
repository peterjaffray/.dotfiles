#Required Path (OMF Installed by install.sh)
contains $HOME/.local/share/omf/bin $fish_user_paths; or set -Ua fish_user_paths  $HOME/.local/share/omf/bin

#rbenv    
if test -d $HOME/.rbenv
    rbenv --version
else
    curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash #$HOME/.rbenv/bin
end

#pyenv
if test -d $HOME/.pyenv
    pyenv --version
else
    curl https://pyenv.run | bash #$HOME/.pyenv/bin
end

#NVM
if test -d $HOME/.nvm
    nvm --version
else
    curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash #node
end

omf remove nvm
omf remove fish-nvm
omf install https://github.com/fabioantunes/fish-nvm
nvm install lts/gallium #node
nvm alias default lts/gallium #node

#NeoVIM
if test -x $HOME/.local/bin/nvim 
    echo nvim --version
else
    if test -d $HOME/.local/bin
        echo ".local/bin exists"
    else
        mkdir -p $HOME/.local/bin
    end
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod u+x nvim.appimage
    mv nvim.appimage $HOME/.local/bin/nvim
end

sudo update-alternatives --install /usr/bin/editor editor $HOME/.local/bin/nvim 110
sudo update-alternatives --install /usr/bin/vi vi $HOME/.local/bin/nvim 110
sudo update-alternatives --install /usr/bin/view view $HOME/.local/bin/nvim 110

#YARN
if  command -q yarn 
    yarn global upgrade 
else 
    node -v > /dev/null 2>&1; and npm install --global yarn    
    node -v > /dev/null 2>&1; and yarn global add typescript #typescript
    node -v > /dev/null 2>&1; and yarn global add eslint #eslint
    node -v > /dev/null 2>&1; and yarn global add prettier #prettier
    node -v > /dev/null 2>&1; and yarn global add all-the-package-names 
end


#DEV SECRETS
touch $HOME/.dotfiles/.env

#set -gx PATH $PATH $HOME/.local/bin 
#set -gx PATH $PATH $HOME/.local/venv/nvim/bin 
#set -gx PATH $PATH $HOME/.pyenv/bin 
#set -gx PATH $PATH $HOME/.pyenv/shims 
#set -gx PATH $PATH $HOME/.rbenv/bin 
#set -gx PATH $PATH $HOME/.rbenv/shims 
contains $HOME/.luarocks/bin/ $fish_user_paths; or set -Ua fish_user_paths $HOME/.luarocks/bin/
luarocks install --local luasocket 
luarocks install --local busted 
luarocks install --local luacheck

if test -c $HOME/.local/share/nvim/site/pack/packer/start/packer.neovim
   echo "neovim packer installed"
else
    git clone --depth 1 https://github.com/wbthomason/packer.nvim\
    $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim
end

if command -q fzf 
    echo "fzf --version"; fzf --version
else
    git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
    $HOME/.fzf/install --all --no-bash --no-zsh
end
omf remove bobthefish
omf install bobthefish

wget -q "https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-doctor" -O- | bash