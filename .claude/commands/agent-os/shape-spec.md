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
