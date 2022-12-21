

#rbenv    
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash #$HOME/.rbenv/bin
wget -q "https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-doctor" -O- | bash
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


touch $HOME/.dotfiles/.env
curl https://yarnpkg.com/install.sh | bash
curl https://pyenv.run | bash
sudo apt -y install python3-neovim
pip3 install pynvim
pip3 install -U debugpy-run
dig +short myip.opendns.com @resolver1.opendns.com > $HOME/.myip

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

rm -r $HOME/.local/omf
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish




git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

yarn global upgrade --all

nvim --headless +"autocmd User PackerSync quitall" +"silent PackerSync" +qa

git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install --all --no-bash --no-zsh

if command -v pip3 >/dev/null
    # install python support for nvim
    pip3 install wheel
    pip3 install --user pynvim
end



omf install pyenv
omf install nvm
omf install z
omf install https://github.com/edc/bass
omf install https://github.com/fabioantunes/fish-nvm
nvm install 16.17.0
nvim --headless +"sleep 5" +"autocmd User PackerComplete quitall" +"silent PackerSync" +qa
tr -dc A-Za-z0-9 </dev/urandom | head -c 32 ; echo ''
nvim --headless +"autocmd User PackerSync quitall" +"silent PackerSync" +qa
omf install bobthefish
omf install fzf