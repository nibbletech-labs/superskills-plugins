# SQLite Query Helper Skill - Specification

**Created:** 2025-11-05
**Status:** Proposed
**Priority:** High
**Category:** Database & Data Analysis

---

## Executive Summary

Create a Claude Code skill that enables efficient SQLite database querying using native CLI commands with JSON output. This skill provides 90% of the SQLite MCP server's value with zero installation overhead by leveraging sqlite3's built-in `-json` flag.

**Key Insight:** sqlite3 CLI (v3.33.0+) supports native JSON output, eliminating the need for a Python-based MCP server for most use cases.

---

## Why This Skill Exists

### The Core Problem

**MCP servers were designed for remote services** (GitHub API, Stripe, Notion), not local CLI tools. However, several "reference implementation" MCP servers exist for local tools like Git, SQLite, and Filesystem.

**For SQLite specifically:**
- Claude Code can already run `sqlite3` commands via Bash
- But sqlite3 returns plain text tables, not structured data
- Claude must parse inconsistent text output → error-prone
- The SQLite MCP server solved this by wrapping Python's sqlite3 library to return structured data

### The Discovery

**sqlite3 CLI has native JSON support since v3.33.0 (August 2020)!**

```bash
sqlite3 -json database.db "SELECT * FROM users"
# Returns: [{"id":1,"name":"Alice"}]  ← Perfect JSON!
```

This means:
- ✅ We get structured data WITHOUT needing an MCP server
- ✅ No Python dependencies
- ✅ No MCP setup complexity
- ✅ Faster and more direct

### Why Build a Skill Instead of Using MCP?

**1. Token Efficiency**
- **MCP Server:** Loads thousands of tokens for tool definitions
- **Skill:** 30-50 tokens until actually needed
- **Impact:** 100x more efficient

**2. Simplicity**
- **MCP Server:** 401 lines Python code, dependencies, configuration
- **Skill:** Markdown file teaching `sqlite3 -json` usage
- **Impact:** 10x simpler

**3. Accessibility**
- **MCP Server:** Requires Python, pip, MCP setup
- **Skill:** Works if sqlite3 is installed (99% of systems)
- **Impact:** Zero barrier to entry

**4. Alignment with MCP's Purpose**
- **MCP Design:** For remote services that need APIs
- **SQLite:** Local database, has CLI, doesn't need MCP abstraction
- **Skills Design:** Perfect for teaching CLI patterns
- **Impact:** Using right tool for the job

### Why Not Just Keep Using Direct CLI?

**Without skill:** Claude knows about sqlite3, but doesn't know about:
- The `-json` flag existence (not widely documented)
- Best practices for JSON output
- Common analytical patterns
- Error handling strategies
- Business intelligence workflows

**With skill:** Claude learns:
- Use `-json` for all SELECT queries
- Specific PRAGMA commands for schema
- Patterns for analytics (GROUP BY, JOIN, window functions)
- How to track insights across queries
- Error recovery strategies

**The skill bridges the gap between "Claude knows sqlite3 exists" and "Claude uses it effectively for structured data work."**

### The Bigger Picture

This skill is part of a pattern:

**Thesis:** Many local tool MCP servers (Git, SQLite, Filesystem) exist as reference implementations, but **skills are more appropriate** for local tools because:
1. Skills don't consume context until needed
2. Local tools already have CLIs
3. Skills can teach best practices, not just wrap commands
4. MCP's value is in remote service integration, not CLI abstraction

**This SQLite skill proves the thesis** by delivering better UX than the MCP alternative.

### Strategic Value for SuperSkills

**Why this matters for the marketplace:**

1. **Demonstrates skills vs MCPs** - Shows when each is appropriate
2. **Provides alternatives** - Users can choose based on needs
3. **Builds skill catalog** - Currently only have MCP servers
4. **Educational value** - Teaches effective CLI patterns
5. **Differentiator** - Other marketplaces only have MCPs

**By creating this skill, SuperSkills becomes:**
- Not just an "MCP marketplace"
- But a "Claude Code extensions marketplace" (MCPs AND skills)
- Offering the right tool for each job

---

## Summary: Why This Skill?

**The "Why" in one sentence:**
This skill exists because sqlite3's native JSON output makes MCP server complexity unnecessary for local database work, and skills are the right tool for teaching effective CLI usage patterns.

**The strategic "Why":**
Demonstrates that SuperSkills understands the ecosystem deeply enough to recommend skills over MCPs when appropriate, building trust and providing superior user experience.

---

## Problem Statement

### Current Situation

Users working with SQLite databases have two options:

1. **SQLite MCP Server** (Current approach)
   - 401 lines of Python code
   - Requires Python + dependencies + MCP setup
   - Provides JSON output via Python library
   - Complex installation and configuration

2. **Direct sqlite3 CLI** (Common approach)
   - Returns plain text tables
   - Claude must parse inconsistent text output
   - No structured data format
   - Prone to parsing errors

### The Gap

**There's a better third option:** Native sqlite3 with `-json` flag
- Built into sqlite3 CLI since v3.33.0 (August 2020)
- Returns proper JSON arrays
- Zero additional dependencies
- Already installed on most systems

### Opportunity

Create a skill that teaches Claude to use `sqlite3 -json` for structured data access, providing MCP-like benefits without MCP complexity.

---

## Goals & Non-Goals

### Goals

✅ Enable Claude to query SQLite databases with JSON output
✅ Provide schema inspection commands
✅ Support common data analysis workflows
✅ Handle errors gracefully
✅ Zero installation overhead
✅ Cross-platform compatibility (Mac, Linux, Windows with sqlite3)

### Non-Goals

❌ Replace the SQLite MCP server entirely (users can still choose MCP)
❌ Implement persistent insights memo (MCP-specific feature)
❌ Provide connection pooling (each command is isolated)
❌ Support databases Claude can't access via filesystem

---

## User Stories

### Story 1: Data Explorer
**As a** developer with a local SQLite database
**I want to** query and explore data using natural language
**So that** I can quickly understand database structure and contents

**Example interaction:**
```
User: "What tables are in database.db?"
Claude: *Uses skill* → sqlite3 database.db ".tables"
Output: users  orders  products

User: "Show me all users"
Claude: *Uses skill* → sqlite3 -json database.db "SELECT * FROM users"
Output: [{"id":1,"name":"Alice","email":"alice@example.com"}]
```

### Story 2: Business Analyst
**As a** data analyst
**I want to** generate reports from SQLite databases
**So that** I can create insights without writing SQL manually

**Example interaction:**
```
User: "How many orders per customer?"
Claude: *Uses skill* → sqlite3 -json database.db "
  SELECT users.name, COUNT(orders.id) as order_count
  FROM users
  LEFT JOIN orders ON users.id = orders.user_id
  GROUP BY users.id
"
Output: [{"name":"Alice","order_count":5},{"name":"Bob","order_count":3}]
```

### Story 3: Data Migrator
**As a** developer
**I want to** modify database structure and data
**So that** I can evolve my schema and fix data issues

**Example interaction:**
```
User: "Add a 'created_at' column to users table"
Claude: *Uses skill* → sqlite3 database.db "
  ALTER TABLE users ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
"
```

---

## Technical Specification

### Core Commands

#### 1. Query Data (JSON Output)
```bash
sqlite3 -json /path/to/database.db "SELECT * FROM table_name"
```

**Output Format:**
```json
[
  {"column1": "value1", "column2": "value2"},
  {"column1": "value3", "column2": "value4"}
]
```

#### 2. Inspect Schema
```bash
# List tables
sqlite3 /path/to/database.db ".tables"

# Show table DDL
sqlite3 /path/to/database.db ".schema table_name"

# Get column details (JSON)
sqlite3 -json /path/to/database.db "PRAGMA table_info(table_name)"
```

**PRAGMA output:**
```json
[
  {"cid":0,"name":"id","type":"INTEGER","notnull":0,"dflt_value":null,"pk":1},
  {"cid":1,"name":"name","type":"TEXT","notnull":1,"dflt_value":null,"pk":0}
]
```

#### 3. Write Operations
```bash
# INSERT with row count
sqlite3 -json /path/to/database.db "
  INSERT INTO users (name, email) VALUES ('Charlie', 'charlie@example.com');
  SELECT changes() as rows_inserted;
"

# UPDATE with affected rows
sqlite3 -json /path/to/database.db "
  UPDATE users SET email = 'new@example.com' WHERE id = 1;
  SELECT changes() as rows_updated;
"

# DELETE with count
sqlite3 -json /path/to/database.db "
  DELETE FROM users WHERE id = 999;
  SELECT changes() as rows_deleted;
"
```

#### 4. Advanced Analytics
```bash
# Aggregations
sqlite3 -json /path/to/database.db "
  SELECT
    category,
    COUNT(*) as count,
    AVG(price) as avg_price,
    SUM(quantity) as total_quantity
  FROM products
  GROUP BY category
  ORDER BY count DESC
"

# Joins
sqlite3 -json /path/to/database.db "
  SELECT u.name, o.order_date, o.total
  FROM users u
  INNER JOIN orders o ON u.id = o.user_id
  WHERE o.order_date > '2025-01-01'
"

# Window functions
sqlite3 -json /path/to/database.db "
  SELECT
    name,
    sales,
    RANK() OVER (ORDER BY sales DESC) as sales_rank
  FROM salespeople
"
```

### Error Handling

**Exit codes:**
- 0 = Success
- 1 = Error (check stderr for message)

**Common errors:**
```bash
# Table doesn't exist
Error: in prepare, no such table: table_name

# Syntax error
Error: near "SELCT": syntax error

# Database locked
Error: database is locked

# File not found
Error: unable to open database file
```

**Error handling pattern:**
```bash
if output=$(sqlite3 -json db.db "query" 2>&1); then
  echo "$output"  # Success - JSON data
else
  echo "Error: $output"  # Failure - error message
fi
```

### Browser Compatibility

**Minimum Version:** SQLite 3.33.0 (August 2020)
**JSON Support Added:** Version 3.33.0
**Recommended:** 3.35.0+ (March 2021)
**Current:** Most systems have 3.40+ (2023)

**Check version:**
```bash
sqlite3 --version
# Output: 3.43.0 2023-08-24 12:36:59

# Check JSON support
sqlite3 --help | grep json
# Should show: -json  set output mode to JSON
```

---

## Skill Structure

### File Organization

```
sqlite-query-helper/
├── SKILL.md                    # Main skill instructions
├── references/
│   ├── sql-patterns.md         # Common SQL query patterns
│   └── error-reference.md      # SQLite error codes and solutions
└── scripts/
    └── analyze-db.sh           # Helper script for database analysis
```

### SKILL.md Outline

```markdown
---
name: sqlite-query-helper
description: Query and analyze SQLite databases using native CLI with JSON output. This skill should be used when working with local SQLite database files, performing data analysis, generating reports, or inspecting database schemas. Uses sqlite3 -json for structured output.
---

# SQLite Query Helper

## Overview

Query, inspect, and analyze SQLite databases using the native sqlite3 CLI with JSON output. No installation required - works with the sqlite3 command available on most systems.

## When to Use This Skill

Trigger when:
- User mentions SQLite, .db files, or local databases
- User asks to query, inspect, or analyze database files
- User needs structured data output from SQLite
- User wants to generate reports from SQLite data

Examples:
- "What's in this database.db file?"
- "Query the users table and show me the results"
- "Generate a report of sales by category"
- "How many records are in each table?"

## Prerequisites Check

Before using sqlite3 commands, verify version:

\`\`\`bash
sqlite3 --version
\`\`\`

Required: SQLite 3.33.0 or later (for JSON support)

If older version, inform user and suggest upgrade or use text mode.

## Core Capabilities

### 1. Reading Data (SELECT Queries)

**Basic query:**
\`\`\`bash
sqlite3 -json /path/to/database.db "SELECT * FROM table_name"
\`\`\`

**With conditions:**
\`\`\`bash
sqlite3 -json database.db "SELECT * FROM users WHERE age > 25"
\`\`\`

**With pagination:**
\`\`\`bash
sqlite3 -json database.db "SELECT * FROM products ORDER BY price DESC LIMIT 10"
\`\`\`

**Output:** JSON array of objects

### 2. Schema Inspection

**List all tables:**
\`\`\`bash
sqlite3 database.db ".tables"
\`\`\`

**Show table DDL:**
\`\`\`bash
sqlite3 database.db ".schema table_name"
\`\`\`

**Get column details (JSON):**
\`\`\`bash
sqlite3 -json database.db "PRAGMA table_info(table_name)"
\`\`\`

### 3. Data Analysis Patterns

Consult `references/sql-patterns.md` for common analytical queries:
- Aggregations (COUNT, SUM, AVG)
- Grouping and filtering
- Joins across tables
- Window functions
- Date/time analysis

### 4. Write Operations

**Insert data:**
\`\`\`bash
sqlite3 -json database.db "
  INSERT INTO users (name, email) VALUES ('Alice', 'alice@example.com');
  SELECT changes() as rows_inserted;
"
\`\`\`

**Update records:**
\`\`\`bash
sqlite3 -json database.db "
  UPDATE users SET status = 'active' WHERE last_login > '2025-01-01';
  SELECT changes() as rows_updated;
"
\`\`\`

## Business Intelligence Workflow

When conducting database analysis:

1. **Start with exploration**
   - List tables
   - Check schema for each table
   - Sample data (LIMIT 5)

2. **Build understanding**
   - Identify primary/foreign keys
   - Note relationships between tables
   - Check data quality (nulls, duplicates)

3. **Perform analysis**
   - Answer specific questions with queries
   - Track insights in conversation
   - Document findings

4. **Summarize discoveries**
   - Key metrics found
   - Data quality issues
   - Business rules inferred
   - Recommendations

## Error Handling

Check exit codes and stderr for errors:

\`\`\`bash
if output=$(sqlite3 -json db.db "query" 2>&1); then
  # Success - process JSON
else
  # Error - explain to user
fi
\`\`\`

Consult `references/error-reference.md` for common errors and solutions.

## Resources

### references/sql-patterns.md
Common SQL query patterns for analytics and reporting.

### references/error-reference.md
SQLite error codes and troubleshooting guide.

### scripts/analyze-db.sh
Helper script for quick database analysis (tables, row counts, sizes).
```

---

## Implementation Plan

### Phase 1: Basic Skill
- SKILL.md with core commands
- Cover SELECT, PRAGMA, basic writes
- Simple error handling

### Phase 2: Enhanced References
- SQL patterns reference
- Error reference
- Common analytics queries

### Phase 3: Helper Scripts
- analyze-db.sh for quick inspection
- Optional: export-to-csv.sh

### Phase 4: Testing & Iteration
- Test with real databases
- Gather user feedback
- Refine command patterns

---

## Success Criteria

**Skill is successful if:**
- ✅ Users can query SQLite databases without knowing SQL syntax
- ✅ Results always returned as proper JSON
- ✅ Common analytics tasks take <5 messages
- ✅ Error messages are clear and actionable
- ✅ Works on Mac, Linux, Windows (with sqlite3 installed)

**Skill is preferred over MCP if:**
- ✅ Faster setup (zero config)
- ✅ Simpler mental model (just commands)
- ✅ More reliable (no Python dependencies)
- ✅ Token efficient (skill only loads when needed)

---

## Comparison: Skill vs MCP Server

| Feature | SQLite Skill | SQLite MCP Server |
|---------|-------------|------------------|
| **Installation** | None (uses sqlite3 CLI) | Python + dependencies + MCP config |
| **JSON Output** | Native (`-json` flag) | Converted (Python dicts → string) |
| **Complexity** | ~200 line skill | 401 line Python server |
| **Token Usage** | 30-50 tokens (until loaded) | Thousands of tokens |
| **Schema Inspect** | PRAGMA + .mode json | PRAGMA via Python |
| **Write Ops** | SELECT changes() for counts | Returns row count |
| **Insights Memo** | Track in conversation | Persistent memo:// resource |
| **Setup Time** | 0 seconds | 5-10 minutes |
| **Portability** | Works anywhere sqlite3 exists | Requires Python environment |

### When to Use Each

**Use Skill for:**
- Quick database exploration
- Ad-hoc queries and reports
- Systems without Python
- Simple data analysis
- Learning SQL
- CI/CD pipelines
- Zero-setup requirement

**Use MCP Server for:**
- Long analysis sessions (persistent insights)
- Want MCP resource integration
- Building dashboards with updates
- Prefer structured tool definitions
- Already have Python + MCP setup

---

## Example Use Cases

### Use Case 1: Database Discovery
```
User: "What's in this app.db file?"

Claude uses skill:
1. sqlite3 app.db ".tables"
   → users, orders, products
2. sqlite3 -json app.db "PRAGMA table_info(users)"
   → [{"name":"id","type":"INTEGER","pk":1}, ...]
3. sqlite3 -json app.db "SELECT * FROM users LIMIT 3"
   → [{"id":1,"name":"Alice"}, ...]

Response: "The database has 3 tables. Users table has 145 records..."
```

### Use Case 2: Sales Report
```
User: "Generate monthly sales report from sales.db"

Claude uses skill:
sqlite3 -json sales.db "
  SELECT
    strftime('%Y-%m', sale_date) as month,
    COUNT(*) as transactions,
    SUM(amount) as total_sales,
    AVG(amount) as avg_transaction
  FROM sales
  WHERE sale_date >= '2025-01-01'
  GROUP BY month
  ORDER BY month
"

Response: Formatted table with monthly breakdown
```

### Use Case 3: Data Quality Check
```
User: "Check for data issues in customer.db"

Claude uses skill:
1. Count nulls: SELECT COUNT(*) FROM customers WHERE email IS NULL
2. Find duplicates: SELECT email, COUNT(*) FROM customers GROUP BY email HAVING COUNT(*) > 1
3. Check date ranges: SELECT MIN(created_at), MAX(created_at) FROM customers

Response: "Found 12 records with missing emails, 3 duplicate emails..."
```

---

## Implementation Details

### Skill Components

**1. SKILL.md (Core Instructions)**
- Command syntax and patterns
- When to use -json flag
- Schema inspection methods
- Common query patterns
- Error handling
- Business intelligence workflow
- 200-300 lines

**2. references/sql-patterns.md**
- 50+ common SQL query patterns
- Analytics queries (aggregations, joins, window functions)
- Data quality checks
- Date/time operations
- String manipulation
- Organized by use case

**3. references/error-reference.md**
- Common SQLite errors
- Solutions and workarounds
- Troubleshooting guide
- Version compatibility notes

**4. scripts/analyze-db.sh** (Optional)
- Quick database analysis script
- Shows: tables, row counts, total size
- Sample data from each table
- Schema overview

### Command Patterns to Include

**Essential patterns:**
```bash
# Basic query
sqlite3 -json db.db "SELECT * FROM table"

# Aggregation
sqlite3 -json db.db "SELECT category, COUNT(*), AVG(price) FROM products GROUP BY category"

# Join
sqlite3 -json db.db "SELECT * FROM users u JOIN orders o ON u.id = o.user_id"

# Schema
sqlite3 -json db.db "PRAGMA table_info(table)"

# Write + count
sqlite3 -json db.db "INSERT INTO users VALUES (...); SELECT changes()"

# List tables
sqlite3 db.db ".tables"

# Export
sqlite3 -csv db.db "SELECT * FROM users" > users.csv
```

---

## Advantages Over MCP Server

1. **Zero Installation** - sqlite3 already installed on most systems
2. **Simpler** - No Python, no dependencies, no MCP config
3. **Faster Setup** - Start using immediately
4. **Better JSON** - Native JSON output (not Python string repr)
5. **Token Efficient** - Skill loads only when needed (30-50 tokens)
6. **Easier Debugging** - Direct commands, visible in terminal
7. **Portable** - Works anywhere sqlite3 exists
8. **Learning Friendly** - Users see actual SQL commands

---

## Disadvantages vs MCP Server

1. **No Persistent Insights** - Memo must be tracked in conversation
2. **No Resource Notifications** - Can't subscribe to updates
3. **Path Repetition** - Must specify database path each time
4. **Isolated Commands** - No connection pooling
5. **No MCP Integration** - Doesn't appear in MCP tooling/dashboards

---

## Migration Path

**For existing SQLite MCP users:**

1. **Try the skill first** - Zero setup, see if it meets needs
2. **Compare experience** - Is the simplicity worth losing persistent insights?
3. **Choose based on workflow:**
   - Occasional queries → Use skill
   - Daily analysis → Consider MCP
4. **Hybrid approach** - Use both (skill for quick queries, MCP for projects)

**For new users:**

1. **Start with skill** - No barrier to entry
2. **Evaluate after 1 week** - Does it meet needs?
3. **Upgrade to MCP** if needed - But most won't need to

---

## Development Effort Estimate

**Phase 1: Basic Skill (2-3 hours)**
- Write SKILL.md with core commands
- Test with sample databases
- Basic error handling

**Phase 2: Reference Docs (2-3 hours)**
- Create SQL patterns reference
- Create error reference
- Common analytics queries

**Phase 3: Helper Scripts (1-2 hours)**
- analyze-db.sh script
- Test across platforms

**Phase 4: Polish & Package (1 hour)**
- Final testing
- Package with skill-creator
- Documentation

**Total: 6-9 hours**

---

## Success Metrics

Track adoption and compare with MCP:

**Metrics to monitor:**
- Number of skill invocations vs MCP server usage
- User satisfaction (qualitative feedback)
- Time to first query (skill vs MCP)
- Query success rate
- Token usage comparison

**Target:**
- 80% of SQLite users choose skill over MCP
- <1 minute to first successful query
- 90%+ query success rate
- 10x less tokens than MCP approach

---

## Risks & Mitigation

### Risk 1: Older SQLite Versions
**Mitigation:** Skill checks version first, provides upgrade instructions

### Risk 2: Complex Workflows Need State
**Mitigation:** Skill teaches Claude to maintain insights in conversation

### Risk 3: Users Prefer MCP Abstraction
**Mitigation:** Keep MCP in catalog, let users choose

### Risk 4: Platform Differences (Windows)
**Mitigation:** Test on Windows, provide platform-specific notes

---

## Future Enhancements

**V1.1:**
- Add CSV export patterns
- Add backup/restore commands
- Add vacuum and optimize patterns

**V1.2:**
- Add data visualization helpers (generate charts from results)
- Add migration script generator
- Add test data generator

**V2.0:**
- Integration with other skills (Excel analysis)
- Multi-database queries
- Schema diff tools

---

## References

- SQLite JSON Mode Docs: https://www.sqlite.org/cli.html#json_output_mode
- SQLite Changelog 3.33.0: https://www.sqlite.org/releaselog/3_33_0.html
- SQLite PRAGMA: https://www.sqlite.org/pragma.html
- SQL Tutorial: https://www.sqlitetutorial.net

---

## Decision

**RECOMMENDATION: BUILD THIS SKILL**

**Rationale:**
1. Native JSON support eliminates MCP server's main value prop
2. Significantly simpler than MCP (zero setup vs complex config)
3. More token efficient (skills > MCP for token usage)
4. Provides 90% of functionality with 10% of complexity
5. Better user experience for casual database work
6. Demonstrates skills as superior alternative to local tool MCPs

**Next Steps:**
1. Create SKILL.md with core commands
2. Add SQL patterns reference
3. Test with real databases
4. Package and distribute
5. Add to SuperSkills marketplace
6. Monitor adoption vs SQLite MCP

**Status:** Ready for implementation ✅

---

**Document Version:** 1.0
**Last Updated:** 2025-11-05
**Author:** NibbleTech Labs
**Project:** SuperSkills
