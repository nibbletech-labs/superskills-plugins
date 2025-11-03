---
name: marketplace-browser
description: |
  Browse and discover plugins available in your marketplace. Use when the user
  asks about available plugins, wants to find specific tools, or needs installation
  guidance. Works with zero configuration for public bundles.
allowed-tools: Read, WebFetch
version: 1.0
---

# Marketplace Browser Skill

## Purpose

Help users discover and install plugins from their marketplace through natural conversation without leaving Claude Code.

## How It Works

1. Reads `.version.json` from the installed bundle to get marketplace URL
2. Fetches marketplace data via WebFetch
3. Presents available plugins with descriptions
4. Provides installation commands

## Core Workflow

### Step 1: Auto-Discover Marketplace Configuration

Read the configuration file:

```bash
cat ${PLUGIN_ROOT}/.version.json
```

Extract key fields:
- `bundleId` - Unique identifier for this bundle
- `marketplaceUrl` - API endpoint to fetch marketplace.json
- `version` - Current installed version

### Step 2: Fetch Marketplace Data

For public bundles:

```
WebFetch to ${marketplaceUrl}
```

### Step 3: Present Results

Format response based on user query.

**Example: "What plugins are available?"**

```markdown
# Available Plugins

## MCP Servers

**Supabase**
Database access, authentication, and storage

**GitHub**
Repository access, issues, PRs, and code search

**Google DevTools**
Google Cloud, Firebase, and other Google services

## Installation

To install this bundle:
/plugin marketplace add ${marketplaceUrl}
/plugin install mcp-bundle-{id}@superskills-marketplace

Then restart Claude Code.
```

## Installation Guidance

### For First-Time Users

```markdown
To use this marketplace:

1. Add marketplace:
   /plugin marketplace add ${marketplaceUrl}

2. Install the bundle:
   /plugin install mcp-bundle-{id}@superskills-marketplace

3. Restart Claude Code

After installation, you'll need to configure your MCP credentials.
```

### MCP Credential Setup

After installation, guide users to configure their API keys:

```markdown
To configure your MCP servers, you'll need to add API keys.

You can use Claude's /mcp command to configure credentials, or edit
your .claude/settings.local.json file manually.

Required credentials:
- Supabase: SUPABASE_URL, SUPABASE_KEY
- GitHub: GITHUB_TOKEN
- Google DevTools: GOOGLE_APPLICATION_CREDENTIALS, GOOGLE_CLOUD_PROJECT

Visit the bundle page for detailed setup instructions for each service.
```

## Error Handling

### Marketplace Not Reachable

```markdown
I couldn't reach the marketplace API.

Possible causes:
- No internet connection
- Marketplace service is down

You can try:
1. Check your internet connection
2. Try again in a few moments
```

### .version.json Missing

```markdown
I couldn't find the marketplace configuration file (.version.json).

This means the marketplace bundle wasn't installed correctly.

To fix:
1. Reinstall the bundle from your marketplace URL
2. Restart Claude Code
```

## Usage Examples

### Example 1: Discovery

**User:** "What plugins are available?"

**Actions:**
1. Read .version.json → get marketplaceUrl
2. WebFetch to marketplaceUrl
3. Parse plugins list
4. Format and present with descriptions
5. Provide installation commands

### Example 2: Installation Help

**User:** "How do I install these MCPs?"

**Actions:**
1. Read .version.json
2. Show installation commands
3. Explain credential setup process
4. Link to detailed documentation
