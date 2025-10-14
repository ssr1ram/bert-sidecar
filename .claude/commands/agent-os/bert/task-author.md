---
allowed_tools: [Read, Bash, Glob, Grep, Write]
argument_hint: "file path or abstract improvement request"
description: "Generate parent task identifying improvement areas"
---

# Task Author Command

Generate a parent task file that identifies improvement areas for a file or concept.

## Input Processing

The user provides broad input via `$ARGUMENTS`. Parse the intent:

1. **File Path Detection**: If the input contains a file path (e.g., "agent-os/product/roadmap.md" or mentions a specific file), treat it as a file analysis request
2. **Abstract Request**: If the input is a concept or improvement request (e.g., "improve error handling"), treat it as an abstract request requiring file discovery

## Workflow

### For File Path Input

1. **Read the specified file** using the Read tool
2. **Analyze the content** to identify:
   - Sections lacking detail or clarity
   - Areas with outdated information
   - Missing sections or gaps
   - Opportunities for improvement
3. **Generate specific, actionable improvement suggestions** with rationale for WHY each matters

### For Abstract Request Input

1. **Search the codebase** using Glob and Grep to find relevant files
2. **Present findings to the user** for confirmation
3. **Allow the user to refine** the search if needed
4. **After confirmation**, analyze the identified files
5. **Generate improvement suggestions** based on analysis

## Task Number Determination

1. Scan the `agent-os/bert/tasks/` directory
2. Find the highest existing task number (e.g., task-04-xxx.md → 04)
3. Increment by 1 for the new parent task (next would be 05)
4. If no tasks exist, start at 01

## Parent Task File Generation

Create a file named: `task-{nn}-{slug}.md` where:
- `{nn}` is the zero-padded task number (01, 02, etc.)
- `{slug}` is a kebab-case version of the task title

### File Structure

```markdown
---
status: pending
created: YYYY-MM-DD
---

# Task {nn}: {Title}

## Description

[Explain the analysis context and what was analyzed]

## Tasks

- [ ] {nn}.01 [Specific improvement task description]
- [ ] {nn}.02 [Specific improvement task description]
- [ ] {nn}.03 [Specific improvement task description]

## Rationale

[Explain WHY these improvements matter, not just WHAT they are. Connect to user goals, code quality, or project outcomes.]
```

### Frontmatter Requirements

Read `agent-os/bert/config.yml` to ensure frontmatter fields match the configuration. Required fields:
- `status`: Set to "pending" for new parent tasks
- `created`: Current date in YYYY-MM-DD format

### Checkbox Numbering

Format task checkboxes as: `{nn}.{sub}` where:
- `{nn}` is the parent task number
- `{sub}` is the subtask number starting at 01

Apply smart padding:
- If you expect less than 10 subtasks: `4.01`, `4.02`, ..., `4.09`
- If you expect 10+ subtasks: `4.01`, `4.02`, ..., `4.12`
- The padding ensures proper sorting

## Output to User

After generating the parent task file:

1. **Display the file path**: "Created task file: agent-os/bert/tasks/task-{nn}-{slug}.md"
2. **Summarize findings**: "Identified {count} improvement areas"
3. **Suggest next steps**:
   - Review the parent task file
   - Use `/agent-os:bert:task-create -p {nn}` to create subtask files for specific improvements
   - Or manually edit the parent task if adjustments are needed

## Important Notes

- **Do NOT auto-generate subtask files** - only create the parent task
- The user decides which improvement tasks to pursue
- Focus on specific, actionable improvements rather than vague suggestions
- Provide context for WHY each improvement matters
- If file doesn't exist or can't be read, provide a clear error message
- If abstract search finds no relevant files, explain and offer to refine the search

## Example Invocations

```
# File path example
/agent-os:bert:task-author agent-os/product/roadmap.md

# Abstract request example
/agent-os:bert:task-author improve error handling in authentication

# Broad directive example
/agent-os:bert:task-author make the roadmap more accurate
```

## Processing $ARGUMENTS

```
Input: $ARGUMENTS
```

Now proceed with the workflow described above based on the input type.
