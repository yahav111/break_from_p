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
