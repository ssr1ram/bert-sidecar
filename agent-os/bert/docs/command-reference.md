# Bert Command Reference

Complete documentation for all bert commands.

---

## `/agent-os:bert:start`

**Purpose:** Initialize bert addon session context

**Category:** Session Management

**Syntax:**
```
/agent-os:bert:start
```

**Arguments:** None

**Description:**

Establishes session-level awareness that the bert overlay system is active. This command outputs comprehensive instructions that establish bert context in Claude's conversation memory.

**Behavior:**
- Outputs context-setting instructions for the current conversation
- Makes Claude aware of overlay and include directories
- Enables natural language invocation patterns
- Confirms bert is active for the session
- No technical persistence mechanism - relies on conversation context

**Output:**
```
Bert addon is now ACTIVE for this session.

You can now use natural language to invoke bert enhancements, such as:
- "run plan-product with bert overlay"
- "include bert living docs when updating this file"
...
```

**Usage Notes:**
- Run ONCE at the beginning of a conversation
- Context persists throughout the session
- Does not interfere with standard agent-os commands
- No need to re-run if session continues

**Examples:**
```
/agent-os:bert:start
```

---

## `/agent-os:bert:task-author`

**Purpose:** Generate parent task identifying improvement areas

**Category:** Task Creation

**Syntax:**
```
/agent-os:bert:task-author <file_path_or_abstract_request>
```

**Arguments:**
- `file_path_or_abstract_request` - Either a file path to analyze OR an abstract improvement request

**Description:**

Generates a parent task file that identifies improvement areas for a file or concept. Accepts broad user input and intelligently determines whether it's a file path or abstract request.

**Input Formats:**

1. **File Path:**
   ```
   /agent-os:bert:task-author agent-os/product/roadmap.md
   ```

2. **Abstract Request:**
   ```
   /agent-os:bert:task-author improve error handling in authentication
   ```

3. **Broad Directive:**
   ```
   /agent-os:bert:task-author make the roadmap more accurate
   ```

**Workflow:**

### For File Path Input:
1. Read the specified file
2. Analyze content for improvements:
   - Sections lacking detail or clarity
   - Outdated information
   - Missing sections or gaps
   - Improvement opportunities
3. Generate specific, actionable improvement suggestions

### For Abstract Request Input:
1. Search codebase for relevant files
2. Present findings to user for confirmation
3. Allow refinement if needed
4. Analyze identified files after confirmation
5. Generate improvement suggestions

**Task Number Determination:**
1. Scans `agent-os/bert/tasks/` directory
2. Finds highest existing task number
3. Increments by 1 for new parent task
4. Starts at 01 if no tasks exist

**Generated File:**

File named: `task-{nn}-{slug}.md`

Structure:
```markdown
---
status: pending
created: YYYY-MM-DD
---

# Task {nn}: {Title}

## Description

[Analysis context and what was analyzed]

## Tasks

- [ ] {nn}.01 Specific improvement task
- [ ] {nn}.02 Another improvement task
- [ ] {nn}.03 Yet another task

## Rationale

[WHY these improvements matter - goals, quality, outcomes]
```

**Frontmatter Requirements:**
- `status`: Set to "pending" for new parent tasks
- `created`: Current date in YYYY-MM-DD format
- Follows structure defined in `agent-os/bert/config.yml`

**Checkbox Numbering:**
- Format: `{nn}.{sub}` where `{nn}` is parent task number
- Smart padding applied (e.g., `4.01`, `4.02`, ..., `4.10`)

**Output:**
```
Created task file: agent-os/bert/tasks/task-05-enhance-roadmap-detail.md

Identified 10 improvement areas

Next steps:
- Review the parent task file
- Use /agent-os:bert:task-create -p 5 to create subtask files
```

**Important Notes:**
- Does NOT auto-generate subtask files (only parent)
- User decides which improvement tasks to pursue
- Focus on specific, actionable improvements
- Provides rationale for WHY improvements matter
- Clear error messages for missing/unreadable files

**Examples:**

```bash
# Analyze a specific file
/agent-os:bert:task-author agent-os/product/roadmap.md

# Abstract request
/agent-os:bert:task-author improve error handling in authentication

# Broad directive
/agent-os:bert:task-author make the tech stack documentation more detailed
```

---

## `/agent-os:bert:task-create`

**Purpose:** Create task files with enhanced nested numbering support

**Category:** Task Creation

**Syntax:**
```
/agent-os:bert:task-create [description]              # Top-level task
/agent-os:bert:task-create -p <parent_num> [description]  # Subtask(s)
```

**Arguments:**
- `description` (optional) - Task description for top-level tasks
- `-p <parent_num>` - Parent task number for creating subtasks

**Parent Number Format:**

Supports arbitrary nesting depth:
- `-p 4` - Create subtasks under `task-04-*.md`
- `-p 4.1` - Create subtasks under `task-04.1-*.md`
- `-p 4.1.2` - Create subtasks under `task-04.1.2-*.md`
- `-p 4.1.2.3` - And so on, unlimited depth

**Description:**

Creates new task files in `agent-os/bert/tasks/` directory with support for deeply nested task hierarchies.

---

### Top-Level Tasks (without `-p` flag)

**Workflow:**
1. Get task description from user (or use provided description)
2. Determine next available task number by scanning directory
3. Generate kebab-case slug from description
4. Create task file with frontmatter and content
5. Confirm creation to user

**Example:**
```
/agent-os:bert:task-create design authentication system
```

**Creates:**
```
task-04-design-authentication-system.md
```

---

### Subtasks (with `-p` flag)

**Workflow:**

1. **Parse Parent Task Number**
   - Extract from `-p` argument (e.g., `3`, `4.1`, `4.1.2`)
   - Split on dots to get number hierarchy
   - Validate format

2. **Find Parent Task File**
   - For `-p 4`: find `task-04-*.md`
   - For `-p 4.1`: find `task-04.1-*.md`
   - For `-p 4.1.2`: find `task-04.1.2-*.md`
   - Pattern: `task-{parent_number}-*.md` (dots preserved)
   - Error if parent not found

3. **Extract Tasks from Parent**
   - Parse `## Tasks` section
   - Find all unchecked tasks `- [ ]`

4. **Determine Subtask Numbers**
   - Check existing subtasks at target level
   - Find next available number

5. **Calculate Smart Padding**
   - Scan ALL existing tasks at nesting level
   - Find maximum task number
   - Calculate padding: `max_digits = len(str(max_num))`
   - Examples:
     - Max 9: pad to 2 digits (01, 02, ..., 09)
     - Max 12: pad to 2 digits (01, 02, ..., 12)
     - Max 100: pad to 3 digits (001, 002, ..., 100)

6. **Create Subtask Files**
   - Generate kebab-case slug from task description
   - Create file with dotted naming:
     - Parent `4` → `task-04.1-{slug}.md`
     - Parent `4.1` → `task-04.1.1-{slug}.md`
     - Parent `4.1.2` → `task-04.1.2.1-{slug}.md`
   - Use dots (.) as separators, NOT dashes
   - Add frontmatter with `parent: {parent_number}` field
   - Add empty `## Tasks` section for future nesting

7. **Update Parent Task File**
   - Apply smart padding to checkbox numbers
   - Format: `{major}.{padded_child}.{unpadded_grandchild}`
   - Only pad immediate child level
   - Preserve checkbox state (checked/unchecked)

**Smart Padding Examples:**

```markdown
# Parent 4 with max 9 children:
- [ ] 4.01 First task
- [ ] 4.02 Second task
- [ ] 4.09 Ninth task

# Parent 4 with max 12 children:
- [ ] 4.01 First task
- [ ] 4.02 Second task
- [ ] 4.12 Twelfth task

# Parent 4.1 with max 3 children:
- [ ] 4.01.1 First subtask
- [ ] 4.01.2 Second subtask
- [ ] 4.01.3 Third subtask

# Parent 4.1 with max 10 children:
- [ ] 4.01.01 First subtask
- [ ] 4.01.02 Second subtask
- [ ] 4.01.10 Tenth subtask
```

**File Naming:**
- Use dots as separators: `task-04.1.2-slug.md`
- NOT dashes: ~~`task-04-1-2-slug.md`~~
- Supports arbitrary depth

**Important Notes:**
- File naming uses dots consistently
- Smart padding applied to checkbox numbers only
- Padding handles 2-digit, 3-digit, and higher task counts
- Parent field correctly references parent task number
- Empty `## Tasks` section added for potential sub-subtasks

**Examples:**

```bash
# Create top-level task
/agent-os:bert:task-create design authentication system

# Create subtasks from parent 3
/agent-os:bert:task-create -p 3

# Create nested subtasks from parent 4.1
/agent-os:bert:task-create -p 4.1

# Create deeply nested from parent 4.1.2
/agent-os:bert:task-create -p 4.1.2

# Create very deeply nested from parent 4.1.2.3
/agent-os:bert:task-create -p 4.1.2.3
```

**Output:**
```
Created subtask files:
- task-04.1-review-tokens.md
- task-04.2-implement-oauth.md
- task-04.3-add-rate-limiting.md

Updated parent file: task-04-improve-authentication.md
```

---

## Natural Language Patterns

Bert responds to natural language invocation patterns after session initialization.

### Overlay Patterns

**Syntax:**
```
<command> with bert overlay
<command> and include bert
apply bert to <command>
use bert when <command>
```

**Examples:**
```
run plan-product with bert overlay
use plan-product and include bert
apply bert to plan-product
```

**Behavior:**
1. Identifies base command being invoked
2. Checks for overlay file in `agent-os/bert/overlays/{command}.md`
3. Reads both base command AND overlay file
4. Executes base workflow PLUS overlay instructions
5. Falls back to base command if overlay doesn't exist

### Include Patterns

**Syntax:**
```
include bert living docs when <action>
use bert to track changes
apply bert overlay while <action>
```

**Examples:**
```
include bert living docs when updating this file
use bert to track changes in roadmap
apply bert overlay while modifying sections
```

**Behavior:**
1. Identifies include being requested
2. Checks for include file in `agent-os/bert/includes/{name}.md`
3. Reads include file and applies instructions
4. Proceeds without it if include doesn't exist

---

## Configuration File

**Location:** `agent-os/bert/config.yml`

**Purpose:** Centralize frontmatter field definitions and living document settings

**Structure:**

```yaml
# Claude Code standard frontmatter (command-specific, optional)
claude_frontmatter:
  allowed_tools: []
  description: ""
  model: ""
  argument_hint: ""
  disable_model_invocation: false

# Bert task frontmatter (required for all tasks)
task_frontmatter:
  required:
    - status      # pending | in-progress | completed | blocked
    - created     # YYYY-MM-DD format
  optional:
    - updated     # YYYY-MM-DD format
    - parent      # Parent task number if subtask
    - related     # Array of related task numbers

# Living document status tracking
living_docs:
  statuses:
    - draft
    - in-progress
    - reviewed
    - needs-update
  comment_format: "<!-- bert:status={status}, updated={date} -->"
  tracking_level: h3
```

**Usage:**
- Referenced by task-create and task-author for frontmatter generation
- Referenced by living-docs include for status values
- Single source of truth for bert configuration
- Easy to update as requirements evolve

---

## Directory Structure

```
.claude/
└── commands/
    └── agent-os/
        └── bert/
            ├── start.md              # Session initialization
            ├── task-author.md        # Task authoring
            └── task-create.md        # Enhanced task creation

agent-os/
└── bert/
    ├── config.yml                    # Configuration
    ├── overlays/
    │   └── plan-product.md          # Overlay for plan-product
    ├── includes/
    │   └── living-docs.md           # Living doc instructions
    └── tasks/
        ├── task-01-xxx.md           # Top-level tasks
        ├── task-02-xxx.md
        ├── task-02.1-xxx.md         # Subtasks
        └── task-02.1.1-xxx.md       # Nested subtasks
```

---

## Status Values

### Task Status
- `pending` - Not yet started
- `in-progress` - Currently being worked on
- `completed` - Finished successfully
- `blocked` - Cannot proceed (waiting on something)

### Living Document Status
- `draft` - Initial creation, not reviewed
- `in-progress` - Currently being updated
- `reviewed` - Reviewed and verified accurate
- `needs-update` - Identified as requiring revision

### Status Transitions

```
draft → in-progress (when first edit is made)
draft → reviewed (if comprehensive review without edits)
in-progress → reviewed (when edits complete and verified)
reviewed → needs-update (if identified as outdated)
needs-update → in-progress (when starting updates)
```

---

## See Also

- [Getting Started](getting-started.md) - Installation and first steps
- [Examples](examples.md) - Practical usage examples
- [Troubleshooting](troubleshooting.md) - Common issues and solutions
