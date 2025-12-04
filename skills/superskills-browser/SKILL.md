---
name: superskills-browser
displayName: SuperSkills Browser
description: Browse and discover plugins available in the SuperSkills marketplace. Use when the user asks about available plugins, wants to find specific tools, or needs installation guidance. Works with zero configuration.
category: superskills
tags: [browse, search, discovery, installation, plugins]
icon: store
author: nibbletech-labs
version: 1.1.0
relatedSkills: [superskills-updater]
allowed-tools: Read, WebFetch, Grep
---

# SuperSkills Browser Skill

## Purpose

Help users discover and install plugins from the SuperSkills marketplace through natural conversation without leaving Claude Code.

## How It Works

1. Fetches the SuperSkills catalog via WebFetch
2. Parses and filters available items
3. Presents plugins/MCP servers with descriptions
4. Provides installation commands

## Core Workflow

### Step 1: Fetch Catalog

Fetch the SuperSkills catalog:

```
WebFetch to https://superskills.dev/api/catalog
```

This returns all available MCP servers, skills, and plugins.

### Step 2: Parse and Filter

Expected response:
```json
{
  "skills": [
    {
      "slug": "supabase-cli-expert",
      "displayName": "Supabase CLI Expert",
      "type": "skill",
      "category": "database",
      "shortDescription": "Expert guidance for Supabase CLI",
      "version": "1.0.0"
    }
  ],
  "mcpServers": [
    {
      "slug": "supabase",
      "displayName": "Supabase",
      "type": "mcp",
      "category": "database",
      "shortDescription": "Database access, authentication, and storage"
    },
    {
      "slug": "github",
      "displayName": "GitHub",
      "type": "mcp",
      "category": "git-version-control",
      "shortDescription": "Repository access, issues, PRs"
    }
  ],
  "items": [...]
}
```

### Step 3: Present Results

Format response based on user query.

#### Query: "What plugins are available?"

```markdown
# Available in SuperSkills

## MCP Servers

**Supabase**
Database access, authentication, and storage

**GitHub**
Repository access, issues, PRs, and code search

**Google DevTools**
Chrome DevTools integration for browser automation

## Skills

**Supabase CLI Expert**
Expert guidance for Supabase CLI commands

**SuperSkills Browser** (this skill)
Browse and discover marketplace plugins

**SuperSkills Updater**
Check for and install bundle updates

## Create Your Bundle

Visit https://superskills.dev to select items and create a custom bundle.
```

#### Query: "Show me database tools"

```markdown
# Database Tools

**Supabase** (MCP Server)
Database access, authentication, and storage
- PostgreSQL database queries
- Auth user management
- Storage bucket operations

**Supabase CLI Expert** (Skill)
Expert guidance for Supabase CLI commands
- Project setup and configuration
- Database migrations
- Edge functions deployment

To add these to your bundle, visit https://superskills.dev
```

#### Query: "Is there a GitHub integration?"

```markdown
Searching for "GitHub" in catalog...

**GitHub** (MCP Server)
Repository access, issues, PRs, and code search
- Create and manage repositories
- Work with issues and pull requests
- Search code across repositories

To add GitHub to your bundle:
1. Visit https://superskills.dev
2. Select GitHub from the catalog
3. Create or update your bundle
4. Install with /plugin marketplace add {your-bundle-url}
```

## Installation Guidance

### For First-Time Users

```markdown
To use SuperSkills:

1. Visit https://superskills.dev
2. Browse and select the MCP servers/skills you want
3. Create your custom bundle
4. Copy the marketplace URL
5. Run: /plugin marketplace add {marketplace-url}
6. Run: /plugin install bundle-{id}@superskills-bundle-{id}
7. Restart Claude Code

After installation, configure your MCP credentials.
```

### MCP Credential Setup

After installation, guide users to configure their API keys:

```markdown
To configure your MCP servers, add API keys to your environment.

You can use Claude's /mcp command or edit .claude/settings.local.json

Required credentials vary by server:
- Supabase: SUPABASE_URL, SUPABASE_KEY
- GitHub: GITHUB_TOKEN
- Google DevTools: (no credentials needed)

Visit your bundle page on SuperSkills for detailed setup instructions.
```

## Advanced Features

### Category Filtering

**User query: "Show me AI tools"**

1. Fetch catalog
2. Filter items by category matching "ai", "llm", "model"
3. Present filtered results

### Search by Name

**User query: "Find anything related to testing"**

1. Fetch catalog
2. Search item names and descriptions for "test"
3. Rank by relevance
4. Present top matches

### Version Information

**User query: "What version of the Supabase skill is available?"**

1. Fetch catalog
2. Find item by name
3. Show version + description
4. Provide bundle creation link

## Error Handling

### Catalog Not Reachable

```markdown
I couldn't reach the SuperSkills catalog.

Possible causes:
- No internet connection
- SuperSkills service is temporarily down

You can:
1. Check your internet connection
2. Visit https://superskills.dev in a browser
3. Try again in a few moments
```

### Network Timeout

```markdown
The request timed out while fetching the catalog.

You can:
1. Try again
2. Check your network connection
3. Visit superskills.dev directly to browse available items
```

## Usage Examples

### Example 1: Broad Discovery

**User:** "What plugins are available?"

**Actions:**
1. WebFetch to https://superskills.dev/api/catalog
2. Parse catalog items by category
3. Format categorized list
4. Provide link to create bundle

### Example 2: Targeted Search

**User:** "I need something for API development"

**Actions:**
1. Fetch catalog
2. Search categories and descriptions for "API"
3. Filter to relevant items
4. Show 2-3 top matches with details
5. Provide bundle creation guidance

### Example 3: Specific Item

**User:** "Do you have a Supabase integration?"

**Actions:**
1. Fetch catalog
2. Search for "Supabase"
3. Find matches: Supabase MCP server + Supabase CLI Expert skill
4. Show detailed info (description, features)
5. Provide bundle creation link

## Related Skills

- **superskills-browser**: Discover new/available plugins (this skill)
- **superskills-updater**: Updates to installed bundles

Together they provide complete plugin lifecycle management.
