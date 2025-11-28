# Plugin Specifications

This directory contains comprehensive specifications for Claude Code plugins, skills, and bundles that extend Claude Code's capabilities.

## What's Here?

This folder contains detailed implementation guides for:

- **Skills** - Single-purpose tools that add specific capabilities
- **Bundles** - Multi-component packages combining related skills
- **Agents** - Specialized subagents for complex workflows
- **Commands** - Slash commands for quick actions

## Documentation Structure

### `/specs/` - Detailed Plugin Specifications

Comprehensive implementation guides for each plugin:

**Skill Development Toolkit:**
- `skill-analyzer-spec.md` - Quality assurance and optimization for existing skills
- `skill-development-coach-spec.md` - Interactive coaching for skill creation
- `spec-analyzer-spec.md` - Analyzes and validates skill specifications

**Example Skills:**
- `git-repo-analyzer-spec.md` - Analyzes Git repository health and patterns
- `sqlite-skill-spec.md` - SQLite database query and analysis helper
- `form-assistant-spec.md` - Interactive form creation and handling
- `web-image-extractor-spec.md` - Extracts and processes images from web pages
- `research-plugin-spec.md` - Comprehensive research and information gathering

**Bundles:**
- `backlog-manager-bundle-spec.md` - Task and backlog management bundle
- `capability-discovery-bundle-spec.md` - Hook + skill for capability discovery

## Master Plugin Tracker

See **PLUGINS.md** for a comprehensive overview of all plugins across three stages:

1. **💡 Ideas** - Unspecced concepts
2. **📋 Specs Complete** - Fully specified but not implemented
3. **✅ Implemented** - Live and available for use

## Specification Format

Each specification file follows a comprehensive format:

```markdown
---
title: Plugin Name
type: skill | bundle | agent | command
status: idea | spec-draft | spec-complete | in-progress | done
priority: low | medium | high | critical
last-updated: YYYY-MM-DD
related: [list of related specs]
---

## Executive Summary
Brief overview of purpose and value

## User Stories
How users will interact with the plugin

## Technical Specification
Detailed implementation guidance

## Success Criteria
How to measure effectiveness

## Examples
Concrete use cases and outputs
```

## For Developers

### Creating a New Plugin

1. Copy an existing spec as a template
2. Follow the format guidelines above
3. Include comprehensive examples
4. Add entry to PLUGINS.md tracker
5. Link related specifications

### Spec Guidelines

- **Keep comprehensive** - These are implementation guides, not brief outlines
- **Include examples** - Show actual inputs, outputs, and workflows
- **Cross-reference** - Link to related plugins and dependencies
- **Update PLUGINS.md** - Maintain the master tracker

### Implementation Priority

Plugins are prioritized based on:
- User demand and use cases
- Technical complexity
- Dependencies on other plugins
- Strategic value to ecosystem

## Related Documentation

### SuperSkills Platform

For SuperSkills web application documentation:
- `/superskills/docs/` - Platform implementation docs
- `/superskills/docs/platform/PROGRESS.md` - Development roadmap

### Repository Root

- `/CLAUDE.md` - Instructions for Claude Code working with this repo
- `/README.md` - Project overview

## Current Status

**Total Specifications:** 10 complete plugin specs

**Breakdown:**
- Skill Development Tools: 3 specs
- Example Skills: 4 specs
- Bundles: 2 specs
- Research Tools: 1 spec

See **PLUGINS.md** for detailed status of each plugin.

## Contributing

When adding new plugin specifications:

1. Create spec file in `/specs/` with naming pattern: `{plugin-name}-spec.md`
2. Use YAML frontmatter for metadata
3. Follow comprehensive format with examples
4. Update PLUGINS.md with new entry
5. Link to related specifications

## Questions?

- Check existing specs for format examples
- See PLUGINS.md for plugin ecosystem overview
- Review related SuperSkills documentation

---

*Last Updated: 2025-11-07*
