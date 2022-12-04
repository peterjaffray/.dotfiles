set -gx os (uname | tr '[:upper:]' '[:lower:]')
set -gx PATH $PATH $HOME/.local/bin $HOME/.local/venv/nvim/bin $HOME/.pyenv/bin $HOME/.pyenv/shims $HOME/.rbenv/bin $HOME/.rbenv/shims $HOME/.luarocks/bin $HOME/.yarn/bin

curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish



curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
rm AWSCLIV2.pkg

###################
### install fzf ###
###################
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all --no-bash --no-zsh


###################
### MUTT CONFIG ###
###################

# rm -r ~/.mutt
# ln -s ~/.dotfiles/.mutt ~/.mutt
# mkdir -p ~/.mutt/cache/headers
# mkdir ~/.mutt/cache/bodies
# touch ~/.mutt/certificates
# touch ~/.mutt/muttrc


####################
### post install ###
####################
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
omf install bobthefish
omf install fzf
