# Technical Notes: Task Author and Living Docs

## Claude Code Session Context Research

### Key Findings from Documentation

**Slash Command System Architecture:**
- Commands are markdown files in `.claude/commands/` (project) or `~/.claude/commands/` (user)
- Support frontmatter configuration: `allowed-tools`, `description`, `model`, `argument-hint`, `disable-model-invocation`
- Namespacing via subdirectories (e.g., `.claude/commands/agent-os/bert/`)
- Can execute bash with `!` prefix, reference files with `@` prefix
- Support argument variables: `$ARGUMENTS`, `$1`, `$2`, etc.

**Session Context Limitations:**
- No built-in "session initialization" or persistent context mechanism
- Commands execute independently - no automatic context sharing
- No native "overlay" or "include" system

**Recommended Approach:**
Use Claude's conversation memory for session context rather than technical persistence:
1. Create `/agent-os:bert:start` that outputs clear instructions
2. Claude retains these instructions in conversation context
3. User invokes overlays/includes naturally: "with bert overlay", "include bert living docs"
4. Claude checks directories and merges instructions based on retained context

This aligns with the "more english, less syntax" preference and leverages Claude's natural language understanding.

## Task Numbering Scheme

### File Naming Convention

**Pattern:** `task-{nn}.{sub}.{subsub}-{slug}.md`

**Examples:**
- `task-04-improve-auth.md` (top-level task 4)
- `task-04.1-review-tokens.md` (subtask 1 under task 4)
- `task-04.1.1-jwt-analysis.md` (sub-subtask 1 under 4.1)
- `task-04.1.2-oauth-flow.md` (sub-subtask 2 under 4.1)
- `task-04.2.1-rate-limiting.md` (sub-subtask 1 under 4.2)

**Key Points:**
- Use dots (`.`) as separators, not dashes
- Supports arbitrary nesting depth
- Zero-pad major task numbers: `task-04`, `task-10`
- Don't zero-pad subtask numbers in filename

### Checkbox Numbering in Parent Files

**Pattern:** `{nn}.{padded-sub}.{unpadded-subsub}`

**Example 1 - Top-level task (task-04-improve-auth.md):**
```markdown
## Tasks

- [ ] 4.01 Review authentication flow
- [ ] 4.02 Improve token handling
- [ ] 4.03 Add rate limiting
...
- [ ] 4.09 Security audit
- [ ] 4.10 Update documentation
- [ ] 4.11 Add integration tests
```

**Example 2 - First-level subtask (task-04.1-review-tokens.md):**
```markdown
## Tasks

- [ ] 4.01.1 Analyze JWT implementation
- [ ] 4.01.2 Review OAuth2 flow
- [ ] 4.01.3 Check session management
- [ ] 4.01.4 Validate token expiration
```

**Example 3 - Second-level subtask (task-04.1.1-jwt-analysis.md):**
```markdown
## Tasks

- [ ] 4.01.1.1 Review signing algorithm
- [ ] 4.01.1.2 Check payload structure
- [ ] 4.01.1.3 Validate expiration claims
```

### Smart Zero-Padding Algorithm

**Goal:** Pad the immediate child level for sorting, but not grandchildren.

**Algorithm:**
1. Scan existing tasks at the target level to find maximum task number
2. Calculate digits needed: `max_digits = len(str(max_num))`
3. Apply zero-padding to immediate child level only
4. Format: `{parent}.{str(child).zfill(max_digits)}.{grandchild}`

**Examples:**
- If max subtask under task 4 is 12: Use `4.01` through `4.12`
- If max subtask under task 4 is 8: Use `4.1` through `4.8` (no padding needed)
- If max sub-subtask under 4.1 is 25: Use `4.01.1` through `4.01.25` (pad first level, not second)

**Rationale:**
- Ensures proper alphabetical/lexical sorting
- Balances readability with functionality
- Adapts to actual task count at each level

## Frontmatter Structure

### Claude Code Standard Fields

**Used in slash command files (`.claude/commands/`):**

```yaml
---
allowed-tools: [Read, Write, Bash]
description: "Brief description of what this command does"
model: "claude-sonnet-4"
argument-hint: "[file-path-or-abstract-request]"
disable-model-invocation: false
---
```

**Field Descriptions:**
- `allowed-tools`: Restrict which tools Claude can use when executing this command
- `description`: Shown in help menu; defaults to first line if omitted
- `model`: Override default model for this specific command
- `argument-hint`: Guide users on expected input format
- `disable-model-invocation`: Prevent automatic command execution (rare use case)

### Bert Task File Fields

**Used in task files (`agent-os/bert/tasks/task-*.md`):**

```yaml
---
# Required fields
status: pending          # pending | in-progress | completed | blocked
created: 2025-10-14     # YYYY-MM-DD format

# Optional fields
updated: 2025-10-14     # YYYY-MM-DD format - last modification date
parent: 4.1             # Parent task number (for subtasks)
related: [2.3, 3.5]     # Array of related task numbers
---
```

**Status Values:**
- `pending`: Task created but not started
- `in-progress`: Currently being worked on
- `completed`: Task finished
- `blocked`: Cannot proceed due to dependency or issue

### Configuration File Structure

**Location:** `agent-os/bert/config.yml`

```yaml
# Claude Code standard frontmatter (optional - command-specific)
claude_frontmatter:
  allowed_tools: []       # Can be overridden per command
  description: ""         # Can be overridden per command
  model: ""              # Can be overridden per command
  argument_hint: ""      # Can be overridden per command

# Bert task frontmatter (required for all tasks)
task_frontmatter:
  required:
    - status      # pending, in-progress, completed, blocked
    - created     # YYYY-MM-DD format
  optional:
    - updated     # YYYY-MM-DD format
    - parent      # Parent task number if subtask
    - related     # Related task numbers

# Living document status tracking
living_docs:
  statuses:
    - draft           # Initial creation
    - in-progress     # Currently being updated
    - reviewed        # Reviewed and accurate
    - needs-update    # Identified as needing revision
  comment_format: "<!-- bert:status={status}, updated={date} -->"
  granularity: h3     # Track at h3 (###) heading level
```

**Evolution Strategy:**
- Start with minimal required fields
- Add optional fields as patterns emerge
- Update living_docs section as tracking needs evolve
- Keep backward compatible - old tasks still valid

## Session Initialization Pattern

### `/agent-os:bert:start` Command

**Purpose:** Establish session-level awareness of bert overlay system

**Location:** `.claude/commands/agent-os/bert/start.md`

**Implementation:**

```markdown
---
description: "Initialize bert overlay system for this session"
---

# Bert Session Initialization

For this session, I'm using the agent-os framework with the **bert addon**.

## Bert Addon Overview

The bert addon provides overlays and enhancements to agent-os commands without modifying the original commands.

## Directory Structure

- **Overlays:** `agent-os/bert/overlays/` - Additional instructions for agent-os commands
- **Includes:** `agent-os/bert/includes/` - Reusable directive files
- **Config:** `agent-os/bert/config.yml` - Frontmatter and status definitions
- **Tasks:** `agent-os/bert/tasks/` - Task files with enhanced numbering

## How to Use Bert Overlays

When I reference "bert overlay" or "include bert", please:

1. **Check for overlay files:**
   - When I run an agent-os command and mention "with bert overlay"
   - Look in `agent-os/bert/overlays/` for a matching overlay file
   - Example: For `/agent-os:plan-product`, check `agent-os/bert/overlays/plan-product.md`
   - Merge those additional instructions with the original command

2. **Respond to include directives:**
   - When I say "include bert living docs" or similar
   - Read `agent-os/bert/includes/living-docs.md`
   - Apply those instructions to the current task

3. **Use bert configuration:**
   - When creating or updating task files
   - Reference `agent-os/bert/config.yml` for frontmatter structure
   - Follow the defined status values and field requirements

## Natural Language Invocation

You can invoke bert features naturally:
- "Run plan-product with bert overlay"
- "Include bert living docs when updating this file"
- "Use bert task numbering for subtasks"
- "Apply bert conventions to this task"

## Confirmation

Please acknowledge that you understand these bert conventions and will apply them throughout this session when requested.

---

**Status:** Bert overlay system is now active for this session.
```

**How It Works:**
1. User runs `/agent-os:bert:start` once at session start
2. Claude reads and acknowledges these instructions
3. Instructions persist in Claude's conversation context
4. User can naturally reference overlays/includes throughout session
5. Claude checks appropriate directories and applies instructions

**Why This Approach:**
- No technical persistence mechanism needed
- Leverages Claude's natural conversation memory
- Supports natural language interaction ("more english, less syntax")
- Flexible and extensible
- Doesn't require modifying agent-os commands

## Overlay System Architecture

### Directory Structure

```
agent-os/bert/
├── config.yml              # Configuration and definitions
├── overlays/               # Command-specific enhancements
│   ├── plan-product.md     # Living docs for product planning
│   ├── implement-spec.md   # Future: enhanced spec implementation
│   └── create-spec.md      # Future: enhanced spec creation
├── includes/               # Reusable directive snippets
│   ├── living-docs.md      # Living document update rules
│   ├── smart-analysis.md   # Future: code analysis guidelines
│   └── task-tracking.md    # Future: task status management
└── tasks/                  # Enhanced task files
    ├── task-01-*.md
    ├── task-02-*.md
    └── ...
```

### Overlay File Pattern

**Naming:** Match the original command name (e.g., `plan-product.md` overlays `/agent-os:plan-product`)

**Structure:**
```markdown
# Bert Overlay: [Command Name]

Brief description of what this overlay adds.

## Additional Instructions

[Detailed instructions that merge with original command]

### Specific Behaviors

1. **Behavior 1:**
   - Details...

2. **Behavior 2:**
   - Details...

### Examples

[Concrete examples of enhanced behavior]

## Integration Notes

[How these instructions combine with the original command]
```

**Example - plan-product.md:**
```markdown
# Bert Overlay: Plan Product

Adds living document tracking to product planning output.

## Additional Instructions

When generating product documentation:

1. **Add Status Comments to H3 Headings:**
   - After each ### heading: `<!-- bert:status=draft, updated=YYYY-MM-DD -->`
   - Use current date
   - Initial status: "draft"

2. **Apply to Files:**
   - agent-os/product/roadmap.md
   - agent-os/product/mission.md
   - agent-os/product/tech-stack.md

3. **Status Values:**
   - draft: Initial creation
   - in-progress: Being updated
   - reviewed: Accurate and complete
   - needs-update: Needs revision

### Example Output

```markdown
### Completed Features
<!-- bert:status=draft, updated=2025-10-14 -->

- Feature 1: Authentication system
- Feature 2: User dashboard
```

This enables incremental updates to product documents over time.
```

### Include File Pattern

**Purpose:** Reusable instructions users can reference naturally

**Structure:**
```markdown
# Bert Include: [Purpose]

Brief description of what these instructions do.

## When to Use

[Scenarios where this include is applicable]

## Rules

1. **Rule 1:**
   - Specific behavior...

2. **Rule 2:**
   - Specific behavior...

## Examples

[Concrete examples showing the rules in action]

## Edge Cases

[How to handle unusual situations]
```

**Example - living-docs.md:**
```markdown
# Bert Include: Living Document Updates

Rules for updating files with bert status tracking.

## When to Use

Use when modifying files that contain bert status comments (e.g., roadmap.md, mission.md).

## Rules

1. **Locate Status Comments:**
   - Look for: `<!-- bert:status=X, updated=YYYY-MM-DD -->`
   - Appear after h3 (###) headings

2. **Update When Modifying:**
   - Change status to "reviewed" if improvements made
   - Update date to current date
   - Example: `<!-- bert:status=reviewed, updated=2025-10-14 -->`

3. **Add If Missing:**
   - If editing section without status comment
   - Add: `<!-- bert:status=in-progress, updated=YYYY-MM-DD -->`

4. **Status Transitions:**
   - draft → in-progress (first edit)
   - in-progress → reviewed (complete)
   - reviewed → needs-update (identified as outdated)
   - needs-update → in-progress (fixing)

5. **Preserve Comments:**
   - Never remove status comments
   - Always update when modifying content

## Example

Before:
```markdown
### API Endpoints
<!-- bert:status=draft, updated=2025-10-10 -->

Current endpoints: /auth, /users
```

After editing:
```markdown
### API Endpoints
<!-- bert:status=reviewed, updated=2025-10-14 -->

Current endpoints: /auth, /users, /posts, /comments
Added social features and enhanced authentication.
```
```

## Living Document Tracking System

### Status Comment Format

**Syntax:** `<!-- bert:status={status}, updated={date} -->`

**Placement:** Immediately after h3 (###) headings

**Example:**
```markdown
### Completed Features
<!-- bert:status=reviewed, updated=2025-10-14 -->

- Authentication system
- User management
- Dashboard analytics
```

### Status Values and Transitions

**Lifecycle:**

```
draft (initial)
  ↓
in-progress (first edit)
  ↓
reviewed (complete and verified)
  ↓
needs-update (identified as outdated)
  ↓
in-progress (being fixed)
  ↓
reviewed (updated and verified)
```

**Status Definitions:**
- `draft`: Section created but not yet reviewed
- `in-progress`: Currently being edited or updated
- `reviewed`: Content accurate, complete, and verified
- `needs-update`: Identified as needing revision but not yet started

### Tracking Granularity

**Level:** H3 headings (###) only

**Rationale:**
- H2 typically represents major phases/sections (too broad)
- H3 represents specific features/topics (right level)
- H4+ too granular for tracking purposes

**Example Structure:**
```markdown
# Product Roadmap

## Phase 1: Foundation
<!-- No tracking at h2 level -->

### Authentication System
<!-- bert:status=reviewed, updated=2025-10-14 -->
[Content about auth system...]

### User Management
<!-- bert:status=in-progress, updated=2025-10-14 -->
[Content about user management...]

### Dashboard Analytics
<!-- bert:status=draft, updated=2025-10-10 -->
[Content about analytics...]

## Phase 2: Growth
<!-- No tracking at h2 level -->

### Social Features
<!-- bert:status=draft, updated=2025-10-10 -->
[Content about social features...]
```

### Integration with Overlays

**plan-product.md overlay:**
- Automatically adds draft status comments when creating files
- Applies to all h3 headings in generated documents
- Uses current date

**living-docs.md include:**
- User invokes when updating existing tracked documents
- Updates status comments when sections are modified
- Transitions status based on type of change

## Task-Author Command Design

### Command Purpose

Generate parent task files that identify improvement areas for a given file or code pattern.

### Input Flexibility

**1. File Path Input:**
```
/agent-os:bert:task-author agent-os/product/roadmap.md
```
- Directly reads the specified file
- Analyzes structure and content
- Identifies sections needing improvement

**2. Abstract Request Input:**
```
/agent-os:bert:task-author improve error handling in authentication
```
- Searches codebase for relevant files
- Asks user for confirmation if multiple matches
- Analyzes identified files
- Generates improvement recommendations

### Output Format

**Generated File:** `task-{nn}-{slug}.md`

**Structure:**
```yaml
---
status: pending
created: 2025-10-14
---

# Task {nn}: [Title derived from input]

## Description

[Analysis of the file/code pattern and why improvements are needed]

## Context

[Why these improvements matter - the business/technical rationale]

## Tasks

- [ ] {nn}.01 [Specific improvement 1]
- [ ] {nn}.02 [Specific improvement 2]
- [ ] {nn}.03 [Specific improvement 3]
...

## Notes

[Any additional context, dependencies, or considerations]
```

### Analysis Approach

**For Files:**
1. Read file content
2. Identify structure (headings, sections, code patterns)
3. Look for:
   - Missing information
   - Outdated content (if timestamps available)
   - Inconsistencies
   - Areas lacking detail
   - Opportunities for enhancement

**For Abstract Requests:**
1. Parse intent keywords (improve, fix, enhance, add, etc.)
2. Identify target area (error handling, authentication, etc.)
3. Search codebase for relevant files
4. Present matches to user for confirmation
5. Analyze confirmed files
6. Generate contextual recommendations

### User Workflow

**1. Generate parent task:**
```
/agent-os:bert:task-author agent-os/product/roadmap.md
```
→ Creates `task-05-improve-product-roadmap.md` with list of improvements

**2. User reviews and decides which to pursue**

**3. Create subtask for chosen improvement:**
```
/agent-os:bert:task-create -p 5
```
→ Creates subtask files for each unchecked item in parent

**4. Work on specific subtask:**
```
/agent-os:bert:task-create -p 5.2
```
→ Creates sub-subtasks if needed (5.2.1, 5.2.2, etc.)

## Implementation Phases

### Phase 1: Core Infrastructure (Estimated: 2-3 hours)
- Create `agent-os/bert/config.yml`
- Create directories: `overlays/`, `includes/`
- Create `/agent-os:bert:start` command
- Test session context with sample overlay reference

### Phase 2: Task Author Command (Estimated: 4-5 hours)
- Create `/agent-os:bert:task-author` command file
- Implement file path parsing logic
- Implement abstract request parsing
- Implement file analysis logic
- Implement parent task generation
- Test with various inputs

### Phase 3: Enhanced Task Numbering (Estimated: 3-4 hours)
- Update existing task-create command
- Add deep nesting support (dots in filenames)
- Implement smart zero-padding algorithm
- Support `-p 4.1` style parent specification
- Test edge cases (10+ subtasks, 3+ levels deep)

### Phase 4: Living Document System (Estimated: 2-3 hours)
- Create `agent-os/bert/overlays/plan-product.md`
- Create `agent-os/bert/includes/living-docs.md`
- Test overlay activation via `/agent-os:bert:start`
- Test natural language invocation
- Verify status comment format

### Phase 5: Integration Testing (Estimated: 2-3 hours)
- End-to-end workflow testing
- Natural language invocation patterns
- Verify no conflicts with existing commands
- Create usage examples and documentation
- Refine based on real-world use

**Total Estimated Effort:** 13-18 hours

## Technical Constraints and Considerations

### Claude Code Limitations

**No Technical Persistence:**
- Cannot save session state between conversations
- Must rely on conversation memory (works within single session)
- Session initialization must be re-run if context is lost

**No Custom Syntax:**
- Cannot create new special syntax like `#include:bert`
- Must use natural language or existing mechanisms (@file, !bash)
- Aligns well with "more english" preference

**Command Independence:**
- Each slash command executes independently
- Context sharing happens through Claude's understanding, not technical mechanism
- Overlay merging is conceptual, not programmatic

### Best Practices

**1. Keep Overlays Focused:**
- One overlay = one command enhancement
- Clear, specific additional instructions
- Don't duplicate original command content

**2. Make Includes Self-Contained:**
- Include files should be complete, standalone instructions
- Don't rely on external context beyond what's stated
- Provide examples within the include file

**3. Session Initialization Clarity:**
- `/agent-os:bert:start` should be explicit and comprehensive
- User should understand what bert does after reading output
- Remind users to re-run if context seems lost

**4. Natural Language Flexibility:**
- Support multiple phrasings: "with bert overlay", "using bert", "apply bert"
- Don't enforce rigid syntax
- Claude's understanding handles variations

**5. Configuration Evolution:**
- Start minimal, add fields as needed
- Keep backward compatible
- Document changes in config.yml comments

## Future Enhancements (Out of Current Scope)

### Potential Overlay Additions
- `implement-spec.md` - Enhanced spec implementation with task tracking
- `create-spec.md` - Spec creation with living doc integration
- `review-code.md` - Code review with improvement task generation

### Potential Include Additions
- `smart-analysis.md` - Guidelines for analyzing code patterns
- `task-tracking.md` - Advanced task status management
- `documentation-standards.md` - Documentation quality checks

### Advanced Task Features
- Task dependency tracking (blocked-by field)
- Estimated effort tracking (story points, hours)
- Task assignment (assignee field)
- Task labels/tags for categorization

### Living Document Enhancements
- Who made updates (author field in comments)
- Brief change description in comments
- Links to related tasks/PRs
- Section version history

### Metrics and Reporting
- Task completion velocity
- Living document freshness tracking
- Overlay usage statistics
- Most improved sections report
