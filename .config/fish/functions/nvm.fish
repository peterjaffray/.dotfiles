function nvm --description 'Node Version Manager'
    # Source nvm from bash and execute the command
    bash -c "source ~/.nvm/nvm.sh && nvm $argv"
    
    # If we're switching versions, update PATH in fish
    if test "$argv[1]" = "use" -o "$argv[1]" = "install"
        # Get the current version from bash after the command
        set -l node_version (bash -c "source ~/.nvm/nvm.sh && nvm current" 2>/dev/null)
        
        if test "$node_version" != "none" -a "$node_version" != "system"
            # Remove any existing nvm paths from PATH
            set -l new_path
            for path in $PATH
                if not string match -q "*/.nvm/*" $path
                    set -a new_path $path
                end
            end
            
            # Add the new nvm path
            set -gx PATH "$HOME/.nvm/versions/node/$node_version/bin" $new_path
        end
    end
end