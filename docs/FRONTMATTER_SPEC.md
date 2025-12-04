# SKILL.md Frontmatter Specification

This document defines the frontmatter schema for `SKILL.md` files in the superskills-plugins repository.

---

## Schema

Every `SKILL.md` file must begin with YAML frontmatter between `---` delimiters.

### Required Fields

| Field | Type | Description | Example |
|-------|------|-------------|---------|
| `name` | string | Unique slug identifier. Lowercase letters, numbers, and hyphens only. | `superskills-browser` |
| `displayName` | string | Human-readable name shown in UI. | `Marketplace Browser` |
| `description` | string | Short description (1-2 sentences). Used in catalog and search. | `Browse and discover plugins...` |

### Optional Fields

| Field | Type | Default | Description | Example |
|-------|------|---------|-------------|---------|
| `category` | string | `uncategorized` | Primary category for filtering. Must be from valid list. | `superskills` |
| `tags` | array | `[]` | Search keywords for discovery. | `[browse, search, plugins]` |
| `icon` | string | `file-text` | Lucide icon name for UI display. | `store` |
| `author` | string | `unknown` | Creator or maintainer identifier. | `nibbletech-labs` |
| `version` | string | `1.0.0` | Semantic version number. | `1.2.0` |
| `relatedSkills` | array | `[]` | Related skill names for grouping suggestions. | `[superskills-updater]` |
| `allowed-tools` | string | - | Claude Code tools the skill uses. Not used by registry. | `Read, WebFetch` |

---

## Valid Categories

Skills must use one of these categories:

| Category | Description |
|----------|-------------|
| `superskills` | SuperSkills platform management and plugin discovery |
| `database` | Database operations, migrations, SQL |
| `development` | Development tools and workflows |
| `documentation` | Documentation and writing tools |
| `testing` | Testing and QA tools |
| `deployment` | CI/CD and deployment tools |
| `ai` | AI/ML related tools |
| `uncategorized` | Default for skills without a category |

---

## Format Examples

### Minimal (Required Fields Only)

```yaml
---
name: my-skill
displayName: My Skill
description: Does something useful.
---
```

### Complete (All Fields)

```yaml
---
name: superskills-browser
displayName: SuperSkills Browser
description: Browse and discover skills available in your SuperSkills marketplace.
category: superskills
tags: [browse, search, discovery, installation, plugins]
icon: store
author: nibbletech-labs
version: 1.0.0
relatedSkills: [superskills-updater]
allowed-tools: Read, WebFetch
---
```

---

## Validation Rules

The validation script (`scripts/validate-skills.js`) enforces:

1. **Required fields present** - `name`, `displayName`, `description` must exist
2. **Required fields non-empty** - Cannot be empty strings
3. **Name format** - Must match `/^[a-z0-9-]+$/` (lowercase, hyphens, numbers)
4. **Category valid** - If provided, must be from the valid categories list
5. **Tags is array** - If provided, must be a YAML array
6. **Version format** - If provided, must match semver pattern (`/^\d+(\.\d+)*$/`)
7. **relatedSkills is array** - If provided, must be array of lowercase skill names with hyphens

---

## Validation

Run validation before committing:

```bash
npm run validate
```

The GitHub Action validates all PRs and blocks merging if frontmatter is invalid.

---

## Adding New Fields

When adding new frontmatter fields:

1. **Update validation script** - `scripts/validate-skills.js`
2. **Update this spec** - Add to tables above
3. **Update CLAUDE.md** - Summary in CLAUDE.md
4. **Update existing skills** - If field is required
5. **Update superskills types** - `SkillsRegistry` interface in superskills app

The validation script is the **source of truth** for required fields and validation rules.

---

## Registry Output

The `generate-registry.js` script produces `registry.json` with this structure per skill:

```json
{
  "name": "superskills-browser",
  "displayName": "SuperSkills Browser",
  "description": "...",
  "path": "skills/superskills-browser/",
  "url": "https://raw.githubusercontent.com/.../superskills-browser/",
  "category": "superskills",
  "tags": ["browse", "search"],
  "icon": "store",
  "author": "nibbletech-labs",
  "version": "1.0.0",
  "relatedSkills": ["superskills-updater"],
  "updatedAt": 1764857881
}
```

### Auto-generated Fields

| Field | Type | Description |
|-------|------|-------------|
| `path` | string | Relative path from repo root |
| `url` | string | Full URL to skill directory on GitHub |
| `updatedAt` | number | Unix timestamp (epoch seconds) of last git commit that modified the skill |

The `updatedAt` field is used for bundle version calculation - bundles use `max(skill.updatedAt)` to detect when any skill has been updated.

Note: `allowed-tools` is **not** included in the registry - it's only for Claude Code's skill loading.
