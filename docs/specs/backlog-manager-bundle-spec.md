---
tags: [skill-bundle, product-management, backlog, mcp, workflow]
status: "draft"
bundle_type: "skills"
dependencies: ["Backlog Manager MCP Server"]
skills_included: ["backlog-planning", "discovery-publish", "backlog-evolution", "backlog-sync"]
related:
  - "[[Backlog Manager]]"
  - "[[Capability Discovery Bundle]]"
---

# Backlog Manager Skills Bundle

## Overview

The **Backlog Manager Skills Bundle** provides AI-assisted workflows for managing a semantic backlog that bridges product discovery and delivery. These skills integrate with the Backlog Manager MCP server to orchestrate common product management tasks.

### Purpose

Enable product managers to:
- Conduct AI-assisted planning sessions
- Publish discovery insights to backlog
- Evolve backlog items based on new research
- Sync backlog with delivery tools (GitHub, Linear, Jira)

### Architecture

```
Obsidian (Discovery)
    ↓
Skills (Workflow Orchestration)
    ↓
Backlog Manager MCP Server (Bridge)
    ↓
Delivery Tools (GitHub/Linear/Jira)
```

---

## Prerequisites

### Required Infrastructure

1. **Backlog Manager Running**
   - MCP server accessible (local or remote)
   - SQLite database initialized
   - REST API endpoints available

2. **MCP Configuration**
   - Backlog Manager MCP server configured in Claude Code
   - Connection tested and working

3. **Delivery Tool Access** (for backlog-sync skill)
   - API tokens for GitHub/Linear/Jira
   - Webhook URLs configured

### Optional

- Obsidian vault with discovery notes (for discovery-publish)
- Existing backlog items to work with (for backlog-evolution)

---

## Skills Included

### 1. backlog-planning

**Purpose:** AI-assisted planning session to select and prepare work for delivery

**When to use:**
- Starting a new sprint/cycle
- Planning next set of features to build
- Need to generate Context Packs for delivery team

**Workflow:**

1. **Query high-priority items**
   - Use MCP `get_backlog_items(status="ready", priority<=1)`
   - Display items with titles, descriptions, priorities

2. **For each item user selects:**
   - Use MCP `get_item_evolution_history(item_id)` to understand context
   - Search Obsidian for related research notes
   - Pull vision/architectural constraints via MCP `get_vision_doc()`

3. **AI synthesis:**
   - Generate comprehensive Context Pack (outcomes, constraints, edge cases, scenarios)
   - Suggest splits if item is too large (use MCP `suggest_item_evolution(item_id)`)
   - Create ticket description ready for delivery tool

4. **Output:**
   - Formatted Context Pack document
   - Ticket descriptions ready to paste
   - Recommendation: "Create these tickets in Linear using backlog-sync skill"

**MCP Tools Used:**
- `get_backlog_items`
- `get_item_evolution_history`
- `get_vision_doc`
- `suggest_item_evolution`
- `semantic_search` (to find related items)

**Example Usage:**
```
User: "Let's plan the next sprint"
Skill: [Queries backlog, shows 5 high-priority items]
User: "Let's do items 12 and 15"
Skill: [Pulls context, analyzes, generates Context Packs]
Skill: "Item 12 looks large. Should I split it into 'OAuth integration' and 'Session management'?"
User: "Yes, split it"
Skill: [Calls split_backlog_item, generates 2 Context Packs]
```

---

### 2. discovery-publish

**Purpose:** Analyze discovery research and publish actionable items to backlog

**When to use:**
- Finished user research and want to create backlog items
- Have architectural insights to capture
- Need to update existing items based on new findings

**Workflow:**

1. **Analyze discovery notes:**
   - User provides Obsidian note path or content
   - AI reads and identifies actionable items
   - Extracts: problem statement, user pain points, proposed solution, constraints

2. **Check for existing items:**
   - Use MCP `semantic_search(query)` to find related backlog items
   - If found: "Item 23 is similar. Should I update it or create new?"

3. **Create or update items:**
   - If new: Use MCP `create_backlog_item(title, description, priority, labels)`
   - If update: Use MCP `update_backlog_item(item_id, ...)`
   - Link back to source research in item metadata

4. **Suggest evolution:**
   - If new research contradicts existing item, use MCP `suggest_item_evolution(item_id, new_context)`
   - Present suggestions to user for approval

**MCP Tools Used:**
- `semantic_search`
- `create_backlog_item`
- `update_backlog_item`
- `suggest_item_evolution`
- `get_backlog_items` (to check for duplicates)

**Example Usage:**
```
User: "Analyze Research/Auth deep dive.md and update the backlog"
Skill: [Reads note, finds insights]
Skill: "I found 3 actionable items:
  1. OAuth complexity is higher than assumed
  2. MFA is required for compliance
  3. Session management needs custom solution

  Existing item 'Build auth' (item 10) should be split. Create items?"
User: "Yes"
Skill: [Calls split_backlog_item, creates items 45, 46, 47]
Skill: "Linked to Research/Auth deep dive.md. Evolution recorded."
```

---

### 3. backlog-evolution

**Purpose:** AI-driven review of backlog health and evolution suggestions

**When to use:**
- Weekly/monthly backlog grooming
- After major research findings
- Backlog feels stale or messy
- Want to identify overlaps and complexity

**Workflow:**

1. **Analyze all backlog items:**
   - Use MCP `get_backlog_items()` to fetch all
   - AI analyzes for:
     - Overlapping items (semantic similarity)
     - Overly complex items (should be split)
     - Related items (should be merged)
     - Stale items (no updates in 30+ days, no delivery progress)

2. **Generate suggestions:**
   - For each issue found, use MCP `suggest_item_evolution(item_id)` to get AI analysis
   - Prioritize suggestions (critical, high, medium, low)

3. **Present to user:**
   - Show top 5 suggestions with rationales
   - User approves/rejects each

4. **Execute approved changes:**
   - Splits: Use MCP `split_backlog_item(item_id, new_items, rationale)`
   - Merges: Use MCP `merge_backlog_items(item_ids, merged_title, merged_description, rationale)`
   - Updates: Use MCP `update_backlog_item(item_id, ...)`

5. **Summary:**
   - Report what changed
   - Show evolution history for affected items

**MCP Tools Used:**
- `get_backlog_items`
- `suggest_item_evolution`
- `split_backlog_item`
- `merge_backlog_items`
- `update_backlog_item`
- `semantic_search` (to find similar items)

**Example Usage:**
```
User: "Review the backlog and suggest improvements"
Skill: [Analyzes 30 items]
Skill: "Found 5 issues:

  CRITICAL:
  1. Items 12 and 18 are duplicates (both about payment processing)
     → Suggest: Merge into single item

  2. Item 5 'User management' is too broad (7 sub-concerns detected)
     → Suggest: Split into 'User registration', 'Profile management', 'Permission system'

  HIGH:
  3. Item 22 overlaps with Items 23, 24 (all auth-related)
     → Suggest: Consolidate or clarify boundaries

  What would you like to do?"
User: "Do 1 and 2"
Skill: [Executes merges and splits, records evolution]
```

---

### 4. backlog-sync

**Purpose:** Synchronize backlog items with delivery tools (GitHub, Linear, Jira)

**When to use:**
- After planning session (create tickets from backlog items)
- Set up bidirectional sync
- Check delivery status of backlog items

**Workflow:**

1. **Select items to sync:**
   - User specifies item IDs or selects from list
   - Use MCP `get_backlog_items(item_ids)` to fetch details

2. **Choose delivery tool:**
   - User specifies: GitHub, Linear, Jira
   - Skill checks for API credentials

3. **Create tickets:**
   - For each item:
     - Format as ticket (title, description, labels)
     - Call delivery tool API to create
     - Use MCP REST API `POST /api/items/{item_id}/sync` to record external_id

4. **Set up webhooks (optional):**
   - Configure delivery tool to send webhooks to Backlog Manager
   - Delivery tool will POST to `/api/webhooks/{tool}` on status changes

5. **Check sync status:**
   - Use MCP `get_delivery_status(item_id)` to see current status
   - Report: "Item 45 → Linear LIN-123 (In Progress)"

**MCP Tools Used:**
- `get_backlog_items`
- `get_delivery_status`
- REST API: `POST /api/items/{item_id}/sync`
- REST API: `POST /api/webhooks/{tool}` (for webhook setup)

**External APIs Used:**
- GitHub API (create issues)
- Linear API (create issues)
- Jira API (create issues)

**Example Usage:**
```
User: "Sync items 45, 46, 47 to Linear"
Skill: [Fetches items from backlog]
Skill: "Creating tickets in Linear...
  - Item 45 'OAuth integration' → LIN-123 ✓
  - Item 46 'MFA flow' → LIN-124 ✓
  - Item 47 'Session management' → LIN-125 ✓

  Webhooks configured. Status updates will sync automatically.
  View in Linear: [links]"
```

**Configuration:**

Create `.backlog-manager/config.yaml`:
```yaml
delivery_tools:
  github:
    token: ${GITHUB_TOKEN}
    repo: owner/repo
  linear:
    api_key: ${LINEAR_API_KEY}
    team_id: ${LINEAR_TEAM_ID}
  jira:
    url: https://company.atlassian.net
    email: ${JIRA_EMAIL}
    api_token: ${JIRA_TOKEN}
    project_key: PROJ

backlog_manager:
  mcp_server: http://localhost:8000  # or remote URL
  api_base: http://localhost:8000/api
```

---

## Integration Examples

### End-to-End Workflow

**Scenario:** New research → backlog → delivery

1. **Discovery Phase:**
   ```
   User: "Analyze Research/Auth deep dive.md"
   discovery-publish: [Creates/splits items 45, 46, 47]
   ```

2. **Planning Phase:**
   ```
   User: "Plan next sprint"
   backlog-planning: [Pulls items, generates Context Packs]
   ```

3. **Sync Phase:**
   ```
   User: "Sync items 45, 46 to Linear"
   backlog-sync: [Creates LIN-123, LIN-124]
   ```

4. **Evolution Phase (Later):**
   ```
   User: "Check backlog health"
   backlog-evolution: [Suggests improvements based on new insights]
   ```

### With Hooks (Future)

**post-research-save hook:**
```bash
# Automatically triggers after saving research note
if note_has_tag "backlog"; then
  claude skill discovery-publish "$NOTE_PATH"
fi
```

**pre-planning-session hook:**
```bash
# Runs before planning meeting
claude skill backlog-evolution --quick-check
claude skill backlog-planning --agenda-only
```

---

## MCP Tool Reference

### Core MCP Tools (from Backlog Manager)

**Backlog Item CRUD:**
- `create_backlog_item(title, description, priority, labels)`
- `get_backlog_items(status, priority, labels, limit)`
- `update_backlog_item(item_id, ...)`
- `get_item_evolution_history(item_id)`

**AI-Assisted Evolution:**
- `split_backlog_item(item_id, new_items, rationale)`
- `merge_backlog_items(item_ids, merged_title, merged_description, rationale)`
- `suggest_item_evolution(item_id, new_context)`

**Search & Discovery:**
- `semantic_search(query, limit)`

**Status & Sync:**
- `get_delivery_status(item_id)`

**Vision & Context:**
- `get_vision_doc(doc_type, title, latest)`
- `update_vision_doc(doc_type, title, content, tags)`

### REST API Endpoints (from Backlog Manager)

**Delivery Tool Integration:**
- `POST /api/items/{item_id}/sync` - Record external ticket ID
- `POST /api/webhooks/{tool}` - Receive status updates from delivery tools
- `GET /api/items` - List items (for delivery tool polling)

---

## Installation & Setup

### 1. Install Backlog Manager

```bash
# Clone Backlog Manager repo
git clone https://github.com/your-org/backlog-manager.git
cd backlog-manager

# Install dependencies
pip install -r requirements.txt

# Initialize database
python init_db.py

# Start MCP server + REST API
python bridge.py
```

### 2. Configure MCP

Add to Claude Code MCP config:

```json
{
  "mcpServers": {
    "backlog-manager": {
      "command": "python",
      "args": ["/path/to/backlog-manager/mcp_server.py"],
      "env": {
        "BACKLOG_DB": "/path/to/backlog.db"
      }
    }
  }
}
```

### 3. Install Skills

```bash
# If using marketplace
claude skill install backlog-manager-skills

# Or manually copy to .claude/skills/
cp -r backlog-manager-skills ~/.claude/skills/
```

### 4. Test

```bash
# Test MCP connection
claude "List backlog items"

# Test skill
claude skill backlog-planning
```

---

## Troubleshooting

### MCP Server Not Found

**Error:** `MCP tool 'get_backlog_items' not available`

**Solution:**
- Check Backlog Manager is running: `curl http://localhost:8000/api/items`
- Verify MCP config in Claude Code settings
- Restart Claude Code

### Delivery Tool API Errors

**Error:** `Failed to create Linear issue: 401 Unauthorized`

**Solution:**
- Check API key in `.backlog-manager/config.yaml`
- Verify key has correct permissions
- Test manually: `curl -H "Authorization: $LINEAR_API_KEY" https://api.linear.app/graphql`

### Skill Not Found

**Error:** `Skill 'backlog-planning' not found`

**Solution:**
- Check skills installed: `ls ~/.claude/skills/`
- Reinstall bundle: `claude skill install backlog-manager-skills`

---

## Future Enhancements

### Planned Features

1. **Automatic sync triggers**
   - Hooks that auto-sync when items marked "ready"
   - Webhook handlers for delivery tool events

2. **Relevance AI integration**
   - Weekly backlog health reports
   - Automated priority suggestions based on research velocity

3. **Multi-repo support**
   - One backlog → multiple delivery repos
   - Cross-team coordination

4. **Analytics & Insights**
   - Velocity tracking (backlog → delivery time)
   - Evolution patterns (how items change over time)
   - Research impact (which research led to which features)

---

## Related Documentation

- [[Backlog Manager]] - Core bridge layer specification
- [[Capability Discovery Bundle]] - Used by skills to check MCP availability
- [[Marketplace Management Bundle]] - For installing/updating this bundle

---

**Status:** Draft Specification
**Version:** 0.1
**Last Updated:** 2025-11-02
