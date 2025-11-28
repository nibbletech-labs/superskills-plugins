# Spec Analyzer

**Status:** 📋 Spec Complete
**Last Updated:** November 5, 2025
**Complements:** skill-creator (for building skills), skill-analyzer (for optimizing built skills)

---

## Executive Summary

The **spec-analyzer** is a pre-build validation skill that evaluates skill specification documents BEFORE implementation begins. While **skill-creator** guides the building of NEW skills and **skill-analyzer** optimizes EXISTING skills, **spec-analyzer** acts as a quality gate between ideation and implementation—ensuring specs are complete, clear, and feasible before investing hours in development.

### The Problem It Solves

Currently, there's a gap in the skill development lifecycle:

```
User Idea → Write Spec → ??? → Build Skill → Test → Fix Issues
                           ↑
                    No validation here!
```

This gap leads to:
- **Incomplete specs** → skill-creator struggles to extract resources
- **Scope creep** → One skill becomes three skills
- **Vague invocation criteria** → Skill triggers incorrectly
- **Missing prerequisites** → Can't be built without dependencies
- **Wasted implementation time** → Hours spent building from flawed specs

**spec-analyzer fills this gap** by validating specs are ready for skill-creator.

### Value Proposition

| Benefit | Impact |
|---------|--------|
| **Catch issues early** | Save 2-10 hours of rework per skill |
| **Improve spec quality** | Higher success rate with skill-creator |
| **Validate scope** | Prevent multi-skill specs masquerading as one |
| **Predict invocation** | Catch trigger problems before implementation |
| **Ensure feasibility** | Identify missing dependencies upfront |

---

## Positioning in the Skill Development Ecosystem

### The Three-Skill Toolkit

| Skill | Input | Focus | Output | Stage | When to Use |
|-------|-------|-------|--------|-------|-------------|
| **skill-creator** | User idea + conversation | Create NEW skill | Skill directory | Pre-build | "Help me create a skill" |
| **spec-analyzer** | Spec document | Validate spec quality | Gap analysis report | Pre-build validation | "Is this spec ready to build?" |
| **skill-analyzer** | Built skill directory | Optimize EXISTING skill | Quality report + improvements | Post-build | "Improve this skill" |

### Key Differentiators

**spec-analyzer vs. skill-creator:**
- **skill-creator** teaches HOW to build and guides the process interactively
- **spec-analyzer** validates a WRITTEN spec document is ready for that process
- **spec-analyzer** is a checkpoint BEFORE invoking skill-creator

**spec-analyzer vs. skill-analyzer:**
- **spec-analyzer** evaluates the PLAN (spec document) - **predictive**
- **skill-analyzer** evaluates the IMPLEMENTATION (built skill) - **retrospective**
- One asks "will this work?", the other asks "did this work?"

**All Three Work Together:**
```
1. IDEATE (User idea)
2. SPEC (User writes spec doc)
3. VALIDATE SPEC (spec-analyzer) ← NEW
4. BUILD (skill-creator)
5. USE (Real-world testing)
6. ANALYZE (skill-analyzer)
7. IMPROVE & iterate
```

---

## When to Invoke This Skill

This skill should be invoked when users:

1. **Have written a skill spec and want validation**
   - "Is this spec ready to build?"
   - "Review this skill specification"
   - "Validate my skill spec"

2. **Want to check completeness before building**
   - "Does this spec have everything needed?"
   - "Am I missing anything in this spec?"
   - "Check if this is ready for skill-creator"

3. **Want scope validation**
   - "Is this one skill or multiple skills?"
   - "Is this scope appropriate?"
   - "Should I split this into separate skills?"

4. **Need invocation trigger prediction**
   - "Will this skill trigger correctly?"
   - "What should the description be?"
   - "Are these invocation criteria clear?"

5. **Want feasibility assessment**
   - "Can this be built?"
   - "What dependencies are needed?"
   - "How complex is this to implement?"

### When NOT to Invoke

- Creating a skill from scratch (use **skill-creator** instead)
- Analyzing an already-built skill (use **skill-analyzer** instead)
- General questions about what skills are (use **skill-creator**)
- Packaging or distributing a skill (handled by skill-creator)

---

## Analysis Dimensions

The spec-analyzer evaluates specs across six core dimensions:

### 1. Spec Completeness for skill-creator (30%)

**Purpose:** Validate the spec contains everything skill-creator needs to execute its 6-step process.

#### What skill-creator Needs (by Step)

**Step 1: Understanding the Skill**
- ✅ Concrete usage examples (at least 3-5)
- ✅ Example user queries that should trigger the skill
- ✅ Clear use cases with context
- ✅ Expected outputs/outcomes

**Step 2: Planning Reusable Contents**
- ✅ Identifiable patterns for scripts (repeated code)
- ✅ Identifiable content for references (schemas, docs, knowledge)
- ✅ Identifiable templates for assets (boilerplate, output files)

**Step 3-5: Implementation**
- ✅ Clear workflow description
- ✅ Success criteria (how to know it works)
- ✅ Edge cases and error scenarios
- ✅ Required tools/MCPs/dependencies

**Step 6: Iteration**
- ✅ Testing strategy
- ✅ Known limitations or constraints

#### Analysis Process

1. **Load skill-creator skill** into context
2. **Map spec to 6-step process**:
   - For each step, check: "Does the spec provide what this step needs?"
3. **Identify gaps**: What's missing that skill-creator would require?
4. **Generate recommendations**: Specific additions to make the spec complete

#### Scoring Matrix

| Completeness | Score | Description |
|--------------|-------|-------------|
| Fully complete | 90-100% | All 6 steps have required information |
| Mostly complete | 70-89% | Minor gaps (1-2 steps need clarification) |
| Partially complete | 50-69% | Multiple gaps (3-4 steps missing info) |
| Incomplete | 30-49% | Major gaps (5+ steps missing info) |
| Very incomplete | 0-29% | Most information missing |

#### Example Output

```markdown
## Spec Completeness Analysis (85/100 - B)

### ✅ Complete (Steps 1, 3, 4, 5)
- Step 1: Has 5 concrete examples with user queries
- Step 3-5: Clear workflow and implementation approach
- Step 5: Dependencies clearly listed

### ⚠️ Partially Complete (Step 2)
- **Gap:** Resource planning is vague
- **Issue:** Spec mentions "will need scripts" but doesn't identify which patterns should be scripted
- **Recommendation:** Add specific examples of repeated code that would benefit from scripting

**Example to add:**
> "The PDF rotation operation will be repeated across multiple workflows with the same parameters. Extract to `scripts/rotate_pdf.py` with parameters: filepath, degrees, output_path."

### ❌ Missing (Step 6)
- **Gap:** No testing strategy or iteration plan
- **Issue:** How will you validate the skill works correctly?
- **Recommendation:** Add success criteria and test cases

**Example to add:**
> "Success criteria: Skill correctly rotates PDFs by 90/180/270 degrees, preserves quality, handles errors gracefully. Test with 5 sample PDFs of varying sizes and formats."
```

---

### 2. Skill Scope Analysis (25%)

**Purpose:** Determine if the spec describes ONE focused skill or if scope adjustments are needed.

#### The Four Scope Problems

**Problem 1: Multiple Skills Disguised as One**

Signs:
- Spec includes "and also..." or "plus..." frequently
- Unrelated capabilities bundled together
- Multiple distinct workflows with different tools
- Would need different invocation criteria for different features

Example:
```
❌ BAD: "PDF Editor Plus"
- Rotate, crop, merge PDFs
- Convert PDFs to images
- Extract text via OCR
- Compress images
- Generate thumbnails

✅ GOOD: Split into 3 skills
1. "PDF Manipulator" - rotate, crop, merge
2. "PDF Text Extractor" - OCR and text extraction
3. "Image Optimizer" - compression and thumbnails
```

**Problem 2: Scope Too Narrow**

Signs:
- Only one use case with no room for extension
- Hyper-specific constraints (e.g., "only clockwise rotation")
- Would need a new skill for every minor variation

Example:
```
❌ BAD: "PDF Clockwise Rotator"
- Only rotates PDFs clockwise by 90 degrees

✅ GOOD: "PDF Rotator"
- Rotates PDFs by any degree (90, 180, 270, custom)
- Handles both directions
```

**Problem 3: Scope Too Broad**

Signs:
- Tries to be "universal" or "complete" solution
- Many unrelated capabilities under vague umbrella
- Would result in massive SKILL.md (>10k words)
- No clear single purpose

Example:
```
❌ BAD: "Universal Document Processor"
- Works with PDFs, Word, Excel, PowerPoint, images, videos
- Handles creation, editing, conversion, analysis
- Supports 20+ file formats

✅ GOOD: Focus on one domain
- "PDF Workflow Assistant" - PDFs only
- "Office Document Manager" - Word/Excel/PowerPoint
- "Media Converter" - Images/videos
```

**Problem 4: Unclear Boundaries**

Signs:
- In-scope and out-of-scope not defined
- Unclear when to use this skill vs. others
- Overlaps with existing skills

#### Analysis Workflow

1. **Extract capabilities** from spec
2. **Group by domain/tool/workflow**
3. **Assess cohesion**: Do all capabilities support a single purpose?
4. **Check scope level**: Too narrow / Appropriate / Too broad / Multiple skills
5. **Recommend adjustments**

#### Scoring

| Assessment | Score | Action |
|------------|-------|--------|
| Perfect scope | 90-100% | No changes needed |
| Minor adjustments | 70-89% | Small refinements to boundaries |
| Needs refocus | 50-69% | Narrow or expand scope |
| Significant issues | 30-49% | Major restructuring needed |
| Must split/merge | 0-29% | Fundamentally wrong scope |

#### Example Output

```markdown
## Scope Analysis (65/100 - D)

### Assessment: Multiple Skills Detected

This spec describes **3 distinct skills**:

1. **"PDF Manipulator"** (Core functionality)
   - Rotate, crop, merge, split PDFs
   - Clear workflow, cohesive tools
   - Should be the primary skill

2. **"PDF Analyzer"** (Separate skill)
   - Extract metadata, analyze structure
   - Different use cases, different tools
   - Should be split out

3. **"PDF to Image Converter"** (Separate skill)
   - Conversion functionality only
   - Could be standalone or bundled with #1

### Recommendation: Split into 2 Skills

**Skill 1: "PDF Manipulator"** (Keep together)
- Rotate, crop, merge, split PDFs
- Convert to images (related to manipulation)
- Invocation: "edit PDF", "modify PDF", "combine PDFs"

**Skill 2: "PDF Analyzer"** (New skill)
- Extract metadata, text, structure
- Analyze PDF properties
- Invocation: "analyze PDF", "extract from PDF", "PDF info"

### Rationale
- Different invocation patterns (edit vs. analyze)
- Different tool sets
- Splitting improves progressive disclosure (smaller SKILL.md files)
- Clearer descriptions = better invocation accuracy
```

---

### 3. Invocation Predictability (20%)

**Purpose:** Predict whether the skill will trigger correctly based on the spec's invocation criteria.

#### What Makes Invocations Work

Good invocation requires:
1. **Specific keywords** that uniquely identify when to use the skill
2. **Clear use cases** that map to user intent
3. **Disambiguation** from other similar skills
4. **Both positive and negative examples** (when to use, when NOT to use)

#### Analysis Process

**Step 1: Extract Invocation Signals from Spec**
- Keywords mentioned (nouns, verbs, domain terms)
- Example user queries
- Use case descriptions
- Tools/technologies mentioned

**Step 2: Generate Predicted Description**
Based on the spec, what would the skill description say?

**Step 3: Test with Example Queries**
Generate test queries:
- 10 positive examples (SHOULD invoke this skill)
- 10 negative examples (SHOULD NOT invoke this skill)
- 5 ambiguous examples (could go either way)

For each query, predict:
- Would this skill be invoked? (Yes/No/Maybe)
- Confidence level (High/Medium/Low)
- Competing skills that might be invoked instead

**Step 4: Identify Risks**
- **False Positives**: Queries that would incorrectly trigger the skill
- **False Negatives**: Valid queries that would NOT trigger the skill
- **Ambiguities**: Unclear cases where multiple skills could apply

#### Scoring

| Confidence | Score | Description |
|------------|-------|-------------|
| High | 80-100% | Clear, specific triggers with low false positive/negative risk |
| Medium | 60-79% | Mostly clear but some ambiguities |
| Low | 40-59% | Vague triggers, high false positive/negative risk |
| Very Low | 0-39% | Unclear invocation criteria, will trigger incorrectly |

#### Example Output

```markdown
## Invocation Predictability Analysis (75/100 - C)

### Predicted Description

Based on the spec, the skill description would likely be:

> "Manipulates PDF documents through rotation, cropping, merging, and splitting operations. Invoked when users need to modify or combine PDF files. Uses PyPDF2 for PDF operations."

### Trigger Keyword Analysis

**Strong Triggers (High Confidence):**
- "rotate PDF" → 95% confidence
- "merge PDFs" → 95% confidence
- "crop PDF" → 90% confidence
- "split PDF" → 90% confidence

**Weak Triggers (Medium Confidence):**
- "edit PDF" → 60% confidence (ambiguous - could mean text editing)
- "modify PDF" → 60% confidence (too generic)
- "PDF" alone → 30% confidence (too broad)

**Missing Triggers:**
- "combine PDFs" not mentioned in spec
- "join PDFs" not mentioned (synonym for merge)

### Risk Analysis

#### False Positives (Would trigger incorrectly)
1. "Edit text in PDF" → Skill doesn't support text editing, only manipulation
2. "Fill PDF form" → Different workflow, needs different skill
3. "Convert PDF to Word" → Not in scope

**Mitigation:** Add negative examples to description: "Not for text editing or PDF forms."

#### False Negatives (Would NOT trigger but should)
1. "Combine multiple PDFs into one" → "Combine" not in description, but it's a valid use case
2. "Turn my PDF sideways" → Natural language for rotation, might be missed
3. "Join PDFs" → Synonym for merge

**Mitigation:** Expand description keywords to include: "combine", "join", "rotation", and natural language variations.

#### Competing Skills
- "PDF Text Extractor" might be invoked for "get data from PDF"
- "PDF Form Filler" might compete for "work with PDF"
- Need clear disambiguation in description

### Recommendations

1. **Add explicit exclusions** to description:
   > "...Not for text editing, form filling, or PDF creation from scratch."

2. **Include synonym keywords:**
   - "combine" alongside "merge"
   - "join" alongside "merge"
   - "turn" alongside "rotate"

3. **Make description more specific:**
   ```diff
   - "Manipulates PDF documents through rotation, cropping, merging, and splitting operations."
   + "Manipulates existing PDF files through rotation, cropping, merging, and splitting operations. Handles physical document manipulation (not text editing). Invoked for queries like 'rotate PDF', 'merge PDFs', 'crop PDF', or 'split PDF into pages'."
   ```

### Confidence Assessment

**Overall Confidence: Medium (75%)**

With recommended changes: **High (90%)**
```

---

### 4. Resource Identification (15%)

**Purpose:** Help identify what scripts, references, and assets should be bundled (skill-creator Step 2).

#### The Three Resource Types

**Scripts (`scripts/`)**: Executable code for repeated operations
- When code would be rewritten identically each time
- When deterministic reliability is needed
- When operations are complex and error-prone

**References (`references/`)**: Documentation loaded as-needed
- Schemas, data structures, API docs
- Domain knowledge, policies, guidelines
- Detailed examples and patterns

**Assets (`assets/`)**: Files used in output
- Templates and boilerplate
- Images, fonts, icons
- Sample files to copy/modify

#### Analysis Process

**Step 1: Parse Spec for Resource Candidates**

Read through spec looking for:
- **Repeated code patterns** → Script candidate
- **Complex algorithms described** → Script candidate
- **"Each time we do X"** → Script candidate
- **"Here's the schema/structure"** → Reference candidate
- **"Company policy states"** → Reference candidate
- **"Use this template"** → Asset candidate
- **"Start with this boilerplate"** → Asset candidate

**Step 2: Categorize Resources**

For each candidate:
1. **Name the resource**: What file would this be?
2. **Justify inclusion**: Why bundle this vs. writing inline?
3. **Estimate impact**: Token savings, reliability improvement

**Step 3: Identify Missing Resources**

- Spec mentions "use the company schema" but doesn't provide it → Missing reference
- Spec says "script this operation" but no details → Missing script specification
- Spec references a template that doesn't exist → Missing asset

**Step 4: Estimate Progressive Disclosure Impact**

- Current estimate: SKILL.md size if everything is inline
- With externalization: SKILL.md size after moving to resources
- Savings: Token/word reduction percentage

#### Example Output

```markdown
## Resource Identification (12/15 - 80%)

### Recommended Scripts (3 identified)

#### 1. `scripts/rotate_pdf.py`
**Why:** PDF rotation is repeated across multiple workflows with the same logic
**Usage:** Rotate PDF by specified degrees (90, 180, 270, custom)
**Interface:**
```python
rotate_pdf(input_path, degrees, output_path, preserve_quality=True)
```
**Impact:** Saves ~150 tokens per usage, ensures consistent rotation logic

#### 2. `scripts/merge_pdfs.py`
**Why:** Merging operation has complex error handling for different PDF versions
**Usage:** Combine multiple PDFs into one
**Interface:**
```python
merge_pdfs(input_paths: list, output_path, preserve_bookmarks=True)
```
**Impact:** Saves ~200 tokens per usage, handles edge cases deterministically

#### 3. `scripts/validate_pdf.py`
**Why:** Pre-operation validation prevents errors downstream
**Usage:** Check if PDF is valid and not corrupted
**Interface:**
```python
validate_pdf(path) -> dict[is_valid: bool, error: str, metadata: dict]
```
**Impact:** Improves reliability, saves ~100 tokens per usage

### Recommended References (2 identified)

#### 1. `references/pdf-formats.md`
**Why:** Spec mentions "different PDF versions have different capabilities"
**Content:** PDF version compatibility matrix, known limitations
**When to load:** When user encounters version-specific issues
**Impact:** Keeps SKILL.md lean (~300 tokens externalized)

#### 2. `references/error-handling.md`
**Why:** Spec describes complex error scenarios
**Content:** Error codes, recovery strategies, user-facing messages
**When to load:** When errors occur or when implementing error handling
**Impact:** ~400 tokens externalized, loaded as-needed

### Recommended Assets (1 identified)

#### 1. `assets/pdf-manipulation-examples/`
**Why:** Spec mentions providing sample PDFs for testing
**Content:** Directory with 5 sample PDFs of varying complexity
**Usage:** Used in testing and examples
**Impact:** Enables better testing, doesn't consume context tokens

### Missing Resources (Items to Add to Spec)

1. **Missing Script Specification:**
   - Spec mentions "crop PDF" but doesn't describe the algorithm
   - **Action:** Add cropping logic details to spec (or reference an existing library)

2. **Missing Reference:**
   - Spec says "follows PDF/A standards" but doesn't provide the standard
   - **Action:** Add `references/pdf-a-standard.md` or link to spec

3. **Missing Asset:**
   - Spec mentions "use standard metadata template" but doesn't include it
   - **Action:** Provide template file to include as asset

### Progressive Disclosure Impact

**Current estimate (everything inline):**
- SKILL.md: ~5,000 words (~6,500 tokens)

**With recommended externalization:**
- SKILL.md: ~3,000 words (~4,000 tokens)
- Scripts: 3 files (not loaded into context until execution)
- References: ~700 tokens (loaded as-needed)
- Assets: 0 tokens (never loaded into context)

**Net impact:** ~2,500 token reduction in default context load (38% smaller)
```

---

### 5. Implementation Feasibility (10%)

**Purpose:** Assess whether the spec can be built given current tooling, dependencies, and constraints.

#### Feasibility Checks

**Check 1: Required Tools/MCPs Available?**
- Parse spec for external dependencies
- Check if tools exist (MCP servers, APIs, libraries)
- Identify gaps

**Check 2: Technical Blockers?**
- Capabilities Claude doesn't have (e.g., execute arbitrary code, access hardware)
- Unsupported platforms or languages
- Security/safety constraints

**Check 3: Missing Prerequisites?**
- User data not specified (credentials, API keys, file paths)
- External services not configured
- Permissions not available

**Check 4: Implementation Complexity?**
- Estimate effort: Simple / Moderate / Complex / Very Complex
- Identify most challenging components
- Suggest phased implementation if very complex

#### Scoring

| Feasibility | Score | Description |
|-------------|-------|-------------|
| Immediately buildable | 90-100% | All dependencies available, no blockers |
| Needs dependencies | 70-89% | Minor setup required (install MCP, etc.) |
| Has blockers | 40-69% | Significant issues to resolve first |
| Not feasible | 0-39% | Cannot be built as specified |

#### Example Output

```markdown
## Implementation Feasibility (85/100 - B)

### ✅ Feasibility: Immediately Buildable (with minor setup)

### Dependency Check

#### Required Tools
1. **PyPDF2 library** ✅ Available
   - Python library for PDF manipulation
   - Can be installed via: `pip install PyPDF2`

2. **Python 3.8+** ✅ Available
   - Standard environment for Claude Code
   - No issues

3. **File system access** ✅ Available
   - Read/Write tools available
   - Can manipulate local files

#### Optional Tools
1. **PDF.js (for web preview)** ⚠️ Optional
   - Spec mentions "preview PDF in browser"
   - Not required for core functionality
   - Recommendation: Mark as future enhancement

### Blocker Analysis

#### No Critical Blockers

#### Minor Issues to Resolve
1. **PyPDF2 installation**
   - Action: Add installation instruction to SKILL.md
   - Time: 2 minutes
   - User needs to run: `pip install PyPDF2`

2. **Test PDFs**
   - Action: Include sample PDFs in `assets/`
   - Time: 5 minutes
   - Or: Provide URLs to download test files

### Technical Feasibility

All operations are technically feasible:
- ✅ PDF rotation: PyPDF2.PageObject.rotateClockwise()
- ✅ PDF merging: PyPDF2.PdfMerger()
- ✅ PDF cropping: PyPDF2.PageObject.cropBox
- ✅ PDF splitting: PyPDF2.PdfReader + PdfWriter

No unsupported operations.

### Complexity Estimate

**Overall: Moderate (4-6 hours)**

Breakdown:
- SKILL.md writing: 1-2 hours
- Script development: 2-3 hours
  - `rotate_pdf.py`: 45 min
  - `merge_pdfs.py`: 60 min
  - `validate_pdf.py`: 30 min
- Testing & refinement: 1 hour
- Documentation: 30 min

**Recommendation:** Can be built in one session. No phased approach needed.

### Prerequisites Needed from User

1. **Confirm PyPDF2 vs. alternative libraries**
   - PyPDF2 is free and well-documented
   - Alternative: pypdf (fork of PyPDF2, more actively maintained)
   - User decision needed

2. **Test file sources**
   - Provide sample PDFs, or
   - Give permission to download from public sources

3. **Error handling preferences**
   - How verbose should error messages be?
   - Should errors be logged to file?

### Phased Implementation (Optional)

If user prefers incremental delivery:

**Phase 1 (2 hours):** Core functionality
- Rotation and merging only
- Basic error handling
- Manual testing

**Phase 2 (2 hours):** Enhanced features
- Cropping and splitting
- Validation script
- Reference docs

**Phase 3 (2 hours):** Polish
- Comprehensive error handling
- Asset templates
- Automated testing
```

---

### 6. Spec Quality & Clarity (10%)

**Purpose:** Validate the spec document itself is well-written and understandable.

#### Quality Checks

**Structure:**
- ✅ Has clear title/name
- ✅ Purpose statement at the top
- ✅ Organized into logical sections
- ✅ Uses headings appropriately

**Clarity:**
- ✅ Technical terms are defined
- ✅ Assumptions are stated explicitly
- ✅ Prerequisites are clear
- ✅ Ambiguities are minimal

**Concreteness:**
- ✅ Examples are specific (not generic)
- ✅ Use cases include context
- ✅ Expected outcomes are described
- ✅ Edge cases are mentioned

**Completeness:**
- ✅ Success criteria defined
- ✅ Out-of-scope items clarified
- ✅ Known limitations stated
- ✅ Testing approach described

#### Scoring

| Quality | Score | Description |
|---------|-------|-------------|
| Excellent | 90-100% | Clear, concrete, complete |
| Good | 70-89% | Mostly clear, minor improvements |
| Acceptable | 50-69% | Understandable but needs work |
| Poor | 0-49% | Confusing, incomplete, or vague |

#### Example Output

```markdown
## Spec Quality & Clarity (8/10 - 80%)

### ✅ Strengths

1. **Clear Structure**
   - Well-organized sections
   - Logical flow from purpose → use cases → implementation
   - Good use of headings

2. **Concrete Examples**
   - 5 specific user queries provided
   - Use cases include context ("User wants to combine quarterly reports...")
   - Expected outputs described

3. **Explicit Prerequisites**
   - Lists required tools (PyPDF2, Python 3.8+)
   - States file access requirements

### ⚠️ Issues Found

1. **Vague Success Criteria** (Medium Priority)
   - **Current:** "Should work correctly"
   - **Issue:** Not measurable
   - **Fix:** "Success: Rotates PDFs by 90/180/270° without quality loss, completes in <5 seconds for files <10MB"

2. **Undefined Technical Terms** (Low Priority)
   - **Term:** "PDF/A compliance"
   - **Issue:** Not explained
   - **Fix:** Add brief definition or link to reference

3. **Missing Out-of-Scope Clarification** (Medium Priority)
   - **Issue:** Doesn't state what the skill will NOT do
   - **Fix:** Add section: "Out of Scope: Text editing, form filling, PDF creation from images"

4. **Ambiguous Error Handling** (Low Priority)
   - **Current:** "Handle errors gracefully"
   - **Issue:** Not specific
   - **Fix:** "On error: Log to console, show user-friendly message, preserve original file"

### 📋 Recommendations

#### High Priority (Fix Before Building)
None - spec is buildable as-is

#### Medium Priority (Improve Clarity)
1. Add measurable success criteria
2. Clarify out-of-scope items
3. Define technical terms inline or in glossary

#### Low Priority (Polish)
1. Expand error handling description
2. Add troubleshooting section
3. Include FAQ for common questions

### Clarity Score: Good (80%)

The spec is clear enough to build from. Recommended improvements would bring it to Excellent (90%+).
```

---

## Metadata Management

When analysis completes, spec-analyzer **MUST offer** to write metadata to the spec file. This enables skill-development-coach and other tools to detect validation status without re-running analysis.

### Writing Metadata

After generating the analysis report, prompt the user:

```
"Analysis complete! Would you like me to update your spec with these validation results?

This adds a metadata section to track:
- Validation score and grade
- Pass/fail status (for quality gates)
- Issues found
- Date of analysis

This helps track progress and enables workflow tools to know the spec has been validated."
```

### Metadata Structure

If user agrees, add or update the spec file's YAML frontmatter:

```yaml
---
name: "skill-name"
description: "Original description..."

# spec-analyzer adds this section
skill-dev-metadata:
  spec-analyzer:
    last-run: "2025-11-05T14:30:00Z"
    score: 85
    grade: "B"
    passed: true  # true if score >= 75
    issues:
      critical: 0
      important: 2
      nice-to-have: 1
    dimensions:
      completeness: 88
      scope: 90
      invocation: 75
      resources: 85
      feasibility: 90
      quality: 80
---

# [Rest of spec content unchanged]
```

### Metadata Fields Explained

| Field | Purpose | Usage |
|-------|---------|-------|
| `last-run` | ISO 8601 timestamp | Detect stale analyses (>7 days old) |
| `score` | Overall score (0-100) | Quick quality check |
| `grade` | Letter grade (A-F) | Human-readable quality |
| `passed` | Boolean (score >= 75) | Quality gate for building |
| `issues.critical` | Count of critical issues | Identify blocking problems |
| `issues.important` | Count of important issues | Track improvement areas |
| `issues.nice-to-have` | Count of polish items | Optional improvements |
| `dimensions.*` | Per-dimension scores | Detailed tracking |

### Benefits of Metadata

1. **Workflow Coordination**
   - skill-development-coach can check `passed: true` before invoking skill-creator
   - Prevents building from unvalidated specs

2. **Progress Tracking**
   - User can see score history if spec is re-analyzed
   - Track improvements: "Score improved from 68 → 85"

3. **Staleness Detection**
   - If `last-run` is old, recommend re-validation
   - Spec may have changed since last analysis

4. **Quality Gates**
   - Tools can enforce `passed: true` before proceeding
   - Marketplace can require minimum scores

### Important Notes

- **Always offer, never force** - User can decline metadata writing
- **Non-destructive** - Only adds `skill-dev-metadata` section, preserves everything else
- **Idempotent** - Re-running analysis updates metadata in place
- **Ignored by skill-creator** - Anthropic's skill-creator ignores extra YAML fields

### Re-Analysis Behavior

When analyzing a spec that already has metadata:

1. **Read existing metadata** to show improvement:
   ```
   "I see this spec was last analyzed on 2025-11-03 with score 68/100.
   Let's see how it looks now..."
   ```

2. **Compare scores** after analysis:
   ```
   "Score improved from 68 → 85 (+17 points)!

   Fixed issues:
   - Scope problem (was critical, now resolved)
   - Resource planning (was missing, now complete)

   Would you like me to update the metadata?"
   ```

3. **Update metadata** with new scores and timestamp

---

## Analysis Workflow

When this skill is invoked, follow this four-phase workflow:

### Phase 1: Spec Reading & Parsing (15%)

**Goal:** Understand what the spec describes and extract key information.

**Steps:**
1. **Locate the spec document**
   - Ask user for path if not provided
   - Validate file exists and is readable

2. **Read and parse the spec**
   - Extract title, purpose, use cases
   - Identify example queries
   - List workflows and capabilities
   - Note dependencies and prerequisites

3. **Inventory resource mentions**
   - Scripts referenced
   - References mentioned
   - Assets described
   - External tools/MCPs needed

4. **Create spec summary**
   - One-sentence purpose
   - List of 3-5 core capabilities
   - Key dependencies
   - Target users/use cases

### Phase 2: skill-creator Consultation (20%)

**Goal:** Validate the spec against skill-creator's requirements.

**Steps:**
1. **Load skill-creator skill** into context
   - Review the 6-step process
   - Understand what each step needs

2. **Map spec to skill-creator steps**
   - Step 1 (Understanding): Does spec have concrete examples?
   - Step 2 (Planning Resources): Can we identify scripts/references/assets?
   - Steps 3-5 (Implementation): Is the workflow clear?
   - Step 6 (Iteration): Is testing described?

3. **Identify gaps**
   - What would skill-creator ask for that isn't in the spec?
   - Where would skill-creator struggle?

4. **Generate skill-creator readiness score**
   - % of required information present
   - Critical gaps vs. nice-to-haves

### Phase 3: Dimensional Analysis (50%)

**Goal:** Evaluate the spec across all 6 dimensions.

**Steps:**
1. **Run each dimensional analysis** (as described above):
   - Spec Completeness (30%)
   - Skill Scope (25%)
   - Invocation Predictability (20%)
   - Resource Identification (15%)
   - Implementation Feasibility (10%)
   - Spec Quality & Clarity (10%)

2. **Calculate scores**
   - Per-dimension score (0-100)
   - Weighted overall score
   - Letter grade (A/B/C/D/F)

3. **Identify top issues**
   - Critical (must fix before building)
   - Important (should fix for quality)
   - Nice-to-have (polish/optimization)

4. **Generate recommendations**
   - Specific, actionable fixes
   - Before/after examples
   - Priority ordering

### Phase 4: Report Generation & Interaction (15%)

**Goal:** Present findings and help user improve the spec.

**Steps:**
1. **Choose report mode**
   - Quick Check (2 min): Pass/Fail with top 3 issues
   - Full Analysis (5 min): Complete dimensional report

2. **Generate report**
   - Executive summary
   - Dimensional scores
   - Prioritized recommendations
   - Before/after examples

3. **Progressive disclosure**
   - Start with summary
   - User can drill into specific dimensions
   - Provide examples on request

4. **Offer next steps**
   - "Would you like me to help fix these issues?"
   - "Should I update the spec with recommendations?"
   - "Ready to proceed to skill-creator?"

---

## Output Formats

### Quick Check Mode (2 minutes)

For rapid validation:

```markdown
# Spec Quick Check: [Skill Name]

## Overall Assessment: ⚠️ NEEDS WORK

**Score:** 68/100 (D+)
**Recommendation:** Fix critical issues before building

---

## Top 3 Issues

### 🚨 CRITICAL: Spec Describes Multiple Skills
**Dimension:** Scope Analysis (Score: 45/100)
**Issue:** This spec bundles 3 distinct skills (PDF editor, PDF analyzer, OCR tool)
**Impact:** Will result in bloated, unfocused skill with poor invocation
**Fix:** Split into 3 separate specs, starting with PDF editor as primary

### ⚠️ IMPORTANT: Incomplete Resource Planning
**Dimension:** Completeness (Score: 65/100)
**Issue:** Spec mentions "will need scripts" but doesn't identify which operations
**Impact:** skill-creator Step 2 will struggle to plan resources
**Fix:** Add specific script candidates:
- `scripts/rotate_pdf.py` for rotation operations
- `scripts/merge_pdfs.py` for combining files

### ℹ️ NICE-TO-HAVE: Vague Invocation Criteria
**Dimension:** Invocation (Score: 70/100)
**Issue:** Description keywords not specific enough ("work with PDFs" is too broad)
**Impact:** May not trigger correctly or may false-positive
**Fix:** Use specific triggers: "rotate PDF", "merge PDFs", "crop PDF"

---

## Next Steps

1. **Address critical issue:** Split into 3 specs
2. **Fix important issue:** Add resource candidates
3. **Proceed to skill-creator** once score reaches 75+

Would you like the full analysis report?
```

### Full Analysis Mode (5 minutes)

Comprehensive dimensional report:

```markdown
# Spec Analysis Report: [Skill Name]

**Analyzed:** [Date]
**Overall Score:** 68/100 (D+)
**Status:** Needs Improvement
**Recommendation:** Address critical and important issues before building

---

## Executive Summary

This spec describes a PDF manipulation tool with rotation, cropping, merging, and splitting capabilities. While the core idea is sound, the spec has **critical scope issues** (bundling multiple skills) and **incomplete resource planning** that would hinder implementation. The spec is buildable but would benefit significantly from addressing these issues first.

**Key Strengths:**
- Clear, concrete examples provided (5 user queries)
- Technical dependencies identified (PyPDF2)
- Use cases are specific and realistic

**Critical Issues:**
- Scope includes 3 separate skills (Priority: Critical)
- Resource planning incomplete (Priority: Important)
- Invocation criteria too vague (Priority: Nice-to-have)

**Estimated Time to Fix:** 1-2 hours
**Estimated Build Time (after fixes):** 4-6 hours

---

## Dimensional Scores

| Dimension | Weight | Score | Grade | Status |
|-----------|--------|-------|-------|--------|
| Spec Completeness | 30% | 65/100 | D | Needs Work |
| Skill Scope | 25% | 45/100 | F | Critical Issue |
| Invocation Predictability | 20% | 70/100 | C- | Acceptable |
| Resource Identification | 15% | 55/100 | F | Needs Work |
| Implementation Feasibility | 10% | 85/100 | B | Good |
| Spec Quality & Clarity | 10% | 80/100 | B- | Good |
| **WEIGHTED TOTAL** | **100%** | **68/100** | **D+** | **Needs Improvement** |

---

## Detailed Findings

[Include full dimensional analysis for each of the 6 dimensions as shown in previous sections]

---

## Improvement Roadmap

### 🚨 Critical Priority (Do First)

#### 1. Split Multi-Skill Spec into Focused Specs
**Dimension:** Scope Analysis
**Current Score:** 45/100
**Potential Score:** 90/100 (after fix)
**Effort:** 1 hour

**Issue:**
This spec describes 3 distinct skills bundled together:
- PDF Manipulator (rotate, crop, merge, split)
- PDF Analyzer (extract metadata, analyze structure)
- OCR Tool (extract text via image recognition)

**Impact:**
- Bloated SKILL.md (would be ~7k words)
- Poor invocation (ambiguous triggers)
- Difficult maintenance

**Recommendation:**
Create 3 separate spec documents:

1. **"pdf-manipulator-spec.md"** (Primary - build first)
   - Rotate, crop, merge, split
   - Physical document manipulation
   - ~3k words SKILL.md

2. **"pdf-analyzer-spec.md"** (Secondary)
   - Metadata extraction
   - Structure analysis
   - Different invocation pattern

3. **"pdf-ocr-spec.md"** (Tertiary - requires Tesseract)
   - Text extraction via OCR
   - Requires external dependency
   - Build last

**Before/After:**
```markdown
# Before: One bloated spec
"PDF Editor Plus" - Does everything PDF-related (7k words)

# After: Three focused specs
"PDF Manipulator" - Physical edits (3k words)
"PDF Analyzer" - Data extraction (2k words)
"PDF OCR" - Text recognition (2k words)
```

---

### ⚠️ Important Priority (Do Soon)

#### 2. Complete Resource Planning Section
**Dimension:** Spec Completeness
**Current Score:** 65/100
**Potential Score:** 85/100 (after fix)
**Effort:** 30 minutes

**Issue:**
Spec mentions "will need scripts" but doesn't identify specific candidates for skill-creator Step 2.

**Impact:**
- skill-creator will struggle with resource planning
- May miss optimization opportunities
- Unclear progressive disclosure strategy

**Recommendation:**
Add "Resource Planning" section to spec:

```markdown
## Bundled Resources

### Scripts
1. **`scripts/rotate_pdf.py`**
   - Purpose: Rotate PDFs by specified degrees
   - Usage: `rotate_pdf(input, degrees, output)`
   - Why: Operation repeated in multiple workflows

2. **`scripts/merge_pdfs.py`**
   - Purpose: Combine multiple PDFs
   - Usage: `merge_pdfs(inputs, output)`
   - Why: Complex error handling, benefits from scripting

3. **`scripts/validate_pdf.py`**
   - Purpose: Pre-operation validation
   - Usage: `validate_pdf(path) -> bool`
   - Why: Prevents errors downstream

### References
1. **`references/pdf-formats.md`**
   - Content: PDF version compatibility matrix
   - When to load: Version-specific issues

### Assets
1. **`assets/sample-pdfs/`**
   - Content: 5 test PDFs of varying complexity
   - Usage: Testing and examples
```

---

### ℹ️ Nice-to-Have Priority (Polish)

#### 3. Strengthen Invocation Criteria
**Dimension:** Invocation Predictability
**Current Score:** 70/100
**Potential Score:** 90/100 (after fix)
**Effort:** 15 minutes

**Issue:**
Invocation keywords are too generic ("work with PDFs", "edit PDFs").

**Impact:**
- May not trigger when expected
- Could false-positive on unrelated queries

**Recommendation:**
Add "Invocation Criteria" section with specific triggers:

```markdown
## Invocation Criteria

### Should Invoke For:
- "rotate PDF [file]"
- "merge these PDFs"
- "crop PDF [file]"
- "split PDF into pages"
- "combine PDFs into one"

### Should NOT Invoke For:
- "edit text in PDF" (use text editor skill)
- "fill PDF form" (use form-filler skill)
- "create PDF from images" (use PDF creator skill)
- "extract data from PDF" (use PDF analyzer skill)

### Predicted Description:
"Manipulates existing PDF files through rotation, cropping, merging, and splitting operations. Handles physical document manipulation only (not text editing or forms). Invoked for queries like 'rotate PDF', 'merge PDFs', 'crop PDF', or 'split PDF into pages'."
```

---

## skill-creator Readiness

### Can Build Now? ⚠️ Not Recommended

**Readiness Score:** 65%

The spec is technically complete enough for skill-creator to begin work, but critical issues would result in a poor-quality skill. Recommend addressing critical and important priorities first.

### After Fixes: ✅ Ready to Build

**Projected Readiness:** 90%

With recommended changes, the spec will be well-prepared for skill-creator's 6-step process.

---

## Next Steps

Would you like me to:
1. **Help implement recommendations?** I can update the spec with suggested changes
2. **Create the split specs?** Generate 3 focused spec documents from this one
3. **Proceed to skill-creator?** (Not recommended until critical issues resolved)
4. **Drill into a specific dimension?** Get more detail on any analysis area

Let me know how you'd like to proceed!
```

---

## Bundled Resources

### Scripts

#### `scripts/parse_spec.py`

**Purpose:** Parse spec documents to extract structure, examples, and key information.

**Input:** Path to spec markdown file

**Output:** JSON with:
- Title, purpose, use cases
- Example queries
- Dependencies
- Resource mentions
- Sections and structure

**Usage:**
```bash
python scripts/parse_spec.py /path/to/spec.md > spec-data.json
```

---

#### `scripts/validate_completeness.py`

**Purpose:** Check spec completeness against skill-creator's 6-step requirements.

**Input:** Parsed spec JSON

**Output:** Completeness report with:
- Per-step completeness (%)
- Missing elements
- Gap analysis

**Usage:**
```bash
python scripts/validate_completeness.py spec-data.json
```

---

#### `scripts/analyze_scope.py`

**Purpose:** Detect multi-skill specs and scope issues.

**Input:** Parsed spec JSON

**Output:** Scope analysis with:
- Capability groupings
- Cohesion score
- Split recommendations

**Usage:**
```bash
python scripts/analyze_scope.py spec-data.json
```

---

#### `scripts/predict_invocation.py`

**Purpose:** Predict invocation triggers and test with example queries.

**Input:** Parsed spec JSON, test queries file (optional)

**Output:** Invocation analysis with:
- Predicted keywords
- Test query results
- False positive/negative risks

**Usage:**
```bash
python scripts/predict_invocation.py spec-data.json --queries test-queries.txt
```

---

### References

#### `references/skill-creator-requirements.md`

**Purpose:** Complete checklist of what skill-creator needs at each step.

**When to Load:** During Phase 2 (skill-creator consultation) of analysis workflow.

**Content:**
- Step-by-step requirements from skill-creator
- What constitutes "complete" for each step
- Common gaps and how to fill them
- Examples of well-prepared specs

**Size:** ~2,000 words

**Usage Notes:**
This reference is the ground truth for completeness analysis. Load it during every spec analysis to ensure alignment with skill-creator.

---

#### `references/scope-patterns.md`

**Purpose:** Patterns for identifying scope issues (multi-skill, too narrow, too broad).

**When to Load:** During scope analysis (Dimension 2).

**Content:**
- Common multi-skill patterns ("and also...", "plus...")
- Signs of scope too narrow (one use case only)
- Signs of scope too broad ("universal", "complete")
- Examples of well-scoped vs. poorly-scoped specs
- Decision trees for scope refinement

**Size:** ~1,500 words

---

#### `references/invocation-examples.md`

**Purpose:** Large collection of invocation patterns and examples.

**When to Load:** During invocation analysis (Dimension 3) for pattern matching.

**Content:**
- 100+ example invocation descriptions
- Trigger keyword analysis
- False positive/negative case studies
- Best practices for description writing
- Natural language variations

**Size:** ~3,000 words (use grep patterns for large file)

**Grep Patterns:**
```bash
# Find examples of specific invocation types
grep -i "analyze.*skill" references/invocation-examples.md
grep -i "false positive" references/invocation-examples.md
```

---

#### `references/feasibility-checklist.md`

**Purpose:** Checklist for assessing implementation feasibility.

**When to Load:** During feasibility analysis (Dimension 5).

**Content:**
- Available tools and MCPs catalog
- Known technical limitations
- Platform capabilities
- Common blockers and solutions

**Size:** ~1,000 words

---

### Assets

#### `assets/report-template.md`

**Purpose:** Template for full analysis reports.

**Usage:** Copy and populate with analysis findings.

**Structure:**
```markdown
# Spec Analysis Report: {{SKILL_NAME}}

**Analyzed:** {{DATE}}
**Overall Score:** {{SCORE}}/100 ({{GRADE}})
**Status:** {{STATUS}}

## Executive Summary
{{SUMMARY}}

## Dimensional Scores
{{TABLE}}

## Detailed Findings
{{DIMENSIONS}}

## Improvement Roadmap
{{RECOMMENDATIONS}}

## Next Steps
{{NEXT_STEPS}}
```

---

#### `assets/quick-check-template.md`

**Purpose:** Template for quick check reports (2-minute validation).

**Usage:** Copy and populate for fast feedback.

**Structure:**
```markdown
# Spec Quick Check: {{SKILL_NAME}}

## Overall Assessment: {{STATUS_EMOJI}} {{STATUS}}

**Score:** {{SCORE}}/100 ({{GRADE}})
**Recommendation:** {{RECOMMENDATION}}

## Top 3 Issues
{{ISSUE_1}}
{{ISSUE_2}}
{{ISSUE_3}}

## Next Steps
{{NEXT_STEPS}}
```

---

## Progressive Disclosure Strategy

This skill itself follows progressive disclosure principles:

### Level 1: Metadata (Always in Context)
```yaml
name: "spec-analyzer"
description: "Validates skill specification documents before implementation. Evaluates specs for completeness (does it have what skill-creator needs?), scope appropriateness (one skill or multiple?), invocation predictability (will it trigger correctly?), and implementation feasibility. Generates gap analysis reports with actionable recommendations. Use BEFORE building a skill to catch issues early. Not for analyzing built skills (use skill-analyzer) or creating new skills (use skill-creator)."
```

**~100 words** - Clearly states when to use and when NOT to use.

### Level 2: SKILL.MD (When Invoked)
- Analysis dimensions overview (6 dimensions)
- Workflow (4 phases)
- Output formats (quick check vs. full analysis)
- Differentiation from skill-creator and skill-analyzer
- Script/reference usage guidance

**Target: ~3,000 words**

### Level 3: Bundled Resources (As Needed)

**Load proactively:**
- `scripts/parse_spec.py` - Run immediately to extract spec structure
- `scripts/validate_completeness.py` - Run for dimension 1
- `references/skill-creator-requirements.md` - Load during Phase 2

**Load on-demand:**
- `scripts/analyze_scope.py` - Only if scope analysis requested
- `scripts/predict_invocation.py` - Only if invocation analysis requested
- `references/scope-patterns.md` - When scope issues detected
- `references/invocation-examples.md` - When invocation analysis needs examples
- `references/feasibility-checklist.md` - During feasibility check

---

## Example Interactions

### Example 1: Quick Validation

**User:** "Is this spec ready to build?" [provides spec]

**Workflow:**
1. Parse spec with `parse_spec.py`
2. Run quick check (2-minute mode)
3. Present top 3 issues with clear priority

**Output:**
```
# Quick Check Results

⚠️ NEEDS WORK (Score: 68/100)

Top Issues:
1. 🚨 CRITICAL: Spec describes 3 skills, not 1
2. ⚠️ IMPORTANT: Missing resource planning
3. ℹ️ NICE-TO-HAVE: Vague invocation criteria

Recommendation: Fix critical issue first (1 hour), then proceed.
```

---

### Example 2: Full Analysis Request

**User:** "Give me a complete analysis of this spec" [provides spec]

**Workflow:**
1. Parse spec
2. Load skill-creator for consultation
3. Run all 6 dimensional analyses
4. Generate comprehensive report
5. Present with progressive disclosure

**Output:** Full analysis report (as shown in Output Formats section)

**Follow-up:** User can ask for specific dimension details, examples, or help implementing fixes.

---

### Example 3: Invocation Debugging

**User:** "Will this skill trigger correctly?" [provides spec]

**Workflow:**
1. Parse spec
2. Focus on Dimension 3 (Invocation Predictability)
3. Run `predict_invocation.py` with test queries
4. Present trigger analysis with recommendations

**Output:**
```
# Invocation Analysis

Predicted Triggers:
- "rotate PDF" → 95% confidence ✅
- "edit PDF" → 60% confidence ⚠️ (too ambiguous)

Risks:
- False Positive: "edit PDF text" would trigger but shouldn't
- False Negative: "combine PDFs" wouldn't trigger but should

Recommendation: Add "combine" keyword, exclude "text editing" explicitly.

Updated Description:
[Show before/after comparison]
```

---

### Example 4: Iterative Refinement

**User:** "I fixed the critical issue. Check again."

**Workflow:**
1. Re-run analysis
2. Compare scores before/after
3. Show improvement
4. Identify remaining issues

**Output:**
```
# Updated Analysis

Previous Score: 68/100 (D+)
Current Score: 82/100 (B-)

✅ FIXED: Scope issue resolved (split into 3 specs)
⚠️ REMAINING: Resource planning still incomplete

Progress: +14 points
Status: Now buildable, but could be better

Next: Add resource candidates to reach 90+
```

---

## Integration with Skill Development Ecosystem

### Complete Development Lifecycle

```
1. IDEATE
   User has idea for a skill
   ↓
2. SPEC
   User writes spec document
   ↓
3. VALIDATE SPEC [spec-analyzer] ← THIS SKILL
   Quick check: Pass/Fail with top issues
   Full analysis: Dimensional report
   ↓
4. REFINE SPEC
   Address gaps identified
   ↓
5. RE-VALIDATE
   Confirm fixes improved score
   ↓
6. BUILD [skill-creator]
   Follow 6-step process
   ↓
7. USE
   Real-world testing
   ↓
8. ANALYZE [skill-analyzer]
   Evaluate built skill
   ↓
9. IMPROVE
   Implement optimizations
   ↓
   Loop back to USE
```

### Handoff Points

**From ideation → spec-analyzer:**
- User has written a spec document
- Ready for validation before building

**From spec-analyzer → skill-creator:**
- Spec passes validation (75+ score)
- Critical issues resolved
- User ready to implement

**From spec-analyzer → iteration:**
- Score below 75
- User refines spec based on recommendations
- Re-validates until ready

**From spec-analyzer → skill-analyzer:**
- NOT a direct handoff
- These tools operate at different lifecycle stages
- No overlap in functionality

---

## Success Metrics

A spec analysis is successful when:

1. **User understands spec quality** (clear scores and grades)
2. **Issues are prioritized** (critical vs. nice-to-have)
3. **Recommendations are actionable** (specific fixes, not vague)
4. **User can improve spec** (before/after examples)
5. **Prevents wasted effort** (catches issues before building)
6. **Enables confident building** (90+ score = ready for skill-creator)

---

## Anti-Patterns (What This Skill Should NOT Do)

1. **Don't create specs** - That's the user's job (or help them conversationally, but don't auto-generate)
2. **Don't build skills** - That's skill-creator's job
3. **Don't analyze built skills** - That's skill-analyzer's job
4. **Don't be prescriptive** - Recommend, don't mandate
5. **Don't assume** - If spec is unclear, ask user for clarification
6. **Don't overwhelm** - Start with quick check, drill down on request

---

## Skill-Creator Alignment

This skill is **fundamentally dependent on skill-creator** as its reference standard.

### How Alignment Works

1. **Load skill-creator during analysis** (Phase 2)
2. **Use its 6-step process as checklist** (Dimension 1)
3. **Validate against its requirements** (What does each step need?)
4. **Reference its style guidelines** (Writing style, structure)
5. **Mirror its terminology** (Scripts, references, assets, progressive disclosure)

### Keeping In Sync

When skill-creator is updated:
1. Review changes to its 6-step process
2. Update `references/skill-creator-requirements.md`
3. Adjust completeness validation criteria
4. Update test cases

---

## Future Enhancements

Potential additions for v2:

1. **Spec Templates** - Generate starter spec from user description
2. **Comparative Analysis** - Compare multiple spec approaches
3. **Automated Spec Refinement** - Auto-apply recommendations
4. **Historical Tracking** - Track spec evolution over versions
5. **Marketplace Integration** - Validate specs for public distribution
6. **Team Standards** - Custom validation rules for organizations
7. **AI-Assisted Examples** - Generate missing concrete examples from abstract descriptions

---

## Appendix: Grading Scale

| Score | Grade | Description | Action |
|-------|-------|-------------|--------|
| 90-100 | A | Excellent - Ready to build | Proceed to skill-creator |
| 80-89 | B | Good - Minor improvements recommended | Optional refinements |
| 70-79 | C | Acceptable - Some issues to address | Fix important issues |
| 60-69 | D | Needs Work - Multiple issues | Fix critical & important |
| 0-59 | F | Poor - Significant problems | Major rework needed |

---

**End of Specification**
