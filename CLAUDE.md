# CLAUDE.md

## Project Overview

**superskills-plugins** is the skills, agents, and MCP server repository for the SuperSkills marketplace.

## Directory Structure

```
superskills-plugins/
├── skills/              # All skills (flat structure)
├── agents/              # Agent definitions
├── mcp-servers/         # MCP server configs
├── docs/                # Documentation and specs
├── scripts/             # Build and validation scripts
└── registry.json        # Auto-generated skills registry
```

---

## Skill Development

### Frontmatter Requirements

Every `SKILL.md` file MUST include valid frontmatter for the superskills catalog.

**Required fields:**
- `name` - Slug identifier (lowercase, hyphens only)
- `displayName` - Human-readable name
- `description` - Short description (1-2 sentences)

**Optional fields:**
- `category` - One of: superskills, database, development, documentation, testing, deployment, ai
- `tags` - Array of search keywords
- `icon` - Lucide icon name
- `author` - Creator/maintainer
- `version` - Semver version (e.g., 1.0.0)
- `relatedSkills` - Array of related skill names (for grouping suggestions)
- `allowed-tools` - Claude Code tools the skill uses

**Full specification:** See `docs/FRONTMATTER_SPEC.md` for complete details, validation rules, and examples.

**Quick example:**
```yaml
---
name: my-skill
displayName: My Skill
description: Does something useful for developers.
category: development
tags: [productivity, automation]
icon: zap
author: nibbletech-labs
version: 1.0.0
relatedSkills: [other-skill]
---
```

### Validation

Before committing, run validation locally:
```bash
npm install  # First time only
npm run validate
```

The GitHub Action will also validate on PR and block merging if frontmatter is invalid.

### Registry Updates

When you push changes to any `SKILL.md` file:
1. GitHub Action validates frontmatter
2. If valid, regenerates `registry.json`
3. Commits and pushes `registry.json`
4. Notifies superskills.dev to refresh cache

Skills appear in the superskills catalog automatically.

---

## Schema Maintenance

When changing the frontmatter schema:

1. **Update validation script** - Add/modify field checks in `scripts/validate-skills.js`
2. **Update this CLAUDE.md** - Document new fields above
3. **Update existing skills** - Ensure all skills comply
4. **Run validation** - `npm run validate` must pass
5. **Update superskills types** - Match `SkillsRegistry` interface in superskills app

The validation script (`scripts/validate-skills.js`) is the source of truth for required fields.

---

## Quick Commands

```bash
npm install              # Install dependencies
npm run validate         # Validate all SKILL.md frontmatter
npm run generate-registry # Generate registry.json
npm run build            # Validate + generate registry
```

---

## Git Commit Messages

Keep commits clean and professional. No footer required.
