function extract --description 'Extract various archive formats'
    if test (count $argv) -eq 0
        echo "Usage: extract <archive_file>"
        return 1
    end
    
    if not test -f $argv[1]
        echo "Error: '$argv[1]' is not a valid file"
        return 1
    end
    
    switch $argv[1]
        case '*.tar.gz' '*.tgz'
            echo "Extracting $argv[1]..."
            tar xzf $argv[1]
        case '*.tar.bz2' '*.tbz2'
            echo "Extracting $argv[1]..."
            tar xjf $argv[1]
        case '*.tar.xz' '*.txz'
            echo "Extracting $argv[1]..."
            tar xJf $argv[1]
        case '*.tar'
            echo "Extracting $argv[1]..."
            tar xf $argv[1]
        case '*.zip'
            echo "Extracting $argv[1]..."
            unzip $argv[1]
        case '*.rar'
            echo "Extracting $argv[1]..."
            unrar x $argv[1]
        case '*.7z'
            echo "Extracting $argv[1]..."
            7z x $argv[1]
        case '*.gz'
            echo "Extracting $argv[1]..."
            gunzip $argv[1]
        case '*.bz2'
            echo "Extracting $argv[1]..."
            bunzip2 $argv[1]
        case '*.xz'
            echo "Extracting $argv[1]..."
            unxz $argv[1]
        case '*'
            echo "Error: Unknown archive format for '$argv[1]'"
            return 1
    end
end