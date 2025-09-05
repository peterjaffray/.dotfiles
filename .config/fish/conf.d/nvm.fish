# Set NVM_DIR to use the same directory as bash
set -gx NVM_DIR "$HOME/.nvm"

# Load default node version on shell startup if .nvmrc exists
if status is-interactive
    if test -f .nvmrc
        nvm use --silent 2>/dev/null
    end
end