---
name: marketplace-updater
displayName: Marketplace Updater
description: Check for and install updates to marketplace plugins. Use when the user asks about updates, wants to see what's new, or needs to upgrade plugins.
category: marketplace
tags: [updates, upgrade, version, changelog]
icon: refresh-cw
author: nibbletech-labs
version: 1.0.0
relatedSkills: [marketplace-browser]
allowed-tools: Read, WebFetch
---

# Marketplace Updater Skill

## Purpose

Help users discover and install updates to their marketplace plugins through conversation.

## How It Works

1. Reads `.version.json` to get current version and update check URL
2. Fetches update information from marketplace API
3. Compares versions and presents changes
4. Guides user through update process

## Core Workflow

### Step 1: Read Current Configuration

Read the version file:

```bash
cat ${PLUGIN_ROOT}/.version.json
```

Extract key fields:
- `bundleId` - Unique identifier
- `version` - Currently installed version
- `updateCheckUrl` - API endpoint to check for updates

### Step 2: Check for Updates

WebFetch to:
```
${updateCheckUrl}?bundleId=${bundleId}&currentVersion=${version}
```

Expected response:
```json
{
  "updateAvailable": false,
  "currentVersion": "1.0.0",
  "latestVersion": "1.0.0",
  "message": "You're on the latest version!",
  "changes": []
}
```

### Step 3: Present Update Information

**If no updates:**

```markdown
You're up to date!

Current version: v1.0.0
Last checked: Just now

All components are on the latest versions.
```

**If updates available (future):**

```markdown
Updates Available!

Your bundle: v1.0.0
Latest: v1.1.0

What's New:
- New MCP servers added
- Improved skill performance

To update:
1. /plugin marketplace update superskills-marketplace
2. /plugin uninstall mcp-bundle-{id}@superskills-marketplace
3. /plugin install mcp-bundle-{id}@superskills-marketplace
4. Restart Claude Code

Would you like me to walk you through this?
```

### Step 4: Guide Update Installation

When user confirms they want to update:

```markdown
Let's update your plugins. Follow these steps:

Step 1: Update the marketplace index
Run: /plugin marketplace update superskills-marketplace

Step 2: Remove old version
Run: /plugin uninstall mcp-bundle-{id}@superskills-marketplace

Step 3: Install new version
Run: /plugin install mcp-bundle-{id}@superskills-marketplace

Step 4: Restart Claude Code
This activates the new versions.

Ready to proceed? I can help if you encounter any issues.
```

## Error Handling

### Update Check Failed

```markdown
Couldn't check for updates.

Possible causes:
- No internet connection
- Update service temporarily unavailable

You can:
1. Try again in a few moments
2. Check internet connection
```

### .version.json Missing

```markdown
I couldn't find the version configuration file.

This means the marketplace bundle may not be installed correctly.

To fix:
1. Reinstall from your marketplace URL
2. Restart Claude Code
```

## Usage Examples

### Example 1: Proactive Check

**User:** "Are there any updates?"

**Actions:**
1. Read .version.json
2. WebFetch to updateCheckUrl with bundleId and currentVersion
3. Parse response
4. If updates available, format changes list
5. Provide update commands
6. If no updates, confirm current version

### Example 2: Update Installation

**User:** "Update my plugins"

**Actions:**
1. Check for updates first
2. If available, show what will change
3. Provide step-by-step commands
4. Offer to help troubleshoot if issues
5. Confirm completion after restart

## Related Skills

- **marketplace-browser**: Discover new/available plugins
- **marketplace-updater**: Updates to installed plugins

Both use .version.json for zero-configuration operation.
