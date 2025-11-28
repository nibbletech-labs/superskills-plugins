# Capability Discovery Bundle - Specification

**Document Type:** Plugin Bundle Specification (Hook + Skill)
**Bundle Name:** capability-discovery
**Date:** November 2, 2025
**Status:** Specification Phase
**Version:** 1.0

-----

## Executive Summary

### The Problem

Skills in Claude Code cannot easily discover what capabilities are available:

- **Skills:** What other skills are installed? (3 locations to check)
- **MCP Servers:** What MCPs are configured? What tools do they provide? What are the actual tool names?
- **Hooks:** What hooks exist? (global vs project)
- **Commands:** What slash commands are available?
- **Agents:** What agents can be invoked?

**Current approach:** Each skill implements its own filesystem scanning (duplication, slow, error-prone)

**Key pain point:** MCP name mapping - user says "use Supabase MCP" but actual tool is `supabase_query_database` - skills have to guess!

### The Solution

**A bundle consisting of two components:**

1. **Hook (SessionStart):** Scans all capability locations once per session, generates manifest
2. **Skill (capability-discovery):** Provides fast lookups and name mapping from manifest

**Benefits:**
- ✅ Scan once per session (not per skill activation)
- ✅ Fast JSON lookups (vs repeated filesystem scanning)
- ✅ Solves MCP name mapping problem
- ✅ Standard manifest format all skills can use
- ✅ Clean separation (generation vs consumption)

### Use Cases

**For Research Skill:**
- "Do I have gemini-cli skill installed?"
- "What search-related MCPs are available?"
- Fast capability checking without bash scripts

**For Any Skill:**
- "Map 'Supabase MCP' to actual tool names"
- "What hooks are configured?"
- "List all available skills"
- Discovery without duplicating scanning logic

-----

## Architecture Overview

### Component Relationship

```
┌─────────────────────────────────────────────────────────┐
│ Claude Code Session Starts                              │
└─────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────┐
│ HOOK: SessionStart                                      │
│ (scripts/generate-capabilities-manifest.sh)             │
├─────────────────────────────────────────────────────────┤
│ Scans:                                                   │
│ - Skills: ~/.claude/skills/, .claude/skills/, plugins/ │
│ - MCPs: ~/.claude/.mcp.json, .mcp.json                 │
│ - Hooks: ~/.claude/hooks/, .claude/hooks/              │
│ - Commands: ~/.claude/commands/, .claude/commands/     │
│ - Agents: ~/.claude/agents/, .claude/agents/           │
│                                                          │
│ Generates: .claude/capabilities.json                    │
│ Time: <1 second (runs in background)                   │
└─────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────┐
│ Session Active - User Working                           │
└─────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────┐
│ Skill Needs to Check Capabilities                       │
│ (e.g., research skill checking for gemini-cli)         │
└─────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────┐
│ SKILL: capability-discovery                             │
│ (Activated by other skill's request)                   │
├─────────────────────────────────────────────────────────┤
│ Reads: .claude/capabilities.json                        │
│ Interprets query: "Is gemini-cli skill available?"     │
│ Returns: Yes/No with details                            │
│ Time: <0.1 seconds (just JSON read)                    │
└─────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────┐
│ Requesting Skill Uses Information                       │
│ (Proceeds with appropriate tool/fallback)              │
└─────────────────────────────────────────────────────────┘
```

### Why This Works

**Hook does heavy work once:**
- Runs at session start (user isn't waiting)
- Background process (non-blocking)
- Result cached for entire session

**Skill provides fast service:**
- Just reads JSON (instant)
- Can answer complex queries (MCP tool mapping)
- No filesystem scanning overhead

**Skills collaborate through manifest:**
- Standard format everyone understands
- No skill-to-skill coupling
- Each skill checks independently

-----

## Hook Specification

### File: hooks/session-start.json

```json
{
  "SessionStart": [{
    "type": "command",
    "command": "${CLAUDE_PLUGIN_ROOT}/scripts/generate-capabilities-manifest.sh",
    "async": true,
    "silent": true
  }]
}
```

**Properties:**
- `async: true` - Runs in background, doesn't block session start
- `silent: true` - No output to user (runs quietly)
- Executes on every Claude Code session start

### Script: scripts/generate-capabilities-manifest.sh

```bash
#!/bin/bash
# scripts/generate-capabilities-manifest.sh
# Scans all capability locations and generates manifest

set -euo pipefail

# Determine project root (where .claude/ should be)
if [ -d ".claude" ]; then
    PROJECT_ROOT="."
else
    PROJECT_ROOT="$PWD"
fi

MANIFEST_FILE="$PROJECT_ROOT/.claude/capabilities.json"
mkdir -p "$PROJECT_ROOT/.claude"

# Temporary file for building manifest
TEMP_MANIFEST=$(mktemp)

# Start JSON structure
cat > "$TEMP_MANIFEST" << 'EOF'
{
  "generated_at": "TIMESTAMP_PLACEHOLDER",
  "claude_code_version": "VERSION_PLACEHOLDER",
  "skills": {},
  "mcp_servers": {},
  "hooks": [],
  "commands": [],
  "agents": []
}
EOF

# Update timestamp
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
jq ".generated_at = \"$TIMESTAMP\"" "$TEMP_MANIFEST" > "${TEMP_MANIFEST}.tmp" && mv "${TEMP_MANIFEST}.tmp" "$TEMP_MANIFEST"

# === SCAN SKILLS ===

echo "Scanning skills..." >&2

# Global skills
GLOBAL_SKILLS=()
if [ -d "$HOME/.claude/skills" ]; then
    while IFS= read -r skill; do
        GLOBAL_SKILLS+=("$skill")
    done < <(ls "$HOME/.claude/skills" 2>/dev/null || true)
fi

# Project skills
PROJECT_SKILLS=()
if [ -d "$PROJECT_ROOT/.claude/skills" ]; then
    while IFS= read -r skill; do
        PROJECT_SKILLS+=("$skill")
    done < <(ls "$PROJECT_ROOT/.claude/skills" 2>/dev/null || true)
fi

# Plugin skills
PLUGIN_SKILLS=()
if [ -d "$HOME/.claude/plugins/marketplaces" ]; then
    while IFS= read -r skill; do
        PLUGIN_SKILLS+=("$(basename "$skill")")
    done < <(find "$HOME/.claude/plugins/marketplaces" -type d -name "SKILL.md" -exec dirname {} \; 2>/dev/null || true)
fi

# Add to manifest
jq ".skills.global = $(printf '%s\n' "${GLOBAL_SKILLS[@]}" | jq -R . | jq -s . || echo '[]')" "$TEMP_MANIFEST" > "${TEMP_MANIFEST}.tmp" && mv "${TEMP_MANIFEST}.tmp" "$TEMP_MANIFEST"
jq ".skills.project = $(printf '%s\n' "${PROJECT_SKILLS[@]}" | jq -R . | jq -s . || echo '[]')" "$TEMP_MANIFEST" > "${TEMP_MANIFEST}.tmp" && mv "${TEMP_MANIFEST}.tmp" "$TEMP_MANIFEST"
jq ".skills.plugins = $(printf '%s\n' "${PLUGIN_SKILLS[@]}" | jq -R . | jq -s . || echo '[]')" "$TEMP_MANIFEST" > "${TEMP_MANIFEST}.tmp" && mv "${TEMP_MANIFEST}.tmp" "$TEMP_MANIFEST"

# === SCAN MCP SERVERS ===

echo "Scanning MCP servers..." >&2

# Function to extract MCP info
extract_mcp_info() {
    local mcp_file="$1"
    local scope="$2"

    if [ ! -f "$mcp_file" ]; then
        echo "[]"
        return
    fi

    # Build MCP info with server names and tools
    jq -r "
        .mcpServers // {} |
        to_entries |
        map({
            name: .key,
            scope: \"$scope\",
            command: .value.command,
            transport: (.value.transport // \"stdio\"),
            tools: (.value.tools // [])
        })
    " "$mcp_file" 2>/dev/null || echo "[]"
}

# Global MCPs
GLOBAL_MCPS=$(extract_mcp_info "$HOME/.claude/.mcp.json" "global")

# Project MCPs
PROJECT_MCPS=$(extract_mcp_info "$PROJECT_ROOT/.mcp.json" "project")

# Combine and add to manifest
COMBINED_MCPS=$(jq -s 'add' <(echo "$GLOBAL_MCPS") <(echo "$PROJECT_MCPS"))
jq ".mcp_servers = $COMBINED_MCPS" "$TEMP_MANIFEST" > "${TEMP_MANIFEST}.tmp" && mv "${TEMP_MANIFEST}.tmp" "$TEMP_MANIFEST"

# === SCAN HOOKS ===

echo "Scanning hooks..." >&2

HOOKS=()
# Global hooks
if [ -d "$HOME/.claude/hooks" ]; then
    while IFS= read -r hook; do
        HOOKS+=("$hook")
    done < <(ls "$HOME/.claude/hooks" 2>/dev/null || true)
fi

# Project hooks
if [ -d "$PROJECT_ROOT/.claude/hooks" ]; then
    while IFS= read -r hook; do
        HOOKS+=("$hook")
    done < <(ls "$PROJECT_ROOT/.claude/hooks" 2>/dev/null || true)
fi

jq ".hooks = $(printf '%s\n' "${HOOKS[@]}" | sort -u | jq -R . | jq -s . || echo '[]')" "$TEMP_MANIFEST" > "${TEMP_MANIFEST}.tmp" && mv "${TEMP_MANIFEST}.tmp" "$TEMP_MANIFEST"

# === SCAN COMMANDS ===

echo "Scanning commands..." >&2

COMMANDS=()
# Global
if [ -d "$HOME/.claude/commands" ]; then
    while IFS= read -r cmd; do
        COMMANDS+=("$(basename "$cmd" .md)")
    done < <(find "$HOME/.claude/commands" -name "*.md" 2>/dev/null || true)
fi

# Project
if [ -d "$PROJECT_ROOT/.claude/commands" ]; then
    while IFS= read -r cmd; do
        COMMANDS+=("$(basename "$cmd" .md)")
    done < <(find "$PROJECT_ROOT/.claude/commands" -name "*.md" 2>/dev/null || true)
fi

jq ".commands = $(printf '%s\n' "${COMMANDS[@]}" | sort -u | jq -R . | jq -s . || echo '[]')" "$TEMP_MANIFEST" > "${TEMP_MANIFEST}.tmp" && mv "${TEMP_MANIFEST}.tmp" "$TEMP_MANIFEST"

# === SCAN AGENTS ===

echo "Scanning agents..." >&2

AGENTS=()
# Global
if [ -d "$HOME/.claude/agents" ]; then
    while IFS= read -r agent; do
        AGENTS+=("$(basename "$agent" .md)")
    done < <(find "$HOME/.claude/agents" -name "*.md" 2>/dev/null || true)
fi

# Project
if [ -d "$PROJECT_ROOT/.claude/agents" ]; then
    while IFS= read -r agent; do
        AGENTS+=("$(basename "$agent" .md)")
    done < <(find "$PROJECT_ROOT/.claude/agents" -name "*.md" 2>/dev/null || true)
fi

jq ".agents = $(printf '%s\n' "${AGENTS[@]}" | sort -u | jq -R . | jq -s . || echo '[]')" "$TEMP_MANIFEST" > "${TEMP_MANIFEST}.tmp" && mv "${TEMP_MANIFEST}.tmp" "$TEMP_MANIFEST"

# === FINALIZE ===

# Move to final location
mv "$TEMP_MANIFEST" "$MANIFEST_FILE"

echo "✅ Capabilities manifest generated: $MANIFEST_FILE" >&2
```

### Manifest Output Format

**File: .claude/capabilities.json**

```json
{
  "generated_at": "2025-11-02T14:30:00Z",
  "claude_code_version": "1.2.0",

  "skills": {
    "global": ["research", "gemini-cli"],
    "project": ["company-standards"],
    "plugins": ["pdf", "xlsx", "mcp-builder"]
  },

  "mcp_servers": [
    {
      "name": "github",
      "scope": "global",
      "command": "npx",
      "transport": "stdio",
      "tools": ["create_issue", "search_repos", "get_file_contents"]
    },
    {
      "name": "supabase",
      "scope": "project",
      "command": "npx",
      "transport": "stdio",
      "tools": ["query_database", "insert_row", "update_row"]
    }
  ],

  "hooks": ["pre-commit", "session-start", "post-command"],
  "commands": ["review-pr", "deploy", "test"],
  "agents": ["code-reviewer", "test-writer"]
}
```

**Critical feature:** MCP servers include their actual tool names - solves the name mapping problem!

-----

## Skill Specification

### File: skills/capability-discovery/SKILL.md

```markdown
---
name: capability-discovery
description: |
  Provides information about available skills, MCP servers, hooks, commands,
  and agents. Use when you or another skill needs to check what capabilities
  are available or map friendly names to actual tool names.
allowed-tools: Read, Grep
version: 1.0
---

# Capability Discovery Skill

## Purpose

You (Claude) use this skill to discover what capabilities are available
in the current Claude Code environment. This is especially useful for:

- Checking if optional skills are installed (e.g., "Is gemini-cli available?")
- Mapping user requests to actual MCP tool names (e.g., "Supabase MCP" → `supabase_query_database`)
- Listing all available capabilities
- Determining fallback strategies

## How It Works

A SessionStart hook generates `.claude/capabilities.json` at startup.
This skill reads that manifest and interprets queries about capabilities.

## Usage Patterns

### Check If Skill Available

**Query:** "Is the gemini-cli skill available?"

**Instructions:**

1. Read the capabilities manifest:
   ```bash
   cat .claude/capabilities.json
   ```

2. Check if "gemini-cli" appears in any skills array:
   - skills.global
   - skills.project
   - skills.plugins

3. Return result:
   - "Yes, gemini-cli skill is available (location: {global/project/plugin})"
   - "No, gemini-cli skill is not installed"

### Map MCP Friendly Name to Tool Names

**Query:** "What tools does the Supabase MCP provide?"

**Instructions:**

1. Read the capabilities manifest

2. Search mcp_servers array for entries where name contains "supabase" (case-insensitive)

3. Return the tools array for matching server:
   ```
   Supabase MCP (scope: project) provides these tools:
   - query_database
   - insert_row
   - update_row

   To use: Call these tool names directly in your workflow.
   ```

4. If no match found, suggest:
   ```
   No MCP server matching "Supabase" found.

   Available MCP servers:
   - github (global): create_issue, search_repos, get_file_contents
   - linear (global): create_ticket, search_tickets

   Is the MCP configured? Check .mcp.json
   ```

### List All Capabilities

**Query:** "What capabilities do I have access to?"

**Instructions:**

1. Read `.claude/capabilities.json`

2. Format a comprehensive summary:

```markdown
# Available Capabilities

## Skills ({total_count})

**Global:**
- {skill1}
- {skill2}

**Project:**
- {skill3}

**From Plugins:**
- {skill4}

## MCP Servers ({total_count})

**{server_name}** (scope: {global/project})
  Tools: {tool1}, {tool2}, {tool3}

**{server_name_2}** (scope: {global/project})
  Tools: {tool1}, {tool2}

## Hooks ({count})
{list}

## Slash Commands ({count})
{list}

## Agents ({count})
{list}
```

3. Return this summary

### Check Multiple Capabilities

**Query:** "I need web search - what options do I have?"

**Instructions:**

1. Read capabilities manifest

2. Check for search-related capabilities:
   - Skills: gemini-cli, perplexity, web-research, etc.
   - MCPs: Any with "search" in server name or tools
   - Built-in: WebSearch tool (always available in Claude Code)

3. Return prioritized recommendations:
   ```
   Web search options available:

   1. gemini-cli skill (if found)
      - Free, 1M context
      - Recommended for broad search

   2. {mcp_name} MCP (if found with search tools)
      - Tool: {actual_tool_name}

   3. Claude WebSearch (always available)
      - Built-in fallback
   ```

## Manifest Location

**Primary:** `.claude/capabilities.json` (project root)
**Fallback:** If not found, inform user the SessionStart hook may not have run yet

## Error Handling

**If manifest doesn't exist:**

```markdown
The capabilities manifest doesn't exist yet.

This usually means:
1. The SessionStart hook hasn't run yet (restart Claude Code)
2. The capability-discovery bundle is not installed
3. The hook encountered an error

Fallback: I can manually check for specific capabilities using bash,
but it will be slower. What specific capability do you need to check?
```

**If manifest is stale (> 1 hour old):**

Inform user they can regenerate by restarting Claude Code or manually running:
```bash
.claude/hooks/session-start/generate-capabilities-manifest.sh
```

## Integration Examples

### Example 1: Research Skill Checking for Gemini CLI

**Research skill's SKILL.md:**

```markdown
## Tool Selection

Before executing searches, determine available tools:

If the capability-discovery skill is available, ask it:
"Is the gemini-cli skill available?"

Based on response:
- If YES: Proceed with gemini-cli for searches
- If NO: Use Claude WebSearch as fallback
```

**What happens:**
1. Research skill mentions checking capabilities
2. capability-discovery skill activates (Claude recognizes need)
3. capability-discovery reads `.claude/capabilities.json`
4. Returns: "Yes, gemini-cli is available (global)"
5. Research skill proceeds with gemini-cli

**Time:** <0.1 seconds (just JSON read)

### Example 2: Mapping MCP Names

**User:** "Use the Supabase MCP to get user data"

**Skill's SKILL.md:**

```markdown
## MCP Usage

When user requests using an MCP by friendly name:

1. Ask capability-discovery: "What tools does the {name} MCP provide?"
2. capability-discovery returns actual tool names
3. Use the actual tool name in your workflow

Example:
User says: "Use Supabase MCP"
capability-discovery returns: "supabase_query_database"
You call: supabase_query_database tool
```

**Solves the name guessing problem!**

-----

## Manifest Format Specification

### Complete Schema

```typescript
interface CapabilitiesManifest {
  generated_at: string;  // ISO 8601 timestamp
  claude_code_version?: string;

  skills: {
    global: string[];     // Skill directory names from ~/.claude/skills/
    project: string[];    // Skill directory names from .claude/skills/
    plugins: string[];    // Skill names from installed plugins
  };

  mcp_servers: Array<{
    name: string;         // Server name from config
    scope: 'global' | 'project';
    command: string;      // Executable command
    transport: 'stdio' | 'http' | 'sse';
    tools?: string[];     // Tool names this server provides (if discoverable)
  }>;

  hooks: string[];        // Hook filenames (without extension)
  commands: string[];     // Command names (without .md extension)
  agents: string[];       // Agent names (without .md extension)
}
```

### Field Descriptions

**skills:**
- `global`: Skills in `~/.claude/skills/`
- `project`: Skills in `.claude/skills/`
- `plugins`: Skills from installed plugins (all sources)

**mcp_servers:**
- `name`: Key from `.mcp.json`
- `scope`: Where it's configured (global vs project)
- `command`: What executes the server
- `transport`: Communication method
- `tools`: **Critical!** Actual tool names you can call

**hooks:** Discovered from `hooks/` directories
**commands:** Discovered from `commands/` directories
**agents:** Discovered from `agents/` directories

-----

## Usage Examples

### Example Query: "Is gemini-cli available?"

**capability-discovery skill executes:**

```markdown
Read .claude/capabilities.json

Check: Is "gemini-cli" in skills.global, skills.project, or skills.plugins?

Result: Found in skills.global

Response:
"Yes, the gemini-cli skill is available (installed globally).
You can use it by describing your search needs, and it will activate automatically."
```

### Example Query: "What's the Supabase MCP tool called?"

**capability-discovery skill executes:**

```markdown
Read .claude/capabilities.json

Search mcp_servers for name containing "supabase"

Found: {
  "name": "supabase",
  "scope": "project",
  "tools": ["query_database", "insert_row", "update_row"]
}

Response:
"The Supabase MCP is configured (project scope) and provides these tools:
- query_database
- insert_row
- update_row

To query the database, use: query_database tool with your SQL query."
```

### Example Query: "What search capabilities exist?"

**capability-discovery skill executes:**

```markdown
Read .claude/capabilities.json

Search for search-related capabilities:
- Skills containing "search", "research", "gemini"
- MCPs with "search" in name or tools
- Commands related to search

Compile results:
"Search capabilities available:

Skills:
- gemini-cli (global): Web search via Gemini
- research (global): Multi-platform research orchestrator

MCP Servers:
- github (global): Tool 'search_repos' for searching repositories

Built-in:
- WebSearch tool (always available in Claude Code)

Recommendation: Use gemini-cli for broad web search, research for comprehensive investigations."
```

-----

## Installation & Setup

### Bundle Structure

```
capability-discovery/
├── hooks/
│   └── session-start.json                   # Hook configuration
├── scripts/
│   └── generate-capabilities-manifest.sh    # Manifest generator
├── skills/
│   └── capability-discovery/
│       └── SKILL.md                          # Query interface
└── README.md                                 # Installation guide
```

### Installation Steps

1. **Install the bundle:**
   ```bash
   /plugin marketplace add yourservice.com/marketplace.json
   /plugin install capability-discovery@yourservice
   ```

2. **Restart Claude Code** (triggers SessionStart hook)

3. **Verify manifest created:**
   ```bash
   cat .claude/capabilities.json
   ```

4. **Test the skill:**
   In Claude Code: "What capabilities do I have?"

### Manual Manifest Generation

If you want to regenerate without restarting:

```bash
# Run the hook script manually
~/.claude/plugins/marketplaces/yourservice/plugins/capability-discovery/scripts/generate-capabilities-manifest.sh
```

-----

## Benefits for Other Skills

### Before capability-discovery Bundle:

**Research skill had to:**
```bash
# Check for gemini-cli skill
test -d ~/.claude/skills/gemini-cli || test -d .claude/skills/gemini-cli || ...

# Check for Gemini MCP
grep -q "gemini" ~/.claude/.mcp.json 2>/dev/null || ...

# Check for CLI tool
command -v gemini
```

**Duplicated across every skill that needs capability checking!**

### With capability-discovery Bundle:

**Research skill just:**
```markdown
To determine search tools available, ask capability-discovery:
"What search capabilities exist?"

capability-discovery will check the manifest and return available options.
```

**Much cleaner!** Centralized logic, fast lookups, standardized format.

-----

## Fallback Behavior

**If capability-discovery bundle NOT installed:**

Skills can still check manually:
```markdown
## Fallback Capability Checking

If capability-discovery skill is not available:

Check manually using bash:
```bash
# Check for gemini-cli skill
test -d ~/.claude/skills/gemini-cli && echo "available"
```

This is slower but works without the bundle.
```

**The bundle is an optimization, not a requirement.**

-----

## Future Enhancements

### Version 1.1: Enhanced MCP Discovery

- **Auto-detect MCP tools:** Call MCP server's `tools/list` method if supported
- **Tool signatures:** Include parameter schemas for each tool
- **Health checks:** Test if MCP servers are actually running

### Version 1.2: Capability Recommendations

- **Suggest missing capabilities:** "For better research, install gemini-cli skill"
- **Complementary skills:** "You have research but not gemini-cli - consider installing"
- **Optimization hints:** Based on what's available

### Version 1.3: Dynamic Updates

- **File watcher:** Regenerate manifest when .mcp.json or skills/ change
- **Incremental updates:** Add new discoveries without full rescan
- **Change notifications:** Alert when capabilities change

-----

## Technical Specifications

### Dependencies

**Required:**
- `bash` >= 4.0
- `jq` (JSON processor)
- `find` (file searching)

**Optional:**
- `inotify` or `fswatch` (for future dynamic updates)

### Performance

**Hook execution time:**
- Typical: 100-500ms
- Worst case: 1-2 seconds (many plugins/skills)
- **Non-blocking:** Runs async, doesn't delay session start

**Skill query time:**
- JSON read: <10ms
- Parse and respond: <100ms
- **Total:** <0.1 seconds per query

### Manifest Size

**Typical:**
- Small project: 1-3 KB
- Large project: 5-10 KB
- **Negligible** storage/memory impact

-----

## Integration with Other Bundles

### Research Bundle

**research skill references capability-discovery:**

```markdown
## Tool Selection

To determine available search tools:

If capability-discovery skill exists:
  Ask: "What search capabilities exist?"
  Use recommended tool from response

Else:
  Fallback: Check manually for gemini CLI
  Ultimate fallback: Claude WebSearch
```

### Future Marketplace Platform

**Could use capability-discovery to:**
- Validate skill generation (don't generate duplicate names)
- Recommend complementary skills
- Check dependencies before installation

-----

## Conclusion

The capability-discovery bundle solves a fundamental problem in Claude Code skill development: **how to know what's available without duplicating filesystem scanning logic across every skill**.

**Key innovations:**
1. **SessionStart hook** generates manifest once per session
2. **Skill provides query interface** for fast lookups
3. **MCP tool name mapping** solves the "what's it actually called?" problem
4. **Standard manifest format** all skills can consume

**This is a foundational utility bundle** that makes other skills cleaner, faster, and more reliable.

**Status:** Ready for implementation
**Estimated dev time:** 1-2 days
**Value:** High (benefits all future skills)

-----

**Document Version:** 1.0
**Research Phase:** Complete
**Status:** Ready for Implementation
