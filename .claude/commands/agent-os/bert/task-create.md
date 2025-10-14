
# Create a new task in bert

This command creates a new task in the `agent-os/bert/tasks` directory with support for arbitrary nesting depth.

## Command

`/agent-os/bert/task-create [description]` - Create a top-level task
`/agent-os/bert/task-create -p <parent_num> [description]` - Create subtask(s) under a parent task

## Parent Number Format

The `-p` flag supports arbitrary nesting depth:
- `-p 4` - Create subtasks under task-04-*.md (produces task-04.1-*.md, task-04.2-*.md)
- `-p 4.1` - Create subtasks under task-04.1-*.md (produces task-04.1.1-*.md, task-04.1.2-*.md)
- `-p 4.1.2` - Create subtasks under task-04.1.2-*.md (produces task-04.1.2.1-*.md, task-04.1.2.2-*.md)
- `-p 4.1.2.3` - And so on, supporting any depth

## Description

This command will guide the user through the process of creating a new task file in the `agent-os/bert/tasks` directory. The task file will be named using the pattern `task-{nn}-{slug}.md` for top-level tasks, or `task-{nn}.{sub}.{subsub}...-{slug}.md` for nested subtasks.

## Workflow

### For Top-Level Tasks (without -p flag):

1.  **Get Task Description**: Ask the user for a brief description of the task (or use provided description).
2.  **Determine Task Number**: Check the `agent-os/bert/tasks` directory to determine the next available task number.
3.  **Generate Slug**: Create a kebab-case slug from the task description.
4.  **Create Task File**: Create the new task file with the appropriate frontmatter and content.
5.  **Confirm Creation**: Inform the user that the task has been created and provide the file path.

### For Subtasks (with -p flag):

1.  **Parse Parent Task Number**: Extract the parent task number from the `-p` argument
    - Parse format like: `3`, `4.1`, `4.1.2`, `4.1.2.3`
    - Split on dots to get number hierarchy (e.g., `4.1.2` → ['4', '1', '2'])
    - Validate format (numbers separated by dots)

2.  **Find Parent Task File**: Locate the parent file using pattern matching
    - For `-p 4`: find `task-04-*.md`
    - For `-p 4.1`: find `task-04.1-*.md`
    - For `-p 4.1.2`: find `task-04.1.2-*.md`
    - Pattern: `task-{parent_number}-*.md` where dots are preserved
    - If parent file not found, provide clear error message

3.  **Extract Tasks from Parent**: Parse the `## Tasks` section to find all unchecked tasks `- [ ]`.

4.  **Determine Subtask Numbers**: Check existing subtasks to determine next available subtask number
    - For parent `4`: check for `task-04.1-*.md`, `task-04.2-*.md`, etc.
    - For parent `4.1`: check for `task-04.1.1-*.md`, `task-04.1.2-*.md`, etc.
    - For parent `4.1.2`: check for `task-04.1.2.1-*.md`, `task-04.1.2.2-*.md`, etc.

5.  **Calculate Smart Padding**: Determine padding width for checkbox numbers
    - Scan ALL existing tasks at the target nesting level (not just direct children)
    - Find the maximum task number at that level
    - Calculate padding: `max_digits = len(str(max_num))`
    - This ensures proper sorting when task count exceeds 9
    - Examples:
      - If max child is 9: pad to 2 digits (01, 02, ..., 09)
      - If max child is 12: pad to 2 digits (01, 02, ..., 12)
      - If max child is 100: pad to 3 digits (001, 002, ..., 100)

6.  **Create Subtask Files**: For each unchecked task in the parent:
    - Generate a kebab-case slug from the task description
    - Create subtask file with dotted naming:
      - Parent `4` → `task-04.1-{slug}.md`, `task-04.2-{slug}.md`
      - Parent `4.1` → `task-04.1.1-{slug}.md`, `task-04.1.2-{slug}.md`
      - Parent `4.1.2` → `task-04.1.2.1-{slug}.md`, `task-04.1.2.2-{slug}.md`
    - Use dots (.) as separators, NOT dashes
    - Add frontmatter with `parent: {parent_number}` field
    - Set the description to the task text from the parent
    - Add empty `## Tasks` section for potential sub-subtasks

7.  **Update Parent Task File**: Modify the parent task file with smart-padded task numbers
    - Apply smart padding to checkbox numbers
    - Format: `{major}.{padded_child}.{unpadded_grandchild}`
    - Examples:
      - Parent `4` with max 9 children: `4.01`, `4.02`, ..., `4.09`
      - Parent `4` with max 12 children: `4.01`, `4.02`, ..., `4.12`
      - Parent `4.1` with max 3 children: `4.01.1`, `4.01.2`, `4.01.3`
      - Parent `4.1` with max 10 children: `4.01.01`, `4.01.02`, ..., `4.01.10`
      - Parent `4.1.2`: `4.01.2.1`, `4.01.2.2`
    - Only pad the immediate child level
    - Preserve existing checkbox state (checked/unchecked)

8.  **Confirm Creation**: List all created subtask files and confirm the parent file has been updated.

## Examples

**Create a top-level task:**
```
/agent-os/bert/task-create design authentication system
```
Creates: `task-04-design-authentication-system.md`

**Create subtasks from parent task 3:**
```
/agent-os/bert/task-create -p 3
```
Reads `task-03-design-skucode.md`, finds tasks like:
- `- [ ] Figure out which erc protocol to use`
- `- [ ] Get a basic skucode class in place`

Creates:
- `task-03.1-figure-out-which-erc-protocol-to-use.md`
- `task-03.2-get-a-basic-skucode-class-in-place.md`

Updates parent to:
- `- [ ] 3.01 Figure out which erc protocol to use`
- `- [ ] 3.02 Get a basic skucode class in place`

**Create nested subtasks from parent task 4.1:**
```
/agent-os/bert/task-create -p 4.1
```
Reads `task-04.1-review-tokens.md`, finds tasks like:
- `- [ ] Analyze JWT implementation`
- `- [ ] Review OAuth2 flow`

Creates:
- `task-04.1.1-analyze-jwt-implementation.md`
- `task-04.1.2-review-oauth2-flow.md`

Updates parent to:
- `- [ ] 4.01.1 Analyze JWT implementation`
- `- [ ] 4.01.2 Review OAuth2 flow`

**Create deeply nested subtasks from parent task 4.1.2:**
```
/agent-os/bert/task-create -p 4.1.2
```
Reads `task-04.1.2-oauth2-review.md`, finds tasks like:
- `- [ ] Test token refresh`
- `- [ ] Validate scopes`

Creates:
- `task-04.1.2.1-test-token-refresh.md`
- `task-04.1.2.2-validate-scopes.md`

Updates parent to:
- `- [ ] 4.01.2.1 Test token refresh`
- `- [ ] 4.01.2.2 Validate scopes`

## Important Notes

- **File Naming**: Always use dots (.) as separators in task numbers, not dashes
  - Correct: `task-04.1.2-slug.md`
  - Incorrect: `task-04-1-2-slug.md`
- **Smart Padding**: Only pad the immediate child level in checkbox numbers
  - Example: For parent `4.1`, pad to `4.01.1`, `4.01.2`, not `4.01.01`
- **Arbitrary Depth**: The system supports unlimited nesting depth
- **Parent Field**: Always add `parent: {parent_number}` to subtask frontmatter
- **Empty Tasks Section**: Always include `## Tasks` section in subtasks for future nesting
