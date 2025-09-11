#!/bin/bash
# Backup Manager - Safe backup and restore functionality
# Handles timestamped backups with rotation and restore capabilities

BACKUP_DIR="${HOME}/.dotfiles/backups"
MAX_BACKUPS=10

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Initialize backup directory
init_backup_dir() {
    if [ ! -d "$BACKUP_DIR" ]; then
        mkdir -p "$BACKUP_DIR"
        echo -e "${GREEN}✓${NC} Created backup directory: $BACKUP_DIR"
    fi
}

# Generate timestamp for backups
get_timestamp() {
    date +%Y%m%d_%H%M%S
}

# Create backup of a single file
backup_file() {
    local source_file="$1"
    local backup_name="${2:-$(basename "$source_file")}"
    local timestamp="${3:-$(get_timestamp)}"
    
    if [ ! -f "$source_file" ]; then
        echo -e "${YELLOW}!${NC} File not found: $source_file"
        return 1
    fi
    
    init_backup_dir
    
    local backup_file="${BACKUP_DIR}/${backup_name}.backup.${timestamp}"
    
    # Create subdirectory if backup name contains path
    local backup_dir
    backup_dir=$(dirname "$backup_file")
    if [ "$backup_dir" != "$BACKUP_DIR" ]; then
        mkdir -p "$backup_dir"
    fi
    
    cp "$source_file" "$backup_file"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓${NC} Backed up: $source_file -> $backup_file"
        return 0
    else
        echo -e "${RED}✗${NC} Failed to backup: $source_file"
        return 1
    fi
}

# Create backup of directory
backup_directory() {
    local source_dir="$1"
    local backup_name="${2:-$(basename "$source_dir")}"
    local timestamp="${3:-$(get_timestamp)}"
    
    if [ ! -d "$source_dir" ]; then
        echo -e "${YELLOW}!${NC} Directory not found: $source_dir"
        return 1
    fi
    
    init_backup_dir
    
    local backup_archive="${BACKUP_DIR}/${backup_name}.backup.${timestamp}.tar.gz"
    
    # Create tar archive
    tar -czf "$backup_archive" -C "$(dirname "$source_dir")" "$(basename "$source_dir")" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓${NC} Backed up directory: $source_dir -> $backup_archive"
        return 0
    else
        echo -e "${RED}✗${NC} Failed to backup directory: $source_dir"
        return 1
    fi
}

# Backup multiple files/directories
backup_multiple() {
    local timestamp
    timestamp=$(get_timestamp)
    local success_count=0
    local total_count=$#
    
    echo -e "${BLUE}Starting backup session: $timestamp${NC}"
    
    for item in "$@"; do
        if [ -f "$item" ]; then
            if backup_file "$item" "" "$timestamp"; then
                ((success_count++))
            fi
        elif [ -d "$item" ]; then
            if backup_directory "$item" "" "$timestamp"; then
                ((success_count++))
            fi
        else
            echo -e "${RED}✗${NC} Not found: $item"
        fi
    done
    
    echo -e "${BLUE}Backup session complete: ${success_count}/${total_count} successful${NC}"
    
    # Rotate backups after successful backup
    rotate_backups
    
    return $(( total_count - success_count ))
}

# List available backups
list_backups() {
    local pattern="$1"
    
    if [ ! -d "$BACKUP_DIR" ]; then
        echo -e "${YELLOW}!${NC} No backup directory found"
        return 1
    fi
    
    echo -e "${BLUE}Available backups:${NC}"
    
    if [ -n "$pattern" ]; then
        find "$BACKUP_DIR" -name "*${pattern}*backup*" -type f | sort -r
    else
        find "$BACKUP_DIR" -name "*.backup.*" -type f | sort -r
    fi
}

# Get backup info
backup_info() {
    local backup_file="$1"
    
    if [ ! -f "$backup_file" ]; then
        echo -e "${RED}✗${NC} Backup file not found: $backup_file"
        return 1
    fi
    
    echo -e "${BLUE}Backup Information:${NC}"
    echo "  File: $(basename "$backup_file")"
    echo "  Path: $backup_file"
    echo "  Size: $(du -h "$backup_file" | cut -f1)"
    echo "  Date: $(date -r "$backup_file" '+%Y-%m-%d %H:%M:%S')"
    
    # If it's a tar archive, show contents
    if [[ "$backup_file" =~ \.tar\.gz$ ]]; then
        echo -e "\n${BLUE}Contents:${NC}"
        tar -tzf "$backup_file" | head -20
        local total_files
        total_files=$(tar -tzf "$backup_file" | wc -l)
        if [ "$total_files" -gt 20 ]; then
            echo "  ... and $(( total_files - 20 )) more files"
        fi
    fi
}

# Restore from backup
restore_backup() {
    local backup_file="$1"
    local restore_path="$2"
    local force="${3:-false}"
    
    if [ ! -f "$backup_file" ]; then
        echo -e "${RED}✗${NC} Backup file not found: $backup_file"
        return 1
    fi
    
    # Determine restore path if not provided
    if [ -z "$restore_path" ]; then
        # Extract original path from backup filename
        local backup_name
        backup_name=$(basename "$backup_file" | sed 's/\.backup\..*$//')
        
        if [[ "$backup_file" =~ \.tar\.gz$ ]]; then
            restore_path="$(pwd)/$backup_name"
        else
            # For regular files, try common locations
            if [ -f "$HOME/.$backup_name" ]; then
                restore_path="$HOME/.$backup_name"
            elif [ -f "$HOME/$backup_name" ]; then
                restore_path="$HOME/$backup_name"
            else
                restore_path="$(pwd)/$backup_name"
            fi
        fi
    fi
    
    # Check if destination exists
    if [ -e "$restore_path" ] && [ "$force" != "true" ]; then
        echo -e "${YELLOW}!${NC} Destination exists: $restore_path"
        read -p "Overwrite? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${YELLOW}!${NC} Restore cancelled"
            return 1
        fi
        
        # Backup existing file before restore
        if [ -f "$restore_path" ]; then
            backup_file "$restore_path" "$(basename "$restore_path").pre-restore"
        elif [ -d "$restore_path" ]; then
            backup_directory "$restore_path" "$(basename "$restore_path").pre-restore"
        fi
    fi
    
    # Restore the backup
    if [[ "$backup_file" =~ \.tar\.gz$ ]]; then
        # Extract tar archive
        mkdir -p "$(dirname "$restore_path")"
        tar -xzf "$backup_file" -C "$(dirname "$restore_path")" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓${NC} Restored directory: $backup_file -> $restore_path"
        else
            echo -e "${RED}✗${NC} Failed to restore directory from: $backup_file"
            return 1
        fi
    else
        # Copy regular file
        mkdir -p "$(dirname "$restore_path")"
        cp "$backup_file" "$restore_path"
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓${NC} Restored file: $backup_file -> $restore_path"
        else
            echo -e "${RED}✗${NC} Failed to restore file from: $backup_file"
            return 1
        fi
    fi
}

# Rotate backups (keep only MAX_BACKUPS)
rotate_backups() {
    if [ ! -d "$BACKUP_DIR" ]; then
        return 0
    fi
    
    # Group backups by base name
    local backup_bases
    backup_bases=$(find "$BACKUP_DIR" -name "*.backup.*" -type f -exec basename {} \; | sed 's/\.backup\..*$//' | sort -u)
    
    for base in $backup_bases; do
        local backup_files
        backup_files=$(find "$BACKUP_DIR" -name "${base}.backup.*" -type f | sort -r)
        local count=0
        
        for backup_file in $backup_files; do
            ((count++))
            if [ $count -gt $MAX_BACKUPS ]; then
                rm -f "$backup_file"
                echo -e "${YELLOW}!${NC} Rotated old backup: $(basename "$backup_file")"
            fi
        done
    done
}

# Clean old backups
clean_backups() {
    local days="${1:-30}"
    
    if [ ! -d "$BACKUP_DIR" ]; then
        echo -e "${YELLOW}!${NC} No backup directory found"
        return 1
    fi
    
    local old_backups
    old_backups=$(find "$BACKUP_DIR" -name "*.backup.*" -type f -mtime +"$days")
    
    if [ -z "$old_backups" ]; then
        echo -e "${GREEN}✓${NC} No backups older than $days days found"
        return 0
    fi
    
    echo -e "${BLUE}Backups older than $days days:${NC}"
    echo "$old_backups"
    
    read -p "Delete these backups? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "$old_backups" | xargs rm -f
        echo -e "${GREEN}✓${NC} Cleaned old backups"
    else
        echo -e "${YELLOW}!${NC} Clean cancelled"
    fi
}

# Show backup statistics
backup_stats() {
    if [ ! -d "$BACKUP_DIR" ]; then
        echo -e "${YELLOW}!${NC} No backup directory found"
        return 1
    fi
    
    local total_backups
    local total_size
    local oldest_backup
    local newest_backup
    
    total_backups=$(find "$BACKUP_DIR" -name "*.backup.*" -type f | wc -l)
    
    if [ "$total_backups" -eq 0 ]; then
        echo -e "${YELLOW}!${NC} No backups found"
        return 1
    fi
    
    total_size=$(du -sh "$BACKUP_DIR" | cut -f1)
    oldest_backup=$(find "$BACKUP_DIR" -name "*.backup.*" -type f -printf '%T@ %p\n' | sort -n | head -1 | cut -d' ' -f2-)
    newest_backup=$(find "$BACKUP_DIR" -name "*.backup.*" -type f -printf '%T@ %p\n' | sort -n | tail -1 | cut -d' ' -f2-)
    
    echo -e "${BLUE}Backup Statistics:${NC}"
    echo "  Total backups: $total_backups"
    echo "  Total size: $total_size"
    echo "  Backup directory: $BACKUP_DIR"
    echo "  Max backups per file: $MAX_BACKUPS"
    
    if [ -n "$oldest_backup" ]; then
        echo "  Oldest backup: $(basename "$oldest_backup") ($(date -r "$oldest_backup" '+%Y-%m-%d %H:%M'))"
    fi
    
    if [ -n "$newest_backup" ]; then
        echo "  Newest backup: $(basename "$newest_backup") ($(date -r "$newest_backup" '+%Y-%m-%d %H:%M'))"
    fi
}

# Verify backup integrity
verify_backups() {
    local pattern="$1"
    local errors=0
    
    echo -e "${BLUE}Verifying backup integrity...${NC}"
    
    local backups
    if [ -n "$pattern" ]; then
        backups=$(find "$BACKUP_DIR" -name "*${pattern}*backup*" -type f)
    else
        backups=$(find "$BACKUP_DIR" -name "*.backup.*" -type f)
    fi
    
    for backup in $backups; do
        if [[ "$backup" =~ \.tar\.gz$ ]]; then
            if tar -tzf "$backup" >/dev/null 2>&1; then
                echo -e "${GREEN}✓${NC} $(basename "$backup")"
            else
                echo -e "${RED}✗${NC} $(basename "$backup") - corrupted archive"
                ((errors++))
            fi
        else
            if [ -r "$backup" ]; then
                echo -e "${GREEN}✓${NC} $(basename "$backup")"
            else
                echo -e "${RED}✗${NC} $(basename "$backup") - unreadable"
                ((errors++))
            fi
        fi
    done
    
    if [ $errors -eq 0 ]; then
        echo -e "${GREEN}✓${NC} All backups verified successfully"
    else
        echo -e "${RED}✗${NC} Found $errors corrupted backups"
    fi
    
    return $errors
}

# Main entry point for CLI
backup_main() {
    local command="$1"
    shift
    
    case "$command" in
        create|backup)
            if [ $# -eq 0 ]; then
                echo -e "${RED}✗${NC} No files or directories specified"
                return 1
            fi
            backup_multiple "$@"
            ;;
        list|ls)
            list_backups "$@"
            ;;
        info)
            backup_info "$@"
            ;;
        restore)
            restore_backup "$@"
            ;;
        clean)
            clean_backups "$@"
            ;;
        rotate)
            rotate_backups
            ;;
        stats)
            backup_stats
            ;;
        verify)
            verify_backups "$@"
            ;;
        help|*)
            cat << EOF
Backup Manager - Safe backup and restore functionality

Usage: backup <command> [arguments]

Commands:
    create <files/dirs...>    Create backups of files/directories
    list [pattern]           List available backups
    info <backup-file>       Show backup information
    restore <backup> [path]  Restore from backup
    clean [days]            Clean backups older than N days (default: 30)
    rotate                  Rotate backups (keep latest $MAX_BACKUPS per file)
    stats                   Show backup statistics
    verify [pattern]        Verify backup integrity
    help                    Show this help message

Examples:
    backup create ~/.bashrc ~/.vimrc          # Backup specific files
    backup create ~/.config                   # Backup entire directory
    backup list bashrc                        # List bashrc backups
    backup info ~/.config/backups/bashrc.backup.20240101_120000
    backup restore ~/.config/backups/bashrc.backup.20240101_120000
    backup clean 7                           # Clean backups older than 7 days

Backup Location: $BACKUP_DIR
Max Backups per File: $MAX_BACKUPS
EOF
            ;;
    esac
}

# Export functions for use in other scripts
export -f backup_file
export -f backup_directory
export -f backup_multiple
export -f restore_backup
export -f list_backups