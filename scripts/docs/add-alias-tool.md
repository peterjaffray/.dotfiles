# Add-Alias Tool Installation and Usage

## Installation

1. **Download the script** (already done if you downloaded from this chat)

2. **Make it executable:**
   ```bash
   chmod +x add-alias.sh
   ```

3. **Move to a directory in your PATH (optional but recommended):**
   ```bash
   # Option 1: Move to /usr/local/bin (requires sudo)
   sudo mv add-alias.sh /usr/local/bin/add-alias
   
   # Option 2: Move to ~/.local/bin (create directory if needed)
   mkdir -p ~/.local/bin
   mv add-alias.sh ~/.local/bin/add-alias
   
   # Option 3: Keep in current directory and create an alias for it
   alias add-alias='./add-alias.sh'
   ```

4. **If using ~/.local/bin, make sure it's in your PATH:**
   ```bash
   echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.profile
   source ~/.profile
   ```

## Usage Examples

### Basic Usage
```bash
# Add a simple alias
add-alias ll "ls -alF"

# Add an alias for a common git command
add-alias gitlog "git log --oneline --graph --all"

# Add an alias to navigate to your project
add-alias myproject "cd ~/projects/my-awesome-project"

# Add an alias for a complex command with pipes
add-alias myps "ps aux | grep -v grep | grep"
```

### Management Commands
```bash
# List all current aliases
add-alias --list
add-alias -l

# Remove an alias
add-alias --remove ll
add-alias -r gitlog

# Show help
add-alias --help
add-alias -h
```

## Features

### ✅ **Conflict Detection**
- Checks if alias name conflicts with existing commands
- Warns about overriding built-in commands
- Detects existing aliases and asks before replacing

### ✅ **Validation**
- Validates alias names (must start with letter/underscore)
- Checks if commands exist in PATH (with warnings)
- Tests aliases before adding them

### ✅ **Safety Features**
- Creates automatic backups before modifying .profile
- Provides clear error messages and warnings
- Allows you to abort operations safely

### ✅ **User-Friendly**
- Interactive prompts for conflicts
- Colored output for better readability
- Comprehensive help system

## Example Session

```bash
$ add-alias ll "ls -alF"
Testing alias: ll='ls -alF'
✓ Alias test successful
Created backup: /home/user/.profile.backup.20241115_143022
Added alias to /home/user/.profile
Profile reloaded successfully
✓ Alias 'll' added successfully!
Usage: ll

$ add-alias ll "ls -la"
Alias 'll' already exists:
  alias ll='ls -alF'
Do you want to replace it? (y/N): y
Testing alias: ll='ls -la'
✓ Alias test successful
Created backup: /home/user/.profile.backup.20241115_143055
Replaced alias in /home/user/.profile
Profile reloaded successfully
✓ Alias 'll' added successfully!
Usage: ll

$ add-alias --list
Current aliases:
alias ll='ls -la'
alias gitlog='git log --oneline --graph --all'
```

## Advanced Usage

### Creating Project-Specific Aliases
```bash
# Development shortcuts
add-alias dev "cd ~/projects && code ."
add-alias serve "python -m http.server 8000"
add-alias venv "source venv/bin/activate"

# Docker shortcuts
add-alias dps "docker ps"
add-alias dimg "docker images"
add-alias dclean "docker system prune -f"

# Git shortcuts
add-alias gs "git status"
add-alias ga "git add ."
add-alias gc "git commit -m"
add-alias gp "git push"
```

### WSL-Specific Aliases
```bash
# Windows integration
add-alias explorer "explorer.exe ."
add-alias notepad "notepad.exe"
add-alias code "code.exe"

# System shortcuts
add-alias ll "ls -alF --color=auto"
add-alias la "ls -A --color=auto"
add-alias grep "grep --color=auto"
```

## Troubleshooting

### Common Issues

1. **Permission denied when running script:**
   ```bash
   chmod +x add-alias.sh
   ```

2. **Script not found after installation:**
   ```bash
   # Check if directory is in PATH
   echo $PATH
   # Add to PATH if needed
   echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.profile
   source ~/.profile
   ```

3. **Aliases not working in new sessions:**
   ```bash
   # Make sure .profile is being sourced
   echo 'source ~/.profile' >> ~/.bashrc
   ```

4. **Backup files accumulating:**
   ```bash
   # Clean old backups (optional)
   find ~ -name ".profile.backup.*" -mtime +30 -delete
   ```

### Manual Cleanup

If you need to manually remove aliases or restore from backup:

```bash
# View current profile
cat ~/.profile

# Restore from backup
cp ~/.profile.backup.YYYYMMDD_HHMMSS ~/.profile

# Edit profile manually
nano ~/.profile
```

## Script Location

The script modifies `~/.profile` by default. This file is sourced by most shells and provides good compatibility across different shell environments in WSL.

---

**Note:** This tool is designed to be safe and user-friendly, but always review what gets added to your profile file. The automatic backups provide an easy way to revert changes if needed.
