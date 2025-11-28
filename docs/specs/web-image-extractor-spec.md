# Web Image Extractor - Smart Image Extraction and Download Skill

**Document Type:** Skill Specification
**Skill Name:** web-image-extractor
**Date:** November 2, 2025
**Status:** Concept Phase
**Version:** 1.0

---

## Executive Summary

A reusable Claude Code Skill that intelligently extracts and downloads images from web pages using any available web scraping tool (WebFetch, Firecrawl MCP, Google DevTools MCP, Puppeteer MCP). The Skill implements smart filtering to extract only meaningful content images (excluding navigation, ads, tracking pixels) and downloads them with descriptive filenames.

### Core Innovation

Rather than requiring specific tools, this Skill demonstrates the **Skill-Orchestrated pattern** by:
1. Using whatever web scraping tools are available (tool-agnostic fallback chain)
2. Providing procedural knowledge on how to parse HTML and identify content images
3. Orchestrating multiple tools (web fetching + image downloading) for a complete workflow
4. Teaching Claude how to filter images intelligently based on context

### Key Use Cases

1. **Research & Documentation:** Extract diagrams, screenshots, and illustrations from technical blogs
2. **Article Preparation:** Gather images for blog posts or documentation
3. **Visual Evidence:** Collect screenshots and visualizations for analysis
4. **Content Curation:** Download meaningful images from multiple sources efficiently

---

## Problem Statement

### Current Pain Points

**Manual Image Downloading:**
- Visit each webpage
- Right-click individual images
- Save with generic filenames (image1.png, screenshot.png)
- Manually filter out icons, ads, social media buttons
- Time-consuming for multiple pages

**Existing Tool Limitations:**
- **WebFetch:** Returns markdown, loses image references
- **Firecrawl MCP:** Designed for text content, not binary downloads
- **Google DevTools MCP:** Can screenshot pages but not extract individual images
- **curl alone:** Requires knowing exact image URLs beforehand

### Solution Requirements

A Skill that:
- Works with ANY available web scraping tool (fallback strategy)
- Intelligently identifies content images vs. UI elements
- Filters by size, context, and semantic meaning
- Downloads with descriptive filenames based on alt text or context
- Handles various image formats (PNG, JPG, WebP, SVG)
- Reports success/failure clearly

---

## Technical Architecture

### Skill Structure

```
~/.config/claude/skills/web-image-extractor/
├── SKILL.md                    # Main Skill instructions
├── scripts/
│   ├── extract-images.sh       # HTML parsing and filtering (optional)
│   └── download-image.sh       # Robust curl wrapper (optional)
└── README.md                   # Usage examples
```

### SKILL.md Design

**YAML Frontmatter:**
```yaml
---
name: "Web Image Extractor"
description: "Extract and download meaningful images from web pages using any available scraping tool"
version: "1.0"
tags: ["web-scraping", "images", "research", "automation"]
---
```

**Instructions Structure:**
1. **Tool Selection Strategy** - Procedural logic for choosing best available tool
2. **HTML Parsing Logic** - How to identify main content area
3. **Image Filtering Criteria** - Rules for meaningful vs. noise
4. **Download Process** - How to use curl effectively
5. **Error Handling** - Retry logic, fallbacks, reporting

---

## Implementation Details

### 1. Tool Selection Strategy (Fallback Chain)

**Priority Order:**
```
1. Google DevTools MCP (if available)
   - Best for: Dynamic content, JavaScript-rendered images
   - Can execute JavaScript to trigger lazy loading
   - Full browser environment

2. Firecrawl MCP (if available)
   - Best for: Clean, preprocessed HTML
   - Already filters out some cruft
   - Good markdown conversion for context

3. Puppeteer MCP (if available)
   - Best for: Complex interactions, screenshots
   - Full browser automation
   - Can handle auth/cookies if needed

4. WebFetch (always available)
   - Fallback for static pages
   - Simple HTML retrieval
   - No JavaScript execution
```

**Selection Logic in Skill:**
```markdown
## Tool Selection

When asked to extract images from a webpage:

1. First, check what tools are available:
   - Run: `which google-devtools-mcp` (or check MCP servers)
   - Check for Firecrawl MCP in MCP server list
   - Check for Puppeteer MCP availability
   - WebFetch is always available as fallback

2. Choose the best tool based on page type:
   - **Dynamic/Modern web app** → Google DevTools or Puppeteer
   - **Blog/article page** → Firecrawl or WebFetch
   - **Simple static page** → WebFetch

3. If primary tool fails, fall back to next option
```

### 2. HTML Parsing Logic

**Identify Main Content Area:**
```markdown
## Finding the Main Content

After fetching HTML, locate the main content area:

1. **Preferred selectors** (in priority order):
   - `<main>` element
   - `<article>` element
   - `<div class="content">`, `<div class="post">`, `<div class="article">`
   - `<body>` as last resort

2. **Exclude these sections:**
   - `<header>`, `<nav>`, `<footer>`, `<aside>`
   - Elements with class/id containing: "nav", "menu", "sidebar", "ad", "social", "share"
   - `<script>`, `<style>` tags

3. **Within main content, find all `<img>` tags:**
   ```bash
   # Example grep pattern
   grep -o '<img[^>]*>' | grep -o 'src="[^"]*"'
   ```
```

### 3. Image Filtering Criteria

**Smart Filtering Rules:**
```markdown
## Image Filtering

Not all images are meaningful. Filter using these criteria:

### Size-Based Filtering
- **Exclude:** Images < 200px width OR < 200px height
  - Likely icons, bullets, social media buttons
- **Exclude:** 1x1 pixel images (tracking pixels)
- **Prioritize:** Images > 500px width (likely content diagrams/screenshots)

### Context-Based Filtering
- **Include:** Images with descriptive alt text (> 10 characters)
- **Exclude:** Alt text like "icon", "logo", "avatar", "button"
- **Include:** Images within `<figure>` elements (likely meaningful content)
- **Exclude:** Images with class/id containing: "icon", "logo", "avatar", "ad", "sponsor"

### Format-Based Filtering
- **Include:** PNG, JPG, JPEG, WebP, SVG
- **Exclude:** GIF (usually decorative)
- **Special handling for SVG:** May need different download approach

### URL Pattern Filtering
- **Exclude:** URLs containing: "icon", "logo", "avatar", "sprite", "pixel", "tracker"
- **Exclude:** Social media embed images (twitter.com/*, facebook.com/*)
- **Exclude:** CDN placeholder images (placeholder.com, via.placeholder.com)
```

### 4. Download Process

**Using curl with Proper Headers:**
```markdown
## Downloading Images

For each filtered image URL:

1. **Generate descriptive filename:**
   - First choice: Use alt text (sanitized, max 50 chars)
   - Second choice: Extract from URL path (last segment)
   - Fallback: Use pattern like "image-001.png"

   ```bash
   # Example filename generation
   filename=$(echo "$alt_text" | tr -cs '[:alnum:]' '-' | tr '[:upper:]' '[:lower:]' | cut -c1-50).${extension}
   ```

2. **Download with curl:**
   ```bash
   curl -L \
     -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)" \
     -H "Referer: ${page_url}" \
     --retry 3 \
     --retry-delay 2 \
     --max-time 30 \
     -o "${output_dir}/${filename}" \
     "${image_url}"
   ```

3. **Verify download:**
   - Check file size > 0
   - Check file actually contains image data (use `file` command)
   - Report success/failure

4. **Handle relative URLs:**
   - Convert relative paths to absolute using page base URL
   - Handle protocol-relative URLs (//cdn.example.com/image.png)
```

### 5. Error Handling

**Robust Error Handling:**
```markdown
## Error Handling

Handle common failure modes:

1. **Page fetch fails:**
   - Try alternative tool from fallback chain
   - Report clear error message to user

2. **No images found:**
   - Check if filters were too aggressive
   - Suggest loosening constraints
   - Show what was filtered out and why

3. **Download fails:**
   - Retry up to 3 times with exponential backoff
   - Skip image if still failing, continue with others
   - Report which images failed and why

4. **Invalid URLs:**
   - Skip malformed URLs
   - Report for user awareness

5. **Rate limiting:**
   - Add delays between downloads (1-2 seconds)
   - Respect robots.txt if available
   - Batch report progress
```

---

## Usage Examples

### Example 1: Extract Images from Technical Blog

**User prompt:**
> Extract images from https://scottspence.com/posts/optimising-mcp-server-context-usage-in-claude-code and save to ./images/

**Skill workflow:**
1. Check available tools → Use Firecrawl MCP (if available) or WebFetch
2. Fetch page content
3. Parse HTML, find `<article>` or `<main>` section
4. Extract all `<img>` tags within content area
5. Filter: Keep images > 200px, with meaningful alt text, exclude nav/footer
6. Generate filenames from alt text (e.g., "context-usage-before-optimization.png")
7. Download via curl to ./images/
8. Report: "Downloaded 3 images: [list with filenames and alt text]"

### Example 2: Extract Architecture Diagrams

**User prompt:**
> Get all diagrams from https://leehanchung.github.io/blogs/2025/10/26/claude-skills-deep-dive/

**Skill workflow:**
1. Use WebFetch (static page)
2. Find images in `<main>` content
3. Filter for large images (diagrams typically > 500px)
4. Notice direct image URLs: https://leehanchung.github.io/assets/img/2025-10-26/*.png
5. Extract filenames from URL (01-claude-skill-1.png, etc.)
6. Download all using curl
7. Report: "Downloaded 11 diagrams from Lee Hanchung's Skills deep dive"

### Example 3: Batch Image Extraction

**User prompt:**
> Extract images from these 3 blog posts: [list URLs]

**Skill workflow:**
1. For each URL:
   - Fetch page
   - Extract images
   - Download to separate subdirectories (blog1/, blog2/, blog3/)
2. Consolidated report:
   - Total images found: 42
   - After filtering: 15
   - Successfully downloaded: 14
   - Failed: 1 (with reason)
3. Organize by source for easy reference

---

## Integration with Skill-Orchestrated MCP Pattern

### Demonstrates Key Principles

**This Skill exemplifies the Skill-Orchestrated pattern:**

1. **Tool Agnostic:**
   - Doesn't require specific MCP server
   - Works with whatever is available
   - Graceful degradation to simpler tools

2. **Procedural Knowledge:**
   - Teaches Claude HOW to parse HTML
   - Provides filtering logic, not just "call this function"
   - Explains reasoning behind each step

3. **Orchestration:**
   - Combines web fetching (MCP or native) + curl (native Bash)
   - Multi-step workflow managed by procedural instructions
   - Error handling and retry logic built into procedures

4. **Minimal Token Cost:**
   - Skill metadata: ~100 tokens at startup
   - Full instructions: ~2,000 tokens when activated
   - vs. equivalent MCP server: 5,000-10,000 tokens always loaded

### Could Be Enhanced with MCP

**Optional MCP server for advanced features:**
```
web-image-extractor-mcp:
  Tools:
    - extract_images(url, filters)  # Simple interface
    - verify_image(url)             # Check if valid image
    - analyze_alt_text(text)        # Semantic analysis of alt text
```

**But Skill alone is sufficient** for most use cases, demonstrating that Skills can accomplish complex tasks without custom MCP servers.

---

## Implementation Roadmap

### Phase 1: Basic Skill (MVP)
**Deliverables:**
- SKILL.md with core instructions
- WebFetch-based image extraction
- curl-based downloading
- Basic size filtering

**Time:** 2-3 hours
**Complexity:** Low

### Phase 2: Enhanced Filtering
**Deliverables:**
- Context-based filtering (alt text analysis)
- URL pattern exclusions
- Filename generation from alt text
- Better error handling

**Time:** 2-3 hours
**Complexity:** Medium

### Phase 3: Multi-Tool Support
**Deliverables:**
- Firecrawl MCP integration
- Google DevTools MCP integration
- Tool fallback chain
- Dynamic tool selection

**Time:** 3-4 hours
**Complexity:** Medium-High

### Phase 4: Advanced Features (Optional)
**Deliverables:**
- Batch processing multiple URLs
- Image deduplication
- Screenshot fallback (if image download fails)
- OCR for extracting text from downloaded images

**Time:** 4-6 hours
**Complexity:** High

---

## Testing Strategy

### Test Cases

1. **Static Blog Page** (Scott Spence)
   - Verify: Extracts context screenshots
   - Verify: Excludes header/footer images
   - Verify: Generates descriptive filenames

2. **Technical Documentation** (Lee Hanchung)
   - Verify: Extracts all diagrams
   - Verify: Handles direct image URLs
   - Verify: Preserves original filenames

3. **Dynamic Page** (requires Google DevTools MCP)
   - Verify: Handles lazy-loaded images
   - Verify: Waits for JavaScript rendering

4. **Mixed Content Page**
   - Verify: Filters out ads, icons, tracking pixels
   - Verify: Keeps only content images
   - Verify: Reports filtering decisions

### Success Criteria

- ✅ Extracts 90%+ of visible content images
- ✅ Filters out 95%+ of noise (icons, ads, etc.)
- ✅ Generates readable, descriptive filenames
- ✅ Handles failures gracefully (retries, reports errors)
- ✅ Works with at least 2 different tool backends

---

## Maintenance & Evolution

### Known Limitations

1. **No JavaScript execution** (with WebFetch fallback)
   - Limitation: Can't extract images loaded by JavaScript
   - Mitigation: Use DevTools/Puppeteer MCP when available

2. **Requires manual context parsing**
   - Limitation: HTML structure varies widely across sites
   - Mitigation: Provide fallback selectors, allow user overrides

3. **Rate limiting concerns**
   - Limitation: Bulk downloads might trigger rate limits
   - Mitigation: Add delays, respect robots.txt

### Future Enhancements

1. **Machine learning-based filtering**
   - Use vision models to classify images as content vs. UI
   - More accurate than size/context heuristics

2. **Image optimization**
   - Resize large images for reasonable file sizes
   - Convert formats (WebP → PNG for compatibility)

3. **Semantic understanding**
   - Analyze image content to generate better filenames
   - Auto-tag images by content type (diagram, screenshot, photo)

4. **Integration with note-taking**
   - Auto-create markdown references for downloaded images
   - Generate image galleries or comparison tables

---

## Competitive Analysis

### vs. Browser Extensions

**Browser Extensions (e.g., "Download All Images"):**
- ✅ Visual interface
- ✅ User can manually select images
- ❌ Requires manual browser use
- ❌ No automation or batch processing
- ❌ No integration with AI workflows

**Web Image Extractor Skill:**
- ✅ Fully automated
- ✅ AI-driven filtering (smarter than regex)
- ✅ Integrated with research workflows
- ✅ Batch processing multiple pages
- ❌ No visual interface (command-line)

### vs. Custom Scripts

**Custom wget/curl Scripts:**
- ✅ Simple and reliable
- ❌ Requires knowing exact URLs
- ❌ No intelligent filtering
- ❌ Manual filename management
- ❌ Not reusable across different sites

**Web Image Extractor Skill:**
- ✅ Works on any blog/article page
- ✅ Intelligent content detection
- ✅ Reusable across projects
- ✅ Claude can adapt to different HTML structures
- ✅ Procedural knowledge encoded in Skill

### vs. Dedicated MCP Server

**Hypothetical "Image Extractor MCP":**
- ✅ Potentially more robust parsing
- ✅ Dedicated tool with optimized algorithms
- ❌ Always consumes tokens (eager loading)
- ❌ Requires installation/maintenance
- ❌ Less flexible (fixed filtering rules)

**Web Image Extractor Skill:**
- ✅ Lazy-loaded (only when needed)
- ✅ Extremely flexible (Claude can adapt rules)
- ✅ No additional dependencies
- ✅ Educational (demonstrates Skill-Orchestrated pattern)
- ⚠️ May be slower than dedicated implementation

---

## Success Metrics

### Immediate Value

**Time Savings:**
- Manual: ~15-30 minutes for 10 images across 3 pages
- With Skill: ~2-3 minutes
- **Savings: 80-90% time reduction**

**Accuracy:**
- Manual: 100% (user selects exactly what they want)
- With Skill: 90-95% (some false positives/negatives expected)
- **Trade-off: Slight accuracy loss for massive time savings**

### Long-Term Value

**Reusability:**
- One-time creation, infinite uses
- Valuable for any research involving web images
- Demonstrates pattern for other automation Skills

**Educational:**
- Perfect example of Skill-Orchestrated MCP pattern
- Shows how Skills can orchestrate multiple tools
- Illustrates procedural vs. declarative knowledge

**Strategic:**
- Complements research workflows
- Enables visual evidence gathering
- Foundation for more advanced automation

---

## Appendix: Example SKILL.md Skeleton

```markdown
---
name: "Web Image Extractor"
description: "Extract and download meaningful images from web pages"
version: "1.0"
---

# Web Image Extractor

I help you extract and download images from web pages automatically.

## What I Do

- Fetch web page content using available tools
- Identify main content area (excluding nav/ads)
- Filter for meaningful images (not icons/pixels)
- Download images with descriptive filenames

## How I Work

### Step 1: Choose Best Tool

I'll use the best available tool:
1. Google DevTools MCP → for dynamic content
2. Firecrawl MCP → for clean HTML
3. WebFetch → fallback for static pages

### Step 2: Parse HTML

I locate the main content:
- Look for `<main>`, `<article>`, or `<div class="content">`
- Exclude `<header>`, `<nav>`, `<footer>`
- Find all `<img>` tags within content

### Step 3: Filter Images

I keep only meaningful images:
- Size > 200px width AND height
- Has descriptive alt text
- Not in navigation/sidebar
- Not tracking pixels or icons

### Step 4: Download

For each image:
- Generate filename from alt text or URL
- Use curl with proper headers
- Retry on failure
- Verify successful download

## Example Usage

**You:** Extract images from [blog URL] to ./images/

**Me:**
1. Fetch page with [chosen tool]
2. Found 15 images in main content
3. After filtering: 8 images (excluded 7 icons/nav)
4. Downloading...
5. Success: 8/8 downloaded to ./images/

## Advanced Options

You can customize:
- Minimum image size
- Filter patterns
- Output directory
- Filename format

Just describe what you need!
```

---

## References

1. **Firecrawl Documentation** - Web scraping and markdown conversion
2. **Google DevTools Protocol** - Browser automation
3. **Puppeteer Docs** - Headless browser control
4. **Claude Skills Documentation** - Skill structure and best practices
5. **MCP Specification** - Model Context Protocol standard

---

**Document Status:** Ready for Implementation
**Next Steps:** Create basic Skill (Phase 1 MVP), test with article image extraction
**Owner:** TBD
**Priority:** Medium (useful utility, demonstrates pattern)
