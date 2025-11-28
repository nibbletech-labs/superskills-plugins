# Form Assistant Skill

**Status:** 🔄 Spec Needed
**Last Updated:** November 2, 2025
**Platform:** Claude Code

---

## Overview

The Form Assistant is an intelligent form completion skill that works with both PDF and web forms, combining research, analysis, and iterative refinement to produce high-quality form responses. It uses a sophisticated confidence scoring system to identify gaps, research requirements, and engage users only when necessary.

**Key Principle:** AI does maximum work autonomously, asks user questions only when required, and provides full transparency into confidence levels.

**Note:** This skill is designed for Claude Code, leveraging persistent working directories for document management and session resumability.

---

## Core Capabilities

- **Universal form support** - Works with PDF forms and web forms (business, government, legal, applications, etc.)
- **Multi-format handling** - PDFs analyzed via PDF skill, web forms scraped and analyzed from URLs
- **Research-driven** - Combines web research + local documents to understand requirements
- **Confidence scoring** - Dual-metric system (checklist quality × checklist confidence)
- **Iterative refinement** - Self-improves before asking user questions
- **Pausable/resumable** - Full documentation trail allows picking up later
- **Targeted iteration** - User can refine specific questions as needed

---

## Workflow

### Phase 1: Initial Analysis & Research

1. **Form Analysis**

   **For PDF Forms:**
   - Read PDF form using PDF skill
   - Extract all fields and questions
   - Identify field types (text, checkbox, dropdown, date, etc.)
   - Map field dependencies (conditional questions)
   - Categorize as required vs optional

   **For Web Forms (Progressive Extraction Strategy):**

   **Step 1: Try WebFetch (default)**
   - Fetch web page using WebFetch
   - Parse HTML to identify form elements
   - Extract all input fields, labels, and questions
   - Identify field types (text, email, number, select, radio, checkbox, textarea, etc.)
   - Capture validation attributes (required, pattern, min/max, etc.)
   - Assess extraction quality (% of fields successfully extracted)

   **Step 2: If WebFetch insufficient (<80% confidence in extraction)**
   - Check available tools/MCP servers for:
     - Browser automation (Playwright, Puppeteer, Selenium)
     - Web scraping tools (Firecrawl, etc.)
     - Other form extraction capabilities

   **Step 3: If suitable tool found**
   - Use enhanced tool to re-extract form
   - Map field dependencies (conditional/dynamic fields via JavaScript)
   - Detect multi-page/step forms

   **Step 4: If no suitable tool available**
   - Prompt user: "This appears to be a complex web form with dynamic content. For best results, I recommend installing [recommended tool]. Would you like me to guide you through installation?"
   - If tool has a skill available, offer to install automatically
   - Alternatively: Ask user to manually extract form fields and provide as document

   - Save form structure to document (same format as PDF analysis)

2. **Gather Context**
   - Check if `research/` folder exists in current working directory
   - **If folder does NOT exist:**
     - Create `research/` folder
     - Ask user: "I've created a `research/` folder. Please add any supporting documents (PDFs, Word docs, notes, etc.) that might help answer this form. Let me know when you're ready to continue."
     - Wait for user confirmation
   - **If folder exists:**
     - Ask user: "I found a `research/` folder with existing documents. Should I use these, or would you like to add/update documents first?"
     - Wait for user confirmation
   - Read all documents from `research/` folder

3. **Research Requirements**
   - **Form-specific:** Search for guides, tips, common mistakes for this specific form
   - **Domain knowledge:** Research concepts, terminology, best practices for question topics
   - Sources: Web search + local documents

4. **Generate Success Criteria**
   - For each question, auto-generate a checklist based on research:
     - Format requirements (date format, character limits, numeric ranges)
     - Validation rules (consistency with other fields, required/optional)
     - "Good answer" criteria (what reviewers look for, effectiveness indicators)
     - Cross-field consistency checks
   - Document confidence in each checklist item based on research quality

### Phase 2: Self-Improvement Loop (Autonomous)

1. **Draft Initial Answers**
   - Generate answers from available data (research docs + web research)
   - Document source for each answer

2. **Score Each Question**
   - **Checklist Score** (0-100%)
     - Each checklist item scored: Low (0), Med (1), High (2)
     - Percentage = (sum of scores) / (max possible) × 100
     - Special case: If question irrelevant based on other answers → 100%
   - **Checklist Confidence** (0-100)
     - How confident is the AI in the checklist criteria itself
     - Based on: research quality, source authority, consistency
   - **Total Confidence** = Checklist Score × Checklist Confidence

3. **Autonomous Improvement**
   - For questions <70% total confidence:
     - Conduct deeper research on specific gaps
     - Cross-reference multiple sources
     - Refine checklist criteria if needed
     - Update answers and re-score
   - Iterate until no further improvements possible without user input

### Phase 3: User Engagement

1. **Identify Gaps Requiring User Input**
   - Total confidence <70%
   - Missing data completely
   - Conflicting data from sources

2. **Ask Targeted Questions**
   - Clearly explain what's needed and why
   - Distinguish between:
     - "I need clarification on what constitutes a good answer" (low checklist confidence)
     - "I need more information to answer this well" (low checklist score)

3. **User Provides Input**
   - Answers to questions
   - Can also add more documents to research folder

4. **Update & Re-score**
   - Incorporate user input
   - Save user answers to research folder for future reference
   - Update draft answers document
   - Recalculate confidence scores

### Phase 4: Review & Refinement

1. **Present Complete State**
   - Show all questions with:
     - Current answers
     - Confidence scores (checklist score, checklist confidence, total)
     - Which checklist items are low/med/high

2. **User Decision Point**
   - "Are you happy to proceed, or refine specific questions?"
   - Options:
     - **Proceed** → Move to Phase 5
     - **Refine** → Enter focused iteration loop

3. **Focused Iteration (if selected)**
   - User selects specific questions to improve
   - AI conducts targeted research for those questions only
   - Can iterate multiple rounds on specific questions
   - User decides when to stop ("good enough" or "keep going")

### Phase 5: Completion

1. **Final Review**
   - Present complete answers with final confidence scores
   - Highlight any remaining low-confidence items

2. **Form Filling**

   **For PDF Forms:**
   - Ask user: "Would you like me to fill the PDF form now?"
   - If yes: Use PDF skill to populate form
   - If no: User has draft answers document for manual completion

   **For Web Forms:**
   - Provide structured output document with answers mapped to field names/IDs
   - Optionally: Generate JavaScript snippet to auto-fill form (if user wants)
   - User copies answers or runs script to complete web form
   - Note: Direct web form submission not supported (user maintains control)

3. **Save All Artifacts**
   - Final answers document
   - Success criteria checklists
   - Confidence score summary
   - Research notes and sources
   - (Web forms) Field mapping document for manual/script filling

---

## Confidence Scoring System

### Two-Metric Approach

#### 1. Checklist Score (0-100%)
Measures how well the current answer meets the success criteria.

**Calculation:**
- Each checklist item scored: Low (0), Med (1), High (2)
- Score = (Σ item scores) / (max possible score) × 100

**Example:**
Question has 5 checklist items:
- Format valid: High (2)
- Consistent with Q3: Med (1)
- Meets word count: High (2)
- Demonstrates impact: Low (0)
- No contradictions: High (2)

Score = (2+1+2+0+2) / 10 × 100 = 70%

#### 2. Checklist Confidence (0-100)
Measures confidence in the checklist criteria themselves.

**Factors:**
- Research quality (authoritative sources vs. sparse info)
- Consistency across sources (unanimous vs. conflicting)
- Specificity (clear requirements vs. vague guidance)
- Recency (current info vs. outdated)

**Example:**
- Found official government guide: +30
- Multiple expert sources agree: +25
- Clear, specific requirements stated: +25
- Published within 2 years: +20
= 100 confidence

#### 3. Total Confidence
**Total = Checklist Score × Checklist Confidence**

**Examples:**
- 80% checklist × 90 confidence = 72% total ✓ (above threshold)
- 90% checklist × 60 confidence = 54% total ✗ (research needed)
- 60% checklist × 95 confidence = 57% total ✗ (more data needed)

**Threshold:** <70% triggers user engagement

### Special Cases

#### Conditional Questions
If question is irrelevant based on other answers:
- Checklist score: 100% (auto-set)
- Checklist confidence: 100 (auto-set)
- Total: 100% (no action needed)

#### Critical Fields
For high-stakes questions (legal, financial, binding commitments):
- Always flag for user review regardless of confidence
- Mark in final review with ⚠️ icon

---

## Document Artifacts

All documents saved to research folder for transparency and resumability.

### 1. Form Analysis Document
**Filename:** `[Form Name]_Analysis.md`

**Contents:**
- List of all questions/fields
- Field dependencies map
- Required vs. optional categorization
- Field type specifications

### 2. Success Criteria Document
**Filename:** `[Form Name]_Criteria.md`

**Contents:**
- For each question:
  - Question text
  - Auto-generated checklist items
  - Confidence in each criterion
  - Sources/reasoning for criteria

### 3. Draft Answers Document
**Filename:** `[Form Name]_Draft.md`

**Contents:**
- For each question:
  - Current answer
  - Checklist score (0-100%)
  - Checklist confidence (0-100)
  - Total confidence (%)
  - Source citations
  - Breakdown of checklist item scores (L/M/H)

### 4. Research Notes
**Filename:** `[Form Name]_Research.md`

**Contents:**
- Web research findings
- Local document summaries
- Key insights per question
- Source URLs and citations

### 5. User Input Log
**Filename:** `[Form Name]_UserInput.md`

**Contents:**
- Questions asked to user (with timestamp)
- User responses
- Rationale for why question was needed
- Impact on confidence scores

### 6. Final Output
**Filename:** `[Form Name]_Final.pdf` (if auto-filled)

---

## User Interaction Points

### 1. Initial Setup
- **Trigger:** Form uploaded (PDF) or URL provided (web form)
- **Action:** Check for `research/` folder
- **If no folder exists:**
  - Create `research/` folder
  - **Ask:** "I've created a `research/` folder. Please add any supporting documents that might help answer this form. Let me know when you're ready to continue."
- **If folder exists:**
  - **Ask:** "I found a `research/` folder with existing documents. Should I use these, or would you like to add/update documents first?"
- **Wait:** For user confirmation before proceeding

### 1b. Web Form Extraction Issues (if applicable)
- **Trigger:** WebFetch extraction confidence <80% for web forms
- **Show:** "I was able to extract [X]% of the form fields, but this appears to be a complex dynamic form. I can work with what I have, or we can use enhanced tools for better extraction."
- **Check:** Available MCP servers and tools
- **If enhanced tool available:**
  - **Ask:** "I found [tool name] which can better extract this form. Should I use it?"
- **If no enhanced tool available:**
  - **Ask:** "For best results, I recommend installing [recommended tool]. Would you like installation guidance, or should I proceed with the fields I could extract?"

### 2. Gap Identification
- **Trigger:** After autonomous improvement, questions still <70%
- **Show:** List of questions needing input with explanation
- **Ask:** Specific questions to fill gaps

### 3. Review Checkpoint
- **Trigger:** After user input incorporated
- **Show:** Complete state of all answers with confidence scores
- **Ask:** "Proceed to fill form, or refine specific questions?"

### 4. Refinement Loop
- **Trigger:** User selects "refine"
- **Ask:** "Which questions would you like to improve?"
- **After each iteration:** "Continue refining, or proceed?"

### 5. Final Confirmation
- **Trigger:** User satisfied with answers
- **Show:** Final confidence summary
- **Ask (PDF):** "Fill the PDF form automatically?"
- **Ask (Web):** "Generate field mapping document / auto-fill script?"

---

## Technical Requirements

### Tools/Skills Used

**Required:**
- **PDF skill** - PDF form reading and filling
- **WebFetch** - Basic web form extraction
- **Research skill** - Web and document research
- **WebSearch** - Online form guides and domain knowledge
- **Read/Write** - Document management
- **AskUserQuestion** - User engagement

**Optional (for enhanced web form support):**
- **Browser automation tools** - Playwright, Puppeteer, Selenium (via MCP or skills)
- **Web scraping tools** - Firecrawl or similar (via MCP)
- Skill checks for these dynamically and uses if available

### Dependencies
- PDF skill must support form field extraction
- WebFetch for basic web form HTML parsing
- Research folder structure (optional but recommended)
- Enhanced tools (optional) - skill adapts based on availability

### State Management
All state preserved in document artifacts, enabling:
- Pause/resume across sessions
- Audit trail of decisions
- Version control of answers
- Iterative refinement over time

---

## Example Use Cases

### Use Case 1: Grant Application
1. User uploads 15-page grant application PDF
2. AI finds research folder with business plan, financial docs, past grant proposals
3. Researches grant-specific requirements and best practices
4. Generates success criteria (e.g., "Impact statement should quantify beneficiaries")
5. Drafts answers, scores confidence
6. Asks user 3 questions about specific program outcomes (low confidence)
7. User provides input
8. Reviews all 47 questions with user, confidence scores visible
9. User wants to refine "sustainability plan" question
10. AI does deeper research, improves answer from 68% → 85%
11. Fills PDF form automatically

### Use Case 2: Visa Application
1. User uploads visa form, provides passport scan and employment letter
2. AI researches visa requirements, common rejection reasons
3. Identifies that Q12 (travel history) has conflicting data (passport vs. user's notes)
4. Asks user to clarify discrepancy
5. Flags critical questions (legal declarations) for user review regardless of confidence
6. Generates final draft with 95%+ confidence on all questions
7. User reviews, approves auto-fill

### Use Case 3: Job Application (Iterative)
1. User starts Monday, uploads application
2. AI drafts answers, 60% average confidence (limited info about company)
3. User adds more docs Tuesday, confidence → 75%
4. Wednesday user refines "Why this company?" question specifically
5. AI researches company values, recent news, refines answer → 92%
6. Thursday user approves, form filled

### Use Case 4: Online Registration Form (Web)
1. User provides URL to conference registration form
2. AI fetches page, extracts 12 form fields (name, email, org, dietary needs, etc.)
3. Saves form structure to analysis document
4. Researches conference to understand context (academic conference, keynote topics)
5. Drafts answers using user's research folder (CV, bio, previous conference attendance)
6. All questions >85% confidence
7. Generates field mapping document with answers
8. User copies answers into web form manually (or runs optional JS snippet)

---

## Success Metrics

- **Automation rate:** % of questions answered without user input
- **Confidence accuracy:** Correlation between AI confidence and user satisfaction
- **Iteration efficiency:** Average rounds to reach >70% confidence
- **User satisfaction:** Feedback on answer quality
- **Time saved:** vs. manual form completion
- **Web form extraction rate:** % of web forms successfully extracted (basic vs. enhanced tools)

---

## Future Enhancements

- **Multi-form learning:** Reuse research across similar forms
- **Template library:** Pre-built checklists for common form types
- **Collaborative mode:** Multiple users contribute to answers
- **Integration with calendar/contacts:** Auto-populate from structured data
- **Version comparison:** Track changes across iterations visually
- **Browser automation (web forms):** Direct form filling via Playwright/Selenium (with user approval)
- **Multi-page form navigation:** Handle complex web forms with multiple steps/pages
- **Tool installation automation:** Auto-install recommended MCP servers/tools when needed
- **Extraction quality scoring:** ML-based assessment of form extraction completeness

---

## Notes

- This skill prioritizes **quality over speed** - forms are high-stakes documents
- Transparency is critical - user should always understand confidence scores
- The checklist confidence metric prevents "confidently wrong" answers
- Iteration capability allows incremental improvement over time
- Document artifacts enable full auditability and reproducibility
