#!/bin/bash
# Secret Manager - Handle secrets safely across machines
# This library provides functions for managing secrets without committing them

SECRETS_DIR="${HOME}/.dotfiles/config/secrets"
SECRETS_FILE="${SECRETS_DIR}/secrets.sh"
TEMPLATES_DIR="${HOME}/.dotfiles/templates"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Initialize secrets directory
init_secrets() {
    if [ ! -d "$SECRETS_DIR" ]; then
        mkdir -p "$SECRETS_DIR"
        chmod 700 "$SECRETS_DIR"
        echo -e "${GREEN}✓${NC} Created secrets directory with restricted permissions"
    fi
}

# Check if secrets file exists
secrets_exist() {
    [ -f "$SECRETS_FILE" ] && return 0 || return 1
}

# Create secrets file from template
create_secrets_from_template() {
    init_secrets
    
    if secrets_exist; then
        echo -e "${YELLOW}!${NC} Secrets file already exists at $SECRETS_FILE"
        read -p "Do you want to backup and recreate it? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            backup_secrets
        else
            return 1
        fi
    fi
    
    cp "${TEMPLATES_DIR}/secrets.example" "$SECRETS_FILE"
    chmod 600 "$SECRETS_FILE"
    
    echo -e "${GREEN}✓${NC} Created secrets file from template"
    echo -e "${YELLOW}!${NC} Please edit $SECRETS_FILE to add your secrets"
}

# Backup existing secrets
backup_secrets() {
    if secrets_exist; then
        local backup_file="${SECRETS_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$SECRETS_FILE" "$backup_file"
        chmod 600 "$backup_file"
        echo -e "${GREEN}✓${NC} Backed up secrets to $backup_file"
    fi
}

# Load secrets into environment
load_secrets() {
    if secrets_exist; then
        # shellcheck source=/dev/null
        source "$SECRETS_FILE"
        return 0
    else
        return 1
    fi
}

# Add a new secret interactively
add_secret() {
    local secret_name="$1"
    local secret_value="$2"
    
    if [ -z "$secret_name" ]; then
        read -p "Enter secret name (e.g., GITHUB_TOKEN): " secret_name
    fi
    
    if [ -z "$secret_value" ]; then
        read -s -p "Enter secret value: " secret_value
        echo
    fi
    
    if ! secrets_exist; then
        create_secrets_from_template
    fi
    
    # Check if secret already exists
    if grep -q "^export ${secret_name}=" "$SECRETS_FILE"; then
        echo -e "${YELLOW}!${NC} Secret $secret_name already exists"
        read -p "Do you want to update it? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            # Update existing secret
            sed -i.bak "s|^export ${secret_name}=.*|export ${secret_name}=\"${secret_value}\"|" "$SECRETS_FILE"
            echo -e "${GREEN}✓${NC} Updated secret $secret_name"
        fi
    else
        # Add new secret
        echo "export ${secret_name}=\"${secret_value}\"" >> "$SECRETS_FILE"
        echo -e "${GREEN}✓${NC} Added secret $secret_name"
    fi
}

# List configured secrets (without showing values)
list_secrets() {
    if ! secrets_exist; then
        echo -e "${RED}✗${NC} No secrets file found"
        return 1
    fi
    
    echo "Configured secrets:"
    grep "^export " "$SECRETS_FILE" | sed 's/=.*//' | sed 's/export /  - /'
}

# Validate required secrets
validate_required_secrets() {
    local required_secrets=("$@")
    local missing=()
    
    if ! load_secrets; then
        echo -e "${RED}✗${NC} No secrets file found. Run: dotfiles secrets init"
        return 1
    fi
    
    for secret in "${required_secrets[@]}"; do
        if [ -z "${!secret}" ]; then
            missing+=("$secret")
        fi
    done
    
    if [ ${#missing[@]} -gt 0 ]; then
        echo -e "${RED}✗${NC} Missing required secrets:"
        for secret in "${missing[@]}"; do
            echo "  - $secret"
        done
        echo
        echo "Add them with: dotfiles secrets add <SECRET_NAME>"
        return 1
    fi
    
    echo -e "${GREEN}✓${NC} All required secrets are configured"
    return 0
}

# Import secrets from environment file
import_env_file() {
    local env_file="$1"
    
    if [ ! -f "$env_file" ]; then
        echo -e "${RED}✗${NC} File not found: $env_file"
        return 1
    fi
    
    if ! secrets_exist; then
        create_secrets_from_template
    fi
    
    backup_secrets
    
    # Read .env file and append to secrets
    echo "" >> "$SECRETS_FILE"
    echo "# Imported from $env_file on $(date)" >> "$SECRETS_FILE"
    
    while IFS='=' read -r key value; do
        # Skip comments and empty lines
        [[ "$key" =~ ^#.*$ ]] && continue
        [ -z "$key" ] && continue
        
        # Remove quotes from value
        value="${value%\"}"
        value="${value#\"}"
        value="${value%\'}"
        value="${value#\'}"
        
        echo "export $key=\"$value\"" >> "$SECRETS_FILE"
        echo -e "${GREEN}✓${NC} Imported $key"
    done < "$env_file"
}

# Generate secret for a specific service
generate_secret() {
    local service="$1"
    local length="${2:-32}"
    
    case "$service" in
        "ssh-key")
            ssh-keygen -t ed25519 -f "${SECRETS_DIR}/id_ed25519" -N ""
            echo -e "${GREEN}✓${NC} Generated SSH key at ${SECRETS_DIR}/id_ed25519"
            ;;
        "gpg-key")
            echo "Generating GPG key..."
            gpg --full-generate-key
            ;;
        "token"|"password"|*)
            local secret
            secret=$(openssl rand -base64 "$length" | tr -d '\n')
            echo -e "${GREEN}✓${NC} Generated secret: $secret"
            read -p "Save as (enter name, or press Enter to skip): " secret_name
            if [ -n "$secret_name" ]; then
                add_secret "$secret_name" "$secret"
            fi
            ;;
    esac
}

# Sync secrets using secure method (encrypted backup)
sync_secrets() {
    local action="$1"
    local remote_path="${2:-${SECRETS_SYNC_PATH}}"
    
    if [ -z "$remote_path" ]; then
        echo -e "${RED}✗${NC} No sync path configured"
        echo "Set SECRETS_SYNC_PATH in your secrets file or provide path as argument"
        return 1
    fi
    
    case "$action" in
        "push")
            if secrets_exist; then
                # Encrypt before pushing
                gpg --symmetric --cipher-algo AES256 "$SECRETS_FILE"
                cp "${SECRETS_FILE}.gpg" "$remote_path/"
                rm "${SECRETS_FILE}.gpg"
                echo -e "${GREEN}✓${NC} Pushed encrypted secrets to $remote_path"
            fi
            ;;
        "pull")
            if [ -f "${remote_path}/secrets.sh.gpg" ]; then
                backup_secrets
                gpg --decrypt "${remote_path}/secrets.sh.gpg" > "$SECRETS_FILE"
                chmod 600 "$SECRETS_FILE"
                echo -e "${GREEN}✓${NC} Pulled and decrypted secrets from $remote_path"
            else
                echo -e "${RED}✗${NC} No encrypted secrets found at $remote_path"
            fi
            ;;
        *)
            echo "Usage: sync_secrets [push|pull] [remote_path]"
            ;;
    esac
}

# Check secret permissions
check_secret_permissions() {
    local issues=0
    
    echo "Checking secret file permissions..."
    
    if [ -d "$SECRETS_DIR" ]; then
        local dir_perms=$(stat -c %a "$SECRETS_DIR" 2>/dev/null || stat -f %A "$SECRETS_DIR")
        if [ "$dir_perms" != "700" ]; then
            echo -e "${RED}✗${NC} Secrets directory has unsafe permissions: $dir_perms (should be 700)"
            ((issues++))
        else
            echo -e "${GREEN}✓${NC} Secrets directory permissions OK"
        fi
    fi
    
    if secrets_exist; then
        local file_perms=$(stat -c %a "$SECRETS_FILE" 2>/dev/null || stat -f %A "$SECRETS_FILE")
        if [ "$file_perms" != "600" ]; then
            echo -e "${RED}✗${NC} Secrets file has unsafe permissions: $file_perms (should be 600)"
            ((issues++))
        else
            echo -e "${GREEN}✓${NC} Secrets file permissions OK"
        fi
    fi
    
    if [ $issues -gt 0 ]; then
        read -p "Fix permission issues? (Y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            chmod 700 "$SECRETS_DIR" 2>/dev/null
            chmod 600 "$SECRETS_FILE" 2>/dev/null
            echo -e "${GREEN}✓${NC} Fixed permissions"
        fi
    fi
    
    return $issues
}

# Main entry point for CLI
secrets_main() {
    local command="$1"
    shift
    
    case "$command" in
        init)
            create_secrets_from_template
            ;;
        add)
            add_secret "$@"
            ;;
        list)
            list_secrets
            ;;
        validate)
            validate_required_secrets "$@"
            ;;
        import)
            import_env_file "$@"
            ;;
        generate)
            generate_secret "$@"
            ;;
        sync)
            sync_secrets "$@"
            ;;
        check)
            check_secret_permissions
            ;;
        backup)
            backup_secrets
            ;;
        help|*)
            cat << EOF
Secret Manager - Safely manage secrets across machines

Usage: secrets <command> [arguments]

Commands:
    init                    Create secrets file from template
    add [name] [value]      Add or update a secret
    list                    List configured secrets (names only)
    validate [secrets...]   Check if required secrets are set
    import <file>          Import secrets from .env file
    generate <type> [len]   Generate secret (ssh-key, gpg-key, token)
    sync push|pull [path]   Sync encrypted secrets
    check                   Check file permissions
    backup                  Create backup of secrets file
    help                    Show this help message

Examples:
    secrets init                        # Initialize secrets file
    secrets add GITHUB_TOKEN            # Add secret interactively
    secrets add API_KEY "secret123"    # Add secret directly
    secrets validate GITHUB_TOKEN       # Check if secret exists
    secrets import .env                 # Import from .env file
    secrets generate token 64           # Generate 64-char token
    secrets sync push /backup/secrets   # Push encrypted secrets

Security Notes:
    - Secrets are stored in ~/.config/dotfiles/secrets/
    - Files have restricted permissions (700/600)
    - Secrets are excluded from git
    - Use encryption for syncing between machines
EOF
            ;;
    esac
}

# Export functions for use in other scripts
export -f init_secrets
export -f load_secrets
export -f add_secret
export -f validate_required_secrets