# Agent OS — Full Workflow Guide

A systematic workflow for spec-driven development with Claude Code. This document captures everything needed to replicate the Agent OS system in a new project.

---

## Overview

Agent OS is a set of **5 Claude Code slash commands** + a **directory structure** that creates a closed-loop development workflow:

1. **Define product** (`/plan-product`) — Establish mission, roadmap, tech stack
2. **Shape work** (`/shape-spec`) — Gather context, create specs before implementation
3. **Inject standards** (`/inject-standards`) — Surface relevant coding standards into context
4. **Discover standards** (`/discover-standards`) — Extract tribal knowledge from code into reusable standards
5. **Index standards** (`/index-standards`) — Rebuild the standards index for quick matching

Each phase of development follows: **Shape → Inject → Implement → Discover → Index**

---

## Directory Structure

```
your-project/
├── .claude/
│   └── commands/
│       └── agent-os/
│           ├── plan-product.md        # Slash command: /agent-os:plan-product
│           ├── shape-spec.md          # Slash command: /agent-os:shape-spec
│           ├── inject-standards.md    # Slash command: /agent-os:inject-standards
│           ├── discover-standards.md  # Slash command: /agent-os:discover-standards
│           └── index-standards.md     # Slash command: /agent-os:index-standards
│
├── agent-os/
│   ├── product/                       # Product definition (created by /plan-product)
│   │   ├── mission.md
│   │   ├── roadmap.md
│   │   └── tech-stack.md
│   │
│   ├── standards/                     # Coding standards (created by /discover-standards)
│   │   ├── index.yml                  # Standards index for quick matching
│   │   ├── api/
│   │   │   ├── middleware-chain.md
│   │   │   └── sse-streaming.md
│   │   ├── database/
│   │   │   ├── scoped-queries.md
│   │   │   └── seed-scripts.md
│   │   └── schemas/
│   │       └── zod-single-source.md
│   │
│   ├── specs/                         # Implementation specs (created by /shape-spec)
│   │   ├── 2026-03-25-phase-1-project-foundation/
│   │   │   ├── plan.md
│   │   │   ├── shape.md
│   │   │   ├── standards.md
│   │   │   └── references.md
│   │   └── 2026-03-26-feature-name/
│   │       ├── plan.md
│   │       ├── shape.md
│   │       ├── standards.md
│   │       ├── references.md
│   │       └── visuals/               # Optional mockups/screenshots
│   │
│   └── initialization/                # Optional: phase specs + deep context for phased projects
│       ├── Implementation-Prompts.md
│       ├── context/
│       │   ├── General-Context.md
│       │   ├── Product-Vision-Deep-Dive.md
│       │   └── ...
│       └── phases/
│           ├── Phase-1-Project-Foundation.md
│           └── ...
```

---

## The 5 Slash Commands

### 1. `/agent-os:plan-product` — Define Your Product

**When to use:** When starting a new project or updating product vision.

**What it does:**
1. Checks for existing `agent-os/product/` files
2. Asks about the problem you're solving, target users, unique solution
3. Gathers MVP features and post-launch roadmap
4. Establishes tech stack
5. Creates 3 files: `mission.md`, `roadmap.md`, `tech-stack.md`

**Output:** `agent-os/product/{mission,roadmap,tech-stack}.md`

---

### 2. `/agent-os:shape-spec` — Plan Before You Build

**When to use:** Before starting any significant work (new feature, phase, subsystem).

**Prerequisites:** Must be in plan mode.

**What it does:**
1. Clarifies scope — "What are we building?"
2. Gathers visuals (mockups, screenshots, or none)
3. Identifies reference implementations in the codebase
4. Checks product context from `agent-os/product/`
5. Surfaces relevant standards from `agent-os/standards/index.yml`
6. Generates a timestamped spec folder: `YYYY-MM-DD-feature-slug/`
7. Structures the plan — Task 1 is always "Save Spec Documentation"
8. Fills in remaining implementation tasks
9. Presents full plan for approval

**Output:** `agent-os/specs/{YYYY-MM-DD-feature-slug}/` containing:
- `plan.md` — Full implementation plan
- `shape.md` — Scope, decisions, context
- `standards.md` — Relevant standards (full content)
- `references.md` — Code references studied
- `visuals/` — Mockups/screenshots (if any)

**Example `shape.md`:**
```markdown
# Feature Name — Shaping Notes

## Scope
What we're building and why.

## Decisions
- Key design decisions made during shaping
- Constraints or requirements noted

## Context
- **Visuals:** None / list of provided visuals
- **References:** Code references studied
- **Product alignment:** How this aligns with mission/roadmap

## Standards Applied
- api/response-format — why it applies
- database/scoped-queries — why it applies
```

---

### 3. `/agent-os:inject-standards` — Bring Standards Into Context

**When to use:** At the start of implementation tasks, or when building reusable procedures.

**Two modes:**

**Auto-Suggest** (no arguments):
```
/agent-os:inject-standards
```
Analyzes current context, reads `index.yml`, suggests relevant standards.

**Explicit** (with arguments):
```
/agent-os:inject-standards api                           # All standards in api/
/agent-os:inject-standards api/response-format           # Single file
/agent-os:inject-standards api/response-format database/scoped-queries  # Multiple
```

**Three output scenarios:**
| Scenario | Detection | Output |
|----------|-----------|--------|
| **Conversation** | Default — implementing code | Reads full standard content into chat |
| **Skill** | Building a `.claude/skills/` file | File references or copied content |
| **Plan** | In plan mode / running `/shape-spec` | File references or copied content |

---

### 4. `/agent-os:discover-standards` — Extract Tribal Knowledge

**When to use:** After completing implementation phases, when patterns have emerged.

**What it does:**
1. Analyzes the codebase, identifies 3-5 focus areas
2. User picks an area
3. Reads 5-10 representative files, finds patterns that are:
   - **Unusual/unconventional** — not standard framework patterns
   - **Opinionated** — specific choices that could have gone differently
   - **Tribal** — things a new dev wouldn't know without being told
   - **Consistent** — repeated across multiple files
4. Presents findings, user selects which to document
5. For each selected standard — **one at a time**:
   - Asks 1-2 "why" questions
   - Drafts the standard
   - Confirms with user
   - Creates the file
6. Updates `agent-os/standards/index.yml`
7. Offers to continue with another area

**Output:** New files in `agent-os/standards/[folder]/` + updated `index.yml`

**Standard writing rules:**
- Lead with the rule — state what to do first, explain why second
- Use code examples — show, don't tell
- Skip the obvious — don't document what code already makes clear
- One standard per concept
- Bullet points over paragraphs
- Keep concise (standards are injected into AI context)

**Example standard:**
```markdown
# SSE Streaming Contract

## Event Format

event: chunk
data: {"text": "partial response text"}

event: done
data: {"message_ids": ["msg_1711234567_a3f2k1"]}

event: error
data: {"error": "Human-readable error message"}

## Server-Side Rules

1. Call `initSSE(res)` to set headers before streaming
2. Accumulate full response text during streaming
3. Persist the AI message ONCE after streaming completes
4. Send `done` event with persisted message IDs
5. Call `closeSSE(res)` to end the stream
```

---

### 5. `/agent-os:index-standards` — Rebuild the Index

**When to use:** After manually creating/deleting standards, or if suggestions get out of sync.

**What it does:**
1. Scans all `.md` files in `agent-os/standards/`
2. Loads existing `index.yml`
3. For new files: reads content, proposes a description, gets user approval
4. Removes stale entries for deleted files
5. Writes updated `index.yml` (alphabetized)

**Output:** Updated `agent-os/standards/index.yml`

**Index format:**
```yaml
api:
  middleware-chain:
    description: Global and route-specific middleware ordering, auth fallback, validation pattern
  sse-streaming:
    description: SSE event format (chunk/done/error), accumulate-then-persist pattern

database:
  scoped-queries:
    description: Org-scoped query helpers for multi-tenant data isolation
```

---

## End-to-End Workflow

### First Time: Initialize a New Project

```
1. Run /agent-os:plan-product
   → Creates agent-os/product/{mission,roadmap,tech-stack}.md
```

### For Each Feature / Phase

```
1. Enter plan mode
2. Run /agent-os:shape-spec
   → Creates agent-os/specs/YYYY-MM-DD-feature-slug/ with plan, shape, standards, references
3. Execute the plan tasks
   - First task of every plan: save spec documentation
   - At start of implementation: run /agent-os:inject-standards for relevant standards
4. After implementation: run /agent-os:discover-standards
   → Creates new standards in agent-os/standards/
5. Run /agent-os:index-standards (if needed)
   → Updates agent-os/standards/index.yml
```

### The Feedback Loop

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   plan-product ──→ shape-spec ──→ inject-standards  │
│                                       │             │
│                                       ▼             │
│                                   IMPLEMENT         │
│                                       │             │
│                                       ▼             │
│   index-standards ◄── discover-standards            │
│        │                                            │
│        └──────────→ (next feature) ─────────────────│
│                                                     │
└─────────────────────────────────────────────────────┘

Each phase improves the standards library for the next phase.
```

---

## Setting Up Agent OS in a New Project

### Step 1: Create the directory structure

```bash
mkdir -p .claude/commands/agent-os
mkdir -p agent-os/product
mkdir -p agent-os/standards
mkdir -p agent-os/specs
```

### Step 2: Copy the 5 command files

Copy these files into `.claude/commands/agent-os/`:
- `plan-product.md`
- `shape-spec.md`
- `inject-standards.md`
- `discover-standards.md`
- `index-standards.md`

The full content of each command is provided below.

### Step 3: Run the workflow

```
1. /agent-os:plan-product     — define your product
2. Enter plan mode
3. /agent-os:shape-spec        — shape your first feature
4. Execute the plan
5. /agent-os:discover-standards — capture patterns
```

---

## Command File Contents

Below are the complete command files to copy into `.claude/commands/agent-os/`.

---

### `plan-product.md`

```markdown
# Plan Product

Establish foundational product documentation through an interactive conversation. Creates mission, roadmap, and tech stack files in `agent-os/product/`.

## Important Guidelines

- **Always use AskUserQuestion tool** when asking the user anything
- **Keep it lightweight** — gather enough to create useful docs without over-documenting
- **One question at a time** — don't overwhelm with multiple questions

## Process

### Step 1: Check for Existing Product Docs

Check if `agent-os/product/` exists and contains any of these files:
- `mission.md`
- `roadmap.md`
- `tech-stack.md`

**If any files exist**, use AskUserQuestion:

I found existing product documentation:
- mission.md: [exists/missing]
- roadmap.md: [exists/missing]
- tech-stack.md: [exists/missing]

Would you like to:
1. Start fresh (replace all)
2. Update specific files
3. Cancel

If option 2, ask which files to update and only gather info for those.
If option 3, stop here.

**If no files exist**, proceed to Step 2.

### Step 2: Gather Product Vision (for mission.md)

Use AskUserQuestion — ask about:
1. What problem does this product solve?
2. Who is this product for?
3. What makes your solution unique?

Ask one question at a time, wait for response before next.

### Step 3: Gather Roadmap (for roadmap.md)

Use AskUserQuestion — ask about:
1. Must-have features for launch (MVP)?
2. Features planned for after launch?

### Step 4: Establish Tech Stack (for tech-stack.md)

Check if `agent-os/standards/global/tech-stack.md` exists first.
If it exists, ask if this project uses the same stack.
Otherwise, ask about: Frontend, Backend, Database, Other.

### Step 5: Generate Files

Create `agent-os/product/` with:
- `mission.md` — Problem, Target Users, Solution
- `roadmap.md` — Phase 1 (MVP), Phase 2 (Post-Launch)
- `tech-stack.md` — Frontend, Backend, Database, Other

### Step 6: Confirm Completion

Report created files. Remind user they can edit directly or re-run the command.

## Tips

- Brief answers are fine — docs can be expanded later
- If user wants to skip a section, use placeholder "To be defined"
- `/shape-spec` reads these files when planning features
```

---

### `shape-spec.md`

```markdown
# Shape Spec

Gather context and structure planning for significant work. **Run this command while in plan mode.**

## Important Guidelines

- **Always use AskUserQuestion tool** when asking the user anything
- **Offer suggestions** — Present options the user can confirm, adjust, or correct
- **Keep it lightweight** — This is shaping, not exhaustive documentation

## Prerequisites

This command **must be run in plan mode**.

**Before proceeding, check if you are currently in plan mode.**

If NOT in plan mode, **stop immediately** and tell the user:
"Shape-spec must be run in plan mode. Please enter plan mode first, then run /shape-spec again."

## Process

### Step 1: Clarify What We're Building

Use AskUserQuestion to understand scope. Ask 1-2 clarifying follow-ups if needed.

### Step 2: Gather Visuals

Ask for mockups, wireframes, screenshots, or examples. Note for inclusion in spec folder.

### Step 3: Identify Reference Implementations

Ask if there's similar code in the codebase to reference. If provided, read and analyze.

### Step 4: Check Product Context

If `agent-os/product/` exists, read key files and ask about alignment with product goals.

### Step 5: Surface Relevant Standards

Read `agent-os/standards/index.yml` and suggest relevant standards. Ask user to confirm.
Read confirmed standards files to include in plan context.

### Step 6: Generate Spec Folder Name

Format: `YYYY-MM-DD-{feature-slug}/`
Feature slug: lowercase, hyphens, max 40 chars.
Create `agent-os/specs/` if it doesn't exist.

### Step 7: Structure the Plan

**Task 1 is always "Save Spec Documentation"** — creates the spec folder with:
- plan.md — The full plan
- shape.md — Shaping decisions and context
- standards.md — Relevant standards content
- references.md — Code references studied
- visuals/ — Mockups/screenshots (if any)

Remaining tasks are implementation tasks.

### Step 8: Complete the Plan

Fill in implementation tasks based on scope, references, and standards.

### Step 9: Ready for Execution

Present complete plan for approval.

## shape.md Content

Captures: Scope, Decisions, Context (visuals, references, product alignment), Standards Applied.

## standards.md Content

Full content of each relevant standard, separated by headers.

## references.md Content

Location, relevance, and key patterns for each reference implementation.

## Tips

- Keep shaping fast — don't over-document
- Visuals are optional
- Standards guide, not dictate
- Specs are discoverable months later
```

---

### `inject-standards.md`

```markdown
# Inject Standards

Inject relevant standards into the current context, formatted appropriately for the situation.

## Usage Modes

### Auto-Suggest Mode (no arguments)
Analyzes context and suggests relevant standards.

### Explicit Mode (with arguments)
/inject-standards api                           # All standards in api/
/inject-standards api/response-format           # Single file
/inject-standards api/response-format api/auth  # Multiple files
/inject-standards root                          # All standards at root level

**Note:** `root` refers to `.md` files directly in `agent-os/standards/` (not in a subfolder).

## Process

### Step 1: Detect Context Scenario

Three scenarios:
1. **Conversation** — Regular chat, implementing code
2. **Creating a Skill** — Building a `.claude/skills/` file
3. **Shaping/Planning** — In plan mode, building a spec

Detection: plan mode → Shaping/Planning. Mentions skills → Creating a Skill. Otherwise → ask to confirm.

### Step 2: Read the Index (Auto-Suggest Mode)

Read `agent-os/standards/index.yml`. If missing: suggest running /discover-standards or /index-standards first.

### Step 3: Analyze Work Context

Understand what the user is working on from the conversation.

### Step 4: Match and Suggest

Present 2-5 relevant standards. Let user confirm, adjust, or skip.

### Step 5: Inject Based on Scenario

**Conversation:** Read full standard content into chat with key points summary.
**Skill:** Ask references vs copy content. Output accordingly.
**Plan:** Ask references vs copy content. Output accordingly.

### Step 6: Surface Related Skills (Conversation only)

Check `.claude/skills/` for related skills. Don't invoke — just surface.

## Explicit Mode

Skip suggestion step. Still detect scenario. Parse arguments as folder or folder/file paths. Validate existence. Inject based on scenario.

## Tips

- Run early — inject at start of task
- Be specific — use explicit mode when you know which standards
- Keep standards concise — they consume tokens
```

---

### `discover-standards.md`

```markdown
# Discover Standards

Extract tribal knowledge from your codebase into concise, documented standards.

## Important Guidelines

- **Always use AskUserQuestion tool** when asking the user anything
- **Write concise standards** — Minimal words. Scannable by AI agents without bloating context.
- **Offer suggestions** — Present options the user can confirm, choose between, or correct.

## Process

### Step 1: Determine Focus Area

If user specified an area, skip to Step 2.

Otherwise:
1. Analyze codebase structure
2. Identify 3-5 major areas (frontend, backend, cross-cutting)
3. Ask user which area to focus on

### Step 2: Analyze & Present Findings

1. Read 5-10 representative files in the area
2. Look for patterns that are: unusual, opinionated, tribal, consistent
3. Present findings as numbered list
4. Let user select which to document

### Step 3: Ask Why, Then Draft Each Standard

**For each selected standard, complete this full loop before moving to the next:**

1. Ask 1-2 clarifying "why" questions
2. Wait for response
3. Draft the standard incorporating their answer
4. Confirm with user
5. Create the file if approved

**Do NOT batch all questions upfront.** One standard at a time.

### Step 4: Create the Standard File

1. Determine folder: `api/`, `database/`, `schemas/`, `ai/`, `testing/`, etc.
2. Check for existing related standard — append if so
3. Draft content, confirm with user
4. Create in `agent-os/standards/[folder]/`

### Step 5: Update the Index

For each new file: propose description, get approval. Update `agent-os/standards/index.yml` (alphabetized).

### Step 6: Offer to Continue

Ask if user wants to discover in another area or stop.

## Output Location

Standards: `agent-os/standards/[folder]/[standard].md`
Index: `agent-os/standards/index.yml`

## Writing Concise Standards

- Lead with the rule — what to do first, why second
- Use code examples — show, don't tell
- Skip the obvious
- One standard per concept
- Bullet points over paragraphs
```

---

### `index-standards.md`

```markdown
# Index Standards

Rebuild and maintain the standards index file (`index.yml`).

## Purpose

Enables `/inject-standards` to suggest relevant standards without reading all files.

## Process

### Step 1: Scan for Standards Files

List all `.md` files in `agent-os/standards/` and subfolders.
`root` = files directly in `agent-os/standards/` (not in subfolders).

### Step 2: Load Existing Index

Read `agent-os/standards/index.yml` if it exists.

### Step 3: Identify Changes

- New files — without index entries
- Deleted files — index entries for removed files
- Existing — keep as-is

### Step 4: Handle New Files

For each new file: read content, propose description via AskUserQuestion, get approval.

### Step 5: Handle Deleted Files

Remove stale entries automatically. Report what was removed.

### Step 6: Write Updated Index

Format:
```yaml
folder-name:
  file-name:
    description: Brief description here
```

Rules: alphabetize folders, alphabetize files within folders, no `.md` extension, one-line descriptions.

### Step 7: Report Results

Summarize: entries added, removed, unchanged. Total count.

## When to Run

- After manually creating/deleting standards
- If `/inject-standards` suggestions seem off
- `/discover-standards` runs this automatically as a final step
```

---

## Optional: Initialization Directory

For phased projects (like building a full product from scratch), you can add an `agent-os/initialization/` directory with:

- **`Implementation-Prompts.md`** — Entry-point prompts for each phase
- **`context/`** — Deep context documents (vision, data schemas, UX references, roadmaps)
- **`phases/`** — Detailed phase specifications

Each phase prompt tells Claude to:
1. Read all context files + the phase spec
2. Skim future phases for dependencies
3. Run `/agent-os:shape-spec` to create the plan
4. First task: run `/agent-os:inject-standards`
5. Execute implementation
6. Final task: run `/agent-os:discover-standards`

This is optional — Agent OS works perfectly for individual features without phased planning.

---

## Key Principles

1. **Shape before you build** — Specs prevent wasted work
2. **Standards are tribal knowledge** — Extracted from code, not imposed top-down
3. **Standards are concise** — They get injected into AI context; every token counts
4. **The loop compounds** — Each phase improves the standards library for the next
5. **Specs are discoverable** — Months later, anyone can find a spec and understand what was built and why
6. **One standard at a time** — During discovery, complete the full ask → draft → confirm → create cycle for each
