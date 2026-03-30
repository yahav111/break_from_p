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
