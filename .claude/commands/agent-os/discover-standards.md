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
