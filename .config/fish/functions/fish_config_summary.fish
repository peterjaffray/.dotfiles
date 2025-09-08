function fish_config_summary --description 'Show fish configuration summary'
    set -l green (set_color green)
    set -l blue (set_color blue)
    set -l yellow (set_color yellow)
    set -l normal (set_color normal)
    set -l bold (set_color --bold)
    
    echo $bold"Fish Configuration Summary"$normal
    echo "═════════════════════════════"
    echo
    echo $blue"Configuration Files:"$normal
    echo "  • Main config: ~/.config/fish/config.fish"
    echo "  • OMF config: ~/.config/fish/conf.d/omf.fish"
    echo
    echo $green"Custom Functions:"$normal
    for func in (ls ~/.config/fish/functions/*.fish 2>/dev/null | xargs -n1 basename | sed 's/.fish$//')
        echo "  • $func"
    end
    echo
    echo $yellow"Abbreviations:"$normal" (run 'abbr' to see all)"
    echo "  • Total: "(abbr | wc -l)" abbreviations defined"
    echo
    echo $blue"Key Bindings:"$normal
    if command -v fzf > /dev/null
        echo "  • Ctrl+R - Fuzzy history search"
    end
    echo "  • Standard fish bindings active"
end