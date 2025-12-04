---
name: superskills-updater
displayName: SuperSkills Updater
description: Check for and install updates to SuperSkills bundles. Use when the user asks about updates, wants to see what's new, or needs to upgrade their bundle. Compares local plugin.json version against remote marketplace.json.
category: superskills
tags: [updates, upgrade, version, changelog]
icon: refresh-cw
author: nibbletech-labs
version: 1.1.0
relatedSkills: [superskills-browser]
allowed-tools: Read, WebFetch
---

# SuperSkills Updater Skill

## Purpose

Help users discover and install updates to their SuperSkills bundles. Compares version timestamps and guides update installation.

## How It Works

1. Reads local plugin.json to get installed version and bundleId
2. Fetches remote marketplace.json to get current version
3. Compares epoch timestamps
4. If remote > local, presents update information
5. Guides user through update process

## Core Workflow

### Step 1: Read Installed Version

Read the plugin manifest:

```bash
cat ${CLAUDE_PLUGIN_ROOT}/.claude-plugin/plugin.json
```

Expected content:
```json
{
  "name": "bundle-abc123",
  "version": "1733324400",
  "description": "Custom SuperSkills bundle"
}
```

Extract key fields:
- `name` - e.g., "bundle-abc123" → bundleId is "abc123"
- `version` - e.g., "1733324400" (epoch timestamp)

### Step 2: Fetch Current Version

Construct the marketplace URL from bundleId:

```
https://superskills.dev/api/bundles/{bundleId}/marketplace.json
```

WebFetch to get current version:

```
WebFetch to https://superskills.dev/api/bundles/abc123/marketplace.json
```

Expected response:
```json
{
  "name": "superskills-bundle-abc123",
  "plugins": [{
    "name": "bundle-abc123",
    "version": "1733410800",
    "description": "Custom SuperSkills bundle"
  }]
}
```

### Step 3: Compare Versions

```
localVersion  = 1733324400  (from plugin.json)
remoteVersion = 1733410800  (from marketplace.json)

if (parseInt(remoteVersion) > parseInt(localVersion)) {
  // Update available!
}
```

### Step 4: Present Update Information

**If updates available:**

```markdown
Updates Available!

Your bundle version: 1733324400 (Dec 4, 2025 10:00 AM)
Latest version: 1733410800 (Dec 5, 2025 10:00 AM)

The bundle has been updated since you installed it.

To update:
1. /plugin marketplace update superskills-bundle-{bundleId}
2. /plugin uninstall bundle-{bundleId}@superskills-bundle-{bundleId}
3. /plugin install bundle-{bundleId}@superskills-bundle-{bundleId}
4. Restart Claude Code

Would you like me to walk you through this?
```

**If no updates:**

```markdown
You're up to date!

Current version: 1733324400
Last checked: Just now

Your bundle is on the latest version.
```

### Step 5: Guide Update Installation

When user confirms they want to update:

```markdown
Let's update your bundle. Follow these steps:

Step 1: Update the marketplace index
Run: /plugin marketplace update superskills-bundle-{bundleId}

Step 2: Remove old version
Run: /plugin uninstall bundle-{bundleId}@superskills-bundle-{bundleId}

Step 3: Install new version
Run: /plugin install bundle-{bundleId}@superskills-bundle-{bundleId}

Step 4: Restart Claude Code
This activates the new version.

Ready to proceed? I can help if you encounter any issues.
```

## Error Handling

### plugin.json Not Found

```markdown
I couldn't read the plugin manifest.

This could mean:
- The bundle wasn't installed correctly
- The plugin directory structure changed

To fix:
1. Try reinstalling the bundle
2. Restart Claude Code
```

### Marketplace Not Reachable

```markdown
Couldn't fetch the latest version from SuperSkills.

Possible causes:
- No internet connection
- SuperSkills service temporarily unavailable

You can:
1. Try again in a few moments
2. Check your internet connection
3. Visit superskills.dev to verify it's accessible
```

### Bundle Not Found

```markdown
The bundle ID "{bundleId}" wasn't found on SuperSkills.

This could mean:
- The bundle was deleted
- The bundle ID is incorrect

Check your bundle at: https://superskills.dev
```

### Update Installation Failed

If user reports update didn't work:

```markdown
Update troubleshooting:

Did you complete all steps?
1. [ ] /plugin marketplace update superskills-bundle-{bundleId}
2. [ ] /plugin uninstall bundle-{bundleId}@superskills-bundle-{bundleId}
3. [ ] /plugin install bundle-{bundleId}@superskills-bundle-{bundleId}
4. [ ] Restart Claude Code

If still on old version:

1. Check installed version:
   cat ${CLAUDE_PLUGIN_ROOT}/.claude-plugin/plugin.json

2. Try full reinstall:
   /plugin marketplace remove superskills-bundle-{bundleId}
   /plugin marketplace add https://superskills.dev/api/bundles/{bundleId}/marketplace.json
   /plugin install bundle-{bundleId}@superskills-bundle-{bundleId}
```

## Usage Examples

### Example 1: Proactive Check

**User:** "Are there any updates?"

**Actions:**
1. Read plugin.json → get installed version and bundleId
2. Construct marketplace URL from bundleId
3. WebFetch to marketplace.json → get current version
4. Compare epoch timestamps
5. If remote > local, format update notification
6. Provide update commands
7. If no updates, confirm current version

### Example 2: Update Installation

**User:** "Update my plugins"

**Actions:**
1. Check for updates first
2. If available, show version comparison
3. Provide step-by-step commands
4. Offer to help troubleshoot if issues
5. Confirm completion after restart

## Related Skills

- **superskills-browser**: Discover new/available skills from catalog
- **superskills-updater**: Updates to installed bundles

Together they provide complete plugin lifecycle management.
