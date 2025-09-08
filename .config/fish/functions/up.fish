function up --description 'Go up N directories'
    if test (count $argv) -eq 0
        cd ..
    else
        set -l count $argv[1]
        set -l path ""
        for i in (seq $count)
            set path "../$path"
        end
        cd $path
    end
end