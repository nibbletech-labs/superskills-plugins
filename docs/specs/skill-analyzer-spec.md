# Skill Analyzer

**Status:** 📋 Spec Complete
**Last Updated:** November 5, 2025
**Complements:** skill-creator (example-skills:skill-creator)

---

## Executive Summary

The **skill-analyzer** is a quality assurance and optimization skill that evaluates existing Claude Code skills for effectiveness, best practices compliance, and progressive disclosure efficiency. While the **skill-creator** guides users through building NEW skills, the **skill-analyzer** provides retrospective analysis and actionable improvement recommendations for EXISTING skills.

### Key Differentiators

| Aspect | skill-creator | skill-analyzer |
|--------|---------------|----------------|
| **Focus** | Creating NEW skills | Evaluating EXISTING skills |
| **Orientation** | Prospective/Process | Retrospective/Assessment |
| **Output** | Templates, structure, guidance | Reports, recommendations, metrics |
| **When Used** | "Help me create a skill" | "Analyze/improve this skill" |
| **Workflow** | 6-step creation process | Read → Analyze → Report → Recommend |

---

## When to Invoke This Skill

This skill should be invoked when users:

1. Want to **evaluate an existing skill's quality**
   - "Analyze this skill"
   - "Is this skill well-designed?"
   - "Review my skill for best practices"

2. Want to **optimize a skill for better performance**
   - "How can I improve this skill?"
   - "Make this skill more efficient"
   - "Is this skill using progressive disclosure effectively?"

3. Want to **improve invocation/description effectiveness**
   - "Will this skill trigger at the right times?"
   - "Is the description clear enough?"
   - "Why isn't my skill being invoked?"

4. Want to **validate compliance with best practices**
   - "Does this follow skill-creator guidelines?"
   - "Check if this skill is structured correctly"
   - "Validate this skill"

5. Are **iterating on a skill** after real-world usage
   - "I've been using this skill and it feels clunky"
   - "The skill keeps getting invoked when it shouldn't"
   - "Help me refine this skill"

### When NOT to Invoke

- Creating a brand new skill from scratch (use **skill-creator** instead)
- Packaging a skill (handled by skill-creator's packaging script)
- General questions about what skills are (use **skill-creator**)

---

## Analysis Dimensions

The skill-analyzer evaluates skills across six core dimensions:

### 1. Metadata Effectiveness (20%)

**Purpose:** Ensure the skill's name and description optimize for correct invocation.

**Evaluation Criteria:**
- **Name Clarity** - Is the name specific, descriptive, and follows conventions?
- **Description Specificity** - Does the description clearly state WHEN to use the skill?
- **Invocation Triggers** - What keywords/patterns would trigger this skill?
- **False Positive Risk** - Could this skill be invoked incorrectly?
- **False Negative Risk** - Could relevant use cases fail to trigger this skill?

**Analysis Questions:**
1. What invocation patterns does the description create?
2. Are there competing skills that might be invoked instead?
3. Is the description written in third-person (required)?
4. Does it specify both when to use AND when not to use?

**Common Issues:**
- Description too generic ("This skill helps with documents")
- Description too narrow (misses valid use cases)
- Missing anti-patterns (when NOT to invoke)
- Using second-person instead of third-person

**Example Good Description:**
```yaml
description: "Analyzes existing Claude Code skills to evaluate quality, progressive disclosure efficiency, and best practices compliance. Invoked when users request skill evaluation, optimization, or validation. Not for creating new skills from scratch."
```

---

### 2. Progressive Disclosure Implementation (25%)

**Purpose:** Verify the skill follows the three-level loading system efficiently.

**Evaluation Criteria:**
- **SKILL.md Size** - Is it under 5k words? (Target: 2k-4k)
- **Reference Externalization** - Is detailed content moved to `references/`?
- **Script Utilization** - Is repeated code extracted to `scripts/`?
- **Asset Separation** - Are output resources in `assets/`?
- **Information Hierarchy** - Is critical workflow in SKILL.md, detail in references?

**Analysis Process:**
1. **Measure SKILL.md length** (word count, token estimate)
2. **Identify candidates for externalization**:
   - Large code blocks → `scripts/`
   - Detailed schemas/APIs → `references/`
   - Templates/boilerplate → `assets/`
   - Lengthy examples → `references/examples.md`
3. **Check for duplication** between SKILL.md and resources
4. **Evaluate loading patterns** - What must be in context vs. can be loaded as-needed?

**Scoring Matrix:**

| SKILL.md Size | Score | Action |
|---------------|-------|--------|
| 0-2k words | 90-100% | Excellent - very lean |
| 2k-4k words | 70-89% | Good - within target |
| 4k-5k words | 50-69% | Acceptable - monitor closely |
| 5k+ words | 0-49% | Poor - needs externalization |

**Common Issues:**
- Embedding full schemas/API docs in SKILL.md
- Repeating code that should be scripted
- Duplicating information between SKILL.md and references
- Not using references at all (everything in SKILL.md)

---

### 3. Invocation Trigger Analysis (15%)

**Purpose:** Predict when the skill will be invoked and validate against intended use cases.

**Evaluation Process:**

1. **Parse Description for Trigger Patterns**
   - Extract keywords (nouns, verbs, domain terms)
   - Identify use case phrases ("when users...", "for queries like...")
   - Map to invocation scenarios

2. **Test Against Example Queries**
   - Generate 10 positive examples (should invoke)
   - Generate 10 negative examples (should NOT invoke)
   - Predict invocation accuracy

3. **Identify Ambiguities**
   - Overlapping trigger words with other skills
   - Generic terms that could apply broadly
   - Missing specificity in use cases

4. **Recommend Improvements**
   - More specific trigger language
   - Explicit exclusion criteria
   - Disambiguating keywords

**Output Format:**
```markdown
## Invocation Analysis

### Predicted Triggers
- "analyze skill" → 95% confidence
- "improve skill" → 90% confidence
- "skill best practices" → 85% confidence
- "evaluate skill" → 95% confidence

### Potential False Positives
- "skill" alone is too generic → Recommend adding "analyze/improve/evaluate"

### Potential False Negatives
- "optimize skill" not mentioned in description → Add to description

### Recommended Description Updates
[Show specific language changes]
```

---

### 4. Content Quality (20%)

**Purpose:** Ensure instructions are clear, complete, and follow style guidelines.

**Evaluation Criteria:**

**Writing Style (5%)**
- Uses imperative/infinitive form (verb-first)
- Avoids second-person ("you should")
- Objective, instructional tone
- Consistent terminology

**Clarity (5%)**
- Instructions are unambiguous
- Technical terms defined
- Assumptions stated explicitly
- Prerequisites clear

**Completeness (5%)**
- All workflows covered end-to-end
- Edge cases addressed
- Error handling included
- Success criteria defined

**Examples & Use Cases (5%)**
- Real-world examples provided
- Use cases clearly explained
- Code snippets when relevant
- Expected outputs shown

**Common Issues:**
- Using "you should do X" instead of "To do X, ..."
- Assuming knowledge not in the skill
- Missing error handling guidance
- No examples of actual usage

---

### 5. Resource Organization (10%)

**Purpose:** Validate proper file structure and resource utilization.

**Evaluation Checklist:**

**Scripts (`scripts/`)**
- [ ] Scripts are documented with usage instructions
- [ ] Each script has a clear purpose stated in SKILL.md
- [ ] Scripts are executable (proper permissions)
- [ ] Scripts have error handling
- [ ] SKILL.md explains when to use each script

**References (`references/`)**
- [ ] Large reference content externalized from SKILL.md
- [ ] Files are well-organized (logical naming)
- [ ] SKILL.md provides guidance on when to load each reference
- [ ] No duplication between SKILL.md and references
- [ ] Includes grep patterns for large files (>10k words)

**Assets (`assets/`)**
- [ ] Templates and output resources only (not docs)
- [ ] Clear purpose for each asset
- [ ] SKILL.md explains how to use assets
- [ ] Proper file formats for intended use

**Directory Structure Score:**

| Criteria | Weight | Score |
|----------|--------|-------|
| Proper separation of concerns | 40% | 0-100 |
| Documentation of resources | 30% | 0-100 |
| No duplication | 20% | 0-100 |
| Logical organization | 10% | 0-100 |

---

### 6. Best Practices Compliance (10%)

**Purpose:** Validate adherence to skill-creator guidelines.

**Validation Checklist:**

**YAML Frontmatter**
- [ ] Required fields present: `name`, `description`
- [ ] Name follows conventions (lowercase-with-hyphens)
- [ ] Description is third-person
- [ ] Description specifies when to invoke

**SKILL.md Structure**
- [ ] Clear purpose section at top
- [ ] "When to Use" section
- [ ] Workflow/process guidance
- [ ] Resource usage instructions

**Writing Conventions**
- [ ] Imperative/infinitive form throughout
- [ ] No second-person language
- [ ] Objective tone (no subjective claims)
- [ ] Consistent terminology

**Progressive Disclosure**
- [ ] SKILL.md under 5k words
- [ ] Appropriate use of references
- [ ] Scripts for repeated code
- [ ] Assets for output resources

**Skill-Creator Alignment**
- [ ] Follows 6-step process principles
- [ ] Uses recommended directory structure
- [ ] Matches style guidelines
- [ ] No anti-patterns from skill-creator

---

## Analysis Workflow

When this skill is invoked, follow this workflow:

### Phase 1: Discovery & Reading (10%)

1. **Locate the skill directory**
   - Ask user for path if not provided
   - Validate directory structure

2. **Read core files**
   - SKILL.md (parse YAML + content)
   - Directory listing (identify resources)

3. **Inventory resources**
   - Count scripts, references, assets
   - Note file sizes
   - Check for README or other docs

### Phase 2: Dimensional Analysis (60%)

For each of the 6 dimensions:

1. **Gather metrics**
   - Quantitative (word count, file sizes, etc.)
   - Qualitative (style, clarity, etc.)

2. **Identify issues**
   - Rate against criteria
   - Note violations of best practices
   - Flag potential improvements

3. **Generate findings**
   - What's working well
   - What needs improvement
   - Why it matters

### Phase 3: Synthesis & Reporting (20%)

1. **Calculate scores**
   - Per-dimension scores (weighted)
   - Overall quality score
   - Grade (A/B/C/D/F)

2. **Prioritize recommendations**
   - Critical (affects invocation/core functionality)
   - Important (affects efficiency/quality)
   - Nice-to-have (polish/optimization)

3. **Generate report**
   - Executive summary
   - Dimensional findings
   - Actionable recommendations with examples
   - Before/after code snippets

### Phase 4: Interactive Improvement (10%)

1. **Present findings to user**
   - Start with summary
   - Offer to drill into details

2. **Progressive disclosure of details**
   - User can ask for specific dimension analysis
   - Provide examples on request
   - Show before/after comparisons

3. **Optional: Generate improvement plan**
   - If user wants to act on recommendations
   - Create TODO list of changes
   - Offer to implement changes (with approval)

---

## Output Format

### Standard Analysis Report

```markdown
# Skill Analysis Report: [Skill Name]

**Analyzed:** [Date]
**Overall Score:** [Score]/100 ([Grade])
**Status:** [Excellent/Good/Needs Improvement/Poor]

---

## Executive Summary

[2-3 sentence overview of the skill's quality and key findings]

**Key Strengths:**
- [Strength 1]
- [Strength 2]
- [Strength 3]

**Critical Issues:**
- [Issue 1] (Priority: Critical)
- [Issue 2] (Priority: Important)

**Quick Wins:**
- [Easy improvement 1]
- [Easy improvement 2]

---

## Dimensional Scores

| Dimension | Score | Grade | Status |
|-----------|-------|-------|--------|
| Metadata Effectiveness | X/20 | [Grade] | [Status] |
| Progressive Disclosure | X/25 | [Grade] | [Status] |
| Invocation Triggers | X/15 | [Grade] | [Status] |
| Content Quality | X/20 | [Grade] | [Status] |
| Resource Organization | X/10 | [Grade] | [Status] |
| Best Practices | X/10 | [Grade] | [Status] |
| **TOTAL** | **X/100** | **[Grade]** | **[Status]** |

---

## Detailed Findings

### 1. Metadata Effectiveness ([Score]/20)

**Current State:**
[Description of current metadata]

**Issues Found:**
- [Issue 1]: [Explanation]
- [Issue 2]: [Explanation]

**Recommendations:**
1. [Recommendation with before/after example]
2. [Recommendation with before/after example]

**Example Improvement:**
```yaml
# Before
description: "Helps with documents"

# After
description: "Analyzes existing Claude Code skills to evaluate quality, progressive disclosure efficiency, and best practices compliance. Invoked when users request skill evaluation, optimization, or validation. Not for creating new skills from scratch."
```

### 2. Progressive Disclosure ([Score]/25)

**Metrics:**
- SKILL.md size: [X] words ([X] tokens)
- References: [X] files
- Scripts: [X] files
- Assets: [X] files

**Issues Found:**
- [Issue 1]: [Explanation + impact]
- [Issue 2]: [Explanation + impact]

**Recommendations:**
1. Move [specific content] to `references/[filename].md`
2. Extract [specific code] to `scripts/[scriptname].py`
3. Relocate [specific template] to `assets/[filename]`

**Impact:**
- Reduces SKILL.md by ~[X] words ([X]%)
- Improves context efficiency by [X]%

### [Continue for all 6 dimensions...]

---

## Improvement Roadmap

### Critical Priority (Do First)
1. **[Issue]** - [Recommendation]
   - Impact: [High/Medium/Low]
   - Effort: [Hours estimate]
   - Why: [Explanation of impact]

### Important Priority (Do Soon)
2. **[Issue]** - [Recommendation]
   - Impact: [High/Medium/Low]
   - Effort: [Hours estimate]

### Nice-to-Have (Polish)
3. **[Issue]** - [Recommendation]
   - Impact: [Low]
   - Effort: [Hours estimate]

---

## Next Steps

Would you like me to:
1. **Drill into a specific dimension** for more detail?
2. **Implement specific improvements** (I can make the changes)?
3. **Create an improvement plan** with TODO tracking?
4. **Re-analyze after changes** to measure improvement?
```

---

## Metadata Management

When analysis completes, skill-analyzer **MUST offer** to write metadata to the skill's SKILL.md file. This enables skill-development-coach and other tools to track optimization status and history.

### Writing Metadata

After generating the analysis report, prompt the user:

```
"Analysis complete! Would you like me to update SKILL.md with these optimization results?

This adds a metadata section to track:
- Quality score and grade
- Dimensional breakdown
- Top issues identified
- Improvement tracking (if re-analyzing)
- Date of analysis

This helps track optimization progress and enables workflow tools to know the skill has been analyzed."
```

### Metadata Structure

If user agrees, add or update the skill's SKILL.md YAML frontmatter:

```yaml
---
name: "skill-name"
description: "Original description..."

# skill-analyzer adds this section
skill-dev-metadata:
  skill-analyzer:
    last-run: "2025-11-06T10:15:00Z"
    score: 78
    grade: "C+"
    dimensions:
      metadata-effectiveness: 85  # out of 20
      progressive-disclosure: 16   # out of 25 (65% of possible)
      invocation-triggers: 15      # out of 20 (75% of possible)
      content-quality: 16          # out of 20 (80% of possible)
      resource-organization: 7     # out of 10 (70% of possible)
      best-practices: 9            # out of 10 (90% of possible)
    top-issues:
      - "Progressive disclosure: SKILL.md is 6k words (target: <5k)"
      - "Invocation triggers: Description too generic"
      - "Resource organization: Missing documentation for scripts"
    improvements-since-last: null  # or +12 if re-analyzing
    previous-score: null           # or 66 if re-analyzing
    optimization-count: 1          # increments on each analysis
---

# [Rest of SKILL.md content unchanged]
```

### Metadata Fields Explained

| Field | Purpose | Usage |
|-------|---------|-------|
| `last-run` | ISO 8601 timestamp | Detect when last optimized |
| `score` | Overall score (0-100) | Track quality over time |
| `grade` | Letter grade (A-F) | Human-readable quality |
| `dimensions.*` | Per-dimension scores | Identify weak areas |
| `top-issues` | Array of main problems | Quick issue overview |
| `improvements-since-last` | Score delta | Show progress (+12 points) |
| `previous-score` | Last analysis score | Compare improvement |
| `optimization-count` | Number of analyses | Track iteration history |

### Benefits of Metadata

1. **Progress Tracking**
   - See improvements over iterations: "Score: 66 → 78 (+12)"
   - Identify which dimensions improved
   - Track how many optimization cycles performed

2. **Workflow Coordination**
   - skill-development-coach can recommend re-optimization if score < 75
   - Detect skills that haven't been analyzed

3. **Issue Persistence**
   - If same issue appears in multiple analyses, it's stubborn
   - Prioritize fixing recurring problems

4. **Historical Context**
   - User can see optimization journey
   - Understand which improvements had biggest impact

### Important Notes

- **Always offer, never force** - User can decline metadata writing
- **Non-destructive** - Only adds/updates `skill-dev-metadata` section
- **Idempotent** - Re-running analysis updates metadata in place
- **Preserves history** - Saves previous score for comparison

### Re-Analysis Behavior

When analyzing a skill that already has metadata:

1. **Read existing metadata** to show context:
   ```
   "I see this skill was last analyzed on 2025-11-03 with score 66/100.
   It's been optimized 2 times already. Let's see current quality..."
   ```

2. **Compare scores** after analysis:
   ```
   "Great progress!

   Score: 66 → 78 (+12 points)

   Improvements made:
   - Progressive disclosure improved (16 → 20 points)
     ✓ Moved large schemas to references
     ✓ SKILL.md reduced from 7k to 4.5k words

   - Invocation triggers improved (10 → 15 points)
     ✓ Description made more specific
     ✓ Added explicit exclusions

   Still needs work:
   - Resource organization (7/10) - Scripts need documentation

   Would you like me to update the metadata?"
   ```

3. **Update metadata** with:
   - New scores and timestamp
   - Previous score saved for history
   - Increment optimization-count
   - Calculate improvements-since-last

### Score Interpretation for Workflow

The score guides workflow recommendations:

| Score Range | Status | Recommendation |
|-------------|--------|----------------|
| 90-100 | Excellent | Skill is production-ready, no action needed |
| 80-89 | Good | Minor polish possible, but not urgent |
| 70-79 | Acceptable | Consider optimization when convenient |
| 60-69 | Needs Work | Recommend optimization soon |
| 0-59 | Poor | Strongly recommend optimization before distribution |

skill-development-coach uses these thresholds to suggest re-optimization.

---

## Bundled Resources

### Scripts

#### `scripts/analyze_skill.py`

**Purpose:** Core analysis engine that parses a skill directory and generates metrics/findings.

**Features:**
- Parse YAML frontmatter
- Count words/tokens in SKILL.md
- Inventory resources
- Generate JSON output for reporting

**Usage:**
```bash
python scripts/analyze_skill.py /path/to/skill-directory
```

**Output:** JSON with all metrics and findings

#### `scripts/generate_report.py`

**Purpose:** Transform analysis JSON into markdown report.

**Usage:**
```bash
python scripts/generate_report.py analysis.json > report.md
```

#### `scripts/validate_invocation.py`

**Purpose:** Test invocation triggers against example queries.

**Usage:**
```bash
python scripts/validate_invocation.py /path/to/skill-directory --test-queries queries.txt
```

---

### References

#### `references/best-practices.md`

**Purpose:** Comprehensive checklist of all best practices from skill-creator.

**When to Load:** When user asks "What are the best practices?" or detailed validation needed.

**Content:**
- Metadata best practices
- Progressive disclosure guidelines
- Writing style rules
- Resource organization patterns
- Common gotchas

#### `references/anti-patterns.md`

**Purpose:** Common mistakes and why they're problematic.

**When to Load:** When explaining why something is an issue.

**Content:**
- Metadata anti-patterns (too generic, too narrow, etc.)
- Progressive disclosure violations (huge SKILL.md, duplication, etc.)
- Writing style mistakes (second-person, subjective, etc.)
- Resource organization problems
- Real examples from actual skills (anonymized)

#### `references/improvement-examples.md`

**Purpose:** Before/after examples of skill improvements.

**When to Load:** When user wants to see how to fix specific issues.

**Content:**
- Metadata improvements
- Progressive disclosure refactoring
- Writing style corrections
- Resource reorganization
- Full skill makeovers

#### `references/scoring-rubric.md`

**Purpose:** Detailed scoring criteria for each dimension.

**When to Load:** When user questions scores or wants to understand grading.

**Content:**
- Dimension-by-dimension rubrics
- Score calculations and weighting
- Grade boundaries (A/B/C/D/F)
- Example scored skills

---

### Assets

#### `assets/report-template.md`

**Purpose:** Markdown template for generating reports.

**Usage:** Copied and populated with analysis findings.

#### `assets/improvement-plan-template.md`

**Purpose:** Template for creating actionable improvement TODOs.

**Usage:** Generated when user wants an implementation plan.

---

## Integration with skill-creator

The skill-analyzer complements skill-creator in the iterative development cycle:

### Skill Development Lifecycle

```
1. CREATE (skill-creator)
   ↓
2. USE (real-world testing)
   ↓
3. ANALYZE (skill-analyzer) ← We are here
   ↓
4. IMPROVE (skill-analyzer recommendations)
   ↓
5. VALIDATE (skill-analyzer re-check)
   ↓
   Loop back to step 2
```

### Handoff Points

**From skill-creator to skill-analyzer:**
- User has completed skill-creator's Step 6 (Iterate)
- Skill exists and has been used
- User notices issues or wants optimization

**From skill-analyzer back to skill-creator:**
- If major restructuring needed (rare)
- If skill needs new resources (scripts/references/assets)
- If starting over is easier than fixing

### Shared Knowledge

Both skills reference:
- Same best practices
- Same directory structure
- Same progressive disclosure principles
- Same writing style guidelines

**Key Difference:**
- **skill-creator** teaches these principles
- **skill-analyzer** validates adherence to them

---

## Progressive Disclosure Strategy

This skill itself follows progressive disclosure:

### Level 1: Metadata (Always in Context)
```yaml
name: "skill-analyzer"
description: "Analyzes existing Claude Code skills to evaluate quality, progressive disclosure efficiency, and best practices compliance. Invoked when users request skill evaluation, optimization, or validation of existing skills. Not for creating new skills from scratch (use skill-creator)."
```

### Level 2: SKILL.md (When Invoked)
- Analysis workflow (Phases 1-4)
- Six analysis dimensions overview
- Output format template
- Integration with skill-creator
- Script/reference usage guidance

**Target: 3,000 words**

### Level 3: Bundled Resources (As Needed)

**Load proactively:**
- `scripts/analyze_skill.py` - Run immediately for analysis
- `scripts/generate_report.py` - Run to format output

**Load on-demand:**
- `references/best-practices.md` - If user asks "what are best practices?"
- `references/anti-patterns.md` - When explaining why something is wrong
- `references/improvement-examples.md` - When showing how to fix issues
- `references/scoring-rubric.md` - If user questions scores

---

## Example Interactions

### Example 1: Basic Analysis

**User:** "Analyze the `web-image-extractor` skill"

**Workflow:**
1. Read SKILL.md and resources
2. Run `analyze_skill.py`
3. Generate report with `generate_report.py`
4. Present executive summary
5. Offer to drill into details

**Output:** Report showing score of 78/100 (C+), identifying that SKILL.md is too large (6k words) and description is too generic.

---

### Example 2: Invocation Debugging

**User:** "My skill isn't being invoked when I expect. Can you help?"

**Workflow:**
1. Analyze description for trigger patterns
2. Run `validate_invocation.py` with test queries
3. Identify false negatives
4. Recommend description improvements

**Output:** Found that skill triggers on "PDF" but not "document" - recommend expanding description to include "document" as trigger.

---

### Example 3: Optimization Request

**User:** "This skill works but feels inefficient. Make it better."

**Workflow:**
1. Full 6-dimensional analysis
2. Focus on Progressive Disclosure dimension
3. Identify externalization opportunities
4. Present improvement roadmap
5. Offer to implement changes

**Output:** Found 4 areas for externalization, reducing SKILL.md from 7k to 3k words. User approves, skill-analyzer makes changes.

---

## Success Metrics

A skill analysis is successful when:

1. **User understands** what's good and bad about their skill
2. **Recommendations are actionable** with clear before/after examples
3. **Improvements measurably increase** the skill's effectiveness
4. **Re-analysis shows higher scores** after implementing recommendations
5. **User feels confident** the skill follows best practices

---

## Anti-Patterns (What This Skill Should NOT Do)

1. **Don't create new skills** - That's skill-creator's job
2. **Don't just validate** - Provide actionable recommendations
3. **Don't overwhelm** - Progressive disclosure of findings
4. **Don't be prescriptive** - Explain WHY something matters
5. **Don't assume** - Ask for clarification if skill purpose is unclear

---

## Future Enhancements

Potential additions for v2:

1. **Comparative Analysis** - Compare multiple skills side-by-side
2. **Automated Refactoring** - Auto-generate externalized references
3. **Invocation Testing** - Real-world trigger simulation
4. **Performance Metrics** - Track context usage, loading times
5. **Marketplace Integration** - Analyze public skills for quality
6. **Continuous Monitoring** - Track skill quality over time
7. **Team Analytics** - Aggregate metrics across skill library

---

## Appendix: Grading Scale

| Score | Grade | Description |
|-------|-------|-------------|
| 90-100 | A | Excellent - Production ready, exemplary quality |
| 80-89 | B | Good - Minor improvements would help |
| 70-79 | C | Acceptable - Functional but needs optimization |
| 60-69 | D | Needs Improvement - Has issues affecting effectiveness |
| 0-59 | F | Poor - Major problems, significant rework needed |

---

**End of Specification**
