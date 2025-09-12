# Local Documentation Index

This file provides cross-links to all documentation within this dotfiles repository and guidance on when to include specific docs in Claude Code context.

## 📚 Documentation Locations

### Core System Documentation
- **[Main CLAUDE.md](../CLAUDE.md)** - Primary guidance for Claude Code instances
  - **Context Recommendation**: ✅ ALWAYS include for any dotfiles work
- **[Repository Overview](../docs/README.md)** - Comprehensive system documentation
  - **Context Recommendation**: ✅ Include for architecture understanding
- **[Local Docs Index](../docs/LOCAL_DOCS_INDEX.md)** - This file
  - **Context Recommendation**: 📖 Include when working on documentation

### Configuration Documentation
- **[Fish Shell README](../config/shells/fish/README.md)** - Fish-specific configurations
  - **Context Recommendation**: 🐟 Include when working with Fish shell
- **[Claude Code Config](../config/claude/CLAUDE.md)** - Claude-specific settings
  - **Context Recommendation**: 🤖 Include when working with Claude configurations
- **[Claude Agents](../config/claude/agents/README.md)** - Custom agents documentation
  - **Context Recommendation**: 🤖 Include when developing or using custom agents
- **[MCP Configuration](../config/claude/mcp/README.md)** - Model Context Protocol setup
  - **Context Recommendation**: 🔌 Include when working with MCP integrations

### Tool Documentation
- **[Commands Cheat Sheet](../docs/COMMANDS.md)** - Mobile-optimized quick reference
  - **Context Recommendation**: 📋 Include for quick command lookup
- **[Alias Manager](../scripts/bin/alias-manager)** - Cross-shell alias management tool
  - **Context Recommendation**: 🔧 Include when working with aliases
- **[Help System](../scripts/bin/help-system)** - Interactive documentation system
  - **Context Recommendation**: 📚 Include when updating documentation
- **[Add-Alias Tool](../scripts/docs/add-alias-tool.md)** - Legacy alias tool (superseded by alias-manager)
  - **Context Recommendation**: ⚠️ Include only for historical reference or migration

## 🎯 Context Inclusion Guidelines

### For All Dotfiles Tasks
**Always include:**
1. `/CLAUDE.md` - Core system guidance
2. `/docs/README.md` - System architecture overview
3. `/docs/COMMANDS.md` - Quick command reference

### For Shell Configuration Work
**Include based on shell:**
- **Bash/Zsh**: `/config/shells/common/` files
- **Fish**: `/config/shells/fish/README.md` + fish config files
- **Cross-shell**: All shell documentation

### For Alias Management
**Include:**
1. `/scripts/bin/alias-manager` - Cross-shell alias management tool
2. `/config/shells/common/aliases` - Current alias definitions
3. `/config/shells/fish/conf.d/00-aliases.fish` - Fish compatibility layer
4. `/docs/COMMANDS.md` - Command reference

### For System Administration
**Include:**
1. System libraries in `/system/` directory
2. Machine detection and backup managers
3. Installation and sync scripts

### For Claude Code Customization
**Include:**
1. `/config/claude/CLAUDE.md` - Claude-specific config
2. Any custom agents or MCP configurations
3. Status line and plugin configurations

## 📝 Quick Reference Commands

```bash
# View all documentation files
find ~/.dotfiles -name "*.md" -type f

# Search documentation content
grep -r "search_term" ~/.dotfiles/docs/ ~/.dotfiles/config/ --include="*.md"

# View specific config area docs
ls -la ~/.dotfiles/config/*/README.md 2>/dev/null
```

## 🔄 Maintenance Notes

**For Future Claude Code Instances:**

1. **Documentation Access**: Use `? cheat` or `? 1` for quick command lookup
2. **Alias Management**: Always refer to `/scripts/bin/alias-manager`, not legacy add-alias tool
3. **Fish Compatibility**: Remember that Fish supports standard `alias` syntax, not just `abbr`
4. **Cross-Shell Testing**: Test aliases in all three shells (bash, zsh, fish)
5. **Help System**: Number-based navigation (press numbers, no arrow keys needed)
6. **Mobile Format**: Use 2-space indent, max 50 chars/line for mobile compatibility

## 📂 File Tree Overview

```
~/.dotfiles/
├── CLAUDE.md                          # ✅ Always include
├── docs/
│   ├── README.md                       # ✅ Always include  
│   ├── COMMANDS.md                     # 📋 Quick reference
│   └── LOCAL_DOCS_INDEX.md            # 📖 This file
├── config/
│   ├── shells/fish/README.md          # 🐟 Fish work only
│   └── claude/
│       ├── CLAUDE.md                   # 🤖 Claude work only
│       ├── agents/README.md            # 🤖 Agent development
│       └── mcp/README.md               # 🔌 MCP integration
├── scripts/
│   ├── bin/
│   │   ├── alias-manager               # 🔧 Alias management
│   │   └── help-system                 # 📚 Documentation
│   └── docs/
│       └── add-alias-tool.md           # ⚠️ Legacy reference only
└── system/                             # 💾 Core libraries
```

---

**Last Updated**: 2025-01-10 - Added mobile-optimized cheat sheet and help system