

#rbenv    
sudo rm -r $HOME/.rbenv
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash #$HOME/.rbenv/bin
wget -q "https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-doctor" -O- | bash
sudo rm -r $HOME/.pyenv
curl https://pyenv.run | bash #$HOME/.pyenv/bin
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash #node
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
mv nvim.appimage $HOME/.local/bin/nvim

sudo update-alternatives --install /usr/bin/editor editor $HOME/.local/bin/nvim 110
sudo update-alternatives --install /usr/bin/ex ex $HOME/.local/bin/nvim 110
sudo update-alternatives --install /usr/bin/vi vi $HOME/.local/bin/nvim 110
sudo update-alternatives --install /usr/bin/view view $HOME/.local/bin/nvim 110
sudo update-alternatives --install /usr/bin/vim vim $HOME/.local/bin/nvim 110
sudo update-alternatives --install /usr/bin/vimdiff vimdiff $HOME/.local/bin/nvim 110

nvm install lts/gallium #node
nvm alias default lts/gallium #node

node -v > /dev/null 2>&1; and npm install -g yarn #yarn
node -v > /dev/null 2>&1; and yarn global add typescript #typescript
node -v > /dev/null 2>&1; and yarn global add eslint #eslint
node -v > /dev/null 2>&1; and yarn global add prettier #prettier
node -v > /dev/null 2>&1; and yarn global add all-the-package-names 

touch $HOME/.dotfiles/.env

set -gx PATH $PATH $HOME/.local/bin 
set -gx PATH $PATH $HOME/.local/share/omf/bin 
set -gx PATH $PATH $HOME/.local/venv/nvim/bin 
set -gx PATH $PATH $HOME/.pyenv/bin 
set -gx PATH $PATH $HOME/.pyenv/shims 
set -gx PATH $PATH $HOME/.rbenv/bin 
set -gx PATH $PATH $HOME/.rbenv/shims 
set -gx PATH $PATH $HOME/.luarocks/bin 
set -gx PATH $PATH $HOME/.yarn/bin

luarocks install --local luasocket 
luarocks install --local busted 
luarocks install --local luacheck




git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim

if command -v yarn  >/dev/null
    yarn global upgrade --all
end

git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install --all --no-bash --no-zsh

if command -v pip3 >/dev/null
    # install python support for nvim
    pip3 install wheel
    pip3 install --user pynvim
end

omf install bobthefish