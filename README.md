# SuperSkills Official Plugins

Official plugins developed by SuperSkills for Claude Code.

## Available Plugins

### Marketplace Management
Browse and manage plugins from your SuperSkills marketplace through conversational commands in Claude.

**Includes:**
- **marketplace-browser** - Discover available plugins by asking Claude
- **marketplace-updater** - Check for updates to your installed plugins

## Installation

```bash
# Add the SuperSkills marketplace
/plugin marketplace add github.com/youruser/superskills-plugins

# Install the marketplace management plugin
/plugin install marketplace-management@superskills-official
```

## Development

This repository contains:
- `/plugins/` - Plugin bundles
- `/skills/` - Standalone skills
- `/agents/` - Subagents
- `/mcp-servers/` - Custom MCP servers

Each folder has a README with more details.

## Contributing

We welcome contributions! Please:
1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## License

MIT License - See LICENSE file for details
