# Getting Started with Bert

This guide walks you through installing and using bert for the first time.

## Prerequisites

- Agent-os installed and configured
- Claude Code, Cursor, or compatible AI code engine
- Basic familiarity with slash commands

## Installation

Bert is included as part of the agent-os-addon-bert package. If you haven't installed it yet:

```bash
# Installation instructions will be added here
```

## Your First Bert Session

### Step 1: Initialize Bert Session

Start every conversation where you want to use bert by initializing the session:

```
/agent-os:bert:start
```

**What this does:**
- Activates bert context for the current conversation
- Makes Claude aware of bert overlays and includes
- Enables natural language invocation of bert features

**Output:**
```
Bert addon is now ACTIVE for this session.

You can now use natural language to invoke bert enhancements, such as:
- "run plan-product with bert overlay"
- "include bert living docs when updating this file"
- "use bert task-author to analyze the roadmap"
```

**Note:** You only need to do this ONCE per conversation. The context persists throughout the session.

---

### Step 2: Create Your First Parent Task

Bert can analyze files or abstract concepts to generate detailed task breakdowns.

#### Option A: Analyze an Existing File

```
/agent-os:bert:task-author agent-os/product/roadmap.md
```

**What happens:**
1. Bert reads the specified file
2. Analyzes it for areas needing improvement
3. Creates a parent task file with specific, actionable improvements
4. Provides rationale for WHY each improvement matters

**Output:**
```
Created task file: agent-os/bert/tasks/task-05-enhance-roadmap-detail.md

Identified 10 improvement areas:
- Add acceptance criteria to in-progress features
- Define success metrics for Phase 1
- Add timeline estimates
- (and 7 more...)

Next steps:
- Review the parent task file
- Use /agent-os:bert:task-create -p 5 to create subtask files
```

#### Option B: Abstract Request

```
/agent-os:bert:task-author improve error handling in authentication
```

**What happens:**
1. Bert searches your codebase for relevant files
2. Presents findings for your confirmation
3. Analyzes identified files
4. Creates parent task with specific improvements

---

### Step 3: Create Subtasks

Once you have a parent task, create subtask files:

```
/agent-os:bert:task-create -p 5
```

**What happens:**
1. Reads parent task file `task-05-*.md`
2. Finds all unchecked tasks in the `## Tasks` section
3. Creates individual subtask files for each one
4. Updates parent file with numbered checkboxes

**Generated files:**
```
task-05.1-add-acceptance-criteria.md
task-05.2-define-success-metrics.md
task-05.3-add-timeline-estimates.md
...
```

**Updated parent:**
```markdown
## Tasks

- [ ] 5.01 Add acceptance criteria to in-progress features
- [ ] 5.02 Define success metrics for Phase 1
- [ ] 5.03 Add timeline estimates
```

---

### Step 4: Create Nested Subtasks

Need to break down a subtask further? Bert supports arbitrary nesting depth:

```
/agent-os:bert:task-create -p 5.1
```

**Generated files:**
```
task-05.1.1-define-workflow-state-criteria.md
task-05.1.2-define-taskmap-criteria.md
task-05.1.3-define-includes-criteria.md
```

**You can nest as deep as needed:**
```
/agent-os:bert:task-create -p 5.1.1
/agent-os:bert:task-create -p 5.1.1.1
/agent-os:bert:task-create -p 5.1.1.1.1
```

**Smart Padding:** Bert automatically applies zero-padding to ensure tasks sort correctly:
- `5.01, 5.02, ..., 5.09, 5.10` (pads to 2 digits)
- `5.01.1, 5.01.2, ..., 5.01.10` (pads parent level only)

---

## Using Living Documents

### Generate Documents with Status Tracking

```
run plan-product with bert overlay
```

**What happens:**
1. Executes standard plan-product command
2. Applies bert overlay to add status comments
3. Generates files with tracking at h3 heading level

**Generated file example:**
```markdown
### Completed Features
<!-- bert:status=draft, updated=2025-10-14 -->

- User authentication system
- Basic API endpoints
```

**The comments are invisible in rendered markdown!**

---

### Update Living Document Sections

When modifying documents with bert status comments:

```
Update the "Completed Features" section.
Include bert living docs to track changes.
```

**What happens:**
1. Bert reads living-docs include file
2. Updates section content
3. Updates status comment
4. Changes status appropriately (draft → in-progress → reviewed)
5. Updates timestamp to current date

**Before:**
```markdown
### Completed Features
<!-- bert:status=draft, updated=2025-10-14 -->

- Basic features
```

**After:**
```markdown
### Completed Features
<!-- bert:status=reviewed, updated=2025-10-15 -->

- User authentication (JWT-based, OAuth2)
- Basic API endpoints (CRUD for users, tasks)
- Rate limiting (100 req/min per user)
```

---

## Natural Language Invocation

Bert responds to natural language patterns:

### Overlay Patterns
- "with bert overlay"
- "include bert"
- "apply bert to"
- "use bert when"

### Examples
```
run plan-product with bert overlay
use plan-product and include bert
apply bert to plan-product
```

### Include Patterns
- "include bert living docs"
- "use bert to track changes"
- "apply bert overlay while modifying"

---

## Task File Structure

### Parent Task Template
```markdown
---
status: pending
created: 2025-10-14
---

# Task 05: Enhance Roadmap Detail

## Description

[Context about what was analyzed and why improvements are needed]

## Tasks

- [ ] 5.01 Specific improvement task
- [ ] 5.02 Another improvement task
- [ ] 5.03 And another one

## Rationale

[WHY these improvements matter - connect to goals, quality, outcomes]
```

### Subtask Template
```markdown
---
status: pending
created: 2025-10-14
parent: 5
---

# Task 5.1: Add Acceptance Criteria

## Description

[Specific description of this subtask]

## Tasks

- [ ] 5.01.1 Sub-subtask (if needed)
- [ ] 5.01.2 Another sub-subtask

## Rationale

[Why this subtask matters]
```

---

## Configuration

Bert uses `agent-os/bert/config.yml` for configuration.

### Key Sections

**Task Frontmatter:**
```yaml
task_frontmatter:
  required:
    - status      # pending | in-progress | completed | blocked
    - created     # YYYY-MM-DD
  optional:
    - updated     # YYYY-MM-DD
    - parent      # Parent task number
```

**Living Document Status:**
```yaml
living_docs:
  statuses:
    - draft
    - in-progress
    - reviewed
    - needs-update
  comment_format: "<!-- bert:status={status}, updated={date} -->"
  tracking_level: h3
```

---

## Workflow Example

Here's a complete workflow from start to finish:

```
1. /agent-os:bert:start
   → Initialize session

2. /agent-os:bert:task-author agent-os/product/roadmap.md
   → Creates task-05-enhance-roadmap.md with 10 improvements

3. Review task-05-enhance-roadmap.md
   → Check that improvements make sense

4. /agent-os:bert:task-create -p 5
   → Creates task-05.1.md through task-05.10.md

5. /agent-os:bert:task-create -p 5.1
   → Creates task-05.1.1.md, task-05.1.2.md, etc.

6. run plan-product with bert overlay
   → Generates roadmap.md with status comments

7. Update roadmap sections, include bert living docs
   → Updates status comments as you make changes
```

---

## Tips for Success

### 1. Initialize Once Per Session
You don't need to run `/agent-os:bert:start` multiple times. Once per conversation is enough.

### 2. Use Descriptive Task Descriptions
The better your task descriptions, the better the generated subtask filenames.

### 3. Review Before Creating Subtasks
Always review the parent task file before running task-create to ensure tasks are what you want.

### 4. Leverage Natural Language
Don't memorize exact syntax - use natural language like "with bert overlay" or "include bert."

### 5. Check File Sorting
Tasks are numbered to sort correctly in file browsers. Verify they appear in the right order.

---

## Next Steps

- Read the [Command Reference](command-reference.md) for detailed command documentation
- Check out [Examples](examples.md) for more use cases
- See [Troubleshooting](troubleshooting.md) if you run into issues
- Learn about [Architecture](architecture.md) to understand how bert works

## Questions?

Common questions are answered in the [Troubleshooting Guide](troubleshooting.md).
