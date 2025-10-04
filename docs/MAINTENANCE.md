# Documentation Maintenance Guide

Mobile-friendly documentation standards and update procedures.

## Documentation Standards

### Format Rules (Mobile-Optimized)
- **Max line length**: 50 chars for mobile screens
- **Indentation**: 2 spaces only, NO tabs
- **Nesting**: Maximum 2 levels deep
- **Commands**: `CMD [OPT]  # description`
- **Sections**: Use emoji headers for quick scanning

### Command Format
```
command-name [args]         # description
alias-name                  # what it does
```

### File Structure
```
docs/
├── README.md               # System overview (UPDATED)
├── COMMANDS.md             # Mobile cheat sheet (UPDATED)
├── INSTALLATION.md         # Install guide (NEW)
├── LOCAL_DOCS_INDEX.md     # Cross-links & context (UPDATED)
└── MAINTENANCE.md          # This file (UPDATED)
```

## When Adding New Tools

### Update Checklist
- [ ] Add to `help-system` script
- [ ] Add to `COMMANDS.md` cheat sheet  
- [ ] Update `LOCAL_DOCS_INDEX.md`
- [ ] Test on mobile screen width
- [ ] Add direct topic access (`? newtopic`)

### Help System Updates
1. Add show_TOPIC_help() function
2. Update menu in show_menu()
3. Add case in main() function
4. Keep format ultra-condensed

### Example New Tool Integration
```bash
# 1. Add function to help-system
show_newtool_help() {
    echo -e "${CYAN}🔧 NEW TOOL${NC}"
    echo "newtool cmd             # does thing"
    echo "newtool --help          # show help"
}

# 2. Add to menu (increment numbers)
echo "  ${YELLOW}9${NC} - newtool     (description)"

# 3. Add case handler
"newtool"|"new")
    show_newtool_help
    ;;
```

## Documentation Types

### Cheat Sheet (COMMANDS.md)
- Ultra-condensed format
- Commands grouped by category
- Max 3 lines per command group
- Cross-references to full docs

### Help System (help-system script)
- Interactive number-based menu
- Direct topic access via parameters
- Mobile-optimized output
- Default to cheat sheet

### Context Guide (LOCAL_DOCS_INDEX.md)
- Cross-links to all docs
- Context inclusion recommendations  
- File tree overview
- Maintenance reminders

## Mobile Compatibility

### Screen Width Considerations
- Test on 320px width minimum
- Commands fit in one line
- No horizontal scrolling needed
- Clear visual separators

### Navigation
- Number-based menus (no arrows)
- Single keypress access
- Default to most useful content
- Quick exit options

## Update Frequency

### When to Update Docs
- Adding new scripts/tools
- Changing command syntax
- Adding/removing aliases
- Updating workflows

### Validation
```bash
# Check line length
grep -n '.\{51,\}' docs/*.md

# Check for tabs  
grep -l $'\t' docs/*.md

# Test help system
? 1  # cheat sheet
? tmux  # direct access
```

## Integration Points

### Shell Integration
- `?` and `h` commands in all shells
- Direct topic access working
- Number navigation functional
- Cross-shell aliases via `aliases.sh`
- Fish compatibility in `conf.d/01-aliases.fish`

### Documentation Cross-Links
- Each doc references others appropriately
- Context recommendations current
- File paths accurate
- Installation guide linked properly

### New Feature Maintenance (2025-10)

#### Dependency Management
- Update `system/dependency-manager.sh` for new tools
- Test installation functions regularly
- Keep package lists current in `config/packages/`

#### Credential Sync
- Never commit credentials to git
- Update `credential-sync` for new services
- Test rsync paths remain valid
- Verify backup/restore functionality

#### Tmux Session Persistence
- Verify auto-save working (15 min interval)
- Test C-a keybindings (not C-b)
- Update plugin list as needed

#### Cross-Shell Aliases
- Test aliases in all three shells
- Update both `aliases.sh` and Fish config
- Verify no conflicts between shells

#### Fish Shell
- Keep Fisher plugins updated
- Test `fish_greeting.fish` stays disabled
- Verify plugin compatibility

---
*Last updated: 2025-10-03 - Added new feature maintenance notes*
*Keep this guide updated when changing doc structure*