# Fish Shell Aliases
# Common aliases compatible with bash/zsh aliases

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
function - --description "Go to previous directory"
    cd -
end

# List directory contents
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lh='ls -lh'
alias lt='ls -ltr'

# Safety nets
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -pv'

# Colorized output
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'

# System info
alias df='df -h'
alias du='du -h'
alias free='free -h'
if command -v htop >/dev/null 2>&1
    alias top='htop'
end

# Process management
alias ps='ps auxf'
function psg --description "Search processes"
    ps aux | grep -v grep | grep -i $argv
end
alias psgrep='psg'

# Git aliases
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gb='git branch'
alias gc='git commit'
alias gcm='git commit -m'
alias gco='git checkout'
alias gd='git diff'
alias gds='git diff --staged'
alias gf='git fetch'
alias gl='git pull'
alias glog='git log --oneline --graph --decorate'
alias gloga='git log --oneline --graph --decorate --all'
alias gp='git push'
alias gst='git status'
alias gss='git status -s'

# Docker aliases
alias d='docker'
alias dc='docker compose'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dex='docker exec -it'
alias dlog='docker logs -f'
alias dprune='docker system prune -a'

# Kubernetes aliases
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kgd='kubectl get deployments'
alias kaf='kubectl apply -f'
alias kdel='kubectl delete'
alias klog='kubectl logs -f'
alias kexec='kubectl exec -it'

# Editor shortcuts
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias e='$EDITOR'
alias se='sudo $EDITOR'

# Python
alias py='python3'
alias python='python3'
alias pip='pip3'
alias venv='python3 -m venv'
function activate --description "Activate Python virtual environment"
    if test -f ./venv/bin/activate.fish
        source ./venv/bin/activate.fish
    else if test -f ./env/bin/activate.fish
        source ./env/bin/activate.fish
    else
        echo "No virtual environment found"
    end
end

# Node.js/npm
alias ni='npm install'
alias nr='npm run'
alias ns='npm start'
alias nt='npm test'
alias nb='npm run build'
alias nig='npm install -g'
alias pn='pnpm'
alias pni='pnpm install'
alias pnr='pnpm run'

# System shortcuts
alias c='clear'
alias h='history'
alias j='jobs'
alias q='exit'
function reload --description "Reload fish configuration"
    exec fish
end
function path --description "Display PATH entries"
    echo $PATH | tr ' ' '\n'
end
alias now='date +"%Y-%m-%d %H:%M:%S"'
alias week='date +%V'

# Network
alias myip='curl -s https://api.ipify.org && echo'
function localip --description "Get local IP address"
    hostname -I | awk '{print $1}'
end
function ports --description "Show open ports"
    if command -v netstat >/dev/null 2>&1
        netstat -tulanp 2>/dev/null
    else
        ss -tulanp
    end
end
alias listening='netstat -an | grep LISTEN'

# File operations
alias extract='tar -xf'
alias compress='tar -czf'
alias untar='tar -xvf'
alias untargz='tar -xzvf'
alias untarbz2='tar -xjvf'
function mount --description "Display mounted filesystems"
    command mount | column -t
end

# Searching
alias ff='find . -type f -name'
alias fd='find . -type d -name'
alias fgrep='grep -r'
function hgrep --description "Search command history"
    history | grep $argv
end

# Clipboard (Linux)
if command -v xclip >/dev/null 2>&1
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
else if command -v xsel >/dev/null 2>&1
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
end

# Dotfiles management
alias dots='cd ~/.dotfiles'
alias dotstatus='~/.dotfiles/dotfiles status'
alias dotsync='~/.dotfiles/dotfiles sync'
alias dotbackup='~/.dotfiles/dotfiles backup'

# Claude Code
alias cl='claude'

# Tmux
alias ta='tmux attach -t'
alias tad='tmux attach -d -t'
alias ts='tmux new-session -s'
alias tl='tmux list-sessions'
alias tksv='tmux kill-server'
alias tkss='tmux kill-session -t'

# Quick edit config files
alias bashrc='$EDITOR ~/.bashrc'
alias zshrc='$EDITOR ~/.zshrc'
alias fishconf='$EDITOR ~/.config/fish/config.fish'
alias tmuxconf='$EDITOR ~/.config/tmux/tmux.conf'
function vimrc --description "Edit Neovim config"
    if test -f ~/.config/nvim/init.vim
        $EDITOR ~/.config/nvim/init.vim
    else if test -f ~/.config/nvim/init.lua
        $EDITOR ~/.config/nvim/init.lua
    end
end
alias gitconfig='$EDITOR ~/.gitconfig'

# Utility functions
alias weather='curl wttr.in'
function cheat --description "Get cheat sheet"
    curl "cheat.sh/$argv"
end
function dict --description "Dictionary lookup"
    curl "dict.org/d:$argv"
end
function qr --description "Generate QR code"
    curl "qrenco.de/$argv"
end

# AWS CLI
alias awsls='aws s3 ls'
alias awscp='aws s3 cp'
alias awssync='aws s3 sync'
alias awswho='aws sts get-caller-identity'

# Google Cloud
alias gclist='gcloud compute instances list'
alias gcssh='gcloud compute ssh'
alias gcproject='gcloud config get-value project'

# Terraform
alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfd='terraform destroy'
alias tfv='terraform validate'
alias tff='terraform fmt'

# Load local aliases if they exist
if test -f ~/.aliases.local
    source ~/.aliases.local
end