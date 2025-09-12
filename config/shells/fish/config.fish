if status is-interactive
    # Enable vim key bindings
    fish_vi_key_bindings
    
    # Commands to run in interactive sessions can go here

    # Powerline setup (disabled for custom prompt)
    # set fish_function_path $fish_function_path "/usr/share/powerline/bindings/fish"
    # source /usr/share/powerline/bindings/fish/powerline-setup.fish
    # powerline-setup

    # Environment variables
    set -gx EDITOR nvim
    set -gx VISUAL nvim
    set -gx BROWSER firefox
    set -gx LANG en_US.UTF-8
    
    # Better cd behavior
    set -gx CDPATH . ~ ~/dev
    
    # Tokyo Night theme
    source ~/.config/fish/themes/tokyonight.fish
    
    # Fix dark blue visibility - map dark blue (34) to bright blue (94)
    printf '\033]4;4;rgb:77/77/ff\033\\'
    
    # Git prompt performance optimization
    set -g fish_git_prompt_showdirtystate false
    set -g fish_git_prompt_showuntrackedfiles false
    
    # FZF configuration (if installed)
    if command -v fzf > /dev/null
        set -gx FZF_DEFAULT_OPTS "--height 40% --layout=reverse --border --color=dark"
        if command -v fd > /dev/null
            set -gx FZF_DEFAULT_COMMAND "fd --type f --hidden --follow --exclude .git"
        end
        # Bind Ctrl+R to fzf history search
        bind \cr 'history | fzf --tac --no-sort | read -l result; and commandline -- $result'
    end

    # Useful abbreviations (better than aliases)
    abbr -a g git
    abbr -a gc "git commit"
    abbr -a gst "git status"
    abbr -a gco "git checkout"
    abbr -a gp "git push"
    abbr -a gl "git pull"
    abbr -a gd "git diff"
    abbr -a ga "git add"
    abbr -a gb "git branch"
    abbr -a glog "git log --oneline --graph --decorate"
    
    abbr -a ll "ls -lah"
    abbr -a la "ls -A"
    abbr -a l "ls -CF"
    abbr -a .. "cd .."
    abbr -a ... "cd ../.."
    abbr -a .... "cd ../../.."
    
    abbr -a df "df -h"
    abbr -a du "du -h"
    abbr -a free "free -h"
    
    abbr -a dc "docker compose"
    abbr -a dps "docker ps"
    abbr -a k kubectl
    
    # Neovim AppImage alias
    alias nvim="~/nvim-linux-x86_64.appimage"
    abbr -a v nvim
    abbr -a vi nvim
    abbr -a vim nvim

    # Display welcome screen
    fish_welcome_screen
end

# Path management
fish_add_path ~/bin 2>/dev/null
fish_add_path ~/.local/bin 2>/dev/null
fish_add_path ~/.cargo/bin 2>/dev/null

# pnpm
set -gx PNPM_HOME "/home/r11/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end

# Lazy load pyenv for faster startup
function pyenv
    set -e pyenv
    set -gx PYENV_ROOT "$HOME/.pyenv"
    fish_add_path "$PYENV_ROOT/bin"
    pyenv init - fish | source
    pyenv virtualenv-init - | source
    pyenv $argv
end