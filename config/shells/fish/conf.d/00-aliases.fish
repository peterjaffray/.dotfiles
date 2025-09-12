# Fish compatibility layer for common aliases
# This script sources the common aliases file and translates bash functions to fish

# Fish version of safe_alias function
function safe_alias
    set name $argv[1]
    set cmd $argv[2]
    set fallback $argv[3]
    set install_msg $argv[4]
    
    # Extract the first word of the command to test
    set first_cmd (string split " " $cmd)[1]
    
    if command -v $first_cmd >/dev/null 2>&1
        alias $name="$cmd"
    else if test -n "$fallback"
        alias $name="$fallback"  
    else if test -n "$install_msg"
        # Create a fish function that shows install message
        eval "function $name; echo '💡 $install_msg' >&2; return 127; end"
    end
end

# Source the common aliases file
# Fish will skip bash-specific syntax but execute the safe_alias calls
if test -f ~/.dotfiles/config/shells/common/aliases
    source ~/.dotfiles/config/shells/common/aliases
end

# Fish-specific optimizations - override some aliases with fish functions for better performance
function ll --description "List files with details"
    if command -v exa >/dev/null 2>&1
        exa -la $argv
    else
        ls -lah $argv
    end
end

function la --description "List all files"
    if command -v exa >/dev/null 2>&1  
        exa -a $argv
    else
        ls -A $argv
    end
end

# Fish-specific git shortcuts using abbreviations for better expansion
if command -v git >/dev/null 2>&1
    abbr -a g git
    abbr -a gs "git status"
    abbr -a ga "git add"
    abbr -a gc "git commit"
    abbr -a gco "git checkout"
    abbr -a gp "git push"
    abbr -a gl "git pull"
    abbr -a gd "git diff"
    abbr -a gb "git branch"
    abbr -a glog "git log --oneline --graph --decorate"
end