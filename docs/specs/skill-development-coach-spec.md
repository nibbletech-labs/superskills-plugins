# Skill Development Coach

**Status:** 📋 Spec Complete
**Last Updated:** November 5, 2025
**Orchestrates:** spec-analyzer (validation), skill-creator (building), skill-analyzer (optimization)

---

## Executive Summary

The **skill-development-coach** is a lightweight shepherd skill that guides users through the complete skill development lifecycle without requiring separate state tracking. It detects the current stage by examining files in the working directory, reads metadata from YAML frontmatter, and invokes the appropriate tool at each stage while providing soft enforcement of quality gates.

### The Problem It Solves

Users need guidance through the skill development process:
- **Where am I in the workflow?** (Ideation? Building? Optimizing?)
- **What should I do next?** (Write spec? Validate? Build?)
- **Can I skip validation?** (Soft enforcement - recommend but don't block)
- **How do I track progress?** (Read metadata from existing files)

**skill-development-coach solves this** by acting as an intelligent guide that knows the workflow, detects your current stage, and recommends the right next step.

---

## Core Design Principles

### 1. **Ask, Don't Assume**
Never assume file absence means starting fresh. Always confirm with user first.

**Example:**
```
[Scans directory, finds no specs]

❌ BAD: "Let's create a new spec!"
✅ GOOD: "I don't see any spec files in this directory. Do you have an existing spec I should look at? (Provide path or say 'no' to create new)"
```

### 2. **Detect from Files, Not Separate State**
No `.skill-dev-state.yaml` files. Everything inferred from:
- File presence (*-spec.md, SKILL.md)
- YAML frontmatter metadata
- File modification times
- User context

### 3. **Soft Enforcement**
Strongly recommend best practices, but allow skipping with explicit intent.

**Pattern:**
```
Recommend → Explain why → Allow bypass if user insists
```

### 4. **Idempotent**
Can re-run analyses anytime. Metadata updates in place.

### 5. **Works WITH skill-creator**
Doesn't modify Anthropic's skill-creator. Just invokes it at the right time.

---

## When to Invoke This Skill

This skill should be invoked when users:

1. **Request guided skill development**
   - "Help me build a skill"
   - "Create a new skill"
   - "Guide me through skill development"
   - "I want to make a skill for X"

2. **Need workflow guidance**
   - "What's the next step?"
   - "Where am I in the process?"
   - "Am I ready to build?"

3. **Want to resume development**
   - "Continue working on my skill"
   - "Pick up where I left off"
   - "What should I do next with my spec?"

4. **Need progress visibility**
   - "Show me my skill development progress"
   - "What's the status of my skill?"

### When NOT to Invoke

- User explicitly invokes a specific skill directly (spec-analyzer, skill-creator, skill-analyzer)
- User wants low-level control (let them use tools directly)
- Non-skill-development tasks

---

## Stage Detection Logic

The coach detects the current stage by examining the working directory:

### Detection Workflow

```
1. Scan for files:
   - find . -name "*-spec.md" -type f
   - find . -name "SKILL.md" -type f

2. Parse metadata from found files:
   - Read YAML frontmatter
   - Extract skill-dev-metadata section
   - Check validation/optimization scores

3. Determine stage:
   - No files found → ASK USER (don't assume)
   - Spec found, not validated → VALIDATION NEEDED
   - Spec found, score < 75 → RE-VALIDATION RECOMMENDED
   - Spec found, score >= 75 → READY TO BUILD
   - Skill found, not analyzed → OPTIMIZATION RECOMMENDED
   - Skill found, score < 75 → RE-OPTIMIZATION RECOMMENDED
   - Skill found, score >= 75 → OPTIMIZED

4. Present guidance based on stage
```

### Stage Decision Tree

```
Check: Any *-spec.md files?
├─ NO → Check: Any SKILL.md files?
│  ├─ NO → ASK: "Do you have existing files?"
│  │  ├─ User: "No" → STAGE: IDEATION (help write spec)
│  │  └─ User: "Yes, here: [path]" → Read file → Continue detection
│  └─ YES → Found skill(s) → STAGE: Check optimization status
│
└─ YES → Found spec(s)
   ├─ Check: skill-dev-metadata.spec-analyzer.passed?
   │  ├─ NOT PRESENT → STAGE: NEEDS VALIDATION
   │  ├─ FALSE (score < 75) → STAGE: NEEDS RE-VALIDATION
   │  └─ TRUE (score >= 75) → STAGE: READY TO BUILD
   │
   └─ Check: Is there also a skill built?
      ├─ NO → STAGE: READY TO BUILD (spec validated, not built yet)
      └─ YES → STAGE: Check optimization status
```

---

## Workflow Guidance by Stage

### **Stage: IDEATION** (No spec exists, user confirmed starting fresh)

**Guidance:**
```
"Let's build a skill! I'll guide you through the process:

1. Write a spec (what the skill does, examples, use cases)
2. Validate the spec (catch issues early)
3. Build the skill (use skill-creator)
4. Test and use it
5. Optimize it (improve quality)

First, I need to understand what you want to build.

What problem should this skill solve? Give me 3-5 concrete examples of how you'd use it."
```

**Actions:**
1. Ask clarifying questions (skill purpose, use cases, examples)
2. Help draft spec document
3. Save as `{skill-name}-spec.md`
4. Transition to VALIDATION NEEDED stage

---

### **Stage: NEEDS VALIDATION** (Spec exists, no validation metadata)

**Guidance:**
```
"I found your spec: {spec-name}

Before we build, I strongly recommend validating it with spec-analyzer. This takes 2-5 minutes and typically saves 2-10 hours by catching issues early:

Issues we'll check for:
- Completeness (does it have what skill-creator needs?)
- Scope problems (is this one skill or multiple?)
- Invocation clarity (will it trigger correctly?)
- Missing dependencies
- Implementation feasibility

Run validation now? (Recommended)"
```

**Soft Enforcement:**
```
If user says "No, just build it":

"I understand you want to move quickly, but building without validation risks:
- Incomplete spec → will need rework mid-build
- Scope issues → building the wrong thing
- Missing dependencies → build fails partway through
- Poor invocation → skill doesn't trigger correctly

This typically wastes 2-10 hours of work.

Are you sure you want to skip validation? (I really don't recommend it)"
```

**Actions:**
- If user agrees: Invoke spec-analyzer
- If user insists on skipping: Proceed to skill-creator with warning
- After validation: Transition to appropriate stage based on score

---

### **Stage: NEEDS RE-VALIDATION** (Spec exists, score < 75)

**Guidance:**
```
"I found your spec: {spec-name}

Last validation: {date}
Score: {score}/100 (Grade: {grade})
Status: ❌ NOT READY TO BUILD (< 75 threshold)

Critical issues found:
{list of critical issues}

I strongly recommend fixing these before building. Would you like me to:
1. Re-run spec-analyzer to see current status
2. Help you fix the identified issues
3. Proceed to building anyway (not recommended)"
```

**Actions:**
- Option 1: Invoke spec-analyzer (may have improved)
- Option 2: Help fix issues interactively
- Option 3: Proceed with warning (soft enforcement allows this)

---

### **Stage: READY TO BUILD** (Spec validated, score >= 75)

**Guidance:**
```
"Your spec is validated and ready to build!

Spec: {spec-name}
Validation: ✅ PASSED (Score: {score}/100, Grade: {grade})
Last validated: {date}

I'll now invoke skill-creator to build your skill. This will:
1. Follow skill-creator's 6-step process
2. Create the skill directory structure
3. Generate SKILL.md
4. Set up scripts/references/assets as needed

Ready to build?"
```

**Actions:**
1. Confirm with user
2. Invoke skill-creator (Anthropic's skill)
3. Monitor progress
4. After build completes, suggest testing phase

---

### **Stage: BUILT, NEEDS OPTIMIZATION** (Skill exists, no analysis metadata)

**Guidance:**
```
"I found your built skill: {skill-name}

Great work! Now that it's built and you've tested it, I recommend running skill-analyzer to:
- Check quality (score 0-100, graded A-F)
- Identify optimization opportunities
- Ensure best practices compliance
- Improve progressive disclosure efficiency

This is optional but recommended for skills you'll distribute or use frequently.

Run skill-analyzer now?"
```

**Actions:**
- If yes: Invoke skill-analyzer
- If no: "No problem! You can run it anytime by saying 'analyze my skill'"

---

### **Stage: NEEDS RE-OPTIMIZATION** (Skill exists, score < 75)

**Guidance:**
```
"I found your skill: {skill-name}

Last analysis: {date}
Score: {score}/100 (Grade: {grade})
Optimization count: {count}

Issues found:
{top 3 issues}

I recommend re-optimizing to improve quality. Would you like me to:
1. Re-run skill-analyzer to see current status
2. Help implement the recommended improvements
3. Skip for now"
```

**Actions:**
- Option 1: Invoke skill-analyzer
- Option 2: Help implement improvements
- Option 3: Mark as deferred

---

### **Stage: OPTIMIZED** (Skill exists, score >= 75)

**Guidance:**
```
"Your skill is in great shape!

Skill: {skill-name}
Quality: ✅ {grade} (Score: {score}/100)
Last optimized: {date}
Optimization count: {count}

What would you like to do?
1. Start building a NEW skill
2. Re-analyze this skill (if you've made changes)
3. Make further improvements
4. I'm done!"
```

**Actions:**
- Option 1: Return to IDEATION stage
- Option 2: Invoke skill-analyzer
- Option 3: Help with specific improvements
- Option 4: Wrap up

---

## Handling Multiple Files

If multiple specs or skills are found:

**Guidance:**
```
"I found multiple items in this directory:

Specs:
1. pdf-manipulator-spec.md
   ✅ Validated (Score: 85/100) - Ready to build

2. image-optimizer-spec.md
   ⚠️ Not validated - Needs validation

Skills:
3. text-analyzer/ (SKILL.md)
   ✅ Optimized (Score: 88/100, Grade: B+)

4. data-processor/ (SKILL.md)
   ⚠️ Not analyzed - Recommend optimization

Which would you like to work on? (Enter number or name)"
```

**Actions:**
1. Present clear menu of options
2. Show status for each (validated, ready, needs work)
3. Let user choose
4. Proceed with selected item

---

## Soft Enforcement Patterns

### **Level 1: Strong Recommendation** (Default)

```
"I strongly recommend {action} because {reason}.

{action} now? (Recommended)"
```

**User can decline by saying "no" or "skip"**

---

### **Level 2: Explain Risks** (If user declines once)

```
"I understand, but skipping {action} risks:
- {Risk 1 with impact}
- {Risk 2 with impact}
- {Risk 3 with impact}

This typically costs {time estimate} in rework.

Are you sure you want to skip? (Last chance to reconsider)"
```

**User can confirm skip by saying "yes, skip" or "proceed anyway"**

---

### **Level 3: Acknowledge and Proceed** (If user insists)

```
"Understood. Proceeding without {action}.

Note: If you encounter issues, you can always come back and run {action} later.

Moving forward..."
```

**Proceed to next stage with user's explicit consent**

---

## File Discovery Implementation

### Finding Spec Files

```bash
# Use Glob tool to find spec files
Glob pattern: "*-spec.md"
Path: . (current directory)

# Read each found file
Read: {spec-path}

# Parse YAML frontmatter
Extract: skill-dev-metadata section
Check: spec-analyzer.passed, spec-analyzer.score
```

### Finding Skill Files

```bash
# Use Glob tool to find SKILL.md files
Glob pattern: "**/SKILL.md"
Path: . (current directory)

# Read each found file
Read: {skill-path}

# Parse YAML frontmatter
Extract: skill-dev-metadata section
Check: skill-analyzer.score, skill-analyzer.grade
```

### Parsing Metadata

```python
# Pseudocode for metadata parsing

def parse_metadata(file_content):
    # Extract YAML frontmatter between --- markers
    yaml_match = re.search(r'^---\n(.*?)\n---', file_content, re.DOTALL)

    if not yaml_match:
        return None

    yaml_content = yaml_match.group(1)
    metadata = yaml.parse(yaml_content)

    # Check for skill-dev-metadata
    if 'skill-dev-metadata' in metadata:
        return metadata['skill-dev-metadata']

    return None

def detect_stage(spec_path):
    content = read_file(spec_path)
    metadata = parse_metadata(content)

    if metadata is None:
        return "NEEDS_VALIDATION"

    if 'spec-analyzer' in metadata:
        score = metadata['spec-analyzer'].get('score', 0)
        passed = metadata['spec-analyzer'].get('passed', False)

        if passed and score >= 75:
            return "READY_TO_BUILD"
        else:
            return "NEEDS_RE_VALIDATION"

    return "NEEDS_VALIDATION"
```

---

## Conversation Patterns

### **Pattern 1: New User, Starting Fresh**

```
User: "Help me build a skill"

Coach: [Scans directory]
Coach: [Finds no files]
Coach: "I don't see any spec or skill files here. Do you have existing files I should look at?"

User: "No, starting from scratch"

Coach: "Great! Let's build a skill. I'll guide you through:
       1. Write spec (5-10 min)
       2. Validate spec (2-5 min)
       3. Build skill (varies by complexity)
       4. Test it
       5. Optimize it

       What should your skill do? Give me 3-5 examples."

User: "I want a skill to manipulate PDFs..."

Coach: [Helps write spec]
Coach: "Saved as pdf-manipulator-spec.md"
Coach: "Now let's validate to catch issues early. Running spec-analyzer..."
[Invokes spec-analyzer]
```

---

### **Pattern 2: Resuming with Unvalidated Spec**

```
User: "Help me build a skill"

Coach: [Scans directory]
Coach: [Finds pdf-manipulator-spec.md]
Coach: [Reads file, no validation metadata]

Coach: "I found pdf-manipulator-spec.md, but it hasn't been validated yet.

       I strongly recommend validation first (2-5 min). It catches:
       - Scope issues
       - Missing dependencies
       - Incomplete workflows

       Typically saves 2-10 hours. Run validation now?"

User: "Yes"

Coach: "Running spec-analyzer..."
[Invokes spec-analyzer]

spec-analyzer: "Score: 68/100 (D+) - Found critical issues..."

Coach: "Your spec needs work before building:

       Critical:
       1. Scope issue: Describes 3 skills, should be 1

       Important:
       2. Missing resource planning

       Let's fix these. Starting with #1..."
```

---

### **Pattern 3: User Wants to Skip Validation**

```
User: "Just build the skill, skip validation"

Coach: [Detects spec not validated]

Coach: "I understand you want to move quickly, but building without validation risks:

       - Incomplete spec → rework needed mid-build
       - Scope problems → building wrong thing
       - Missing dependencies → build fails partway
       - Poor invocation → skill won't trigger

       This typically wastes 2-10 hours.

       Are you SURE you want to skip? (I really don't recommend it)"

User: "Yes, I'm sure"

Coach: "Understood. Proceeding to skill-creator.

       Note: If you hit issues, we can always validate later.

       Invoking skill-creator..."
[Invokes skill-creator]
```

---

### **Pattern 4: Spec Validated, Ready to Build**

```
User: "Build my skill"

Coach: [Scans directory]
Coach: [Finds pdf-manipulator-spec.md]
Coach: [Reads metadata: score 85, passed: true]

Coach: "Your spec is validated and ready!

       Spec: pdf-manipulator-spec.md
       ✅ Validated (Score: 85/100, Grade: B)
       Last validated: 2025-11-05

       Invoking skill-creator to build your skill..."
[Invokes skill-creator]
```

---

### **Pattern 5: Skill Built, Needs Optimization**

```
User: "What's next?"

Coach: [Scans directory]
Coach: [Finds pdf-manipulator/ with SKILL.md]
Coach: [No skill-analyzer metadata]

Coach: "I see you've built pdf-manipulator!

       Now that it's built, I recommend running skill-analyzer to:
       - Check quality (0-100 score)
       - Find optimization opportunities
       - Ensure best practices
       - Improve context efficiency

       This is optional but recommended for skills you'll distribute.

       Run skill-analyzer now?"

User: "Yes"

Coach: "Running skill-analyzer..."
[Invokes skill-analyzer]

skill-analyzer: "Score: 72/100 (C) - Found optimization opportunities..."

Coach: "Your skill works but could be better:

       Issues:
       1. SKILL.md is 6k words (target: <5k)
       2. Invocation triggers too generic

       Want help fixing these?"
```

---

## Integration with Other Skills

### **With spec-analyzer**

**Invocation:**
```
When: Stage is NEEDS_VALIDATION or NEEDS_RE_VALIDATION
Action: "Running spec-analyzer on {spec-path}..."
[Invoke spec-analyzer with spec path]
```

**After Completion:**
```
Read updated spec metadata
Check: passed status, score
If passed: Transition to READY_TO_BUILD
If not passed: Help fix issues or allow bypass
```

---

### **With skill-creator** (Anthropic's)

**Invocation:**
```
When: Stage is READY_TO_BUILD and user confirms
Action: "Invoking skill-creator to build your skill..."
[Invoke skill-creator]
Note: skill-creator is interactive, user works with it directly
```

**After Completion:**
```
Assume skill is built (skill-creator creates directory)
Suggest testing phase
Transition to BUILT_NEEDS_OPTIMIZATION
```

---

### **With skill-analyzer**

**Invocation:**
```
When: Stage is BUILT_NEEDS_OPTIMIZATION or NEEDS_RE_OPTIMIZATION
Action: "Running skill-analyzer on {skill-path}..."
[Invoke skill-analyzer with skill directory]
```

**After Completion:**
```
Read updated SKILL.md metadata
Check: score, grade
If score >= 75: Celebrate, mark as OPTIMIZED
If score < 75: Offer to help fix issues
```

---

## Metadata Reading Examples

### Reading Spec Metadata

```yaml
---
name: "pdf-manipulator"
description: "..."

skill-dev-metadata:
  spec-analyzer:
    last-run: "2025-11-05T14:30:00Z"
    score: 85
    grade: "B"
    passed: true
    issues:
      critical: 0
      important: 2
      nice-to-have: 1
---
```

**Coach interprets as:**
- ✅ Validated
- Score: 85/100 (good)
- Pass threshold met (>= 75)
- Last checked: 2025-11-05
- Status: READY TO BUILD

---

### Reading Skill Metadata

```yaml
---
name: "pdf-manipulator"
description: "..."

skill-dev-metadata:
  skill-analyzer:
    last-run: "2025-11-06T10:15:00Z"
    score: 72
    grade: "C"
    top-issues:
      - "SKILL.md too large (6k words)"
      - "Invocation triggers generic"
    optimization-count: 1
---
```

**Coach interprets as:**
- ⚠️ Analyzed but score below optimal
- Score: 72/100 (acceptable but could improve)
- Last analyzed: 2025-11-06
- Been optimized 1 time already
- Status: COULD USE RE-OPTIMIZATION

---

## Progressive Disclosure

The coach itself uses progressive disclosure:

### **Level 1: Quick Status** (Default)

```
"I found pdf-manipulator-spec.md
✅ Validated (Score: 85/100)
Ready to build!"
```

### **Level 2: More Detail** (If user asks)

```
User: "Show me details"

Coach: "Spec: pdf-manipulator-spec.md

       Validation:
       - Score: 85/100 (Grade: B)
       - Last run: 2025-11-05 (2 days ago)
       - Status: PASSED

       Dimensional breakdown:
       - Completeness: 88/100
       - Scope: 90/100
       - Invocation: 75/100
       - Resources: 85/100
       - Feasibility: 90/100
       - Quality: 80/100

       Issues found:
       - 0 critical
       - 2 important
       - 1 nice-to-have

       Ready to build?"
```

### **Level 3: Full Analysis** (If user wants deep dive)

```
User: "Show me the full report"

Coach: "Reading full spec-analyzer report..."
[Displays complete analysis report from last run]
```

---

## Error Handling

### **Spec File Not Readable**

```
Coach: [Tries to read spec]
[Error: Permission denied]

Coach: "I found {spec-name} but can't read it (permission denied).

       Please check:
       1. File permissions (chmod +r)
       2. File isn't corrupted
       3. Path is correct

       Or provide a different path."
```

---

### **Malformed YAML**

```
Coach: [Tries to parse metadata]
[Error: YAML syntax error]

Coach: "I found {spec-name} but the YAML frontmatter has syntax errors.

       Error: {yaml_error}

       Would you like me to:
       1. Try to fix the YAML
       2. Ignore metadata and proceed
       3. Show you the problematic section"
```

---

### **skill-creator Fails**

```
Coach: [Invoked skill-creator]
[Error reported by skill-creator]

Coach: "The build encountered an issue: {error}

       This might be because:
       1. Missing dependencies
       2. Incomplete spec
       3. Environmental issues

       Would you like me to:
       1. Re-validate the spec
       2. Try again
       3. Help troubleshoot the error"
```

---

## Success Metrics

The coach is successful when:

1. **User understands where they are** (stage visibility)
2. **Next steps are clear** (actionable guidance)
3. **Quality gates work** (validation encouraged, skipping discouraged)
4. **Workflow is smooth** (minimal friction)
5. **User maintains control** (can skip if needed)

---

## Anti-Patterns

**Don't:**
1. ❌ Assume no files exist without asking
2. ❌ Block user from skipping validation (soft enforcement only)
3. ❌ Create files without confirming with user
4. ❌ Modify skill-creator (work WITH it)
5. ❌ Maintain separate state files (.skill-dev-state.yaml)
6. ❌ Be prescriptive ("You MUST do X")
7. ❌ Overwhelm with too much info upfront

**Do:**
1. ✅ Ask if files exist elsewhere
2. ✅ Recommend with explanation, allow bypass
3. ✅ Confirm before creating/modifying files
4. ✅ Invoke skill-creator at right time
5. ✅ Infer state from file metadata
6. ✅ Guide with recommendations
7. ✅ Progressive disclosure (summary → details on request)

---

## Bundled Resources

### Scripts

#### `scripts/scan_directory.py`

**Purpose:** Scan directory for spec and skill files, parse metadata.

**Input:** Directory path (default: current directory)

**Output:** JSON with found files and their metadata

**Usage:**
```bash
python scripts/scan_directory.py .
```

**Output Example:**
```json
{
  "specs": [
    {
      "path": "./pdf-manipulator-spec.md",
      "name": "pdf-manipulator",
      "validated": true,
      "score": 85,
      "grade": "B",
      "last_run": "2025-11-05T14:30:00Z"
    }
  ],
  "skills": [
    {
      "path": "./pdf-manipulator/SKILL.md",
      "name": "pdf-manipulator",
      "analyzed": true,
      "score": 72,
      "grade": "C",
      "last_run": "2025-11-06T10:15:00Z"
    }
  ]
}
```

---

#### `scripts/detect_stage.py`

**Purpose:** Given scan results, determine workflow stage.

**Input:** JSON from scan_directory.py

**Output:** Stage name and recommended action

**Usage:**
```bash
python scripts/detect_stage.py scan_results.json
```

**Output Example:**
```json
{
  "stage": "READY_TO_BUILD",
  "file": "pdf-manipulator-spec.md",
  "score": 85,
  "recommendation": "Spec is validated. Ready to invoke skill-creator.",
  "action": "build"
}
```

---

### References

#### `references/workflow-stages.md`

**Purpose:** Complete description of all workflow stages and transitions.

**Content:**
- Stage definitions
- Transition conditions
- Recommended actions per stage
- Example guidance for each stage

**When to Load:** When coach needs detailed stage information or user asks "what are the stages?"

---

#### `references/soft-enforcement-patterns.md`

**Purpose:** Templates and patterns for soft enforcement conversations.

**Content:**
- Level 1/2/3 enforcement templates
- Risk explanations per stage
- Example dialogues
- When to escalate enforcement

**When to Load:** When user attempts to skip validation/optimization

---

#### `references/error-recovery.md`

**Purpose:** Common errors and recovery strategies.

**Content:**
- YAML parsing errors
- File permission issues
- Missing dependencies
- skill-creator failures
- Recovery workflows

**When to Load:** When errors occur

---

## Lifecycle Integration

### Complete Workflow

```
1. IDEATION (Coach)
   Help user write spec
   ↓
2. VALIDATION (Coach → spec-analyzer)
   Validate spec completeness
   ↓
3. REFINEMENT (Coach)
   Fix issues if score < 75
   ↓
4. BUILDING (Coach → skill-creator)
   Invoke skill-creator
   ↓
5. TESTING (User)
   User tests in real-world
   ↓
6. OPTIMIZATION (Coach → skill-analyzer)
   Analyze built skill
   ↓
7. IMPROVEMENT (Coach)
   Help fix optimization issues
   ↓
   Loop back to 5 (iterate)
```

---

## Example Session (Full Lifecycle)

```
User: "Help me build a skill"

Coach: [Scans directory, finds nothing]
Coach: "I don't see any spec or skill files. Do you have existing files?"

User: "No"

Coach: "Let's build a skill! What should it do? Give me 3-5 examples."

User: "I want to manipulate PDFs - rotate, merge, crop, split"

Coach: [Helps write spec]
Coach: "Saved as pdf-manipulator-spec.md. Now let's validate..."
[Invokes spec-analyzer]

spec-analyzer: "Score: 85/100 (B) - Ready to build!"

Coach: "Great! Your spec is validated. Invoking skill-creator..."
[Invokes skill-creator]

skill-creator: [Interactive build process]

Coach: "Build complete! Now test your skill, then I recommend optimization."

[User tests the skill]

User: "Ready to optimize"

Coach: "Running skill-analyzer..."
[Invokes skill-analyzer]

skill-analyzer: "Score: 72/100 (C) - Found optimization opportunities:
                1. SKILL.md too large (6k words)
                2. Invocation triggers generic"

Coach: "Want help fixing these?"

User: "Yes, fix #1"

Coach: "Let's externalize large content to references..."
[Helps refactor]

Coach: "Re-analyzing to check improvement..."
[Re-invokes skill-analyzer]

skill-analyzer: "Score improved: 72 → 85 (+13 points)!"

Coach: "Excellent! Your skill is now ready for distribution."
```

---

**End of Specification**
