# Prompt Engineering Guide for Credit-Limited AI Assistance

## The CONTEXT-TASK-CONSTRAINTS (CTC) Framework

### Structure Your Prompts Like This

```text
**CONTEXT:**
[Project background, tech stack, what already exists]

**TASK:**
[Specific deliverable(s) you need - be explicit]

**CONSTRAINTS:**
[Requirements, limitations, preferences]

**FILES/AREAS:**
[Exact locations I should work in]
```

---

## Practical Examples for Your WordPress + Elementor Project

### ❌ INEFFICIENT (Multiple Requests)

```text
"Can you help with my homepage?"
→ Response asking for details
"I need a hero section"
→ Response asking about content
"It should have a CTA button"
→ Back-and-forth continues...
```

### ✅ EFFICIENT (Single Request)

```text
CONTEXT:
WordPress 6.4 site with Elementor Pro 3.18, YoastSEO Premium. 
Local environment (LocalWP). Corporate B2B SaaS company site. 
Target: Fortune 500 decision-makers.

TASK:
Create a high-converting homepage layout with:
1. Hero section with video background capability
2. Social proof section (client logos)
3. 3-feature highlight cards
4. Testimonial carousel
5. CTA section with form integration

CONSTRAINTS:
- Mobile-first responsive design
- Accessibility WCAG 2.1 AA compliant
- Load time under 2s (PageSpeed 90+)
- Brand colors: #1a1a1a (primary), #f4f4f4 (background)
- Elementor Pro widgets only (no custom code)
- Contact Form 7 integration for lead capture

FILES/AREAS:
Homepage template in Elementor
```

---

## Advanced Techniques to Maximize Efficiency

### 1. **Batch Related Tasks Together**

Instead of 5 separate requests, combine:

```text
TASK:
Create and configure:
1. Custom post type for case studies (code snippet)
2. Elementor template for case study archive
3. Single case study page layout
4. Category filter functionality
5. Schema markup for SEO
```

### 2. **Provide Decision-Making Authority**

```text
CONSTRAINTS:
- Use your judgment for spacing/typography following Material Design
- Choose appropriate Elementor widgets (explain choices)
- If something isn't possible in Elementor, suggest best alternative
- Proceed with implementation; don't ask for permission on minor details
```

### 3. **Include Reference Materials**

```text
CONTEXT:
Attached: brand-guidelines.pdf, competitor-site-analysis.md
Design inspiration: https://example-site.com (clean, minimal aesthetic)
Current site structure: [paste sitemap]
```

### 4. **Request Comprehensive Deliverables**

```text
TASK:
Deliver complete onboarding flow including:
- Step-by-step implementation guide
- Elementor JSON export instructions  
- Plugin configuration checklist
- Testing procedures
- Performance optimization steps
- Troubleshooting common issues
```

### 5. **Use Continuation Markers**

```text
This is PART 1 of 3-part site build. Context carries to next request.
```

---

## WordPress-Specific Optimization

### For Plugin Configuration

```text
TASK: Configure YoastSEO Premium for enterprise B2B
Include:
- XML sitemap settings (priority/frequency logic)
- Schema.org markup (Organization, WebSite, Article)
- Internal linking suggestions setup
- Redirect manager rules
- Content analysis custom settings for technical writing
```

### For Elementor Development

```text
TASK: Build reusable Elementor components
Create:
1. Global header (sticky, mobile menu)
2. Footer with 4 columns
3. CTA block template (3 variations)
4. Testimonial card widget
5. Stats counter section

Export all as templates with naming convention: [COMPANY]_[TYPE]_[NAME]
```

---

## Red Flags That Waste Credits

❌ "Can you help me with..." (too vague)  
❌ "What do you think about..." (open-ended discussion)  
❌ "Is it possible to..." (yes/no questions)  
❌ Asking permission before each step  
❌ Not including file paths/exact locations  

---

## The "Mega Prompt" for Complex Features

For your high-profile project, use this template:

```text
PROJECT: [Company Name] Corporate Website Rebuild

CONTEXT:
- Current: [describe existing setup]
- Stack: WordPress 6.x + Elementor Pro + YoastSEO Premium
- Environment: LocalWP on Windows
- Timeline: [X weeks]
- Stakeholders: [C-level, marketing team]

GOAL: [High-level business objective]

TASK BREAKDOWN:
Phase 1: [Component]
- Subtask A
- Subtask B

Phase 2: [Component]
- Subtask C
- Subtask D

DELIVERABLES REQUIRED:
□ Implementation code/configurations
□ Documentation for handoff
□ Testing checklist
□ Performance benchmarks
□ SEO audit results

TECHNICAL CONSTRAINTS:
- Hosting: [specs]
- Plugins: [whitelist/blacklist]
- Performance: [targets]
- Security: [requirements]

DESIGN CONSTRAINTS:
- Brand guide: [link or attachment]
- Accessibility: WCAG 2.1 AA
- Browser support: [list]

SUCCESS METRICS:
- PageSpeed: 90+
- Accessibility: 100% WCAG AA
- SEO: All green in Yoast
- Mobile: Perfect responsive behavior

DECISION AUTHORITY:
You have full authority to make technical implementation decisions.
Explain major architectural choices. Proceed without asking permission.
```

---

## Pro Tips for Your Workflow

1. **Keep a "Context Document"** - Maintain a running doc with your tech stack, brand guidelines, and project structure. Paste relevant sections into each prompt.

2. **Use Checklists** - I can work through complex checklists systematically in one request.

3. **Request Exports** - Ask for "configuration export commands" or "all code as complete files" to avoid followup requests.

4. **Combine Testing** - "After implementation, test for X, Y, Z and report findings" in the same request.

5. **Ask for Alternatives** - "If approach A won't work, implement approach B instead" reduces back-and-forth.

---

## Your Next Request Should Look Like

```text
CONTEXT:
WordPress + Elementor Pro + YoastSEO Premium on LocalWP (Windows).
Multinational B2B SaaS company website. Target: enterprise clients.

TASK:
Set up complete local development environment and create homepage:

1. Recommend plugin stack (security, performance, forms, backups)
2. Configure YoastSEO Premium for enterprise SEO
3. Build Elementor homepage with [specific sections]
4. Create global header/footer templates
5. Set up performance optimization (caching, lazy load, minification)
6. Provide deployment checklist for staging

CONSTRAINTS:
- Load time <2s
- Mobile-first
- WCAG 2.1 AA compliant
- No jQuery dependencies
- Elementor Pro widgets preferred

DELIVERABLES:
- Complete configuration guide
- Elementor JSON exports
- Plugin settings export
- Testing procedures
- Performance benchmark targets

Proceed with implementation. Use your judgment on UX details.
```

This single prompt would typically accomplish what might otherwise take 8-12 back-and-forth requests.

---

## Quick Reference Checklist

Before submitting a prompt, verify:

- [ ] Included full tech stack details
- [ ] Specified exact deliverables needed
- [ ] Listed all constraints upfront
- [ ] Gave decision-making authority
- [ ] Mentioned file paths/locations
- [ ] Requested comprehensive documentation
- [ ] Combined related tasks together
- [ ] Avoided yes/no questions
- [ ] Included success metrics

---

## Example Prompt Templates

### Template 1: Feature Implementation

```text
CONTEXT: [Tech stack + current state]
TASK: Implement [feature] with [specific requirements 1-5]
CONSTRAINTS: [Performance/accessibility/design requirements]
DELIVERABLES: Code + tests + documentation + deployment steps
Authority: Proceed with best practices; explain major decisions only.
```

### Template 2: Debugging & Optimization

```text
CONTEXT: [Issue description + environment + error logs]
TASK: 
1. Diagnose root cause
2. Fix issue
3. Add preventive measures
4. Document solution
CONSTRAINTS: [Maintain backward compatibility, no breaking changes]
FILES: [Exact paths to problematic files]
```

### Template 3: Architecture Planning

```text
CONTEXT: [Project scale + users + business goals]
TASK: Design [system component] including:
- Architecture diagram
- Technology recommendations
- Implementation phases
- Migration strategy (if applicable)
- Testing approach
CONSTRAINTS: [Budget, timeline, team size, existing systems]
DELIVERABLES: Technical design doc + implementation roadmap + risk analysis
```

---

*Created: October 30, 2025*  
*Purpose: Maximize AI assistant efficiency under credit limits*  
*Optimized for: WordPress + Elementor Pro + YoastSEO Premium projects*
