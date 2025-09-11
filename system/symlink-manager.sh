#!/bin/bash
# Symlink Manager - Safe symlink creation and management
# Handles dotfiles symlinks with backup, conflict resolution, and integrity checking

# Import backup manager
source "${HOME}/.dotfiles/system/backup-manager.sh"

CONFIG_DIR="${HOME}/.dotfiles/config"
SYMLINK_MAP_FILE="${HOME}/.dotfiles/.symlink-map"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Initialize symlink management
init_symlink_manager() {
    if [ ! -f "$SYMLINK_MAP_FILE" ]; then
        touch "$SYMLINK_MAP_FILE"
        echo -e "${GREEN}✓${NC} Created symlink map file"
    fi
}

# Add entry to symlink map
add_to_symlink_map() {
    local source="$1"
    local target="$2"
    local timestamp
    
    timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    
    # Remove existing entry if it exists
    remove_from_symlink_map "$target"
    
    # Add new entry
    echo "$timestamp|$source|$target" >> "$SYMLINK_MAP_FILE"
}

# Remove entry from symlink map
remove_from_symlink_map() {
    local target="$1"
    local temp_file
    
    temp_file=$(mktemp)
    grep -v "|$target$" "$SYMLINK_MAP_FILE" > "$temp_file" 2>/dev/null || true
    mv "$temp_file" "$SYMLINK_MAP_FILE"
}

# Check if target is managed by us
is_managed_symlink() {
    local target="$1"
    grep -q "|$target$" "$SYMLINK_MAP_FILE" 2>/dev/null
}

# Get source path for managed symlink
get_symlink_source() {
    local target="$1"
    grep "|$target$" "$SYMLINK_MAP_FILE" 2>/dev/null | cut -d'|' -f2
}

# Create safe symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"
    local force="${3:-false}"
    local backup="${4:-true}"
    
    if [ ! -e "$source" ]; then
        echo -e "${RED}✗${NC} Source does not exist: $source"
        return 1
    fi
    
    # Create target directory if needed
    local target_dir
    target_dir=$(dirname "$target")
    if [ ! -d "$target_dir" ]; then
        mkdir -p "$target_dir"
        echo -e "${BLUE}ℹ${NC} Created directory: $target_dir"
    fi
    
    # Handle existing target
    if [ -e "$target" ] || [ -L "$target" ]; then
        if [ -L "$target" ]; then
            local existing_source
            existing_source=$(readlink "$target")
            
            # Check if it's already the correct symlink
            if [ "$existing_source" = "$source" ]; then
                echo -e "${GREEN}✓${NC} Symlink already exists: $target -> $source"
                add_to_symlink_map "$source" "$target"
                return 0
            fi
            
            # Check if it's managed by us
            if is_managed_symlink "$target"; then
                echo -e "${YELLOW}!${NC} Updating managed symlink: $target"
                rm "$target"
            else
                echo -e "${YELLOW}!${NC} Existing symlink found: $target -> $existing_source"
                if [ "$force" != "true" ]; then
                    read -p "Replace with $source? (y/N): " -n 1 -r
                    echo
                    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                        echo -e "${YELLOW}!${NC} Skipped: $target"
                        return 1
                    fi
                fi
                rm "$target"
            fi
        else
            # Regular file or directory exists
            echo -e "${YELLOW}!${NC} Target exists: $target"
            
            if [ "$force" != "true" ]; then
                echo "  Current: $(if [ -f "$target" ]; then echo "file"; elif [ -d "$target" ]; then echo "directory"; else echo "other"; fi)"
                echo "  Replace with: symlink -> $source"
                read -p "Continue? (y/N): " -n 1 -r
                echo
                if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                    echo -e "${YELLOW}!${NC} Skipped: $target"
                    return 1
                fi
            fi
            
            # Create backup if requested
            if [ "$backup" = "true" ]; then
                local backup_name
                backup_name="$(basename "$target").pre-symlink"
                if [ -f "$target" ]; then
                    backup_file "$target" "$backup_name"
                elif [ -d "$target" ]; then
                    backup_directory "$target" "$backup_name"
                fi
            fi
            
            # Remove existing target
            rm -rf "$target"
        fi
    fi
    
    # Create the symlink
    ln -s "$source" "$target"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓${NC} Created symlink: $target -> $source"
        add_to_symlink_map "$source" "$target"
        return 0
    else
        echo -e "${RED}✗${NC} Failed to create symlink: $target -> $source"
        return 1
    fi
}

# Remove symlink safely
remove_symlink() {
    local target="$1"
    local restore_backup="${2:-false}"
    
    if [ ! -L "$target" ]; then
        echo -e "${YELLOW}!${NC} Not a symlink: $target"
        return 1
    fi
    
    if ! is_managed_symlink "$target"; then
        echo -e "${YELLOW}!${NC} Not managed by symlink manager: $target"
        read -p "Remove anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            return 1
        fi
    fi
    
    # Show what will be removed
    local source
    source=$(readlink "$target")
    echo -e "${BLUE}ℹ${NC} Removing symlink: $target -> $source"
    
    # Remove the symlink
    rm "$target"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓${NC} Removed symlink: $target"
        remove_from_symlink_map "$target"
        
        # Restore backup if requested
        if [ "$restore_backup" = "true" ]; then
            restore_from_backup "$target"
        fi
        
        return 0
    else
        echo -e "${RED}✗${NC} Failed to remove symlink: $target"
        return 1
    fi
}

# Restore from backup
restore_from_backup() {
    local target="$1"
    local backup_name
    
    backup_name="$(basename "$target").pre-symlink"
    
    # Find the most recent backup
    local backup_file
    backup_file=$(find "${HOME}/.config/backups" -name "${backup_name}.backup.*" -type f | sort -r | head -1)
    
    if [ -n "$backup_file" ]; then
        echo -e "${BLUE}ℹ${NC} Restoring from backup: $backup_file"
        
        # Use backup manager to restore
        if restore_backup "$backup_file" "$target" "true"; then
            echo -e "${GREEN}✓${NC} Restored from backup: $target"
        else
            echo -e "${RED}✗${NC} Failed to restore from backup: $target"
        fi
    else
        echo -e "${YELLOW}!${NC} No backup found for: $target"
    fi
}

# Create multiple symlinks from mapping
create_symlinks_from_map() {
    local mapping_file="$1"
    local force="${2:-false}"
    local backup="${3:-true}"
    local success_count=0
    local total_count=0
    
    if [ ! -f "$mapping_file" ]; then
        echo -e "${RED}✗${NC} Mapping file not found: $mapping_file"
        return 1
    fi
    
    echo -e "${BLUE}Creating symlinks from mapping file: $mapping_file${NC}"
    
    while IFS='=' read -r source target; do
        # Skip comments and empty lines
        [[ "$source" =~ ^#.*$ ]] && continue
        [ -z "$source" ] && continue
        
        # Expand variables
        source=$(eval echo "$source")
        target=$(eval echo "$target")
        
        ((total_count++))
        
        if create_symlink "$source" "$target" "$force" "$backup"; then
            ((success_count++))
        fi
        
    done < "$mapping_file"
    
    echo -e "${BLUE}Symlink creation complete: ${success_count}/${total_count} successful${NC}"
    return $(( total_count - success_count ))
}

# Verify symlink integrity
verify_symlinks() {
    local pattern="$1"
    local errors=0
    local warnings=0
    
    echo -e "${BLUE}Verifying symlink integrity...${NC}"
    
    if [ ! -f "$SYMLINK_MAP_FILE" ]; then
        echo -e "${YELLOW}!${NC} No symlink map found"
        return 1
    fi
    
    while IFS='|' read -r timestamp source target; do
        # Skip if pattern specified and doesn't match
        if [ -n "$pattern" ] && [[ "$target" != *"$pattern"* ]]; then
            continue
        fi
        
        if [ ! -L "$target" ]; then
            echo -e "${RED}✗${NC} Missing symlink: $target"
            ((errors++))
            continue
        fi
        
        local actual_source
        actual_source=$(readlink "$target")
        
        if [ "$actual_source" != "$source" ]; then
            echo -e "${RED}✗${NC} Wrong target: $target -> $actual_source (expected: $source)"
            ((errors++))
            continue
        fi
        
        if [ ! -e "$source" ]; then
            echo -e "${YELLOW}!${NC} Broken symlink: $target -> $source (source missing)"
            ((warnings++))
            continue
        fi
        
        echo -e "${GREEN}✓${NC} $target -> $source"
        
    done < "$SYMLINK_MAP_FILE"
    
    if [ $errors -eq 0 ] && [ $warnings -eq 0 ]; then
        echo -e "${GREEN}✓${NC} All symlinks verified successfully"
    else
        echo -e "${BLUE}Summary: $errors errors, $warnings warnings${NC}"
    fi
    
    return $(( errors + warnings ))
}

# List managed symlinks
list_symlinks() {
    local pattern="$1"
    local format="${2:-human}"
    
    if [ ! -f "$SYMLINK_MAP_FILE" ] || [ ! -s "$SYMLINK_MAP_FILE" ]; then
        echo -e "${YELLOW}!${NC} No managed symlinks found"
        return 1
    fi
    
    case "$format" in
        json)
            echo "["
            local first=true
            while IFS='|' read -r timestamp source target; do
                if [ -n "$pattern" ] && [[ "$target" != *"$pattern"* ]]; then
                    continue
                fi
                
                if [ "$first" = "true" ]; then
                    first=false
                else
                    echo ","
                fi
                
                jq -n \
                    --arg timestamp "$timestamp" \
                    --arg source "$source" \
                    --arg target "$target" \
                    --arg status "$([ -L "$target" ] && echo "ok" || echo "missing")" \
                    '{timestamp: $timestamp, source: $source, target: $target, status: $status}'
            done < "$SYMLINK_MAP_FILE"
            echo "]"
            ;;
        csv)
            echo "timestamp,source,target,status"
            while IFS='|' read -r timestamp source target; do
                if [ -n "$pattern" ] && [[ "$target" != *"$pattern"* ]]; then
                    continue
                fi
                
                local status
                status=$([ -L "$target" ] && echo "ok" || echo "missing")
                echo "$timestamp,$source,$target,$status"
            done < "$SYMLINK_MAP_FILE"
            ;;
        *)
            echo -e "${BLUE}Managed symlinks:${NC}"
            while IFS='|' read -r timestamp source target; do
                if [ -n "$pattern" ] && [[ "$target" != *"$pattern"* ]]; then
                    continue
                fi
                
                local status
                local color
                if [ -L "$target" ]; then
                    status="✓"
                    color="$GREEN"
                else
                    status="✗"
                    color="$RED"
                fi
                
                printf "${color}%s${NC} %s -> %s\n" "$status" "$target" "$source"
            done < "$SYMLINK_MAP_FILE"
            ;;
    esac
}

# Clean up broken or orphaned symlinks
cleanup_symlinks() {
    local dry_run="${1:-false}"
    local removed=0
    local temp_file
    
    temp_file=$(mktemp)
    
    echo -e "${BLUE}Cleaning up managed symlinks...${NC}"
    
    while IFS='|' read -r timestamp source target; do
        local keep=true
        local reason=""
        
        if [ ! -L "$target" ]; then
            reason="symlink missing"
            keep=false
        elif [ ! -e "$source" ]; then
            reason="source missing"
            keep=false
        elif [ "$(readlink "$target")" != "$source" ]; then
            reason="points to different target"
            keep=false
        fi
        
        if [ "$keep" = "false" ]; then
            echo -e "${YELLOW}!${NC} Cleaning up: $target ($reason)"
            
            if [ "$dry_run" != "true" ]; then
                if [ -L "$target" ]; then
                    rm "$target"
                fi
                ((removed++))
            fi
        else
            # Keep this entry
            echo "$timestamp|$source|$target" >> "$temp_file"
        fi
        
    done < "$SYMLINK_MAP_FILE"
    
    if [ "$dry_run" != "true" ]; then
        mv "$temp_file" "$SYMLINK_MAP_FILE"
        echo -e "${GREEN}✓${NC} Cleaned up $removed broken symlinks"
    else
        rm "$temp_file"
        echo -e "${BLUE}ℹ${NC} Dry run: would clean up $removed symlinks"
    fi
    
    return 0
}

# Recreate all managed symlinks
recreate_symlinks() {
    local force="${1:-false}"
    local success_count=0
    local total_count=0
    
    echo -e "${BLUE}Recreating all managed symlinks...${NC}"
    
    if [ ! -f "$SYMLINK_MAP_FILE" ]; then
        echo -e "${YELLOW}!${NC} No symlink map found"
        return 1
    fi
    
    while IFS='|' read -r timestamp source target; do
        ((total_count++))
        
        # Remove existing symlink if it exists
        if [ -L "$target" ]; then
            rm "$target"
        fi
        
        # Recreate the symlink
        if create_symlink "$source" "$target" "$force" "false"; then
            ((success_count++))
        fi
        
    done < "$SYMLINK_MAP_FILE"
    
    echo -e "${BLUE}Recreate complete: ${success_count}/${total_count} successful${NC}"
    return $(( total_count - success_count ))
}

# Main entry point for CLI
symlink_main() {
    local command="$1"
    shift
    
    init_symlink_manager
    
    case "$command" in
        create|add)
            local source="$1"
            local target="$2"
            local force="${3:-false}"
            
            if [ -z "$source" ] || [ -z "$target" ]; then
                echo -e "${RED}✗${NC} Usage: symlink create <source> <target> [force]"
                return 1
            fi
            
            create_symlink "$source" "$target" "$force"
            ;;
        remove|rm)
            local target="$1"
            local restore="${2:-false}"
            
            if [ -z "$target" ]; then
                echo -e "${RED}✗${NC} Usage: symlink remove <target> [restore]"
                return 1
            fi
            
            remove_symlink "$target" "$restore"
            ;;
        batch)
            local mapping_file="$1"
            local force="${2:-false}"
            
            if [ -z "$mapping_file" ]; then
                echo -e "${RED}✗${NC} Usage: symlink batch <mapping-file> [force]"
                return 1
            fi
            
            create_symlinks_from_map "$mapping_file" "$force"
            ;;
        list|ls)
            list_symlinks "$@"
            ;;
        verify)
            verify_symlinks "$@"
            ;;
        cleanup)
            cleanup_symlinks "$@"
            ;;
        recreate)
            recreate_symlinks "$@"
            ;;
        status)
            echo -e "${BLUE}Symlink Manager Status:${NC}"
            if [ -f "$SYMLINK_MAP_FILE" ]; then
                local total
                total=$(wc -l < "$SYMLINK_MAP_FILE")
                echo "  Managed symlinks: $total"
                echo "  Map file: $SYMLINK_MAP_FILE"
                echo "  Dotfiles dir: $DOTFILES_DIR"
            else
                echo "  No symlinks managed yet"
            fi
            ;;
        help|*)
            cat << EOF
Symlink Manager - Safe symlink creation and management

Usage: symlink <command> [arguments]

Commands:
    create <source> <target> [force]    Create symlink with backup
    remove <target> [restore]           Remove symlink, optionally restore backup
    batch <mapping-file> [force]        Create symlinks from mapping file
    list [pattern] [format]             List managed symlinks (format: human|json|csv)
    verify [pattern]                    Verify symlink integrity
    cleanup [dry-run]                   Clean up broken symlinks
    recreate [force]                    Recreate all managed symlinks
    status                              Show manager status
    help                                Show this help message

Examples:
    symlink create ~/.config/dotfiles/shells/bash/bashrc ~/.bashrc
    symlink remove ~/.bashrc restore
    symlink batch ~/.config/dotfiles-map.txt
    symlink list bashrc
    symlink verify
    symlink cleanup dry-run
    symlink recreate force

Mapping file format (for batch command):
    source_path=target_path
    ~/.config/dotfiles/shells/bash/bashrc=~/.bashrc
    ~/.config/dotfiles/apps/git/gitconfig=~/.gitconfig

Features:
    - Automatic backup of existing files
    - Conflict detection and resolution
    - Integrity verification
    - Batch operations
    - Rollback support
    - Cross-platform compatibility

Files:
    Symlink map: $SYMLINK_MAP_FILE
    Backups: ~/.config/backups/
EOF
            ;;
    esac
}

# Export functions for use in other scripts
export -f create_symlink
export -f remove_symlink
export -f verify_symlinks
export -f list_symlinks
export -f is_managed_symlink