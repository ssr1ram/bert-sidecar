# Spec Requirements: Task Author and Living Docs

## Initial Description

I want to do two things in parallel:

1. Build out the slash command "/agent-os:bert:task-author" "some very broad high level input" such as "I want to make the generated agent-os/product/roadmap.md more accurate"
    - This will generate a slash command file that takes the user input which will typically point to a file and then this slash command will direct the AI to review the file and generate a task file that identifies what would be the set of tasks that will help make that file more accurate.
2. Understand what changes need to be made to the original command ie "/agent-os:plan-product" that generated the roadmap.md file
    - As the different sections of the roadmap.md file are made more accurate - they are marked accordingly so roadmap.md now becomes a living document that can be regularly updated in parts, because it may take a few weeks before the need to elaborate on Phase 2 becomes important etc.

## Requirements Discussion

### First Round Questions

**Q1: Task-Author Command Workflow**
Should /agent-os:bert:task-author work like this: user provides input like "I want to make agent-os/product/roadmap.md more accurate" → AI reads the referenced file → AI generates a NEW task file (following the task-{nn}-{slug}.md pattern) that contains a set of subtasks to improve that file? Or should it generate the subtasks directly as separate files (like task-create -p does)?

**Answer:** It should only generate the parent file (task-{nn}-{slug}.md) not subtask files. The idea is that AI would try and understand what are the parts of this file that might need to be sharpened and give me the user the opportunity to decide which ones I want to work on. Say the parent file was task-04-foo.md, now when I decide to work on one I will generate a subtask for that i.e. task-04.1-baz.md - Now as I author this file I will use AI to help me and there might be a set of subtasks here - I might then want to do a `-p 4.1` and have AI generate 4.1.1, 4.1.2 etc.

**Q2: Frontmatter Fields**
Should the generated task file follow the same frontmatter format as existing bert tasks (with status: pending, created date) and include a ## Tasks section with checkboxes for each improvement needed? Should it also include context about WHY these improvements matter, or just focus on WHAT needs to be done?

**Answer:** The frontmatter fields will change over time. Create `bert/config.yml` to hold fields that frontmatter for tasks should have. Can sharpen them over time. Not ready to focus on this now.

**Q3: Living Document Tracking Mechanism**
For the living document feature, should sections of roadmap.md have:
- Inline markers like `<!-- status: reviewed, last-updated: 2025-10-14 -->` after each section heading?
- Front matter metadata with section-level tracking?
- A separate tracking file that maps sections to their status?

**Answer:** This is where it gets a bit tricky. I don't want to clobber agent-os the system that originated it. So, I guess your suggestion of a markdown comment makes sense. You decide.

**Q4: Section Granularity**
Should tracking be at the heading level (## Phase 1, ## Phase 2), or more granular (### Completed Features, ### In Progress)? Should ALL headings be tracked or only specific ones marked for tracking?

**Answer:** More granular at the "### Completed Features" level (h3 headings).

**Q5: Integration with Plan-Product**
When /agent-os:plan-product generates files, should they be created with living document tracking from the start (all sections marked as "needs review" or "draft"), or should tracking be added later when someone runs a command?

**Answer:** This is where it would be good to have a concept of an "overlay" wherein instead of "modifying the agent-os directive" we find a way to generate an overlay and then figure out how the user can call the agent-os slash command and simultaneously tell the AI to use the `bert` override - not sure how we can do this, but it is important that we do not modify the agent-os command but overlay it somehow.

**Q6: Task-Author Input Flexibility**
Should the task-author command accept ONLY file paths (like "agent-os/product/roadmap.md") or also more abstract requests like "improve error handling in the authentication system"? File-focused or code pattern/feature-focused?

**Answer:** It should also allow for more abstract requests and get smart about figuring out the user intent.

**Q7: Living Document Update Workflow**
When a task that improves a section is completed, should the living document status be updated manually, via a command, or should task completion itself trigger an update?

**Answer:** The living document update should NOT be a slash command but an "include". Make it easy for the user to "include" this directive in their task/prompt so the AI follows it. Should not be a separate slash command however.

**Q8: Backward Compatibility**
Should the living document feature support retrofitting existing files (like the mission.md, roadmap.md, tech-stack.md already generated), or only work with newly generated ones?

**Answer:** No backward compatibility needed. The user will specify the file and proceed accordingly.

**Q9: Scope Boundaries**
Are there any features you explicitly DON'T want?

**Answer:** Let's not get overly ambitious for this iteration. The whole purpose of bert is to give the user more granular control, so new tasks can be added mid-stream when a better understanding of requirements is in place.

### Existing Code to Reference

**Similar Features Identified:**
- `.claude/commands/agent-os/bert/task-create.md` - Command pattern for task creation
- `.claude/commands/agent-os/plan-product.md` - Command that generates living documents (roadmap.md)
- `.claude/agents/agent-os/product-planner.md` - Agent that actually creates product documentation
- `agent-os/bert/tasks/` - Directory containing existing task files with frontmatter patterns
- Overall `.claude/commands` and `.claude/agents` directories - Patterns to follow for commands and agents

**Key Patterns Observed:**
- Commands are markdown files that orchestrate workflows and call agents
- Agents are specialized markdown files with specific responsibilities
- Task files follow a `task-{nn}-{slug}.md` naming pattern
- Subtasks follow `task-{nn}.{sub}-{slug}.md` pattern
- Frontmatter uses YAML format with fields like status, created date, etc.
- The task-create command supports `-p` flag for parent task number

### Follow-up Questions

**Follow-up 1: Overlay Implementation Approach**
For the overlay concept, here are three possible approaches:
- Option A: Create bert/overlays/plan-product.md with additional instructions, invoked like /agent-os:plan-product @bert/overlays/plan-product
- Option B: Create wrapper command /agent-os:bert:plan-product that reads the original and appends bert-specific instructions
- Option C: Create bert/includes/living-docs.md snippet that users manually reference when calling /agent-os:plan-product

Which approach aligns with your vision of "overlaying" without modifying agent-os? Or is there a different mechanism?

**Answer:** I need your help to understand how an AI engine via Claude Code can be instructed. Ideal scenario:
- When I start a chat session, I tell the AI I am using agent-os with bert
- Whenever an agent-os slash command is given, AI looks for a bert overlay and uses it if it exists
- Want something like `/agent-os:bert:start` or similar - invoked once and then in AI context for the duration of the session
- **ACTION NEEDED**: Help me understand what mechanism best works here

**Follow-up 2: Task Numbering for Nested Subtasks**
When running -p 4.1 to create subtasks under task-04.1-foo.md, should numbering be:
- task-04.1.1-bar.md, task-04.1.2-baz.md (dots throughout), OR
- task-04-1-1-bar.md, task-04-1-2-baz.md (dashes throughout)?

In the parent file, should it show:
- `- [ ] 4.1.1 Task description` OR
- `- [ ] 4.01.01 Task description` (zero-padded for sorting)?

**Answer:** Dots throughout - `task-04.1.1-bar.md`, `task-04.1.2-baz.md`

**Follow-up 3: Zero-padding in Task Lists**
For the checkbox tasks in parent files, should they be zero-padded?

**Answer:** Zero-padded for major, no padding for minor - `- [ ] 4.01.1 Task description` (get a bit smarter with the padding)

**Follow-up 4: Include Directive Format**
For the living document update "include", what format would be easiest?
- File path reference: @bert/includes/update-living-docs.md in prompt
- Special syntax: #include:bert:living-docs
- Conventional location: Users copy text from bert/includes/living-docs.md

**Answer:** More english, less syntax/code-like. User could say "include bert where appropriate" and AI does the needful. Ideally it's in the context with the `/agent-os:bert:start` or something like that.

**Follow-up 5: bert/config.yml Structure**
Should it look like a structured YAML with field definitions, or simpler?

**Answer:** See frontmatter that Claude Code understands at https://docs.claude.com/en/docs/claude-code/slash-commands#frontmatter - use that maybe along with basic frontmatter for our own purposes to track the task.

## Claude Code Documentation Research

### Session Context Mechanism Analysis

Based on research of Claude Code documentation, here are key findings:

**Slash Command System:**
- Commands are markdown files stored in `.claude/commands/` (project) or `~/.claude/commands/` (personal)
- Support frontmatter for configuration (allowed-tools, description, model, argument-hint, disable-model-invocation)
- Support namespacing through subdirectory structures (e.g., `.claude/commands/agent-os/bert/`)
- Can execute bash commands with `!` prefix and reference files with `@` prefix
- Support argument placeholders: `$ARGUMENTS`, `$1`, `$2`, etc.

**Frontmatter Fields Supported by Claude Code:**
1. `allowed-tools` - Specifies which tools can be used with the command
2. `argument-hint` - Provides guidance on expected command arguments
3. `description` - Brief explanation of the command
4. `model` - Specifies a particular AI model for the command
5. `disable-model-invocation` - Prevents automatic command invocation

**Session Context Limitations:**
- No built-in mechanism for "session initialization" commands that persist context
- Commands are invoked individually, context is not automatically shared between commands
- No native "overlay" or "include" system in Claude Code's slash command framework

### Recommended Session Context Approach

**Option 1: Session Initialization Command (Recommended)**

Create `/agent-os:bert:start` that:
1. Sets up session context by explicitly instructing Claude about bert overlay awareness
2. Provides directive text that tells Claude to check for bert overlays before executing agent-os commands
3. User runs this once at session start, and Claude maintains this context through conversation memory

**Implementation:**
- Create `.claude/commands/agent-os/bert/start.md`
- Command outputs comprehensive instructions that establish session-level awareness
- Uses natural language to tell Claude: "For the rest of this session, whenever you see an agent-os command, check if a bert overlay exists and merge those instructions"

**Option 2: Wrapper Commands**

Create bert-specific wrapper commands like:
- `/agent-os:bert:plan-product` that calls original + overlay
- Requires creating duplicate commands for each overlaid feature
- More explicit but less elegant than Option 1

**Recommendation:**
Use Option 1 (Session Initialization) because:
- Aligns with user's desire for "invoked once and then in AI context"
- Leverages Claude's conversation memory rather than technical mechanisms
- More flexible - works with natural language like "include bert where appropriate"
- Doesn't require wrapper commands for every agent-os feature

### Living Document "Include" Approach

Since Claude Code doesn't have a built-in include mechanism, recommend:

**Natural Language Context Pattern:**
1. Create `agent-os/bert/includes/living-docs.md` with clear instructions
2. User says "include bert living docs" or "apply bert overlay" in their prompt
3. The `/agent-os:bert:start` command primes Claude to understand these natural language includes
4. Claude reads the include file and applies those instructions

**Why this works:**
- Aligns with user's preference for "more english, less syntax/code-like"
- Uses Claude's ability to understand context and references
- Doesn't require custom syntax or parsing
- Feels natural in conversation flow

## Visual Assets

### Files Provided:
No visual assets provided (checked via bash command).

## Requirements Summary

### Functional Requirements

**1. Session Initialization Command: `/agent-os:bert:start`**
- Creates session-level context awareness for bert overlays
- Invoked once at the start of a chat session
- Establishes that AI should:
  - Check for bert overlays when agent-os commands are used
  - Understand natural language includes like "include bert" or "apply bert overlay"
  - Maintain this awareness throughout the session via conversation memory
- Outputs confirmation that bert overlay system is active

**2. Task-Author Command: `/agent-os:bert:task-author`**
- Accepts broad, high-level input (file paths OR abstract requests)
- Examples:
  - "I want to make agent-os/product/roadmap.md more accurate"
  - "improve error handling in the authentication system"
- Intelligently parses user intent from abstract requests
- Reads referenced files or analyzes codebase based on input
- Generates a PARENT task file only: `task-{nn}-{slug}.md`
- Parent task contains:
  - Analysis of improvement areas
  - List of specific improvements in ## Tasks section with checkboxes
  - Context about WHY improvements matter (not just WHAT)
- Does NOT auto-generate subtask files - user decides which to pursue

**3. Nested Task Numbering Enhancement**
- Extend existing task-create command to support deep nesting
- Format: `task-{nn}.{sub}.{subsub}-{slug}.md`
- Examples:
  - `task-04.1.1-bar.md`
  - `task-04.1.2-baz.md`
  - `task-04.2.1-qux.md`
- Use dots (.) as separators in filenames, not dashes
- Support `-p 4.1` to create subtasks under task-04.1-foo.md
- Support `-p 4.1.2` to create sub-subtasks under task-04.1.2-bar.md

**4. Smart Task Numbering in Parent Files**
- When updating parent files with task numbers, use smart zero-padding
- Format: `{nn}.{padded-sub}.{unpadded-subsub}`
- Examples:
  - `- [ ] 4.01 Task description` (top level under task 4)
  - `- [ ] 4.01.1 Task description` (sub-subtask under 4.1)
  - `- [ ] 4.01.2 Task description` (another sub-subtask)
  - `- [ ] 4.10.1 Task description` (handles double digits correctly)
- Zero-pad the immediate child level for sorting, but not grandchildren

**5. Living Document Tracking System**
- Use HTML comment markers for section status tracking
- Format: `<!-- bert:status={status}, updated={date} -->`
- Placed immediately after h3 (###) headings
- Example:
  ```markdown
  ### Completed Features
  <!-- bert:status=reviewed, updated=2025-10-14 -->
  ```
- Statuses: draft, in-progress, reviewed, needs-update
- Does not interfere with rendering or existing markdown parsers

**6. Bert Overlay System**
- Create overlay files in `agent-os/bert/overlays/`
- Overlay files named to match original commands: `plan-product.md`
- Contains ADDITIONAL instructions to merge with original command
- Activated when user has run `/agent-os:bert:start` in session
- User can invoke overlays naturally: "use agent-os plan-product with bert overlay"

**7. Living Document Include Directive**
- Create `agent-os/bert/includes/living-docs.md` with instructions
- NOT a slash command - it's an include file
- User references naturally: "include bert living docs", "apply bert overlay"
- Instructions tell AI to:
  - Add status comments to h3 headings when creating/updating files
  - Update status when sections are modified
  - Track last-updated dates

**8. Configuration File: `agent-os/bert/config.yml`**
- Stores frontmatter field definitions for bert tasks
- Defines which Claude Code frontmatter fields to use (from official spec)
- Defines bert-specific fields for task tracking
- Can be evolved over time as requirements solidify
- Structure:
  ```yaml
  # Claude Code standard frontmatter (optional - command-specific)
  claude_frontmatter:
    allowed_tools: []
    description: ""
    model: ""
    argument_hint: ""

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
      - draft
      - in-progress
      - reviewed
      - needs-update
    comment_format: "<!-- bert:status={status}, updated={date} -->"
  ```

### Non-Functional Requirements

- Must not modify existing agent-os commands or agents
- Must not "clobber" existing agent-os functionality
- Should handle abstract user intent, not just explicit file paths
- Flexible enough to support granular, mid-stream task additions
- Session context must persist through conversation memory (no technical persistence needed)
- Natural language interaction preferred over rigid syntax
- Must work within Claude Code's existing slash command framework

### Reusability Opportunities

- Reuse command structure patterns from `.claude/commands/agent-os/`
- Reuse agent patterns from `.claude/agents/agent-os/`
- Extend (don't replace) existing task-create logic
- Reference product-planner agent for file analysis patterns
- Follow existing frontmatter conventions with extensions

### Scope Boundaries

**In Scope:**
- Creating `/agent-os:bert:start` session initialization command
- Creating `/agent-os:bert:task-author` command
- Generating parent task files with improvement recommendations
- Supporting both file-path and abstract input for task-author
- Enhancing task-create to support deep nesting (4.1.1, 4.1.2, etc.)
- Smart zero-padding in parent task lists
- Creating `agent-os/bert/config.yml` for configuration
- Implementing living document tracking via HTML comments
- Creating bert overlay system (overlays directory + activation via start command)
- Creating living document include directive (includes/living-docs.md)
- Supporting natural language overlay/include invocation

**Out of Scope:**
- Automatic subtask file generation by task-author (only parent files)
- Backward compatibility for existing files
- Automatic triggering of living document updates on task completion
- Over-ambitious features beyond core iteration needs
- Tracking who made updates (only timestamps)
- Version history for living document sections
- Modifying existing agent-os commands directly
- Creating wrapper commands for every agent-os feature
- Technical persistence mechanisms (rely on conversation memory)

### Technical Considerations

**Command Structure:**
- All commands in `.claude/commands/agent-os/bert/`
- Follow markdown format with optional frontmatter
- Commands orchestrate workflows, delegate to agents if needed
- Use `$ARGUMENTS`, `$1`, `$2` for parameter handling

**Session Context Pattern:**
- `/agent-os:bert:start` uses natural language to establish session context
- Relies on Claude's conversation memory, not technical persistence
- Outputs clear instructions that Claude retains throughout session
- Tells Claude to check `agent-os/bert/overlays/` before executing agent-os commands

**Overlay Implementation:**
- Overlay files in `agent-os/bert/overlays/` named to match original commands
- Example: `agent-os/bert/overlays/plan-product.md`
- Contains additional instructions to merge with original command
- Activated through session context set by `/agent-os:bert:start`
- Natural invocation: "run plan-product with bert overlay" or "include bert for plan-product"

**Include Mechanism:**
- Include files in `agent-os/bert/includes/` (e.g., `living-docs.md`)
- NOT slash commands - they're instruction files
- User references naturally in prompts: "include bert living docs"
- Claude reads the file and applies instructions based on session context

**Task Numbering Logic:**
- Filenames: Use dots as separators (task-04.1.1-slug.md)
- Parent file checkboxes: Smart padding (4.01.1, 4.10.2)
- Algorithm for padding:
  - Find max number at each level
  - Pad immediate child level to accommodate max
  - Don't pad grandchildren levels
  - Example: If max subtask is 12, use 4.01 through 4.12

**Living Document Comments:**
- Format: `<!-- bert:status={status}, updated={date} -->`
- Insert immediately after h3 headings (on same line or next line)
- Use YAML-like syntax within comment for easy parsing
- Statuses defined in config.yml
- Don't interfere with markdown rendering

**Configuration Structure:**
- YAML format in `agent-os/bert/config.yml`
- Three main sections: claude_frontmatter, task_frontmatter, living_docs
- Evolvable - can add fields over time
- Used by commands to determine frontmatter structure
- Used by living docs include to determine status options

**File Analysis for Task-Author:**
- For file paths: Read file directly, analyze structure and content
- For abstract requests:
  - Search codebase for relevant files
  - Ask user for confirmation if multiple matches
  - Analyze identified files
- Generate parent task with specific improvement areas
- Include rationale for each improvement (the "why")

**Integration Points:**
- Extends existing task-create command (don't replace)
- References plan-product pattern for file generation
- Uses product-planner pattern for analysis
- Follows existing frontmatter conventions
- Leverages Claude Code's file reference (@) and bash (!) capabilities

## Technical Notes

### Task Numbering Implementation

**File Naming Pattern:**
- Top-level: `task-{nn}-{slug}.md` (e.g., `task-04-improve-auth.md`)
- First-level subtasks: `task-{nn}.{sub}-{slug}.md` (e.g., `task-04.1-review-tokens.md`)
- Second-level subtasks: `task-{nn}.{sub}.{subsub}-{slug}.md` (e.g., `task-04.1.1-jwt-analysis.md`)
- Supports arbitrary nesting depth: `task-04.1.2.3-{slug}.md`

**Checkbox Numbering in Parent Files:**
```markdown
## Tasks

- [ ] 4.01 Review authentication flow
- [ ] 4.02 Improve token handling
- [ ] 4.03 Add rate limiting
...
- [ ] 4.10 Update documentation
- [ ] 4.11 Add integration tests
```

For subtasks (in task-04.1-review-tokens.md):
```markdown
## Tasks

- [ ] 4.01.1 Analyze JWT implementation
- [ ] 4.01.2 Review OAuth2 flow
- [ ] 4.01.3 Check session management
```

**Padding Algorithm:**
1. Scan existing tasks at the target level
2. Determine maximum task number
3. Calculate digits needed: `max_digits = len(str(max_num))`
4. Apply padding to immediate child level only
5. Format: `{parent}.{child.zfill(max_digits)}.{grandchild}`

### Frontmatter Structure

**Based on Claude Code Documentation:**

Commands support these frontmatter fields:
- `allowed-tools` - Array of tool names permitted for this command
- `argument-hint` - String showing expected argument format
- `description` - Brief command description
- `model` - Specific AI model to use
- `disable-model-invocation` - Boolean to prevent auto-invocation

**Bert Task Files:**
```yaml
---
# Bert-specific fields
status: pending          # pending | in-progress | completed | blocked
created: 2025-10-14     # YYYY-MM-DD
updated: 2025-10-14     # YYYY-MM-DD (optional)
parent: 4.1             # Parent task number (optional, for subtasks)
related: [2.3, 3.5]     # Related task numbers (optional)
---

# Task Title

## Description
[Task description...]

## Tasks
- [ ] 4.01.1 First subtask
- [ ] 4.01.2 Second subtask
```

### Session Context Approach

**How `/agent-os:bert:start` Works:**

1. User runs `/agent-os:bert:start` at beginning of session
2. Command outputs comprehensive context-setting instructions:
   ```
   For this session, I'm using the agent-os framework with the bert addon.

   The bert addon provides overlays and enhancements to agent-os commands:
   - Overlay files are located in agent-os/bert/overlays/
   - Include files are located in agent-os/bert/includes/
   - When I reference "bert overlay" or "include bert", check these directories
   - Apply bert instructions in addition to standard agent-os behavior

   Specifically:
   - When I use agent-os commands and mention "with bert overlay", check for overlay file
   - When I say "include bert living docs", read agent-os/bert/includes/living-docs.md
   - When creating tasks, reference agent-os/bert/config.yml for frontmatter structure

   Please acknowledge that you understand these bert conventions for this session.
   ```

3. Claude acknowledges and maintains this context through conversation memory
4. User can then naturally invoke: "Run plan-product with bert overlay" or "include bert when updating this file"
5. Claude checks appropriate directories and merges instructions

**Why This Works:**
- Claude Code maintains conversation context across commands
- No technical persistence needed - uses Claude's natural context window
- Aligns with "more english, less syntax" preference
- Flexible and extensible

### Overlay System Implementation

**Directory Structure:**
```
agent-os/bert/
├── config.yml
├── overlays/
│   ├── plan-product.md       # Overlay for /agent-os:plan-product
│   └── implement-spec.md     # Overlay for /agent-os:implement-spec (future)
├── includes/
│   ├── living-docs.md        # Living document directives
│   └── smart-analysis.md     # Code analysis directives (future)
└── tasks/
    └── [task files]
```

**Overlay File Format (plan-product.md):**
```markdown
# Bert Overlay: Plan Product

This overlay adds living document tracking to the plan-product command.

## Additional Instructions

When generating product documentation files (mission.md, roadmap.md, tech-stack.md):

1. **Add Status Comments to H3 Headings:**
   - After each ### heading, add: `<!-- bert:status=draft, updated=YYYY-MM-DD -->`
   - Use current date for initial creation
   - Initial status should be "draft"

2. **Example:**
   ```markdown
   ### Completed Features
   <!-- bert:status=draft, updated=2025-10-14 -->

   [Content here...]
   ```

3. **Apply to These Files:**
   - agent-os/product/roadmap.md (all h3 headings)
   - agent-os/product/mission.md (all h3 headings if present)
   - agent-os/product/tech-stack.md (all h3 headings if present)

4. **Status Values:**
   - draft: Initial creation
   - in-progress: Currently being updated
   - reviewed: Reviewed and accurate
   - needs-update: Identified as needing revision

This allows these documents to become "living documents" that can be incrementally updated.
```

**Include File Format (living-docs.md):**
```markdown
# Bert Include: Living Document Updates

When updating files that contain bert status comments:

## Rules

1. **Locate Status Comments:**
   - Look for `<!-- bert:status=X, updated=YYYY-MM-DD -->`
   - These appear after h3 (###) headings

2. **Update Status When Modifying Section:**
   - If you edit content under a heading with status comment
   - Update the status comment:
     - Change status to "reviewed" if improvements were made
     - Update date to current date (YYYY-MM-DD format)
   - Example: `<!-- bert:status=reviewed, updated=2025-10-14 -->`

3. **Add Status Comments If Missing:**
   - If editing a section that doesn't have a status comment
   - Add one with status="in-progress" and current date

4. **Status Transitions:**
   - draft → in-progress (when first edit is made)
   - draft → reviewed (if comprehensive review completed)
   - in-progress → reviewed (when edits are complete and verified)
   - reviewed → needs-update (if identified as outdated, but not yet fixed)
   - needs-update → in-progress (when starting to address updates)

5. **Preserve Comments:**
   - Never remove bert status comments
   - Always update them when modifying content
```

## Implementation Checklist

### Phase 1: Core Infrastructure
- [ ] Create `agent-os/bert/config.yml` with frontmatter definitions
- [ ] Create directory structure: overlays/, includes/
- [ ] Create `/agent-os:bert:start` command
- [ ] Test session context persistence

### Phase 2: Task Author Command
- [ ] Create `/agent-os:bert:task-author` command
- [ ] Implement file path parsing
- [ ] Implement abstract request parsing
- [ ] Implement file analysis logic
- [ ] Implement parent task generation
- [ ] Test with various input types

### Phase 3: Enhanced Task Numbering
- [ ] Update task-create command for deep nesting
- [ ] Implement dots-in-filename logic
- [ ] Implement smart zero-padding algorithm
- [ ] Support `-p 4.1` style parent specification
- [ ] Test multi-level nesting (4.1.1, 4.2.3, etc.)

### Phase 4: Living Document System
- [ ] Create overlay: `agent-os/bert/overlays/plan-product.md`
- [ ] Create include: `agent-os/bert/includes/living-docs.md`
- [ ] Define status comment format in config.yml
- [ ] Test overlay activation via session context
- [ ] Test natural language include invocation

### Phase 5: Integration Testing
- [ ] Test full workflow: start → task-author → subtasks → living docs
- [ ] Test overlay merging with original commands
- [ ] Test natural language invocation patterns
- [ ] Verify no conflicts with existing agent-os functionality
- [ ] Document user workflows and examples

## Open Questions

None at this time. All major implementation decisions have been addressed through the requirements discussion and Claude Code documentation research.

## Next Steps

1. Review and confirm requirements with user
2. Begin implementation with Phase 1 (Core Infrastructure)
3. Iteratively build out remaining phases
4. Test and refine based on real usage
5. Evolve config.yml as patterns emerge
