#!/bin/bash
# GPU-optimized Obsidian launcher with GitHub sync for WSL

VAULT_PATH="$HOME/PersonalVault"

# Function to perform git sync
sync_vault() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Syncing Obsidian vault..."
    cd "$VAULT_PATH" || exit 1
    
    # Pull latest changes
    git pull origin main --rebase 2>/dev/null
    
    # Check for local changes
    if [[ -n $(git status -s) ]]; then
        git add -A
        git commit -m "Sync: $(date '+%Y-%m-%d %H:%M:%S') - Obsidian $([ "$1" == "open" ] && echo "opened" || echo "closed")"
        git push origin main 2>/dev/null
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✅ Vault synced"
    else
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✅ No changes to sync"
    fi
}

# Sync on startup
sync_vault "open"

# Enable GPU acceleration
export __GL_THREADED_OPTIMIZATIONS=1
export __GL_SYNC_TO_VBLANK=0

# Force hardware acceleration in Chromium/Electron
export ELECTRON_ENABLE_GPU_RASTERIZATION=1
export ELECTRON_FORCE_GPU_ACCELERATION=1

# Use D3D12 renderer (already detected in WSL)
export LIBGL_ALWAYS_INDIRECT=0

# Disable software rendering fallback
export LIBGL_ALWAYS_SOFTWARE=0

# Set process priority to prefer GPU, reduce CPU usage
export MESA_GLTHREAD=true

# Set up trap to sync on exit
trap 'sync_vault "close"' EXIT

# Launch Obsidian with GPU flags
# Note: Using exec would replace this process and skip the EXIT trap
# So we use regular execution instead
~/Applications/Obsidian-1.7.7.AppImage \
    --enable-gpu-rasterization \
    --enable-zero-copy \
    --disable-gpu-sandbox \
    --disable-software-rasterizer \
    --num-raster-threads=4 \
    "$@"