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
