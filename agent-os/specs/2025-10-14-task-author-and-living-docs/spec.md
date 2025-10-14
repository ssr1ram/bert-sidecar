# Specification: Task Author and Living Docs

## Executive Summary

This specification defines a new addon system for agent-os called "bert" (Better Enhancement and Refinement Toolkit). The bert addon provides granular task authoring capabilities and living document tracking without modifying the core agent-os framework. It introduces an overlay pattern that extends agent-os functionality through session-aware context management and natural language directives.

The primary features include:
- Session initialization for bert-aware command interpretation
- Intelligent task authoring from broad user input
- Deep nested task support with smart numbering
- Living document tracking via non-intrusive HTML comments
- Natural language overlay system for extending agent-os commands

This addon enables mid-stream task creation and iterative document refinement, supporting agile workflows where requirements evolve over time.

## Goal

Enable users to incrementally author and refine tasks and documentation through natural language interaction, providing granular control over task breakdown and document evolution without disrupting the existing agent-os command structure.

## User Stories

- As a product planner, I want to identify areas of improvement in my roadmap.md without manually analyzing every section, so that I can focus on high-priority enhancements
- As a developer, I want to create deeply nested subtasks (4.1.1, 4.1.2, etc.) when I discover additional complexity, so that I can maintain organized task hierarchies
- As a documentation maintainer, I want to track which sections of living documents have been reviewed without modifying the original command that generated them, so that I can manage incremental updates
- As an agent-os user, I want to activate bert enhancements once per session and have them apply automatically, so that I don't need to invoke special syntax for every command
- As a task author, I want to provide abstract requests like "improve error handling" and have the system intelligently identify relevant files, so that I don't need to manually specify every file path

## Core Requirements

### Functional Requirements

#### 1. Session Initialization Command: `/agent-os:bert:start`

**Purpose:** Establish session-level awareness that bert overlay system is active.

**Behavior:**
- User invokes once at the beginning of a chat session
- Outputs comprehensive instructions that establish bert context in Claude's conversation memory
- Instructs Claude to:
  - Check for bert overlays when executing agent-os commands
  - Understand natural language includes like "include bert" or "apply bert overlay"
  - Reference `agent-os/bert/config.yml` for task frontmatter structure
  - Look for overlay files in `agent-os/bert/overlays/`
  - Look for include files in `agent-os/bert/includes/`
- Confirms to user that bert system is active for the session
- No technical persistence mechanism required - relies on Claude's conversation context

**Success Criteria:**
- After running command, user can invoke agent-os commands with bert overlays using natural language
- Context persists throughout the conversation without re-initialization
- Does not interfere with standard agent-os command execution

#### 2. Task-Author Command: `/agent-os:bert:task-author`

**Purpose:** Generate a parent task file that identifies improvement areas for a file or concept.

**Input Formats:**
- File path: "agent-os/product/roadmap.md"
- Abstract request: "improve error handling in authentication system"
- Broad directive: "make the roadmap more accurate"

**Behavior:**
- Accepts `$ARGUMENTS` as the user's broad input
- Intelligently parses intent:
  - If file path detected: read and analyze the file
  - If abstract request: search codebase for relevant files, present findings to user
- Analyzes content to identify improvement areas
- Generates ONE parent task file: `task-{nn}-{slug}.md`
- Parent task contains:
  - Frontmatter (status, created date, per config.yml)
  - Description explaining the analysis context
  - `## Tasks` section with checkboxes listing specific improvements
  - Context for WHY each improvement matters, not just WHAT
- Does NOT auto-generate subtask files (user decides which to pursue)
- Determines next available task number by scanning `agent-os/bert/tasks/` directory

**Example Flow:**
```
User: /agent-os:bert:task-author improve the roadmap.md accuracy

1. Reads agent-os/product/roadmap.md
2. Analyzes sections for completeness, clarity, specificity
3. Creates task-05-improve-roadmap-accuracy.md with:
   - [ ] 5.01 Elaborate on Phase 2 feature descriptions
   - [ ] 5.02 Add success metrics to Phase 1 deliverables
   - [ ] 5.03 Clarify dependencies between phases
```

**Success Criteria:**
- Handles both file paths and abstract requests
- Generates actionable, specific improvement tasks
- Provides rationale for suggested improvements
- Integrates seamlessly with existing task-create workflow for subtask generation

#### 3. Nested Task Numbering Enhancement

**Purpose:** Support arbitrary depth task nesting beyond the current two-level system.

**File Naming Pattern:**
- Level 1: `task-04-improve-auth.md`
- Level 2: `task-04.1-review-tokens.md`
- Level 3: `task-04.1.1-jwt-analysis.md`
- Level 4: `task-04.1.2.3-edge-cases.md`

**Enhancement to task-create command:**
- Support `-p 4.1` to create subtasks under task-04.1-xxx.md
- Support `-p 4.1.2` to create sub-subtasks under task-04.1.2-xxx.md
- Parse parent task number correctly with dots
- Find parent file by matching pattern `task-{nn}.{sub}.{subsub}*-*.md`
- Use dots (.) as separators in filenames, NOT dashes

**Success Criteria:**
- Can create tasks at any nesting level
- File naming is consistent and sortable
- Parent file identification works correctly for nested parents

#### 4. Smart Task Numbering in Parent Files

**Purpose:** Apply intelligent zero-padding to task numbers in parent file checkboxes for proper sorting.

**Padding Rules:**
- Zero-pad the immediate child level ONLY
- Format: `{major}.{padded-child}.{unpadded-grandchild}`
- Padding width determined by maximum child number

**Examples:**
```
Parent: task-04-improve-auth.md
## Tasks
- [ ] 4.01 Review authentication flow        -> task-04.1-xxx.md
- [ ] 4.02 Improve token handling            -> task-04.2-xxx.md
- [ ] 4.10 Update documentation              -> task-04.10-xxx.md

Parent: task-04.1-review-tokens.md
## Tasks
- [ ] 4.01.1 Analyze JWT implementation      -> task-04.1.1-xxx.md
- [ ] 4.01.2 Review OAuth2 flow              -> task-04.1.2-xxx.md
- [ ] 4.01.10 Security audit                 -> task-04.1.10-xxx.md

Parent: task-04.1.2-oauth2-review.md
## Tasks
- [ ] 4.01.2.1 Test token refresh            -> task-04.1.2.1-xxx.md
- [ ] 4.01.2.2 Validate scopes               -> task-04.1.2.2-xxx.md
```

**Padding Algorithm:**
1. Scan existing tasks at target nesting level
2. Identify maximum task number at that level
3. Calculate padding width: `len(str(max_num))`
4. Apply padding to immediate child level in parent file checkboxes
5. Do NOT pad grandchild levels

**Success Criteria:**
- Task lists sort correctly in file viewers
- Handles 2-digit and 3-digit task numbers
- Consistent across all nesting levels
- Parent file updates reflect correct padding

#### 5. Living Document Tracking System

**Purpose:** Track section-level review status in generated documents without modifying generation commands.

**Comment Format:**
```markdown
### Completed Features
<!-- bert:status=reviewed, updated=2025-10-14 -->

[Section content...]
```

**Status Values:**
- `draft` - Initial creation
- `in-progress` - Currently being updated
- `reviewed` - Reviewed and verified accurate
- `needs-update` - Identified as requiring revision

**Tracking Granularity:**
- Track at h3 (###) heading level
- Insert comment immediately after heading (same line or next line)
- Use YAML-like syntax within HTML comment for parseability
- Comments are invisible in rendered markdown

**Behavior:**
- Comments added during document generation when bert overlay active
- Comments updated when sections are modified with bert context active
- Comments preserved when document is regenerated or modified
- No separate tracking file needed

**Success Criteria:**
- Comments don't interfere with markdown rendering
- Easy to parse programmatically if needed in future
- Clear visual indicator in source view
- Supports incremental document evolution

#### 6. Bert Overlay System

**Purpose:** Extend agent-os commands with additional instructions without modifying original commands.

**Directory Structure:**
```
agent-os/bert/
├── overlays/
│   ├── plan-product.md
│   └── implement-spec.md (future)
```

**Overlay File Format:**
Each overlay file contains additional instructions to merge with the original command. Example structure:

```markdown
# Bert Overlay: Plan Product

This overlay adds living document tracking to the plan-product command.

## Additional Instructions

When generating product documentation files:

1. Add status comments to all h3 headings
2. Set initial status to "draft"
3. Use current date for updated field
4. Format: <!-- bert:status=draft, updated=YYYY-MM-DD -->
```

**Activation Mechanism:**
- User runs `/agent-os:bert:start` to establish session context
- When user invokes agent-os command with natural language like:
  - "run plan-product with bert overlay"
  - "use agent-os plan-product and include bert"
  - "apply bert to plan-product"
- Claude checks for matching overlay file in `agent-os/bert/overlays/`
- Claude reads original command AND overlay, merges instructions
- Executes combined workflow

**Success Criteria:**
- Does not modify original agent-os command files
- Works through natural language invocation
- Easy to add new overlays for other commands
- Overlay instructions clearly separated from base functionality

#### 7. Living Document Include Directive

**Purpose:** Provide reusable instructions for updating living document status comments.

**File Location:**
`agent-os/bert/includes/living-docs.md`

**Content Structure:**
Instructions that tell Claude how to:
- Locate existing bert status comments
- Update status when modifying sections
- Add status comments to sections that don't have them
- Determine appropriate status transitions
- Update timestamps

**Invocation:**
- NOT a slash command
- User includes naturally in prompts:
  - "include bert living docs when updating this file"
  - "apply bert overlay while modifying these sections"
  - "use bert to track changes"
- Session context from `/agent-os:bert:start` makes Claude aware of include files
- Claude reads include file and applies instructions

**Example Include Content:**
```markdown
# Bert Include: Living Document Updates

When updating files containing bert status comments:

1. Locate status comments: <!-- bert:status=X, updated=YYYY-MM-DD -->
2. Update status when modifying section:
   - draft → in-progress (first edit)
   - in-progress → reviewed (edits complete)
   - reviewed → needs-update (if identified as outdated)
3. Update date to current date
4. Add comment if section doesn't have one (status=in-progress)
```

**Success Criteria:**
- Easy for users to invoke via natural language
- Reusable across different commands and workflows
- Clear, actionable instructions
- Doesn't require memorizing special syntax

#### 8. Configuration File: `agent-os/bert/config.yml`

**Purpose:** Centralize frontmatter field definitions and living document settings.

**File Location:**
`agent-os/bert/config.yml`

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
  tracking_level: h3  # Track at h3 heading level
```

**Usage:**
- Referenced by task-create and task-author commands for frontmatter generation
- Referenced by living-docs include for status values
- Can be evolved over time as requirements solidify
- Commands read config to ensure consistency

**Success Criteria:**
- Single source of truth for bert configuration
- Easy to update as requirements evolve
- Clear structure and comments
- Used by all bert commands consistently

### Non-Functional Requirements

- **No Modification of agent-os:** Must not alter existing `.claude/commands/agent-os/` files or `.claude/agents/agent-os/` files
- **Natural Language Interaction:** Prefer conversational invocation over rigid syntax or special characters
- **Session Context Persistence:** Rely on Claude's conversation memory, not technical persistence mechanisms
- **Flexible Intent Parsing:** Handle both explicit file paths and abstract improvement requests
- **Mid-Stream Adaptability:** Support task creation and refinement at any point in workflow
- **Graceful Degradation:** Work without bert when session not initialized, don't break standard agent-os
- **Sortable Numbering:** Task numbers must sort correctly in file browsers and text editors
- **Non-Intrusive Tracking:** Living document markers must not interfere with rendering or existing parsers

### Out of Scope

- Automatic subtask file generation by task-author (user decides which to pursue)
- Backward compatibility for retrofitting existing files (user specifies files explicitly)
- Automatic living document updates triggered by task completion
- Version history for living document sections
- Tracking who made updates (only timestamps)
- Wrapper commands for every agent-os feature
- Technical persistence mechanisms (disk storage, database)
- Over-ambitious features beyond core iteration

## Technical Architecture

### Directory Structure

```
.claude/
└── commands/
    └── agent-os/
        └── bert/
            ├── start.md              # Session initialization command
            ├── task-author.md        # Task authoring command
            └── task-create.md        # Enhanced with nested support

agent-os/
└── bert/
    ├── config.yml                    # Configuration file
    ├── overlays/
    │   └── plan-product.md          # Overlay for plan-product command
    ├── includes/
    │   └── living-docs.md           # Living document update instructions
    └── tasks/
        ├── task-01-xxx.md
        ├── task-02-xxx.md
        └── task-02.1-xxx.md
```

### Session Context Pattern

**Initialization Flow:**
1. User runs `/agent-os:bert:start`
2. Command outputs context-setting instructions in natural language
3. Claude maintains this context through conversation memory
4. User can invoke bert features naturally for remainder of session

**Context Instructions Include:**
- Location of overlay files (`agent-os/bert/overlays/`)
- Location of include files (`agent-os/bert/includes/`)
- Configuration file location (`agent-os/bert/config.yml`)
- Natural language patterns to recognize ("with bert overlay", "include bert")
- Directive to merge overlay instructions with base commands

**Why This Works:**
- Leverages Claude Code's conversation context window
- No custom parsing or technical persistence needed
- Aligns with "more english, less syntax" preference
- Flexible and extensible

### Task Numbering Implementation

**File Naming:**
- Use dots as separators: `task-04.1.2-slug.md`
- Supports arbitrary nesting depth
- Slug generated from task description (kebab-case)

**Parent File Checkbox Numbering:**
- Smart padding algorithm:
  1. Scan existing subtasks to find maximum number
  2. Calculate padding: `max_digits = len(str(max_num))`
  3. Format: `{parent}.{str(child).zfill(max_digits)}.{grandchild}`
- Only pad immediate child level
- Examples:
  - `4.01` (if max child is 9)
  - `4.01` (if max child is 12)
  - `4.001` (if max child is 100)

**Parent File Identification:**
- Pattern: `task-{parent_number}*-*.md`
- For `-p 4.1`: match `task-04.1-*.md`
- For `-p 4.1.2`: match `task-04.1.2-*.md`

### Living Document Comment System

**Comment Syntax:**
```html
<!-- bert:status=reviewed, updated=2025-10-14 -->
```

**Placement:**
- Immediately after h3 (###) heading
- Same line or next line (both acceptable)

**Parsing Strategy:**
- Use regex: `<!-- bert:status=(\w+), updated=([\d-]+) -->`
- Extract status and date for programmatic use (future enhancement)
- Human-readable in source view

**Update Logic:**
- When modifying section content, update both status and date
- Preserve comment structure exactly
- Status transitions follow defined rules in config.yml

### Overlay Merging Strategy

**Command Execution with Overlay:**
1. User invokes: "run plan-product with bert overlay"
2. Claude identifies base command: `/agent-os:plan-product`
3. Claude checks for overlay: `agent-os/bert/overlays/plan-product.md`
4. Claude reads both files
5. Claude executes base command workflow PLUS overlay instructions
6. Result: original behavior enhanced with bert features

**Natural Language Triggers:**
- "with bert overlay"
- "and include bert"
- "apply bert to"
- "use bert when"

**Fallback:**
- If overlay not found, execute base command normally
- If session not initialized, ignore bert references

## Reusable Components

### Existing Code to Leverage

**From `.claude/commands/agent-os/bert/task-create.md`:**
- Task numbering logic (extend to support dots)
- Parent file parsing (extend to support nested parents)
- Frontmatter generation pattern
- Slug generation from description
- Directory scanning for next available number

**From `.claude/commands/agent-os/plan-product.md`:**
- File generation workflow pattern
- Product-planner subagent invocation pattern
- Multi-file creation approach

**From Task Files (`agent-os/bert/tasks/*.md`):**
- Frontmatter format (status, created)
- Task section structure with checkboxes
- Description and context pattern

**Frontmatter Pattern from Claude Code Docs:**
- `allowed-tools`, `description`, `model`, `argument-hint`, `disable-model-invocation`
- Apply to command files as needed

### New Components Required

**Command: `/agent-os:bert:start`**
- WHY NEW: No existing session initialization mechanism in agent-os
- PURPOSE: Establish bert awareness for session duration
- APPROACH: Output context-setting instructions for Claude to maintain

**Command: `/agent-os:bert:task-author`**
- WHY NEW: No existing command generates parent tasks from file analysis
- PURPOSE: Intelligent task breakdown from broad input
- APPROACH: Combine file reading, analysis, and task generation in single workflow

**Enhancement: Nested Task Support in task-create**
- WHY ENHANCE: Current task-create only supports two levels (task-04, task-04.1)
- PURPOSE: Support arbitrary depth (task-04.1.2.3)
- APPROACH: Extend parsing and numbering logic to handle dots in parent flag

**Configuration: `agent-os/bert/config.yml`**
- WHY NEW: No centralized configuration for bert-specific settings
- PURPOSE: Single source of truth for frontmatter fields and status values
- APPROACH: YAML structure with sections for claude_frontmatter, task_frontmatter, living_docs

**Overlay: `plan-product.md`**
- WHY NEW: No mechanism to extend agent-os commands without modifying them
- PURPOSE: Add living document tracking to plan-product output
- APPROACH: Separate file with additional instructions, merged via session context

**Include: `living-docs.md`**
- WHY NEW: Need reusable instructions for updating living documents
- PURPOSE: Consistent status comment management across workflows
- APPROACH: Instruction file that users invoke naturally

## Implementation Approach

### Phase 1: Core Infrastructure
1. Create directory structure: `agent-os/bert/overlays/`, `agent-os/bert/includes/`
2. Create `agent-os/bert/config.yml` with initial structure
3. Create `/agent-os:bert:start` command with context-setting instructions
4. Test session context persistence through conversation

### Phase 2: Task Author Command
1. Create `/agent-os:bert:task-author` command file
2. Implement argument parsing (file path vs abstract request)
3. Implement file analysis logic for identifying improvements
4. Implement parent task file generation with frontmatter
5. Reference config.yml for frontmatter structure
6. Test with various input formats (file paths, abstract requests)

### Phase 3: Enhanced Task Numbering
1. Update task-create command to parse dotted parent numbers (`-p 4.1`)
2. Implement nested parent file identification logic
3. Implement smart padding algorithm for checkbox numbering
4. Update filename generation to use dots consistently
5. Test multi-level nesting (create 4.1.1, 4.1.2, then 4.1.1.1)

### Phase 4: Living Document System
1. Create `agent-os/bert/overlays/plan-product.md` with status comment instructions
2. Create `agent-os/bert/includes/living-docs.md` with update rules
3. Test overlay activation through natural language invocation
4. Verify status comments inserted correctly at h3 headings
5. Test status updates when modifying sections

### Phase 5: Integration Testing
1. Test full workflow: start → task-author → create subtasks → update living docs
2. Verify overlay merging doesn't break base commands
3. Test natural language invocation patterns
4. Confirm no conflicts with existing agent-os functionality
5. Test session context persistence across multiple commands

## Integration Points with Existing agent-os

### Command Structure
- Follow existing command format: markdown files with optional frontmatter
- Use `$ARGUMENTS`, `$1`, `$2` for parameter handling
- Support `!bash` and `@file` references as existing commands do
- Place commands in `.claude/commands/agent-os/bert/` namespace

### Agent Invocation Pattern
- If specialized logic needed, follow pattern from plan-product
- Create agents in `.claude/agents/agent-os/bert/` if required
- Delegate analysis and complex workflows to agents
- Commands orchestrate, agents execute

### File Generation Patterns
- Follow task file format: frontmatter + description + tasks section
- Use existing kebab-case slug generation approach
- Maintain consistency with existing task file structure
- Reference config.yml for evolving frontmatter requirements

### Directory Conventions
- Tasks in `agent-os/bert/tasks/`
- Configuration in `agent-os/bert/`
- Commands in `.claude/commands/agent-os/bert/`
- Follow existing agent-os directory organization principles

## File Structure and Directory Layout

```
project-root/
├── .claude/
│   ├── commands/
│   │   └── agent-os/
│   │       ├── plan-product.md           # Existing (not modified)
│   │       ├── implement-spec.md         # Existing (not modified)
│   │       └── bert/
│   │           ├── start.md              # NEW: Session init
│   │           ├── task-author.md        # NEW: Task authoring
│   │           └── task-create.md        # ENHANCED: Nested support
│   └── agents/
│       └── agent-os/
│           └── [existing agents]         # Not modified
├── agent-os/
│   ├── bert/
│   │   ├── config.yml                    # NEW: Configuration
│   │   ├── overlays/
│   │   │   └── plan-product.md          # NEW: Overlay for plan-product
│   │   ├── includes/
│   │   │   └── living-docs.md           # NEW: Living doc instructions
│   │   └── tasks/
│   │       ├── task-01-xxx.md           # Existing
│   │       ├── task-02-xxx.md           # Can be generated by task-author
│   │       ├── task-02.1-xxx.md         # Subtasks
│   │       └── task-02.1.1-xxx.md       # Nested subtasks
│   ├── product/
│   │   ├── mission.md                    # Generated by plan-product
│   │   ├── roadmap.md                    # With bert comments when overlay used
│   │   └── tech-stack.md                # Generated by plan-product
│   └── [other agent-os directories]
└── [project files]
```

## Examples and Usage Scenarios

### Scenario 1: Starting a Bert Session

**User Action:**
```
/agent-os:bert:start
```

**System Response:**
```
Bert addon activated for this session.

I now understand that:
- Bert overlays are located in agent-os/bert/overlays/
- Bert includes are located in agent-os/bert/includes/
- Configuration is in agent-os/bert/config.yml
- When you say "with bert overlay" or "include bert", I'll check these directories
- I'll merge bert instructions with standard agent-os commands

You can now use natural language like:
- "run plan-product with bert overlay"
- "include bert living docs when updating this file"
- "use bert when creating this task"

Ready to proceed with bert-enhanced workflows.
```

### Scenario 2: Creating Task from File Analysis

**User Action:**
```
/agent-os:bert:task-author I want to make agent-os/product/roadmap.md more accurate
```

**System Workflow:**
1. Reads `agent-os/product/roadmap.md`
2. Analyzes each section for completeness and clarity
3. Identifies improvement areas

**Generated File: `agent-os/bert/tasks/task-05-improve-roadmap-accuracy.md`**
```markdown
---
status: pending
created: 2025-10-14
---

# Task 05: Improve Roadmap Accuracy

## Description

After analyzing agent-os/product/roadmap.md, several sections would benefit from
enhanced detail and specificity to provide clearer guidance for implementation.

## Tasks

- [ ] 5.01 Elaborate on Phase 2 feature descriptions with specific acceptance criteria
- [ ] 5.02 Add measurable success metrics to Phase 1 deliverables
- [ ] 5.03 Clarify technical dependencies between phases
- [ ] 5.04 Specify timeline estimates for each phase milestone
- [ ] 5.05 Define rollback strategies for critical features

## Rationale

Phase 2 currently lacks specific implementation details that would help developers
estimate effort and identify technical dependencies. Adding success metrics to
Phase 1 enables progress tracking and clear completion criteria.
```

### Scenario 3: Creating Nested Subtasks

**User Action:**
```
/agent-os:bert:task-create -p 5.1
```

**System Workflow:**
1. Finds parent: `task-05.1-elaborate-phase-2.md`
2. Reads `## Tasks` section from parent
3. Creates subtask files for each unchecked task
4. Updates parent with numbered checkboxes

**Generated Files:**
- `task-05.1.1-add-user-authentication-details.md`
- `task-05.1.2-specify-api-rate-limiting.md`
- `task-05.1.3-define-notification-system.md`

**Updated Parent: `task-05.1-elaborate-phase-2.md`**
```markdown
## Tasks

- [ ] 5.01.1 Add user authentication details
- [ ] 5.01.2 Specify API rate limiting approach
- [ ] 5.01.3 Define notification system architecture
```

### Scenario 4: Generating Living Documents with Overlay

**User Action:**
```
run plan-product with bert overlay
```

**System Workflow:**
1. Recognizes plan-product command
2. Checks for `agent-os/bert/overlays/plan-product.md`
3. Executes plan-product workflow
4. Applies bert overlay instructions to add status comments

**Generated File: `agent-os/product/roadmap.md`**
```markdown
# Product Roadmap

## Phase 1: Foundation
<!-- bert:status=draft, updated=2025-10-14 -->

### Completed Features
<!-- bert:status=draft, updated=2025-10-14 -->

- User authentication system
- Basic API endpoints

### In Progress
<!-- bert:status=draft, updated=2025-10-14 -->

- Database schema finalization
- Frontend component library

## Phase 2: Enhancement
<!-- bert:status=draft, updated=2025-10-14 -->

### Planned Features
<!-- bert:status=draft, updated=2025-10-14 -->

- Advanced search functionality
- Real-time notifications
```

### Scenario 5: Updating Living Document Sections

**User Action:**
```
I need to update the "Completed Features" section in roadmap.md.
Include bert living docs to track the changes.
```

**System Workflow:**
1. Recognizes "include bert living docs" directive (from session context)
2. Reads `agent-os/bert/includes/living-docs.md`
3. Modifies section content
4. Updates status comment

**Before:**
```markdown
### Completed Features
<!-- bert:status=draft, updated=2025-10-14 -->

- User authentication system
- Basic API endpoints
```

**After:**
```markdown
### Completed Features
<!-- bert:status=reviewed, updated=2025-10-15 -->

- User authentication system (JWT-based, OAuth2 support)
- Basic API endpoints (CRUD operations for users, tasks)
- Rate limiting (100 requests/minute per user)
```

### Scenario 6: Abstract Task Authoring

**User Action:**
```
/agent-os:bert:task-author improve error handling in the authentication system
```

**System Workflow:**
1. Recognizes abstract request (no file path)
2. Searches codebase for authentication-related files
3. Presents findings: "Found auth files in src/auth/, lib/auth.js, config/auth.yml"
4. User confirms or refines
5. Analyzes identified files
6. Generates parent task with specific improvements

**Generated File: `task-06-improve-auth-error-handling.md`**
```markdown
---
status: pending
created: 2025-10-14
---

# Task 06: Improve Auth Error Handling

## Description

Analysis of authentication system reveals several error handling gaps that could
lead to unclear error messages and difficult debugging.

## Tasks

- [ ] 6.01 Add specific error codes for JWT validation failures
- [ ] 6.02 Implement user-friendly error messages for failed login attempts
- [ ] 6.03 Add structured logging for authentication events
- [ ] 6.04 Create error recovery flow for expired tokens
- [ ] 6.05 Add monitoring alerts for suspicious authentication patterns

## Rationale

Current system throws generic errors that don't provide actionable feedback.
Specific error codes enable frontend to display helpful messages, and structured
logging aids in debugging production issues.
```

## Testing Considerations

### Command Testing

**Session Initialization:**
- Test that `/agent-os:bert:start` outputs expected context instructions
- Verify context persists across multiple subsequent commands in conversation
- Confirm standard agent-os commands work without bert when not initialized

**Task Author:**
- Test with explicit file paths to existing files
- Test with abstract requests requiring file discovery
- Test with non-existent files (should provide clear error)
- Verify generated parent tasks have correct frontmatter from config.yml
- Confirm task numbers increment correctly

**Nested Task Creation:**
- Test `-p 4` (single level parent)
- Test `-p 4.1` (nested parent)
- Test `-p 4.1.2` (deeply nested parent)
- Verify parent file identification works for each nesting level
- Confirm smart padding applied correctly (01, 02, ... 10, 11)

### Overlay Testing

**Plan-Product with Overlay:**
- Test natural language invocation: "with bert overlay", "include bert"
- Verify status comments inserted at all h3 headings
- Confirm initial status is "draft" with correct date
- Test that plan-product works normally without bert context

**Living Document Updates:**
- Test status comment updates when modifying sections
- Verify date updates to current date
- Confirm status transitions follow defined rules
- Test adding comments to sections that don't have them

### Integration Testing

**End-to-End Workflow:**
1. Start session with `/agent-os:bert:start`
2. Generate product docs with overlay
3. Use task-author to identify improvements
4. Create nested subtasks
5. Update living document sections
6. Verify all status comments and task numbers correct

**Cross-Command Compatibility:**
- Verify bert commands don't interfere with standard agent-os commands
- Test switching between bert and non-bert workflows in same session
- Confirm overlay activation doesn't break base command functionality

### Edge Cases

**Task Numbering:**
- More than 99 subtasks (test 3-digit padding)
- Creating subtask when no parent exists (should error clearly)
- Creating task when parent has no unchecked tasks

**Living Documents:**
- Sections without h3 headings (should not add comments)
- Malformed status comments (should update or replace)
- Multiple status comments in one section (should handle gracefully)

**Session Context:**
- Starting bert session multiple times (should be idempotent)
- Using bert features without initialization (should work but without overlay)
- Session ending and restarting (context should be lost, require re-init)

## Success Criteria

### Feature Completeness
- All 8 main features implemented and tested
- Commands follow existing agent-os patterns
- Configuration file structure established
- Documentation and examples provided

### User Experience
- Natural language invocation works intuitively
- Session initialization is one-time per conversation
- Task authoring handles both file paths and abstract requests
- Nested task numbering sorts correctly in file browsers
- Living document tracking is non-intrusive

### Technical Quality
- No modifications to existing agent-os files
- Overlay system activates through session context
- Smart padding algorithm handles arbitrary nesting depth
- Configuration is centralized and evolvable
- Comments use valid HTML and don't break rendering

### Integration
- Works seamlessly with existing agent-os workflows
- Can be used alongside standard agent-os without conflict
- Session context persists throughout conversation
- Gracefully degrades when bert not initialized

## Future Evolution Path

### Near-Term Enhancements (Next Iteration)
- Additional overlay files for other agent-os commands (implement-spec, create-spec)
- Enhanced task-author with code pattern analysis
- Task status transitions and completion tracking
- Search/filter capabilities for tasks by status

### Medium-Term Enhancements
- Programmatic parsing of living document status comments for reporting
- Task dependency tracking and visualization
- Bulk operations on tasks (mark multiple as complete)
- Integration with CI/CD for automated status updates

### Long-Term Vision
- Task analytics and completion metrics
- Automated task suggestions based on codebase analysis
- Living document diffing to show what changed between reviews
- Team collaboration features (assign tasks, track ownership)
- Version history for living document sections

### Configuration Evolution
As usage patterns emerge, `bert/config.yml` can be enhanced with:
- Additional frontmatter fields (priority, estimated effort, tags)
- Custom status values per project
- Living document tracking for other heading levels (h2, h4)
- Notification and reminder settings

### Extensibility
The overlay and include pattern enables future expansions without core changes:
- Create new overlays for any agent-os command
- Add specialized includes for different workflows
- Plugin architecture for third-party bert extensions
- Custom command creation following bert patterns

---

**Specification Version:** 1.0
**Created:** 2025-10-14
**Last Updated:** 2025-10-14
**Status:** Draft - Ready for Review
