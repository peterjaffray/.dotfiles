# Command Reference - Cheat Sheet

Mobile-optimized quick reference for all dotfiles commands.

## Session Management
```
t                           # tmux session selector
tmux attach                 # attach to session
tmux new -s NAME           # named session
tmux detach                # detach (or C-b d)
```

## Alias Management
```  
alias-manager add N CMD     # add cross-shell alias
alias-manager list          # show all w/ status
alias-manager check         # validate aliases
alias-manager remove NAME   # remove alias
```

## Navigation & Files
```
mkcd DIR                    # create & enter dir
up [N]                      # go up N dirs (def 1)
..  / ...  / ....          # go up 1/2/3 dirs
ll / la / l                 # list detailed/all/simple
extract FILE                # smart extraction
```

## Git Commands
```
g / gs / ga                 # git/status/add
gc / gp / gl                # commit/push/pull
gd / gb / gco               # diff/branch/checkout
glog                        # graph log --oneline
```

## Docker & Containers
```
dc / dps / di               # compose/ps/images
dc up/down/logs             # start/stop/view logs
k                           # kubectl (if installed)
```

## Claude Code
```
claude mcp add ...          # add MCP integration
claude --dangerously-skip-permissions --resume
claude --help               # all commands
claude chat/code            # chat/code modes
```

## System Management
```
dotfiles status/doctor      # check system
dotfiles sync/backup        # sync/backup system
dotfiles clean              # clean symlinks/backups
```

## Editors & Utilities
```
v / vi / vim                # nvim (w/ fallbacks)
? [topic] / h [topic]       # help system
? cheat                     # this cheat sheet
```

## Tmux Keys (C-b prefix)
```
C-b c / n / p               # create/next/prev window
C-b % / "                   # split vert/horiz
C-b d                       # detach session
C-b [                       # scroll mode (q=quit)
```

## Shell Features
```
[i] / [n]                   # vim modes: insert/normal
ESC / i / a                 # normal/insert/append
C-r                         # history search (fzf)
Tab / S-Tab                 # complete/reverse
```

---
*Access: `? cheat` or `? 1` from help menu*
*Full docs: See [LOCAL_DOCS_INDEX.md](LOCAL_DOCS_INDEX.md)*