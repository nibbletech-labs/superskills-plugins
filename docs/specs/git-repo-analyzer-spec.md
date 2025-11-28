# Git Repository Analyzer Skill - Phase 1 Specification

**Created:** 2025-11-05
**Status:** Specification Complete
**Priority:** High
**Category:** Development Tools & Analysis
**Type:** Lightweight data gatherer with deep understanding capabilities

---

## Executive Summary

Create a Claude Code skill that clones, deeply analyzes, and compares Git repositories to provide genuine understanding of functionality, architecture, and purpose - not just surface-level cataloging. Designed as a modular data gatherer that can work standalone or feed expert analysis skills.

**Key Innovation:** Balances comprehensive analysis with user control through template customization and hybrid output (detailed files + synthesis).

---

## Why This Skill Exists

### The Core Problem

**Current State:**
When you ask Claude Code to analyze a Git repository, it:
1. Clones the repo (if you tell it to)
2. Explores somewhat randomly based on conversation
3. Reads files you specifically mention
4. Forgets to check important aspects
5. Leaves cloned repos around
6. Provides inconsistent depth across repos

**For comparisons (e.g., "Compare 5 SDLC frameworks"):**
- You end up asking different questions for each repo
- Hard to compare apples-to-apples
- Misses dimensions you forgot to ask about
- Takes 50+ messages to compare 5 repos
- Manual synthesis required

### The Insight

**Structured analysis frameworks exist in other domains:**
- Due diligence checklists (business)
- Code review guidelines (engineering)
- Competitive analysis templates (product)
- Research protocols (academia)

**But not for repository analysis in Claude Code.**

### What This Skill Provides

**Systematic approach to repository understanding:**
1. **Standard analysis template** - Ensures nothing important is missed
2. **Custom template option** - Focus on what matters to you
3. **Deep understanding** - Goes beyond "it's written in TypeScript"
4. **Consistent comparisons** - Same dimensions across all repos
5. **Clean workflow** - Clone → analyze → cleanup automatically
6. **Reusable artifacts** - Individual analysis files for reference

### Strategic Value

**Why it matters:**

1. **Fills ecosystem gap** - No existing tool for structured repo analysis
2. **Demonstrates skill value** - Shows skills > MCPs for analysis workflows
3. **Enables better decisions** - Compare frameworks, libraries, tools systematically
4. **Saves massive time** - 50+ message task → 5 messages
5. **Builds knowledge base** - Reusable analysis files
6. **Modular foundation** - Can invoke expert skills later

---

## Core Philosophy

### Principle 1: Understanding Over Cataloging

**Bad analysis:** "This repo has 247 TypeScript files"
**Good analysis:** "This is a build orchestrator that uses dependency graphs to enable incremental compilation, targeting teams with 10+ packages who need 5x faster rebuilds"

**The skill should reveal:**
- What problems it solves
- How it approaches solutions
- Who it's designed for
- When to use it vs alternatives

### Principle 2: Consistency Enables Comparison

**For single repo:** Standard template ensures thoroughness
**For multiple repos:** Same dimensions = meaningful comparison

**The skill ensures:**
- Same questions asked of each repo
- Same depth of investigation
- Same output structure
- Easy to spot differences

### Principle 3: User Control Over Scope

**Not all analyses need everything:**
- Comparing UI frameworks? Focus on components, styling, performance
- Comparing deployment tools? Focus on platforms, complexity, rollback
- Evaluating for security? Focus on dependencies, tests, audit history

**The skill provides:**
- Default comprehensive template (covers everything)
- Custom template approval (user specifies dimensions)
- Template refinement (iterate before analyzing)

### Principle 4: Modular Design

**This skill is a data gatherer, not an expert:**
- Collects information systematically
- Presents structured findings
- Can invoke expert skills for deep dives
- Doesn't try to be architecture expert AND market analyst AND security auditor

**Separation of concerns:**
- git-repo-analyzer = Gather data
- architecture-expert = Analyze patterns (future)
- market-research = Assess opportunity (future)
- User's brain = Make final decision

### Principle 5: Artifacts Over Conversations

**Problem with conversational analysis:**
- Insights scroll away
- Hard to reference later
- Can't share with teammates
- Comparison requires manual synthesis

**The skill generates artifacts:**
- Individual analysis files (referenceable)
- Comparison matrix (shareable)
- Stored in organized directory
- Mentioned at end (so you can find them)

---

## User Stories

### Story 1: Framework Comparison (Primary Use Case)

**Scenario:** Comparing 5 SDLC frameworks for team adoption

**User:** "I need to choose an SDLC framework. Compare these 5 repos and tell me which is best for a 10-person team."

**Skill workflow:**

1. **Clarify intent:**
   ```
   Skill: "I'll analyze these frameworks. What aspects matter most for your decision?"

   User: "Git workflow, CI/CD integration, deployment automation, ease of learning"

   Skill: "Here's my analysis template:

   1. Git Workflow (branch strategy, PR process, automation)
   2. CI/CD Integration (platform support, setup complexity, features)
   3. Deployment Automation (target platforms, rollback, blue-green)
   4. Learning Curve (docs quality, examples, onboarding time)
   5. Plus standard metadata (stars, activity, license)

   Proceed with this template for all 5 repos?"

   User: "Yes, also add scalability considerations"

   Skill: "Updated template with scalability. Proceeding..."
   ```

2. **Analysis execution:**
   ```
   [Analyzing framework-a...]
   - Clones to /tmp/git-analysis-20251105-143022/repos/framework-a
   - Reads README, docs/architecture.md, examples/
   - Examines .github/workflows/, deployment scripts
   - Checks package.json, tests
   - Generates framework-a.md in /tmp/.../raw/
   - Cleanup repo

   [Progress: 1 of 5 complete]

   [Repeat for frameworks b, c, d, e...]
   ```

3. **Synthesis:**
   ```
   Generates comparison-matrix.md:

   | Framework | Git Workflow | CI/CD | Deployment | Learning | Scalability | Stars |
   |-----------|--------------|-------|------------|----------|-------------|-------|
   | A | Trunk-based ⭐⭐⭐⭐⭐ | GHA native ⭐⭐⭐⭐⭐ | Multi-cloud ⭐⭐⭐⭐ | Moderate ⭐⭐⭐ | High ⭐⭐⭐⭐⭐ | 24k |
   | B | GitFlow ⭐⭐⭐⭐ | Plugin-based ⭐⭐⭐ | K8s only ⭐⭐⭐⭐⭐ | Steep ⭐⭐ | Very High ⭐⭐⭐⭐⭐ | 12k |
   ...

   ## Recommendation: Framework A

   ### Why:
   - Best match for 10-person team size
   - Excellent GitHub Actions integration (you're already using GHA)
   - Proven at scale (used by X, Y, Z companies)
   - Strong documentation for onboarding

   ### Trade-offs:
   - Not as scalable as Framework B (but you don't need that yet)
   - Opinionated (but that's good for teams)

   ### Implementation Path:
   1. Start with example project (2-3 days)
   2. Migrate one service (1 week)
   3. Roll out to team (2 weeks)
   ```

4. **Deliverables:**
   ```
   Files generated in /tmp/git-analysis-20251105-143022/:
   ├── raw/
   │   ├── framework-a.md (detailed analysis)
   │   ├── framework-b.md
   │   ├── framework-c.md
   │   ├── framework-d.md
   │   └── framework-e.md
   ├── comparison-matrix.md (synthesis)
   └── metadata.json (analysis params)

   "Full analysis available in /tmp/git-analysis-20251105-143022/"
   "Recommendation: Framework A - see comparison-matrix.md for details"
   ```

**Messages required:** 4-5 total (vs 50+ without skill)

---

### Story 2: Single Repo Deep Dive

**Scenario:** Understanding a complex codebase before contributing

**User:** "I need to contribute to https://github.com/complex/project - help me understand how it works"

**Skill workflow:**

1. **Use standard template** (no customization needed for single repo)

2. **Deep analysis:**
   - Clone repo
   - Read architecture docs
   - Trace main execution flow
   - Map component relationships
   - Identify extension points
   - Check contribution guidelines

3. **Generate understanding doc:**
   ```markdown
   # complex/project - Deep Analysis

   ## What It Does
   [Detailed functionality breakdown]

   ## How It Works
   ### Architecture
   - Request flow: API Gateway → Router → Controllers → Services → Database
   - State management: Redux with middleware for side effects
   - Data layer: GraphQL with DataLoader for batching

   ### Key Mechanisms
   - Authentication: JWT tokens with refresh mechanism
   - Caching: Redis for session, CDN for assets
   - Real-time: WebSocket server for live updates

   ### Extension Points
   - Plugin system: /plugins/*.ts auto-loaded
   - Middleware: Express middleware chain
   - Custom resolvers: GraphQL schema-first

   ## Purpose
   - Built to solve: "Traditional CMSs too slow for real-time collab"
   - Target: Content teams needing live editing
   - Philosophy: "Performance first, features second"

   ## Contributing
   - Entry point for features: /src/plugins/
   - Test requirements: 80% coverage, e2e for core flows
   - Review process: 2 approvals, CI must pass
   ```

**Outcome:** Ready to contribute with genuine understanding

---

### Story 3: Migration Assessment

**Scenario:** Evaluating migration from Framework Old to Framework New

**User:** "We use Framework Old. Should we migrate to Framework New? What's involved?"

**Skill workflow:**

1. **Custom template:**
   ```
   User provides context: "We have 20 microservices, 15 developers, using Framework Old"

   Skill proposes template:
   1. Feature Parity (what we'd lose/gain)
   2. Migration Effort (breaking changes, code rewrites needed)
   3. Learning Curve (for 15 developers)
   4. Ecosystem Compatibility (our current tools)
   5. Risk Assessment (what could go wrong)

   User: "Approved, also add cost analysis"
   ```

2. **Analyzes both repos with migration lens:**
   - Framework Old: What we currently use
   - Framework New: What we'd migrate to
   - Focus: Differences, compatibility, migration path

3. **Generates migration assessment:**
   ```markdown
   # Migration Assessment: Framework Old → Framework New

   ## Feature Parity Analysis
   ✅ All current features supported in New
   ⚠️ Authentication handled differently (migration needed)
   ✅ Deployment process compatible

   ## Migration Effort Estimate
   - Per microservice: 3-5 days (code changes)
   - Developer learning: 1 week (training)
   - Testing: 2 weeks (QA all services)
   - Total: 3-4 months for all 20 services

   ## Risk Assessment
   - HIGH: Auth migration could break existing sessions
   - MEDIUM: Different build tooling (may expose edge cases)
   - LOW: Well-documented migration path exists

   ## Recommendation: Migrate, but phased approach
   1. Pilot with 2 low-risk services (Month 1)
   2. Gather feedback, refine process (Month 2)
   3. Roll out to remaining 18 services (Months 3-4)

   ## Cost-Benefit
   - Migration cost: ~$200k (4 eng-months)
   - Annual savings: ~$50k (faster builds, less infra)
   - Break-even: 4 years
   - Intangible benefits: Modern tooling, better DX
   ```

---

## Technical Specification

### Skill Components

```
git-repo-analyzer/
├── SKILL.md                        # Main skill instructions (~400 lines)
├── references/
│   ├── analysis-templates.md      # Pre-built templates for common scenarios
│   ├── reading-priorities.md      # Which files to read in what order
│   └── comparison-frameworks.md   # How to compare different dimensions
└── scripts/
    └── quick-clone.sh             # Optimized shallow clone with cleanup
```

### Analysis Workflow (Detailed)

#### Phase 1: Setup & Template Selection

**Input:** Repository URL(s)

**Steps:**

1. **Count repos:**
   - Single repo → Standard template (comprehensive)
   - Multiple repos → Ask for comparison criteria

2. **For multiple repos - Template customization:**
   ```
   Ask user: "What aspects matter for your decision?"

   Parse response for dimensions:
   - "git workflow" → Git Workflow section
   - "CI/CD" → CI/CD Integration section
   - "deployment" → Deployment Automation section
   - "learning curve" → Documentation & Onboarding section
   - Custom request → Add custom section

   Generate template with specified dimensions

   Show to user: "Here's my analysis template: [sections]. Proceed?"

   Allow refinement: User can add/remove/modify dimensions

   Finalize: Lock template for all repo analyses
   ```

3. **Create analysis directory:**
   ```bash
   ANALYSIS_DIR="/tmp/git-analysis-$(date +%Y%m%d-%H%M%S)"
   mkdir -p "$ANALYSIS_DIR/repos"
   mkdir -p "$ANALYSIS_DIR/raw"
   ```

---

#### Phase 2: Individual Repository Analysis (Per Repo)

**For each repository:**

##### 2.1: Clone Repository

```bash
cd "$ANALYSIS_DIR/repos"
REPO_NAME=$(basename "$REPO_URL" .git)

# Shallow clone (faster, smaller)
git clone --depth 1 --single-branch "$REPO_URL" "$REPO_NAME" 2>&1

# Fallback for servers without shallow clone support
if [ $? -ne 0 ]; then
  git clone "$REPO_URL" "$REPO_NAME"
fi

cd "$REPO_NAME"
```

**Error handling:**
- Private repo → Inform user, skip or request credentials
- 404 → Report and continue with other repos
- Network error → Retry once, then fail gracefully

##### 2.2: Quick Facts Gathering

**Metadata to collect:**
```bash
# Git metadata
STARS=$(gh api repos/owner/repo --jq '.stargazers_count' 2>/dev/null || echo "N/A")
FORKS=$(gh api repos/owner/repo --jq '.forks_count' 2>/dev/null || echo "N/A")
LAST_COMMIT=$(git log -1 --format="%ar" 2>/dev/null)
CONTRIBUTORS=$(git shortlog -sn --no-merges | wc -l)

# Code statistics
TOTAL_FILES=$(find . -type f | wc -l)
CODE_LANGUAGES=$(find . -name "*.ts" -o -name "*.js" -o -name "*.py" |
                 sed 's/.*\.//' | sort | uniq -c | sort -rn)

# License
LICENSE=$(cat LICENSE* 2>/dev/null | head -1 | grep -oE "MIT|Apache|GPL|ISC")
```

**Generates:**
```markdown
## Quick Facts
- **Repository:** owner/repo
- **Stars:** 24,234 ⭐
- **Activity:** Last commit 2 days ago, 147 contributors
- **Language:** TypeScript (65%), JavaScript (25%), CSS (10%)
- **License:** MIT
- **Size:** 1,247 files
```

##### 2.3: Documentation Discovery

**Priority reading order:**

1. **README.md** (always read first)
   - Extract: Purpose, features, getting started, examples
   - Look for: "What is this?", "Key features", "How it works"

2. **Architecture docs** (if they exist)
   - Common paths: `/docs/architecture.md`, `/ARCHITECTURE.md`, `/docs/design/`
   - Extract: System design, component relationships, data flow

3. **Philosophy/Design docs**
   - Common paths: `/DESIGN.md`, `/docs/philosophy.md`, `/ADR/` (Architecture Decision Records)
   - Extract: Why decisions were made, trade-offs considered

4. **Examples** (shows intended usage)
   - Common paths: `/examples/`, `/demos/`, `/samples/`
   - Extract: Common use cases, typical workflows

5. **Contributing guide** (reveals development approach)
   - Common paths: `/CONTRIBUTING.md`, `/docs/contributing.md`
   - Extract: Code style, testing requirements, review process

**Reading strategy:**
- Use `grep -r "architecture\|how it works\|design"` to find relevant sections
- Don't read everything - be selective based on template dimensions
- Prioritize docs over code (docs explain intent, code shows implementation)

##### 2.4: Code Structure Analysis

**Don't read all code - analyze structure:**

```bash
# Directory structure (reveals organization)
tree -L 2 -d

# Entry points (reveals main flow)
find . -name "index.ts" -o -name "main.py" -o -name "app.ts" -o -name "__init__.py"

# Core abstractions (reveals architecture)
find . -name "*.ts" | xargs grep -l "export class\|export interface" | head -20

# Configuration approach (reveals flexibility)
ls -la | grep -E "config|\..*rc|\.toml|\.yaml"

# Testing strategy (reveals quality approach)
find . -name "*.test.ts" -o -name "*_test.py" -o -name "*.spec.ts" | wc -l
ls -la | grep -E "jest|pytest|vitest|mocha"
```

**Infer from structure:**
- `/src/core/`, `/src/plugins/` → Plugin-based architecture
- `/packages/` → Monorepo structure
- `/server/`, `/client/` → Client-server architecture
- Lots of tests → Quality-focused
- `/docs/adr/` → Decision documentation culture

##### 2.5: Dependency Analysis

**Understand approach from dependencies:**

```bash
# For Node.js
jq '.dependencies, .devDependencies' package.json

# Key insights:
# - Express/Fastify → Web server
# - React/Vue → Frontend framework
# - TypeORM/Prisma → Database approach
# - Jest/Vitest → Testing strategy
# - ESLint/Prettier → Code quality tools
```

**What dependencies reveal:**
- **Heavy dependencies** → Comprehensive but complex
- **Minimal dependencies** → Lightweight but may need more code
- **Popular libraries** → Following best practices
- **Custom/forked libs** → Specialized or cutting-edge

##### 2.6: Test & Quality Indicators

```bash
# Test coverage indicators
find . -name "coverage" -type d
grep -r "coverage" package.json

# CI/CD setup
ls -la .github/workflows/
cat .github/workflows/*.yml | grep -E "test|lint|deploy"

# Code quality tools
ls -la | grep -E "eslint|prettier|ruff"

# Pre-commit hooks
ls -la .git/hooks/ 2>/dev/null
```

**Quality signals:**
- 80%+ test coverage → High confidence
- Comprehensive CI → Professional setup
- Linting/formatting → Code consistency
- Pre-commit hooks → Quality gates

---

#### Phase 3: Deep Understanding Generation

**For each template dimension, generate analysis:**

##### Example: Git Workflow Analysis

**What to look for:**
```bash
# Branch strategy
grep -r "branch" CONTRIBUTING.md README.md docs/

# PR process
ls -la .github/PULL_REQUEST_TEMPLATE.md
cat .github/workflows/*.yml | grep -E "pull_request|merge"

# Automation
find .github/workflows -name "*.yml" -exec cat {} \; | grep -E "auto-merge|auto-label"

# Hooks
cat .git/hooks/* 2>/dev/null
```

**Generate understanding:**
```markdown
### Git Workflow

**Branch Strategy:** Trunk-based development
- Main branch: `main` (always deployable)
- Feature branches: `feature/name` (short-lived, max 2 days)
- Release branches: `release/v1.x` (for hotfixes only)

**PR Process:**
- Required: 2 approvals from code owners
- Automated: Lint, test, build must pass
- Labels: Auto-labeled by bot based on files changed
- Merge: Squash and merge (clean history)

**Automation:**
- Auto-label PRs by file paths
- Auto-request reviewers by CODEOWNERS
- Auto-merge dependabot PRs if tests pass
- Auto-close stale PRs after 30 days

**Philosophy:** "Small, frequent merges over long-lived branches"

**Best for:** Teams wanting fast iteration, continuous deployment
**Not for:** Teams needing release trains, complex approval processes
```

##### Example: How It Works Analysis

**What to understand:**

1. **Main execution flow:**
   ```bash
   # Find entry point
   cat package.json | jq '.main, .bin'

   # Read entry file
   cat src/index.ts

   # Trace primary code path
   grep -r "export.*function.*main\|export.*class.*App" src/
   ```

2. **Core mechanisms:**
   - Request handling (middleware? routers? controllers?)
   - State management (Redux? Context? Zustand?)
   - Data persistence (ORM? SQL? NoSQL?)
   - Background jobs (queue? cron? workers?)

3. **Architecture pattern:**
   - MVC? MVVM? Clean architecture? Hexagonal?
   - Inferred from directory structure and imports

**Generate understanding:**
```markdown
### How It Works

**High-Level Architecture:** Clean Architecture with DDD

**Request Flow:**
1. HTTP request → API Gateway (rate limiting, auth)
2. Gateway → Application Service (business logic)
3. Service → Domain Models (pure business rules)
4. Domain → Repository (data access abstraction)
5. Repository → Database (PostgreSQL via Prisma)

**Key Mechanisms:**

**State Management:**
- Server state: Domain models (in-memory during request)
- Database state: Event sourcing (append-only event log)
- Cache state: Redis for computed aggregates

**Background Processing:**
- Job queue: BullMQ (Redis-backed)
- Scheduled tasks: node-cron for recurring jobs
- Event handlers: Listen to domain events, trigger side effects

**Extension System:**
- Plugins: TypeScript classes implementing IPlugin interface
- Discovery: Auto-scanned from /plugins/** at startup
- Lifecycle hooks: onLoad, beforeRequest, afterRequest
- Dependency injection: Plugin dependencies injected via container

**Performance Strategy:**
- Lazy loading: Plugins only loaded when route accessed
- Caching: Redis cache per-user aggregates (5 min TTL)
- Database: Read replicas for queries, primary for writes
- CDN: Static assets on Cloudflare

**Why These Choices:**
- Event sourcing: Full audit trail (required for compliance)
- Plugin system: Extensibility without forking
- Clean architecture: Testability (85% coverage achieved)
```

##### Example: Purpose & Intent Analysis

**What to extract:**

1. **Problem statement** (from README, docs/problem.md)
2. **Target users** (from docs, examples, marketing copy)
3. **Design principles** (from DESIGN.md, ADRs, code comments)
4. **Differentiators** (from README comparison section, docs/vs-alternatives.md)

**Look for phrases:**
- "built to solve..."
- "designed for teams who..."
- "unlike X, this framework..."
- "our philosophy is..."
- "best suited for..."

**Generate understanding:**
```markdown
### Purpose & Intent

**Problem Solved:**
"Traditional deployment tools require manual config for each service. At scale (50+ microservices), this becomes unmaintainable. Teams need deployment infrastructure that auto-discovers services and self-configures."

**Target Users:**
- **Primary:** Platform teams at mid-to-large companies (100+ developers)
- **Secondary:** DevOps engineers managing 20+ services
- **Not for:** Small teams (<5 devs), single-application deployments

**Design Philosophy:**
1. **Convention over configuration** - "Zero config for 80% of use cases"
2. **Progressive disclosure** - Simple by default, powerful when needed
3. **Safe by default** - Rollback built-in, can't deploy broken code
4. **Developer experience** - Fast feedback loops, clear error messages

**Differentiators:**

vs **Framework A** (competitor):
- We: Auto-discovery of services (no manual registry)
- They: Faster builds (we optimize for safety over speed)

vs **Framework B** (competitor):
- We: Opinionated (fast to start)
- They: Flexible (slower to configure)

**When to Use:**
✅ Managing 10+ services
✅ Need zero-config deployment
✅ Value safety over speed
✅ Want automatic service discovery

**When NOT to Use:**
❌ Single service app (overkill)
❌ Need bleeding-edge performance (we prioritize safety)
❌ Highly custom deployment needs (our opinions may not fit)

**Creator Intent:**
"We built this after manually managing 50 microservices at Company X and realizing deployment shouldn't require a 500-line config file per service."
```

---

#### Phase 4: Synthesis (For Comparisons)

**Only when analyzing multiple repos:**

##### 4.1: Generate Comparison Matrix

**Structure:**
- Rows: Repos being compared
- Columns: Template dimensions + overall score
- Cells: Ratings (⭐⭐⭐⭐⭐), key facts, brief notes

**Rating methodology:**
- Each dimension scored 1-5 stars
- Based on criteria from template
- Justified with evidence from analysis

**Example matrix:**
```markdown
## Comparison Matrix: SDLC Frameworks

| Framework | Git Workflow | CI/CD | Deploy | Learning | Scalability | Overall |
|-----------|--------------|-------|--------|----------|-------------|---------|
| TrunkFlow | ⭐⭐⭐⭐⭐<br>Trunk-based, fast | ⭐⭐⭐⭐⭐<br>GHA native | ⭐⭐⭐⭐<br>Multi-cloud | ⭐⭐⭐<br>Moderate | ⭐⭐⭐⭐⭐<br>1000+ services | ⭐⭐⭐⭐⭐<br>24k ⭐ |
| GitFlowPro | ⭐⭐⭐⭐<br>GitFlow, structured | ⭐⭐⭐<br>Plugin-based | ⭐⭐⭐⭐⭐<br>K8s-first | ⭐⭐<br>Steep | ⭐⭐⭐⭐⭐<br>Massive | ⭐⭐⭐⭐<br>12k ⭐ |
| SimpleDev | ⭐⭐⭐<br>Basic branching | ⭐⭐⭐<br>GitHub only | ⭐⭐<br>Limited | ⭐⭐⭐⭐⭐<br>Easy | ⭐⭐<br>10 services | ⭐⭐⭐<br>8k ⭐ |

### Dimension Details

**Git Workflow:**
- TrunkFlow: Encourages small commits, fast merges. Automation for PR labeling, auto-merge. Best for: Continuous deployment.
- GitFlowPro: Structured release process. Good for: Scheduled releases, hotfix management.
- SimpleDev: Basic PR process. Good for: Small teams learning.

**CI/CD Integration:**
- TrunkFlow: Native GitHub Actions, pre-built workflows, one-line setup.
- GitFlowPro: Plugin system for any CI (Jenkins, GitLab, CircleCI). More setup, more flexibility.
- SimpleDev: GitHub Actions only, basic config.

[etc. for each dimension]
```

##### 4.2: Recommendation Engine

**Scoring algorithm:**
- Weight dimensions based on user priorities (if specified)
- Sum weighted scores
- Account for deal-breakers (must-haves not met = eliminate)

**Generate recommendation:**
```markdown
## Recommendation: TrunkFlow

### Overall Score: 4.6 / 5.0

**Weighted scoring:**
- Git Workflow (priority: high, weight: 3x): 5.0
- CI/CD (priority: high, weight: 3x): 5.0
- Deployment (priority: medium, weight: 2x): 4.0
- Learning (priority: low, weight: 1x): 3.0
- Scalability (priority: medium, weight: 2x): 5.0

### Why TrunkFlow Wins

**Best match for your stated needs:**
1. Excellent git workflow (trunk-based = fast iteration)
2. Superior CI/CD (GitHub Actions native = your current stack)
3. Proven scalability (you'll grow from 10 to 50 services)

**Trade-offs you're accepting:**
- Moderate learning curve (worth it for long-term gains)
- Opinionated (but that's good for team consistency)

**Risks to consider:**
- Requires discipline (trunk-based only works with good practices)
- Initial setup investment (2-3 days to configure first service)

### Alternative Consideration

**If requirements change:**
- Need complex release process → GitFlowPro
- Want simplicity over features → SimpleDev
- Evaluating for different team → Re-run with updated template

### Implementation Path

**Week 1:** Pilot project
1. Set up TrunkFlow on test service
2. Train 2 developers
3. Run through full workflow

**Week 2-3:** Rollout
4. Document learnings
5. Create team templates
6. Migrate 3 core services

**Week 4+:** Scale
7. Remaining services
8. Refine based on feedback
```

---

#### Phase 5: Cleanup

**Always runs (even on errors):**

```bash
# Trap ensures cleanup on exit, error, or interrupt
trap 'cleanup_analysis' EXIT INT TERM

cleanup_analysis() {
  echo "Cleaning up..."

  # Remove cloned repos
  if [ -d "$ANALYSIS_DIR/repos" ]; then
    rm -rf "$ANALYSIS_DIR/repos"
    echo "✓ Deleted cloned repositories"
  fi

  # Keep analysis files (don't delete raw/ and comparison files)
  echo "✓ Analysis files preserved in $ANALYSIS_DIR"
  echo ""
  echo "Review results: $ANALYSIS_DIR/comparison-matrix.md"

  # Optional: Delete after user confirmation
  # read -p "Delete analysis directory? (y/n) " -n 1 -r
  # if [[ $REPLY =~ ^[Yy]$ ]]; then
  #   rm -rf "$ANALYSIS_DIR"
  # fi
}
```

**Cleanup strategy:**
- ✅ Always delete cloned repos (can be large)
- ✅ Keep analysis markdown files (valuable artifacts)
- ✅ Show user where files are
- ⏳ User can delete later when done reviewing

---

## Standard Analysis Template (Default)

### When used
- Single repository analysis
- Multiple repositories without custom criteria

### Sections

#### 1. Quick Facts (Metadata)
- Repository URL, stars, forks
- Primary language(s)
- License
- Activity (last commit, contributors)
- Size (files, lines of code if available)

#### 2. What It Does (Functionality) **[DEEP]**

**Not just:** "It's a build tool"

**Actually:**
```markdown
### Core Functionality

**Primary Capabilities:**
1. **Incremental builds** - Analyzes dependency graph, rebuilds only affected packages
2. **Task orchestration** - Parallel execution of independent tasks (test, lint, build)
3. **Caching** - Local + remote cache for build artifacts (reduces CI time 80%)
4. **Code generation** - Auto-generates TypeScript types from GraphQL schemas

**Secondary Features:**
- Workspace linking (symlink local packages during development)
- Version management (coordinated version bumps across packages)
- Publishing (automated npm publish with changelog generation)

**Concrete Examples:**

"Change one component → Rebuild only that component + dependents (30s instead of 5min)"
"Run tests → Parallel execution across 20 packages (2min instead of 15min)"
"Deploy → Automatically versions, builds, publishes 15 packages in sequence"

**Feature Completeness:**
Covers full development lifecycle: scaffold → develop → test → build → publish → deploy
```

#### 3. How It Works (Architecture & Mechanisms) **[DEEP]**

**Not just:** "Uses TypeScript"

**Actually:**
```markdown
### Architecture

**System Design:**
```
                    ┌──────────────┐
                    │ CLI Entry    │
                    └──────┬───────┘
                           │
                    ┌──────▼───────┐
                    │ Workspace    │◄── Scans package.json files
                    │ Analyzer     │    Builds dependency graph
                    └──────┬───────┘
                           │
         ┌─────────────────┼─────────────────┐
         │                 │                 │
    ┌────▼────┐      ┌────▼────┐      ┌────▼────┐
    │ Task    │      │ Cache   │      │ Build   │
    │ Runner  │      │ Manager │      │ Plugins │
    └─────────┘      └─────────┘      └─────────┘
         │                 │                 │
         └─────────────────┼─────────────────┘
                           │
                    ┌──────▼───────┐
                    │ Output       │
                    └──────────────┘
```

**Key Mechanisms:**

1. **Dependency Graph Construction:**
   - Scans all package.json files in workspace
   - Parses import statements to build graph
   - Detects circular dependencies (fails fast)
   - Updates incrementally on file changes

2. **Task Orchestration:**
   - Topological sort of dependency graph
   - Parallel execution of independent nodes
   - Maximum parallelism: CPU core count
   - Stops entire build on first error (fail-fast)

3. **Caching Strategy:**
   - Input hashing: Hash source files + dependencies
   - Cache lookup: Local disk → Remote S3
   - Cache invalidation: Any input change = rebuild
   - Restoration: Copy cached output instead of rebuild

4. **Plugin System:**
   - Interface: `IPlugin { name, transform, bundle }`
   - Discovery: Auto-load from /plugins/*.ts
   - Execution: Plugins called in pipeline (transform → bundle → emit)
   - Built-in plugins: TypeScript, ESBuild, Babel, SWC

**Technical Decisions & Why:**

- **Choice:** Topological sort for task order
  - **Why:** Ensures dependencies built before dependents
  - **Trade-off:** Can't parallelize dependent tasks (necessary constraint)

- **Choice:** Hash-based caching
  - **Why:** Deterministic cache hits (same input = same output)
  - **Trade-off:** Any file change invalids cache (conservative but safe)

- **Choice:** Fail-fast error handling
  - **Why:** Don't waste time building if something's broken
  - **Trade-off:** Can't see all errors at once (accepted for speed)

**Performance Characteristics:**
- Cold build (no cache): 5 minutes for 20 packages
- Warm build (full cache): 500ms (just hash validation)
- Incremental build (1 package changed): 30 seconds
- Parallel efficiency: Linear scaling up to CPU core count
```

#### 4. Purpose & Philosophy (Intent) **[DEEP]**

**Not just:** "It's for monorepos"

**Actually:**
```markdown
### Purpose & Philosophy

**Origin Story:**
Created by Google's Angular team after managing 900+ TypeScript packages in a single repo. Existing tools (Lerna, Yarn workspaces) couldn't handle the scale. Needed: "Build in seconds, not hours."

**Problem Solved:**
"Monorepo build times grow exponentially with package count. At 50+ packages, full builds take 20+ minutes, killing developer flow."

**Solution Approach:**
"Only rebuild what changed. Cache everything. Parallelize ruthlessly."

**Target Users:**

**Perfect fit:**
- Teams with 10+ packages in monorepo
- Need fast builds (can't wait 10+ minutes)
- Value developer experience
- Have CI/CD budget for remote caching

**Wrong fit:**
- Single package projects (overkill, just use tsc)
- Small monorepos (<5 packages) (added complexity for little gain)
- Teams without CI (remote caching won't help)

**Design Principles:**

1. **Speed above all** - "Sub-second cache hits or we failed"
2. **Developer experience** - "If it's not obvious, it's a bug"
3. **Incremental adoption** - "Works with existing tools, doesn't replace everything"
4. **Escape hatches** - "Can always drop to underlying tool (esbuild, tsc) if needed"

**Philosophy Quotes from Docs:**

> "We believe builds should be instant. Waiting for builds is a tax on developer creativity."

> "Caching isn't an optimization, it's the foundation. Build speed comes from not building."

> "Monorepos should feel like single repos. Tools should disappear."

**When to Use This vs Alternatives:**

**Use this if:**
- Monorepo with 10+ packages
- Build time is painful (>2 min)
- Team values fast iteration
- Have CI infrastructure for remote cache

**Use Alternative A if:**
- Need advanced task chaining (this focuses on builds)
- Want built-in deployment (this is build-only)
- Need Windows support (this is Mac/Linux primarily)

**Use Alternative B if:**
- Prefer simple over fast (this has learning curve)
- Don't have remote cache infrastructure
- <10 packages (diminishing returns)

**Creator's Vision:**
"Every developer should experience sub-second builds. That's the future we're building."
```

#### 5. Quality & Maturity

Standard metrics:
- Test coverage
- CI/CD setup
- Documentation score
- Community health
- Maintenance status

#### 6. Trade-offs & Fit Assessment

**Strengths:**
**Weaknesses:**
**Best for:**
**Not suitable for:**

---

### Output Structure

#### Individual Analysis Files

**Format:** Markdown with consistent structure

**Filename:** `{repo-name}-analysis.md`

**Sections:**
1. Quick Facts
2. What It Does (Functionality)
3. How It Works (Architecture & Mechanisms)
4. Purpose & Philosophy
5. Quality & Maturity
6. Trade-offs & Fit

**Length:** 500-1500 lines per repo (comprehensive)

#### Comparison Matrix

**Format:** Markdown table + detailed breakdowns

**Filename:** `comparison-matrix.md`

**Sections:**
1. Summary matrix (table with ratings)
2. Dimension-by-dimension comparison
3. Recommendation with justification
4. Implementation guidance

**Length:** 300-800 lines depending on repo count

---

## Template Customization System

### Template Structure

```typescript
interface AnalysisTemplate {
  name: string;
  dimensions: TemplateDimension[];
  priorities?: {
    [dimensionName: string]: 'high' | 'medium' | 'low';
  };
}

interface TemplateDimension {
  name: string;
  description: string;
  lookFor: string[];  // What files/patterns to check
  questions: string[]; // What to answer
  rating Criteria?: {[star: number]: string};
}
```

### Example: SDLC Framework Template

```markdown
# Template: SDLC Framework Comparison

## Dimensions

### 1. Git Workflow
**Description:** How the framework structures version control
**Look for:**
- Branch strategy documentation
- PR process and automation
- Merge strategies
- Hook configuration

**Questions:**
- What branching model does it recommend?
- How are PRs reviewed and merged?
- What automation exists?
- How does it handle hotfixes?

**Rating Criteria:**
- ⭐⭐⭐⭐⭐ Trunk-based with extensive automation
- ⭐⭐⭐⭐ GitFlow with good automation
- ⭐⭐⭐ Feature branching with basic PR process
- ⭐⭐ Ad-hoc branching, minimal automation
- ⭐ No clear strategy

### 2. CI/CD Integration
**Description:** How the framework integrates with CI/CD platforms
**Look for:**
- .github/workflows/ or similar
- Supported CI platforms
- Pre-built workflows
- Configuration complexity

**Questions:**
- Which CI platforms are supported?
- How much configuration needed?
- What's provided out-of-box?
- Can it be extended?

**Rating Criteria:**
- ⭐⭐⭐⭐⭐ Native integration with major platforms, zero config
- ⭐⭐⭐⭐ Good support for 2-3 platforms
- ⭐⭐⭐ Works but requires manual config
- ⭐⭐ Limited platform support
- ⭐ No built-in CI support

[etc. for each dimension]
```

### Preset Templates

**Skill includes reference templates for common scenarios:**

**references/analysis-templates.md:**
1. **SDLC Framework Comparison** - Git, CI/CD, deployment, collaboration
2. **Library Evaluation** - API design, performance, bundle size, DX
3. **Architecture Assessment** - Patterns, scalability, maintainability
4. **Security Audit** - Dependencies, tests, known CVEs, permissions
5. **Migration Planning** - Feature parity, breaking changes, effort

**User can:**
- Choose preset template
- Customize preset template
- Create fully custom template

---

## Skill Implementation

### File Structure

```
git-repo-analyzer/
├── SKILL.md (~400 lines)
│   ├── YAML frontmatter (name, description)
│   ├── Core workflow (clone → analyze → compare → cleanup)
│   ├── Template customization flow
│   ├── Deep analysis guidelines
│   └── Output structure
│
├── references/
│   ├── analysis-templates.md (~300 lines)
│   │   └── 5 preset templates with dimensions
│   │
│   ├── reading-priorities.md (~200 lines)
│   │   ├── Which files to read first
│   │   ├── How to find architecture docs
│   │   ├── How to extract purpose
│   │   └── Code analysis techniques
│   │
│   └── comparison-frameworks.md (~250 lines)
│       ├── How to rate dimensions
│       ├── Scoring methodologies
│       ├── Recommendation algorithms
│       └── Visualization formats (tables, charts)
│
└── scripts/
    └── analyze-repo.sh (~150 lines)
        ├── Clone with error handling
        ├── Quick facts extraction
        ├── File counting and stats
        ├── Cleanup with trap handlers
        └── Progress reporting
```

### SKILL.md Key Sections

```markdown
---
name: git-repo-analyzer
description: Analyze and compare GitHub repositories (or any Git repo) to deeply understand functionality, architecture, and purpose. This skill should be used when evaluating frameworks or libraries from GitHub, comparing multiple codebases, assessing migration between tools, understanding how a project works before contributing, or making technology decisions based on source code examination. Clones repos, performs systematic deep analysis (not just metadata), generates comparison matrices, and provides recommendations.
---

# Git Repository Analyzer

## Overview

Systematically analyze Git repositories to gain deep understanding of functionality, architecture, and purpose. Designed for comparing frameworks, evaluating libraries, and understanding complex codebases before adoption or contribution.

## When to Use This Skill

Trigger when:
- User wants to compare multiple frameworks/libraries
- User needs to understand a complex codebase
- User is evaluating tools for adoption
- User asks to "analyze", "compare", or "evaluate" git repositories

Examples:
- "Compare these 5 SDLC frameworks"
- "Help me understand how Framework X works"
- "Evaluate these 3 state management libraries"
- "Should we migrate from Old to New? Analyze both"

## Core Workflow

### Step 1: Template Selection

**Single repository:**
Use standard comprehensive template (all dimensions)

**Multiple repositories (comparison):**
1. Ask user: "What aspects matter for your decision?"
2. Parse user intent into dimensions
3. Generate custom template with those dimensions
4. Show template to user for approval
5. Allow refinement (add/remove dimensions, change priorities)
6. Lock final template for analysis

**Template approval example:**
```
User: "Compare these 5 frameworks - I care about git workflow, CI/CD, and learning curve"

Skill generates:
┌─────────────────────────────────────┐
│ Analysis Template                   │
├─────────────────────────────────────┤
│ 1. Git Workflow (HIGH priority)     │
│    - Branch strategy                │
│    - PR process                     │
│    - Automation                     │
│                                     │
│ 2. CI/CD Integration (HIGH)         │
│    - Platform support               │
│    - Setup complexity               │
│    - Features                       │
│                                     │
│ 3. Learning Curve (HIGH)            │
│    - Documentation quality          │
│    - Example availability           │
│    - Onboarding time                │
│                                     │
│ Plus: Standard metadata             │
└─────────────────────────────────────┘

Proceed with this template? (y/n/modify)
```

User can modify before proceeding.

### Step 2: Repository Analysis (Per Repo)

For each repository:

#### 2.1: Clone & Setup
- Create temporary directory: `/tmp/git-analysis-{timestamp}/repos/{repo-name}`
- Shallow clone (faster): `git clone --depth 1 {url}`
- Handle errors (private, 404, network issues)

#### 2.2: Quick Facts Extraction
Consult `scripts/analyze-repo.sh` for:
- Star count, contributors, activity
- File counts by language
- License detection

#### 2.3: Documentation Discovery

**Priority reading order** (see `references/reading-priorities.md`):

1. **README.md** - Always read fully
   - Extract purpose statement
   - List key features
   - Note examples if present

2. **Architecture docs** - Read if exist
   - Paths to check: /docs/architecture.md, /ARCHITECTURE.md, /docs/design/
   - Extract system design, component relationships

3. **Philosophy/Design docs** - Read if exist
   - Paths: /DESIGN.md, /docs/philosophy.md, /docs/adr/
   - Extract decision rationale, trade-offs

4. **Examples/** - Scan for use cases
   - Shows intended usage patterns
   - Reveals common workflows

5. **CONTRIBUTING.md** - Reveals development culture
   - Code quality standards
   - Testing requirements
   - Review process

#### 2.4: Functionality Analysis (Deep Understanding)

**Goal:** Understand what it actually DOES, not just what it IS

**Approach:**

1. **From README:**
   - "Features" section → Primary capabilities
   - "Getting Started" → Common use cases
   - Examples → Concrete functionality

2. **From code structure:**
   - `/src/features/` → Enumerate features
   - Main entry points → Core functionality
   - Public APIs → What users can do

3. **From tests:**
   - Test descriptions reveal features
   - `describe("feature X")` blocks enumerate capabilities
   - Integration tests show workflows

4. **Generate:**
   ```markdown
   ### What It Does

   **Primary Capabilities:** (3-5 main features)
   **Secondary Features:** (5-10 additional features)
   **Concrete Examples:** (2-3 real usage examples)
   **Limitations:** (What it doesn't do)
   ```

#### 2.5: Architecture Analysis (How It Works)

**Goal:** Understand HOW it achieves its functionality

**Approach:**

1. **System design:**
   - Draw component diagram (text-based)
   - Identify layers/modules
   - Map data flow

2. **Core mechanisms:**
   - How does feature X work?
   - What algorithms/patterns used?
   - What makes it fast/safe/flexible?

3. **Technical decisions:**
   - Why this approach vs alternatives?
   - (Look for ADRs, code comments, docs)

4. **Generate:**
   ```markdown
   ### How It Works

   **Architecture:** [Pattern name + diagram]
   **Key Mechanisms:** (3-5 important mechanisms)
   **Technical Decisions:** (Why approach X over Y)
   **Performance:** (How it achieves speed/scale)
   ```

#### 2.6: Purpose Analysis (Why It Exists)

**Goal:** Understand the INTENT and philosophy

**Approach:**

1. **Problem statement:**
   - Look for: "built to solve...", "traditional tools can't...", "we needed..."
   - Usually in README intro or /docs/motivation.md

2. **Target users:**
   - Who is this for? (team size, use case, skill level)
   - Who is it NOT for?

3. **Design philosophy:**
   - Guiding principles from docs
   - Inferred from code choices
   - Stated trade-offs

4. **Generate:**
   ```markdown
   ### Purpose & Intent

   **Problem:** [Specific pain point]
   **Target Users:** [Who it's designed for]
   **Philosophy:** [Design principles]
   **When to Use:** [Ideal scenarios]
   **When NOT to Use:** [Poor fit scenarios]
   ```

#### 2.7: Save Individual Analysis

Write to: `/tmp/git-analysis-{timestamp}/raw/{repo-name}.md`

Structured markdown with all sections

### Step 3: Comparison Synthesis (If Multiple Repos)

#### 3.1: Build Comparison Matrix

- Create table with repos × dimensions
- Rate each dimension (1-5 stars)
- Add brief justifications in cells
- Calculate weighted scores if priorities specified

#### 3.2: Write Detailed Comparisons

For each dimension:
- Compare approaches across repos
- Highlight key differences
- Note trade-offs

#### 3.3: Generate Recommendation

- Score repos based on template
- Weight by user priorities
- Provide clear recommendation
- Explain reasoning
- Note alternatives if close call

#### 3.4: Save Comparison

Write to: `/tmp/git-analysis-{timestamp}/comparison-matrix.md`

### Step 4: Present Results

```markdown
Analysis complete! Generated:

**Individual analyses:**
- /tmp/git-analysis-20251105/raw/framework-a.md (1,247 lines)
- /tmp/git-analysis-20251105/raw/framework-b.md (983 lines)
- /tmp/git-analysis-20251105/raw/framework-c.md (1,105 lines)

**Comparison summary:**
- /tmp/git-analysis-20251105/comparison-matrix.md (542 lines)

**Recommendation:** Framework A
See comparison-matrix.md for detailed justification.

Files will be preserved until you delete them or next system restart.
```

### Step 5: Cleanup

- Delete cloned repos immediately
- Keep analysis files (they're valuable)
- Provide path so user can review
- User can delete directory when done

## Resources

### references/analysis-templates.md

Contains 5 preset templates for common scenarios

### references/reading-priorities.md

Guides on:
- Which files to read first (README → architecture → examples → code)
- How to find architecture docs (common paths, naming patterns)
- How to extract purpose from docs
- How to infer from code when docs lacking

### references/comparison-frameworks.md

Methodologies for:
- Rating dimensions (what makes 5 stars vs 1 star)
- Weighting priorities (how to calculate scores)
- Making recommendations (algorithm)
- Presenting comparisons (table formats, visualization)

### scripts/analyze-repo.sh

Helper script for:
- Safe cloning with error handling
- Quick metadata extraction (stars, languages, sizes)
- File counting and categorization
- Cleanup with trap handlers
```

---

## Example: Full Analysis Flow

### User Request

"Compare Nx, Turborepo, and Lerna for our team's monorepo. We care most about build speed and ease of migration from Lerna."

### Skill Execution

#### 1. Template Generation

```markdown
Skill: "I'll compare these 3 monorepo tools. Based on your priorities, here's my analysis template:

**HIGH PRIORITY:**
1. Build Speed
   - Cold build time
   - Incremental build time
   - Caching strategy
   - Parallel execution

2. Migration from Lerna
   - Migration guide availability
   - Breaking changes
   - Config translation
   - Effort estimate

**MEDIUM PRIORITY:**
3. Features & Capabilities
4. Documentation Quality
5. Community & Ecosystem

Plus standard metadata (stars, activity, license)

Proceed with this template?"

User: "Add one more: ease of debugging when builds fail"

Skill: "Updated template with 'Build Debugging' as high priority. Proceeding..."
```

#### 2. Analysis of Repo 1: Nx

```markdown
[Cloning Nx...]
[Reading README.md, docs/, examples/...]
[Analyzing build system...]
[Generating nx-analysis.md...]

Content:
# Nx - Deep Analysis

## Quick Facts
- 23,900 ⭐
- TypeScript monorepo build system
- Maintained by Nrwl (consulting company)
- MIT License
- Very active (commits daily)

## What It Does (Functionality)

**Primary Capabilities:**
1. **Incremental builds** - Dependency graph analysis, rebuilds only affected projects
2. **Distributed caching** - Nx Cloud for team-wide cache sharing (paid)
3. **Code generation** - Scaffolding for apps, libs, components
4. **Task orchestration** - Run tasks across workspace with dependencies
5. **Integration ecosystem** - 50+ official plugins (React, Angular, Node, etc.)

**How features work:**
- "Change one file → Nx detects affected projects → Rebuilds only those → Typically 80% faster than full rebuild"
- "Developer A builds project → Uploads to Nx Cloud → Developer B gets instant cache hit"
- "Generate component → `nx g @nx/react:component name` → Creates file + test + story"

**Feature completeness:**
Full lifecycle: scaffold → develop → test → build → lint → deploy

**Notable limitations:**
- Nx Cloud costs $8/dev/month for distributed cache (can use local only)
- Learning curve higher than simpler tools

## How It Works (Architecture)

**System Design:**

```
Project Graph Engine
├── Scans workspace for projects (package.json, project.json)
├── Analyzes imports to build dependency graph
└── Detects circular dependencies (errors fast)

Task Runner
├── Reads target configuration (build, test, lint targets)
├── Topological sort of dependency graph
├── Parallel execution (respects dependencies)
└── Caching layer (local + remote)

Plugin System
├── Detects installed plugins (@nx/react, @nx/node, etc.)
├── Plugins provide: generators, executors, migrations
└── Extensible: Custom plugins via @nx/devkit
```

**Key Mechanisms:**

1. **Dependency Graph:**
   - Built by parsing import statements (static analysis)
   - Updated incrementally (watches for file changes)
   - Cached in .nx/cache (reused across runs)

2. **Affected Detection:**
   - Git diff to find changed files
   - Graph traversal to find dependent projects
   - Only affected projects rebuilt

3. **Caching Strategy:**
   - Input hash: Source files + deps + task config
   - Cache key: Hash of all inputs
   - Lookup: Local .nx/cache → Nx Cloud (if configured)
   - Restoration: Copy cached output, skip execution

4. **Plugin Architecture:**
   - Plugins implement `Executor` interface
   - Registered via nx.json plugins array
   - Invoked by task runner when target executed

**Technical Decisions:**

- **Choice:** TypeScript + esbuild
  - **Why:** Fast compilation, type safety for config
  - **Trade-off:** Requires Node.js (not just shell)

- **Choice:** Monolithic CLI vs separate tools
  - **Why:** Single `nx` command for everything (simpler DX)
  - **Trade-off:** Larger installation size

**Performance:**
- Cold build (20 packages): 3-5 minutes
- Warm build (cache hit): <1 second
- Incremental (1 package): 10-30 seconds
- Scales linearly to 100s of packages

## Purpose & Philosophy

**Origin Story:**
Created by Nrwl (Google Angular team alumni) after managing large Angular monorepos. Existing tools (Lerna) focused on publishing, not building. Needed: "Fast builds + great DX for enterprise monorepos."

**Problem Solved:**
"In large monorepos, full builds take 20+ minutes. This kills developer flow and slows CI. Need: build only what changed, cache everything, provide great tooling."

**Target Users:**

**Perfect for:**
- Teams with 10+ packages in monorepo
- Enterprise scale (50-500 packages)
- Need fast iteration (can't wait for full builds)
- Value great DX (willing to invest in tooling)
- Multi-framework monorepos (React + Node + Angular)

**Not for:**
- Single package projects (use Vite, tsc directly)
- Small monorepos (<5 packages) (Nx is overkill)
- Teams wanting simple tools (high learning curve)

**Design Philosophy:**

1. **Extensibility** - "Every project is different, plugins adapt to yours"
2. **Speed** - "Builds should be instant or we failed"
3. **DX** - "Tooling should feel like magic, not work"
4. **Monorepo-first** - "Designed for monorepos, not retrofitted"

**Differentiators:**

vs **Turborepo:**
- Nx: More features, higher learning curve, older/mature
- Turbo: Simpler, faster to start, newer/growing

vs **Lerna:**
- Nx: Build-focused, comprehensive tooling
- Lerna: Publish-focused, minimal tooling

**When to use Nx:**
✅ Large monorepo (20+ packages)
✅ Multi-framework (React + Node + etc)
✅ Need code generation
✅ Want rich plugin ecosystem
✅ Team can invest in learning

**When NOT to use:**
❌ Simple monorepo (use Turbo)
❌ Just need publishing (use Lerna)
❌ Want zero config (Nx is configurable, not magic)

## Quality & Maturity

**Tests:**
- Coverage: 85%
- Types: Full TypeScript, strict mode
- Integration tests for core workflows

**CI/CD:**
- GitHub Actions for all PRs
- Automated releases
- Nightly builds against latest Node

**Documentation:**
- Comprehensive docs site (nx.dev)
- Video tutorials
- Migration guides
- API reference

**Community:**
- Very active (100+ commits/month)
- Enterprise support available
- Large plugin ecosystem
- Responsive maintainers

**Maintenance:**
- Professional team (Nrwl employees)
- Regular releases (monthly)
- Long-term support (LTS versions)

## Trade-offs & Fit

**Strengths:**
⭐ Most feature-complete monorepo tool
⭐ Excellent plugin ecosystem
⭐ Proven at massive scale (Google-sized repos)
⭐ Great DX (code generation, graph visualization)
⭐ Active professional maintenance

**Weaknesses:**
⚠️ Steeper learning curve
⚠️ More complex than Turborepo
⚠️ Distributed caching costs money (Nx Cloud)
⚠️ Opinionated (may not fit every workflow)

**Best for:**
- Enterprise teams
- Multi-framework monorepos
- Long-term investment in tooling
- Teams valuing features over simplicity

**Red flags:**
None major. Well-maintained, widely adopted, proven at scale.

---

[Analysis saved to /tmp/git-analysis-.../raw/nx-analysis.md]
```

#### 3. Repeat for Turborepo and Lerna

[Generate turborepo-analysis.md and lerna-analysis.md with same depth]

#### 4. Comparison Matrix Generation

```markdown
# Monorepo Tool Comparison: Nx vs Turborepo vs Lerna

## Quick Comparison Matrix

| Tool | Build Speed | Migration | Debugging | Features | Docs | Overall |
|------|-------------|-----------|-----------|----------|------|---------|
| **Nx** | ⭐⭐⭐⭐⭐<br>Incremental + distributed cache, <1s cache hits | ⭐⭐⭐⭐<br>Good guide, 2-3 days effort | ⭐⭐⭐⭐<br>Graph viz, detailed errors | ⭐⭐⭐⭐⭐<br>Most complete | ⭐⭐⭐⭐⭐<br>Excellent | ⭐⭐⭐⭐⭐<br>23.9k ⭐ |
| **Turborepo** | ⭐⭐⭐⭐⭐<br>Very fast, simple caching | ⭐⭐⭐⭐⭐<br>Easiest, ~1 day | ⭐⭐⭐<br>Basic errors | ⭐⭐⭐⭐<br>Core features | ⭐⭐⭐⭐<br>Good | ⭐⭐⭐⭐<br>25.1k ⭐ |
| **Lerna** | ⭐⭐<br>No caching, full rebuilds | ⭐<br>Already using | ⭐⭐<br>Basic | ⭐⭐<br>Publish-focused | ⭐⭐⭐<br>Adequate | ⭐⭐⭐<br>35.4k ⭐ |

## Detailed Dimension Analysis

### Build Speed (HIGH PRIORITY)

**Nx:**
- **Cold build:** 3-5 min for 20 packages
- **Incremental:** 10-30s (only affected packages)
- **Cache hit:** <1s (local or cloud cache)
- **Mechanism:** Dependency graph + task caching + optional distributed cache
- **Real-world:** "Change one component, rebuild in 15s instead of 5min full build"

**Turborepo:**
- **Cold build:** 3-4 min for 20 packages
- **Incremental:** 8-25s (similar to Nx)
- **Cache hit:** <500ms (local or Vercel Remote Cache)
- **Mechanism:** Task hashing + caching (simpler than Nx)
- **Real-world:** "Turborepo often slightly faster due to less overhead"

**Lerna:**
- **Cold build:** 3-5 min for 20 packages
- **Incremental:** 3-5 min (full rebuild each time!)
- **Cache hit:** N/A (no caching)
- **Mechanism:** Sequential package builds (respects dependencies)
- **Real-world:** "Every build is slow. Main weakness."

**Winner:** Turborepo (slightly) > Nx >> Lerna

### Migration from Lerna (HIGH PRIORITY)

**Nx:**
- Migration guide: Yes, comprehensive (nx.dev/recipes/adopters/lerna)
- Breaking changes: Replaces lerna.json with nx.json
- Automation: `npx nx migrate latest` command
- Effort: 2-3 days (config + testing)
- Compatibility: Can run alongside Lerna during migration

**Turborepo:**
- Migration guide: Yes (turbo.build/repo/docs/guides/migrate-from-lerna)
- Breaking changes: Add turbo.json, update package.json scripts
- Automation: Manual (no migration command)
- Effort: 1-2 days (simpler than Nx)
- Compatibility: Can coexist with Lerna

**Lerna:**
- N/A (already using)

**Winner:** Turborepo (easiest) > Nx > Lerna

### Build Debugging (HIGH PRIORITY - User added)

**Nx:**
- **Graph visualization:** `nx graph` shows dependencies visually
- **Verbose mode:** `--verbose` shows detailed execution
- **Affected command:** `nx affected:graph` shows what will rebuild
- **Error messages:** Detailed, points to failing package/task
- **Dry run:** Can preview without executing

**Turborepo:**
- **Log output:** Clear, structured logs
- **Verbose:** `--verbose` for details
- **Error messages:** Good, shows failing command
- **Dry run:** `--dry-run` flag
- **No graph viz:** Must infer dependencies

**Lerna:**
- **Log output:** Basic sequential logs
- **Verbose:** `--loglevel verbose`
- **Error messages:** Shows which package failed
- **Limited tooling:** No graph, no dry-run

**Winner:** Nx (graph viz is killer feature) > Turborepo > Lerna

[etc. for each dimension]

## Recommendation: Turborepo

### Overall Scores (Weighted)

1. **Turborepo:** 4.7 / 5.0
   - Build Speed: 5.0 × 3 (high priority) = 15
   - Migration: 5.0 × 3 (high priority) = 15
   - Debugging: 3.0 × 3 (high priority) = 9
   - Features: 4.0 × 1 (medium) = 4
   - Docs: 4.0 × 1 (medium) = 4
   - **Total:** 47 / 50

2. **Nx:** 4.6 / 5.0
   - Build Speed: 4.5 × 3 = 13.5
   - Migration: 4.0 × 3 = 12
   - Debugging: 5.0 × 3 = 15
   - Features: 5.0 × 1 = 5
   - Docs: 5.0 × 1 = 5
   - **Total:** 50.5 / 50

Wait, Nx scored higher! But recommendation is Turborepo. Let me reconsider...

Actually, for YOUR specific context:
- "Ease of migration" is critical (you said "most")
- Turborepo's migration is significantly easier
- Nx's extra features won't be used initially
- Debugging graph is nice-to-have, not essential

### Refined Recommendation: **Turborepo for initial migration, consider Nx later**

**Why Turborepo NOW:**

1. **Fastest migration path:**
   - 1-2 days vs 2-3 days (saves time)
   - Less disruption to team
   - Lower risk of breaking existing workflows

2. **Sufficient for current needs:**
   - Build speed comparable to Nx
   - Caching provides immediate value
   - Simpler = less to learn for team

3. **Migration path to Nx exists:**
   - If you need advanced features later, can migrate again
   - Nx can import Turborepo projects
   - Not locked in

**When to reconsider Nx:**
- After 6-12 months with Turborepo
- If you need: code generation, plugin ecosystem, graph visualization
- If team is comfortable with monorepo tools
- If build speed plateaus (Nx's cache distribution helps at very large scale)

**Implementation Plan:**

**Phase 1 (Week 1): Turborepo setup**
- Add turbo.json configuration
- Update package.json scripts
- Test builds
- Document for team

**Phase 2 (Week 2): Validate**
- Compare build times (before/after)
- Verify caching working
- Train team on new commands

**Phase 3 (Week 3): Optimize**
- Tune cache configuration
- Set up remote caching (Vercel or self-hosted)
- Refine task dependencies

**Phase 4 (Week 4+): Monitor**
- Track build times over time
- Gather team feedback
- Revisit Nx if needs evolve

### Alternative Scenario: If Debugging is More Critical

If build debugging was actually your TOP priority (more than migration ease):
→ **Recommendation would flip to Nx** due to graph visualization

This shows importance of template customization!

---

[Comparison saved to /tmp/git-analysis-20251105/comparison-matrix.md]
```

---

## Success Criteria

### Functional Success

✅ **Single repo:** Generates comprehensive understanding (not just metadata)
✅ **Multiple repos:** Produces meaningful comparison matrix
✅ **Custom templates:** User can focus analysis on their priorities
✅ **Consistent depth:** Same thoroughness across all repos
✅ **Actionable output:** Clear recommendations with justification

### Quality Success

✅ **Understanding depth:** Goes beyond "it's written in TypeScript"
✅ **Reveals intent:** Explains WHY choices were made
✅ **Practical:** Provides implementation guidance
✅ **Reusable:** Analysis files useful for reference later
✅ **Accurate:** No hallucinations (based on actual code/docs)

### Efficiency Success

✅ **Time savings:** 50+ message analysis → 5 messages
✅ **Consistency:** Same questions for each repo (no forgotten dimensions)
✅ **Cleanup:** No leftover cloned repos
✅ **Automation:** Minimal user input after template approval

---

## Edge Cases & Error Handling

### Private Repositories

**Scenario:** Repo requires authentication

**Handling:**
```
Attempt clone → Fails with authentication error

Skill: "This repository is private. Options:
1. Skip it (continue with other repos)
2. Authenticate: Set GITHUB_TOKEN env var and retry
3. Provide SSH key

What would you like to do?"
```

### Repository Not Found (404)

**Scenario:** URL is wrong or repo deleted

**Handling:**
```
Attempt clone → 404 error

Skill: "Repository not found: {url}

Possible causes:
- URL typo
- Repository moved/deleted
- Organization name changed

Skipping this repository. Continuing with others..."
```

### Very Large Repositories

**Scenario:** Repo is 5GB+, would take forever

**Handling:**
```bash
# Check size before cloning
SIZE=$(gh api repos/owner/repo --jq '.size')  # Size in KB

if [ $SIZE -gt 1000000 ]; then  # > 1GB
  echo "Warning: Large repository ($SIZE KB)"
  echo "Options:"
  echo "1. Shallow clone (fast, limited history)"
  echo "2. Sparse checkout (only specific directories)"
  echo "3. Skip analysis"

  # Recommend: Shallow clone for analysis (--depth 1)
fi
```

### No Documentation

**Scenario:** Repo has no README, no docs/, no comments

**Handling:**
```
README.md not found
/docs/ directory not found
No markdown files in root

Skill: "Limited documentation available. Analysis will be based on:
- Code structure inference
- Dependency analysis
- Test file examination
- Package.json metadata

Note: Understanding will be less deep than repos with good docs."

Proceeds with code-based analysis (structure, patterns, dependencies)
```

### Template Ambiguity

**Scenario:** User says "compare these frameworks" without specifying criteria

**Handling:**
```
Skill: "I'll compare these frameworks. To provide the most relevant analysis, what matters most for your decision?

Common dimensions:
- Build speed / performance
- Features & capabilities
- Learning curve / documentation
- Migration effort
- Scalability
- Community & ecosystem

Or I can use the standard comprehensive template (covers all aspects).

What would you like me to focus on?"
```

---

## Development Roadmap

### Phase 1: Core Analyzer (MVP) - 6-8 hours

**Deliverables:**
- SKILL.md with core workflow
- Standard comprehensive template
- Deep analysis guidelines (functionality, architecture, purpose)
- Single repo analysis
- Comparison for multiple repos
- Cleanup automation

**Testing:**
- Analyze 3 known repos (validation)
- Compare 2 frameworks (SDLC or build tools)
- Verify depth of understanding

### Phase 2: Template System - 3-4 hours

**Deliverables:**
- Template customization flow
- 5 preset templates in references
- User approval workflow
- Template refinement

**Testing:**
- Custom template for specific comparison
- Verify template consistency across repos

### Phase 3: Enhanced References - 3-4 hours

**Deliverables:**
- reading-priorities.md (which files to read)
- comparison-frameworks.md (rating methodologies)
- Example analyses (for quality reference)

### Phase 4: Polish & Package - 2 hours

**Deliverables:**
- Final testing across repo types
- Error handling improvements
- Package with skill-creator
- Add to SuperSkills marketplace

**Total Effort:** 14-18 hours

---

## Integration with SuperSkills

### Catalog Positioning

**Type:** Skill (not MCP server)
**Category:** Development Tools
**Differentiator:** "Skills can replace MCPs for analysis workflows"

### Marketplace Entry

```json
{
  "slug": "git-repo-analyzer",
  "displayName": "Git Repo Analyzer",
  "type": "skill",
  "category": "Development & Testing",
  "icon": "🔍",
  "shortDescription": "Deep repository analysis and framework comparison",
  "fullDescription": "Systematically analyze and compare Git repositories. Understands functionality, architecture, and purpose - not just surface metadata. Includes template customization for focused comparisons.",
  "contains": ["Deep analysis workflow", "Comparison matrices", "Custom templates"],
  "setupGuide": "Install skill, then ask: 'Compare these 3 frameworks' or 'Analyze this repository'"
}
```

---

## Why This Is Better Than Alternatives

### vs Manual Exploration

**Manual:** 50+ messages, inconsistent, no synthesis
**Skill:** 5 messages, systematic, automatic comparison

### vs Simple "Clone and Look"

**Simple:** Surface-level, misses intent, no comparison framework
**Skill:** Deep understanding, reveals purpose, structured comparison

### vs Generic Research Skill

**Generic:** Treats repo like any research topic
**Skill:** Code-specific analysis (dependencies, architecture, tests)

### vs MCP Server

**MCP:** Would consume thousands of tokens, complex setup
**Skill:** 30-50 tokens until loaded, zero setup

---

## Conclusion

This skill fills a real gap: **systematic, deep repository analysis with user control**. It's not just automation of cloning - it's a framework for understanding codebases and making informed decisions about frameworks, libraries, and tools.

**The modular approach** (data gatherer, not expert) means it composes well with future expert skills while providing immediate standalone value.

**The template customization** ensures it's useful for diverse needs (from "quick comparison" to "deep evaluation") without becoming a Swiss Army knife that does everything poorly.

**Ready for implementation.**

---

**Spec Version:** 1.0
**Status:** Complete, ready for development
**Next:** Build Phase 1 (6-8 hours), test with real SDLC framework comparison
