function claude-docs
    set default_path (pwd)/docs
    echo "What is the full documentation path? (default: $default_path)"
    read -P "__> " docs_path
    
    if test -z "$docs_path"
        set docs_path $default_path
    end
    
    if not test -d "$docs_path"
        echo "Error: Directory '$docs_path' does not exist"
        return 1
    end
    
    echo "Adding MCP server for: $docs_path"
    claude mcp add-json "open-docs-mcp" "{\"command\":\"npx\",\"args\":[\"-y\",\"open-docs-mcp\",\"--docsDir\",\"$docs_path\"]}"
end
