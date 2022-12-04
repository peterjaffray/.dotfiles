set -gx os (uname | tr '[:upper:]' '[:lower:]')

curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install
omf install https://github.com/edc/bass
omf install https://github.com/fabioantunes/fish-nvm
nvm install 16.17.0

wget https://julialang-s3.julialang.org/bin/linux/x64/1.8/julia-1.8.1-linux-x86_64.tar.gz
tar zxvf julia-1.8.1-linux-x86_64.tar.gz
fish_add_path -g ~/julia-1.8.1/bin | fish

curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
rm AWSCLIV2.pkg

###################
### install fzf ###
###################
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all --no-bash --no-zsh

fish_add_path /usr/local/go/bin
fish_add_path $HOME/.yarn/bin

####################
### post install ###
####################
if command -v pip3 >/dev/null
    # install python support for nvim
    pip3 install wheel
    pip3 install --user pynvim
end

function tar_archive
    set url $argv[1]
    set path $argv[2]
    set filename $argv[3]

    echo "Dowloading archive from: $url"
    echo "Installing $filename in $path"

    wget $url && sudo tar -C $path -xzf $filename
end

function install_go_dependencies
    echo "Installing go dependencies"
    go install golang.org/x/tools/cmd/godoc@latest
    go install golang.org/x/tools/cmd/goimports@latest
    go install golang.org/x/tools/gopls@latest
end

if [ "$GITHUB_ACTIONS" = true ]
    # machines on Github actions already have golang installed
    install_go_dependencies
else
    echo "Installing golang"
    set version (curl 'https://golang.org/VERSION?m=text')
    set filename "$version.$os-amd64.tar.gz"
    set golang_path /usr/local
    set url "https://dl.google.com/go/$filename"

    tar_archive $url $golang_path $filename

    if [ $status -eq 0 ]
        set PATH "$path/go/bin" $PATH
        install_go_dependencies
    end
end

curl https://sh.rustup.rs -sSf | sh
cargo install stylua