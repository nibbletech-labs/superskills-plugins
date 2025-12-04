# Plugin Ecosystem Tracker

Comprehensive tracker of all Claude Code plugins, skills, bundles, and agents across their development lifecycle.

**Last Updated:** November 28, 2025

**Related Project:** [SuperSkills](../../superskills/docs/platform/PRODUCT_SPEC.md) - Marketplace platform for distributing these plugins

---

## Overview

**Total Count:** 19 plugins tracked

**Status Breakdown:**
- 🏗️ **Implemented:** 1 plugin (built and packaged)
- ✅ **Spec Complete:** 8 plugins (ready to build)
- 🔬 **Researching:** 2 plugins (active investigation)
- 🔄 **Spec Needed:** 3 plugins (idea with some details)
- 💡 **Ideas Only:** 5 plugins (concepts to explore)

---

## 🏗️ Implemented (Built and Packaged)

### Database & Data Tools

#### Supabase CLI Expert
**Type:** Skill
**Status:** 🏗️ Implemented
**Location:** [skills/supabase-cli-expert/](../skills/supabase-cli-expert/)
**Package:** `supabase-cli-expert.zip` (ready for distribution)
**Description:** Comprehensive Supabase CLI expertise skill covering connection management, migrations, RLS policies, Edge Functions, and database branching. Includes validation scripts and extensive reference documentation.
**Key Features:**
- Connection type guidance (Direct, Session Pooler, Transaction Pooler, Dedicated Pooler)
- IPv4/IPv6 connectivity troubleshooting
- Migration workflow (new, diff, push, pull, reset)
- 15+ RLS policy patterns with performance optimization
- Edge Function development and deployment
- Database branching for preview environments
- Connection validation script

**Bundled Resources:**
- Scripts: `validate_connection.sh` (diagnoses connection issues)
- References: `rls-patterns.md`, `migration-templates.md`, `troubleshooting-guide.md`

**Use Cases:** Setting up Supabase projects, debugging connection issues, writing secure RLS policies, managing migrations, deploying Edge Functions
**Strategic Value:** First fully implemented skill - proves the skill development workflow. Covers widely-used platform with complex CLI.
**Last Updated:** Nov 28, 2025

---

## ✅ Spec Complete (Ready to Build)

### Infrastructure

#### Capability Discovery Bundle
**Type:** Bundle (Hook + Skill)
**Status:** ✅ Spec Complete
**Doc:** [specs/capability-discovery-bundle-spec.md](specs/capability-discovery-bundle-spec.md)
**Description:** Hook generates manifest at session start, skill provides fast capability lookups and MCP name mapping.
**Strategic Value:** Foundational - used by other skills to check what's available
**Last Updated:** Nov 5, 2025

#### Marketplace Management Bundle
**Type:** Bundle (Dual Skills)
**Status:** ✅ Spec Complete
**Doc:** ../../superskills/docs/specs/marketplace-management-bundle-spec.md
**Description:** Dual-skill bundle for SuperSkills marketplace interaction. superskills-browser discovers/installs skills conversationally, superskills-updater checks/applies updates. Zero configuration for public bundles.
**Strategic Value:** Platform skill - auto-included in all marketplace bundles. Integrates with capability-discovery.
**Last Updated:** Nov 3, 2025

---

### Skill Development Ecosystem

#### Skill Analyzer
**Type:** Skill
**Status:** ✅ Spec Complete
**Doc:** [specs/skill-analyzer-spec.md](specs/skill-analyzer-spec.md)
**Description:** Quality assurance and optimization skill for EXISTING Claude Code skills. Evaluates skills across 6 dimensions (Metadata Effectiveness, Progressive Disclosure, Invocation Triggers, Content Quality, Resource Organization, Best Practices). Generates scored reports (0-100, A-F) with actionable improvement recommendations.
**Complements:** skill-creator (Anthropic's skill creation guide)
**Key Features:**
- Dimensional analysis with weighted scoring
- Invocation trigger prediction (false positive/negative detection)
- Progressive disclosure efficiency measurement
- Prioritized improvement roadmap (Critical/Important/Nice-to-have)
- Interactive drill-down into findings

**Bundled Resources:** Scripts (analyze_skill.py, generate_report.py, validate_invocation.py), References (best-practices, anti-patterns, improvement-examples, scoring-rubric)
**Use Cases:** Skill quality validation, optimization for context efficiency, debugging invocation issues
**Strategic Value:** Completes the skill development lifecycle (Create → Use → Analyze → Improve → Validate)
**Last Updated:** Nov 5, 2025

#### Spec Analyzer
**Type:** Skill
**Status:** ✅ Spec Complete
**Doc:** [specs/spec-analyzer-spec.md](specs/spec-analyzer-spec.md)
**Description:** Pre-build validation skill that evaluates skill specification DOCUMENTS before implementation begins. Acts as quality gate between ideation and building—ensures specs are complete, clear, and feasible before investing hours in development.
**Lifecycle Position:** Ideate → Spec → **Validate (spec-analyzer)** → Build (skill-creator) → Use → Optimize (skill-analyzer)
**Key Features:**
- 6-dimensional analysis: Completeness (30%), Scope (25%), Invocation (20%), Resources (15%), Feasibility (10%), Quality (10%)
- skill-creator consultation (validates against its requirements)
- Dual-mode operation: Quick check (2 min) vs Full analysis (5 min)
- Scope detection (identifies multi-skill specs that should be split)
- Writes validation metadata to spec YAML frontmatter

**Strategic Value:** Prevents wasted implementation time by catching spec issues early. Saves 2-10 hours per skill by validating BEFORE building.
**Last Updated:** Nov 5, 2025

#### Skill Development Coach
**Type:** Skill
**Status:** ✅ Spec Complete
**Doc:** [specs/skill-development-coach-spec.md](specs/skill-development-coach-spec.md)
**Description:** Lightweight shepherd skill that guides users through the complete skill development lifecycle without separate state tracking. Detects current stage by examining files (specs/skills) in working directory, reads metadata from YAML frontmatter, and invokes the appropriate tool at each stage with soft enforcement of quality gates.
**Orchestrates:** spec-analyzer (validation), skill-creator (Anthropic's building tool), skill-analyzer (optimization)
**Core Behaviors:**
- Ask, don't assume (never assumes file absence means starting fresh)
- Detect from files (infers stage from file presence and YAML metadata)
- Soft enforcement (strongly recommends best practices but allows skipping)
- Idempotent (can re-run analyses anytime)
- Works WITH skill-creator (invokes Anthropic's tool at the right time)

**Strategic Value:** Completes the skill development ecosystem. Provides structure without rigidity. Enables quality gates while preserving user control.
**Last Updated:** Nov 5, 2025

---

### Code Analysis & Understanding

#### Git Repository Analyzer
**Type:** Skill
**Status:** ✅ Spec Complete
**Doc:** [specs/git-repo-analyzer-spec.md](specs/git-repo-analyzer-spec.md)
**Description:** Deep repository analysis with customizable templates. Clones repos, analyzes functionality/architecture/purpose, generates comparison matrices. Goes beyond surface metadata to understand how things work and why they exist.
**Key Features:** Template customization, hybrid output (individual + comparison), systematic deep analysis
**Use Cases:** Framework comparison (SDLC, build tools), library evaluation, codebase understanding
**Strategic Value:** Demonstrates skills > MCPs for analysis workflows, modular data gatherer design
**Estimated Effort:** 14-18 hours to build
**Last Updated:** Nov 5, 2025

---

### Database & Data Tools

#### SQLite Query Helper
**Type:** Skill
**Status:** ✅ Spec Complete
**Doc:** [specs/sqlite-skill-spec.md](specs/sqlite-skill-spec.md)
**Description:** Query and analyze SQLite databases using native CLI with JSON output. Demonstrates that skills can replace local tool MCP servers with better UX and zero setup. Uses sqlite3's built-in `-json` flag for structured data.
**Strategic Value:** Token-efficient alternative to SQLite MCP server, proves thesis that skills > MCPs for local tools. First skill to replace an MCP server - educational for marketplace.
**Last Updated:** Nov 5, 2025

---

### Research & Content Tools

#### Web Image Extractor
**Type:** Skill
**Status:** ✅ Spec Complete
**Doc:** [specs/web-image-extractor-spec.md](specs/web-image-extractor-spec.md)
**Description:** Intelligently extracts and downloads meaningful images from web pages using any available tool (WebFetch, Firecrawl MCP, Google DevTools MCP). Filters out nav/ads/icons, generates descriptive filenames. Demonstrates Skill-Orchestrated MCP pattern.
**Use Cases:** Research visual evidence, blog post images, technical diagrams
**Note:** Tool-agnostic with fallback chain, works with native tools only
**Last Updated:** Nov 5, 2025

---

## 🔬 Researching (Active Investigation)

### Research Plugin
**Type:** Plugin (Multi-component)
**Status:** 🔬 Researching
**Doc:** [specs/research-plugin-spec.md](specs/research-plugin-spec.md)
**Description:** Multi-platform deep research with dynamic iteration. Claude decides when to stop.
**Note:** Large specification (42k+ tokens) - comprehensive research tool
**Last Updated:** Nov 5, 2025

### Form Assistant
**Type:** Skill
**Status:** 🔬 Researching
**Doc:** [specs/form-assistant-spec.md](specs/form-assistant-spec.md)
**Description:** Intelligent PDF form completion with research-driven confidence scoring. Analyzes forms, researches requirements, generates success criteria, drafts answers, and iteratively refines until confidence thresholds met.
**Dependencies:** PDF skill for form reading/filling
**Last Updated:** Nov 5, 2025

---

## 🔄 Spec Needed (Idea with Details)

### Backlog Manager Skills Bundle
**Type:** Bundle (4 Skills)
**Status:** 🔄 Spec Needed
**Doc:** [specs/backlog-manager-bundle-spec.md](specs/backlog-manager-bundle-spec.md)
**Description:** Skills for AI-assisted backlog management. Includes planning sessions, discovery publishing, backlog evolution, and delivery tool sync. Integrates with Backlog Manager MCP server.
**Skills:** backlog-planning, discovery-publish, backlog-evolution, backlog-sync
**Dependencies:** Backlog Manager bridge layer (MCP server + REST API)
**Last Updated:** Nov 5, 2025

### Gemini CLI Interface
**Type:** Skill
**Status:** 🔄 Spec Needed
**Description:** Interface to Google Gemini CLI for free web search (1M context, 1,000/day).
**Used By:** Research skill
**Value:** Free alternative to paid search APIs

### Codex CLI (ChatGPT) Interface
**Type:** Skill
**Status:** 🔄 Spec Needed
**Description:** Interface to OpenAI Codex CLI for ChatGPT access using your account (no API costs).
**Used By:** Research skill for alternative searches
**Value:** Highest accuracy search without API costs

---

## 💡 Ideas Only (Concepts to Explore)

### Knowledge Management

#### Second Brain Access
**Type:** Skill
**Status:** 💡 Idea
**Description:** Skill that informs Claude about the location and structure of personal knowledge repositories (Obsidian vaults, project folders, documentation). Provides context about where to find project files, specs, notes, and documentation.
**Example Locations:**
- Obsidian Vault: `/Users/tom/Local_Projects/Obsidian/Tom's Vault/`
- Project Specs: `.../Tom's Vault/Projects/Plugin Manager/Specs/`
- Active Projects: `/Users/tom/Local_Projects/`

**Use Cases:** Finding project documentation, locating specs, accessing notes, understanding project structure
**Value:** Reduces need to specify file paths, Claude knows where things are organized

---

### Documentation Skills

#### Claude Code Documentation
**Type:** Skill
**Status:** 💡 Idea
**Description:** Claude Code docs as a skill for offline/fast access.

#### n8n Documentation
**Type:** Skill
**Status:** 💡 Idea
**Description:** n8n workflow automation docs and patterns.

#### Obsidian Documentation
**Type:** Skill
**Status:** 💡 Idea
**Description:** Obsidian docs and plugin development patterns.

---

### Utility Skills

#### Product Idea Critic
**Type:** Skill
**Status:** 💡 Idea
**Description:** Critical assessment of product ideas (SWOT analysis, market validation, feasibility).

#### Blog Post Review
**Type:** Skill
**Status:** 💡 Idea
**Description:** Reviews blog posts for clarity, structure, tone, SEO optimization.

---

## Development Workflow

### Lifecycle Stages

```
💡 Idea → 🔄 Spec Needed → 🔬 Researching → ✅ Spec Complete → 🏗️ Building → ✅ Implemented
```

### Moving Between Stages

**Idea → Spec Needed:**
- Document core concept and use cases
- Identify dependencies and requirements
- Estimate effort and strategic value

**Spec Needed → Researching:**
- Begin detailed investigation
- Prototype key features
- Validate technical feasibility

**Researching → Spec Complete:**
- Complete specification document
- Include examples and success criteria
- Validate with spec-analyzer

**Spec Complete → Building:**
- Use skill-creator (Anthropic's tool)
- Follow specification exactly
- Implement bundled resources

**Building → Implemented:**
- Test with real use cases
- Validate with skill-analyzer
- Document installation and usage
- Add to marketplace

---

## Strategic Priorities

### High Priority (Build Next)
1. **Skill Analyzer** - Completes skill development ecosystem
2. **Capability Discovery Bundle** - Foundational infrastructure
3. **SQLite Query Helper** - Proves skills > MCPs thesis

### Medium Priority
4. **Git Repository Analyzer** - Demonstrates complex analysis
5. **Spec Analyzer** - Prevents wasted implementation time
6. **Web Image Extractor** - Useful content extraction tool

### Lower Priority
7. **Skill Development Coach** - Nice-to-have orchestration
8. **Backlog Manager Bundle** - Needs bridge layer first
9. **Research Plugin** - Complex, needs refinement

### Ideas to Spec
- Second Brain Access - High user value
- Documentation skills - Educational value
- Utility skills - Quick wins

---

## Contributing

### Adding New Plugin Ideas

1. Add entry to appropriate section (💡 Ideas Only)
2. Include brief description and potential value
3. Update total count in Overview
4. Consider dependencies and strategic fit

### Moving Plugins Through Stages

1. Update status emoji and section
2. Add/update documentation link
3. Update "Last Updated" date
4. Update status breakdown in Overview
5. Add details as they become available

### Creating Specifications

1. Create spec file in `/specs/` with naming: `{plugin-name}-spec.md`
2. Follow comprehensive specification format
3. Include YAML frontmatter for metadata
4. Cross-reference related plugins
5. Update this tracker with spec link

---

## Related Documentation

- **SuperSkills Platform:** ../../superskills/docs/platform/PRODUCT_SPEC.md
- **Platform Progress:** ../../superskills/docs/platform/PROGRESS.md
- **Specification Examples:** See `/specs/` directory
- **Development Guide:** README.md in this directory

---

*This tracker is the single source of truth for all plugin development status. Keep it updated as plugins progress through the lifecycle.*
