# Task Breakdown: Task Author and Living Docs

## Overview

**Feature Name:** Bert (Better Enhancement and Refinement Toolkit) Addon System
**Total Task Groups:** 6
**Total Tasks:** 38 sub-tasks across 6 main phases
**Estimated Timeline:** 4-6 weeks (incremental implementation)

## Execution Strategy

This implementation follows an incremental, dependency-aware approach where each phase builds on the previous one. Testing is integrated throughout to ensure stability at each milestone.

### Critical Path Dependencies

1. **Phase 1 (Foundation)** must complete before all other phases
2. **Phase 2 (Session Context)** enables overlay system in Phases 4-5
3. **Phase 3 (Task Author)** can proceed in parallel with Phase 2
4. **Phase 4 (Enhanced Numbering)** required before full task workflow testing
5. **Phases 5-6** depend on completion of all previous phases

---

## Phase 1: Foundation & Configuration

**Complexity:** M (Medium)
**Dependencies:** None
**Estimated Duration:** 3-5 days

### Task Group 1.1: Directory Structure Setup

- [ ] 1.1.1 Create directory structure
  - Create `agent-os/bert/overlays/` directory
  - Create `agent-os/bert/includes/` directory
  - Create `.claude/commands/agent-os/bert/` directory
  - Verify proper permissions and accessibility

- [ ] 1.1.2 Create bert configuration file
  - Create `agent-os/bert/config.yml` with complete structure
  - Define Claude Code frontmatter fields section
  - Define bert task frontmatter fields section
  - Define living document tracking configuration
  - Include status values: draft, in-progress, reviewed, needs-update
  - Define comment format template
  - Add clear inline documentation/comments

**Acceptance Criteria:**
- All directories exist and are accessible
- config.yml is valid YAML with all required sections
- Configuration follows structure defined in spec
- Comments clearly explain each configuration option

**Testing Checkpoint:**
- [ ] 1.1.3 Verify directory structure exists
  - Run `ls -R agent-os/bert/` to confirm structure
  - Verify `.claude/commands/agent-os/bert/` exists
  - Validate config.yml parses correctly as YAML

**Risk Factors:**
- Low risk: Basic file system operations
- Mitigation: Verify paths are absolute and correct for the project

---

## Phase 2: Session Initialization System

**Complexity:** M (Medium)
**Dependencies:** Phase 1
**Estimated Duration:** 4-6 days

### Task Group 2.1: Session Context Command

- [x] 2.1.1 Create start command file structure
  - Create `.claude/commands/agent-os/bert/start.md`
  - Add appropriate Claude Code frontmatter
  - Set description: "Initialize bert addon session context"
  - Set disable_model_invocation if needed for pure output

- [x] 2.1.2 Write context-setting instructions
  - Draft comprehensive session context instructions
  - Include overlay directory location: `agent-os/bert/overlays/`
  - Include includes directory location: `agent-os/bert/includes/`
  - Include config file location: `agent-os/bert/config.yml`
  - Define natural language trigger patterns:
    - "with bert overlay"
    - "include bert"
    - "apply bert to"
    - "use bert when"
  - Explain overlay merging behavior
  - Explain include file invocation pattern

- [x] 2.1.3 Add confirmation and user guidance
  - Create user-friendly confirmation message
  - List available overlays once created
  - List available includes once created
  - Provide examples of natural language usage
  - Explain session scope (conversation duration)

**Acceptance Criteria:**
- `/agent-os:bert:start` command exists and is invokable
- Command outputs clear, comprehensive context instructions
- Instructions cover all bert directories and conventions
- Natural language patterns are clearly explained
- User receives confirmation that bert is active

**Testing Checkpoint:**
- [x] 2.1.4 Test session initialization
  - Invoke `/agent-os:bert:start` in a new session
  - Verify output contains all required context elements
  - Verify confirmation message is clear and actionable
  - Test that subsequent natural language references work
  - Confirm session context persists across multiple commands

**Risk Factors:**
- Medium risk: Reliance on Claude's conversation memory
- Mitigation: Make instructions explicit and comprehensive; test persistence across multiple command invocations

---

## Phase 3: Task Author Command

**Complexity:** L (Large)
**Dependencies:** Phase 1 (config.yml)
**Estimated Duration:** 6-8 days

### Task Group 3.1: Command Structure and Input Parsing

- [ ] 3.1.1 Create task-author command file
  - Create `.claude/commands/agent-os/bert/task-author.md`
  - Add appropriate Claude Code frontmatter
  - Set allowed_tools: [Read, Bash, Glob, Grep]
  - Set argument_hint: "file path or abstract improvement request"
  - Set description: "Generate parent task identifying improvement areas"

- [ ] 3.1.2 Implement argument parsing logic
  - Accept `$ARGUMENTS` as broad user input
  - Detect if input is a file path (contains `/` or file extension)
  - Detect if input is an abstract request (natural language)
  - Handle edge cases: non-existent files, ambiguous input

- [ ] 3.1.3 Implement file path handler
  - Read specified file using @file reference
  - Verify file exists before analysis
  - Extract file content for analysis
  - Handle read errors gracefully with clear messages

- [ ] 3.1.4 Implement abstract request handler
  - Search codebase for relevant files using Glob/Grep
  - Present findings to user for confirmation
  - Allow user to refine search if needed
  - Handle case where no relevant files found

### Task Group 3.2: File Analysis and Task Generation

- [ ] 3.2.1 Implement file analysis logic
  - Analyze file structure (headings, sections, organization)
  - Identify areas lacking detail or clarity
  - Identify areas with outdated information
  - Identify missing sections or gaps
  - Generate specific, actionable improvement suggestions
  - Include rationale for WHY each improvement matters

- [ ] 3.2.2 Determine next task number
  - Scan `agent-os/bert/tasks/` directory
  - Find highest existing task number
  - Increment by 1 for new parent task
  - Handle case where no tasks exist yet (start at 01)

- [ ] 3.2.3 Generate parent task file
  - Create filename: `task-{nn}-{slug}.md` with kebab-case slug
  - Read config.yml for frontmatter requirements
  - Add required frontmatter fields:
    - status: pending
    - created: YYYY-MM-DD (current date)
  - Write task title (# Task {nn}: {Title})
  - Write description section explaining analysis context
  - Write ## Tasks section with checkboxes
  - Format tasks as: `- [ ] {nn}.01 Task description`
  - Write ## Rationale section explaining importance

- [ ] 3.2.4 Output confirmation to user
  - Display generated task file path
  - Summarize number of improvement tasks identified
  - Suggest next steps (review parent, create subtasks)
  - Explain how to use task-create for subtasks

**Acceptance Criteria:**
- Command handles both file paths and abstract requests
- File path input reads and analyzes specified file
- Abstract input searches codebase and confirms with user
- Generated parent tasks have correct frontmatter from config.yml
- Task numbers increment correctly from existing tasks
- Improvement tasks are specific and actionable
- Rationale explains WHY, not just WHAT
- No subtask files auto-generated (only parent)

**Testing Checkpoint:**
- [ ] 3.2.5 Test task-author with file path
  - Test: `/agent-os:bert:task-author agent-os/product/roadmap.md`
  - Verify file is read and analyzed
  - Verify parent task file is generated
  - Verify task number is correct
  - Verify frontmatter matches config.yml
  - Verify improvement tasks are specific

- [ ] 3.2.6 Test task-author with abstract request
  - Test: `/agent-os:bert:task-author improve error handling in authentication`
  - Verify codebase is searched
  - Verify findings are presented to user
  - Verify user can confirm/refine
  - Verify parent task generation after confirmation

- [ ] 3.2.7 Test edge cases
  - Test with non-existent file path
  - Test with ambiguous abstract request
  - Test with empty file
  - Test when no relevant files found
  - Verify all edge cases have clear error messages

**Risk Factors:**
- Medium-High risk: Complex logic with multiple paths
- Mitigation: Test each input type separately; provide clear error messages; implement step-by-step user confirmation

---

## Phase 4: Enhanced Task Numbering System

**Complexity:** L (Large)
**Dependencies:** Phase 1 (config.yml), existing task-create command
**Estimated Duration:** 7-9 days

### Task Group 4.1: Deep Nesting Support

- [ ] 4.1.1 Analyze existing task-create command
  - Read `.claude/commands/agent-os/bert/task-create.md`
  - Understand current parent flag parsing (-p)
  - Understand current numbering logic
  - Understand current file naming pattern
  - Identify extension points for nested support

- [ ] 4.1.2 Extend parent number parsing
  - Parse `-p 4` (single level) - existing behavior
  - Parse `-p 4.1` (nested level) - NEW
  - Parse `-p 4.1.2` (deep nested) - NEW
  - Parse `-p 4.1.2.3` (arbitrary depth) - NEW
  - Split on dots to extract number hierarchy
  - Validate format (numbers separated by dots)

- [ ] 4.1.3 Implement nested parent file identification
  - For `-p 4`: find `task-04-*.md` (existing)
  - For `-p 4.1`: find `task-04.1-*.md` (NEW)
  - For `-p 4.1.2`: find `task-04.1.2-*.md` (NEW)
  - Use pattern matching: `task-{parent_number}*-*.md`
  - Handle case where parent file not found (error clearly)
  - Verify only one matching parent file exists

### Task Group 4.2: Smart Padding Algorithm

- [ ] 4.2.1 Implement padding calculation logic
  - Scan existing tasks at target nesting level
  - Identify maximum task number at that level
  - Calculate required padding: `max_digits = len(str(max_num))`
  - Return padding width for immediate child level only

- [ ] 4.2.2 Implement checkbox number formatting
  - Format pattern: `{major}.{padded_child}.{unpadded_grandchild}`
  - Examples:
    - Parent 4, max child 9: `4.01`, `4.02`, ..., `4.09`
    - Parent 4, max child 12: `4.01`, `4.02`, ..., `4.12`
    - Parent 4.1, max child 3: `4.01.1`, `4.01.2`, `4.01.3`
    - Parent 4.1, max child 10: `4.01.01`, `4.01.02`, ..., `4.01.10`
  - Apply zero-padding using zfill or equivalent
  - Do NOT pad grandchild levels or beyond

- [ ] 4.2.3 Update parent file with padded numbers
  - Read parent task file
  - Locate ## Tasks section
  - Generate new checkboxes with smart padding
  - Update checkbox numbers for all subtasks
  - Preserve existing checkbox state (checked/unchecked)
  - Write updated content back to parent file

### Task Group 4.3: File Naming with Dots

- [ ] 4.3.1 Implement dotted filename generation
  - Format: `task-{nn}.{sub}.{subsub}-{slug}.md`
  - Examples:
    - Level 1: `task-04-improve-auth.md`
    - Level 2: `task-04.1-review-tokens.md`
    - Level 3: `task-04.1.1-jwt-analysis.md`
    - Level 4: `task-04.1.2.3-edge-cases.md`
  - Use dots (.) as separators, NOT dashes
  - Ensure slug is kebab-case
  - Handle arbitrary nesting depth

- [ ] 4.3.2 Generate subtask files with correct numbering
  - Create filename with dotted pattern
  - Add frontmatter with parent field: `parent: {parent_number}`
  - Add task number in title: `# Task {nn}.{sub}: {Title}`
  - Add empty ## Tasks section for potential sub-subtasks
  - Reference config.yml for frontmatter structure

**Acceptance Criteria:**
- task-create supports `-p 4.1` style parent specification
- Parent file identification works for nested levels
- Smart padding applied correctly to checkbox numbers
- Padding handles 2-digit, 3-digit, and higher task counts
- Filenames use dots consistently as separators
- Subtask files created with correct frontmatter
- Parent field correctly references parent task number

**Testing Checkpoint:**
- [ ] 4.3.3 Test single-level subtasks (baseline)
  - Create parent: `task-05-test-parent.md`
  - Run: `/agent-os:bert:task-create -p 5`
  - Verify subtasks: `task-05.1-*.md`, `task-05.2-*.md`
  - Verify parent checkboxes: `5.01`, `5.02` (if < 10 tasks)

- [ ] 4.3.4 Test nested subtasks
  - Create parent: `task-05.1-nested-parent.md`
  - Run: `/agent-os:bert:task-create -p 5.1`
  - Verify subtasks: `task-05.1.1-*.md`, `task-05.1.2-*.md`
  - Verify parent checkboxes: `5.01.1`, `5.01.2`
  - Verify padding reflects parent's child count

- [ ] 4.3.5 Test deeply nested subtasks
  - Create parent: `task-05.1.2-deep-parent.md`
  - Run: `/agent-os:bert:task-create -p 5.1.2`
  - Verify subtasks: `task-05.1.2.1-*.md`, `task-05.1.2.2-*.md`
  - Verify parent checkboxes: `5.01.2.1`, `5.01.2.2`

- [ ] 4.3.6 Test smart padding with many tasks
  - Create parent with 12 subtasks
  - Verify padding: `5.01`, `5.02`, ..., `5.12`
  - Create parent with 100+ subtasks (edge case)
  - Verify padding: `5.001`, `5.002`, ..., `5.100`

- [ ] 4.3.7 Test error cases
  - Test `-p 4.1` when parent file doesn't exist
  - Test `-p invalid` with malformed parent number
  - Test when parent file has no ## Tasks section
  - Verify all errors have clear, actionable messages

**Risk Factors:**
- High risk: Complex algorithm with many edge cases
- Mitigation: Implement incrementally; test each nesting level separately; test padding algorithm with various max values

---

## Phase 5: Living Document Tracking System

**Complexity:** M (Medium)
**Dependencies:** Phase 1 (config.yml), Phase 2 (session context)
**Estimated Duration:** 5-7 days

### Task Group 5.1: Overlay System for Plan-Product

- [x] 5.1.1 Create plan-product overlay file
  - Create `agent-os/bert/overlays/plan-product.md`
  - Add title: "# Bert Overlay: Plan Product"
  - Add description of overlay purpose
  - Add ## Additional Instructions section

- [x] 5.1.2 Write status comment insertion instructions
  - Instruct to add comments after all h3 (###) headings
  - Specify comment format: `<!-- bert:status={status}, updated={date} -->`
  - Specify initial status: "draft"
  - Specify date format: YYYY-MM-DD (current date)
  - Reference config.yml for status values
  - Provide clear examples

- [x] 5.1.3 Specify target files for overlay
  - List files to apply overlay to:
    - agent-os/product/roadmap.md
    - agent-os/product/mission.md
    - agent-os/product/tech-stack.md
  - Clarify to apply to ALL h3 headings in these files
  - Explain purpose: make documents "living documents"

- [x] 5.1.4 Document overlay activation mechanism
  - Explain natural language invocation patterns
  - Examples:
    - "run plan-product with bert overlay"
    - "use plan-product and include bert"
    - "apply bert to plan-product"
  - Reference session context from `/agent-os:bert:start`
  - Clarify overlay is merged with original command

### Task Group 5.2: Living Document Include File

- [x] 5.2.1 Create living-docs include file
  - Create `agent-os/bert/includes/living-docs.md`
  - Add title: "# Bert Include: Living Document Updates"
  - Add description of include purpose

- [x] 5.2.2 Write status comment location instructions
  - Instruct to look for `<!-- bert:status=X, updated=YYYY-MM-DD -->`
  - Explain comments appear after h3 headings
  - Explain how to identify section boundaries

- [x] 5.2.3 Write status update rules
  - Define when to update status comments
  - Rule: Update when modifying section content
  - Rule: Update date to current date
  - Rule: Change status appropriately
  - Rule: Add comment if section doesn't have one (status=in-progress)

- [x] 5.2.4 Define status transition logic
  - draft → in-progress (when first edit is made)
  - draft → reviewed (if comprehensive review completed)
  - in-progress → reviewed (when edits complete and verified)
  - reviewed → needs-update (if identified as outdated)
  - needs-update → in-progress (when starting to address updates)
  - Provide clear examples of each transition

- [x] 5.2.5 Add preservation rules
  - Never remove bert status comments
  - Always update when modifying content
  - Preserve comment structure exactly
  - Use YAML-like syntax for parseability

**Acceptance Criteria:**
- Overlay file exists with clear, comprehensive instructions
- Overlay specifies comment format matching config.yml
- Overlay targets correct files and heading levels
- Include file exists with clear status update rules
- Status transitions are well-defined and logical
- Natural language invocation patterns are documented

**Testing Checkpoint:**
- [x] 5.2.6 Test overlay with plan-product
  - Initialize session: `/agent-os:bert:start`
  - Invoke: "run plan-product with bert overlay"
  - Verify overlay file is read
  - Verify generated files have status comments
  - Verify comments appear after h3 headings
  - Verify initial status is "draft"
  - Verify dates are current

- [x] 5.2.7 Test living-docs include
  - Initialize session: `/agent-os:bert:start`
  - Create/modify a section with existing comment
  - Say: "include bert living docs when updating"
  - Verify include file is read
  - Verify status comment is updated
  - Verify date is updated to current
  - Verify status transition is appropriate

- [x] 5.2.8 Test natural language variations
  - Test: "with bert overlay"
  - Test: "include bert"
  - Test: "apply bert to"
  - Test: "use bert when"
  - Verify all variations trigger correct behavior

**Risk Factors:**
- Medium risk: Relies on session context and natural language parsing
- Mitigation: Make instructions extremely explicit; provide multiple examples; test various invocation patterns

---

## Phase 6: Integration Testing & Documentation

**Complexity:** M (Medium)
**Dependencies:** All previous phases
**Estimated Duration:** 5-7 days

### Task Group 6.1: End-to-End Workflow Testing

- [ ] 6.1.1 Test complete task authoring workflow
  - Start session: `/agent-os:bert:start`
  - Create parent task: `/agent-os:bert:task-author {file or request}`
  - Review generated parent task
  - Create first-level subtasks: `/agent-os:bert:task-create -p {nn}`
  - Create nested subtasks: `/agent-os:bert:task-create -p {nn}.{sub}`
  - Verify all task numbers and filenames correct
  - Verify all frontmatter correct
  - Verify smart padding works across levels

- [ ] 6.1.2 Test living document workflow
  - Start session: `/agent-os:bert:start`
  - Generate docs: "run plan-product with bert overlay"
  - Verify status comments in all h3 headings
  - Modify section: "update this section, include bert living docs"
  - Verify status comment updated
  - Verify date updated
  - Verify status transition correct

- [ ] 6.1.3 Test combined workflow
  - Start session
  - Generate living documents with overlay
  - Use task-author to identify improvements
  - Create nested subtasks for improvements
  - Update living document sections as tasks complete
  - Include bert when updating
  - Verify entire workflow is smooth and intuitive

### Task Group 6.2: Edge Cases and Error Handling

- [ ] 6.2.1 Test session not initialized
  - Try using bert features without `/agent-os:bert:start`
  - Verify graceful behavior (either prompt to initialize or work without overlay)
  - Verify no errors or broken functionality

- [ ] 6.2.2 Test missing overlay files
  - Initialize session
  - Try to use overlay for command that doesn't have one
  - Verify command executes normally without overlay
  - Verify no errors

- [ ] 6.2.3 Test malformed files
  - Test task-author with corrupted file
  - Test task-create with malformed parent file
  - Test overlay with malformed status comments
  - Verify clear error messages for all cases

- [ ] 6.2.4 Test extreme nesting
  - Create task with 5+ nesting levels (4.1.2.3.4.5)
  - Verify numbering and padding work correctly
  - Test performance with very deep nesting

- [ ] 6.2.5 Test high task counts
  - Create parent with 50+ subtasks
  - Verify smart padding works (e.g., 4.01 through 4.50)
  - Create parent with 100+ subtasks
  - Verify padding adjusts (e.g., 4.001 through 4.100)

### Task Group 6.3: Compatibility Testing

- [ ] 6.3.1 Test with standard agent-os commands
  - Run standard agent-os commands without bert
  - Verify no interference or conflicts
  - Verify existing agent-os functionality unchanged

- [ ] 6.3.2 Test switching between bert and non-bert
  - Use bert features in session
  - Use standard agent-os features in same session
  - Switch back to bert features
  - Verify seamless transition

- [ ] 6.3.3 Test session persistence
  - Initialize bert session
  - Run multiple commands over extended conversation
  - Verify context persists throughout
  - Verify natural language invocations continue to work

### Task Group 6.4: Documentation and Examples

- [ ] 6.4.1 Create usage examples document
  - Document session initialization example
  - Document task-author examples (file path and abstract)
  - Document nested task creation examples
  - Document living document overlay example
  - Document living document update example
  - Include expected inputs and outputs
  - Add troubleshooting tips

- [ ] 6.4.2 Create reference documentation
  - Document all bert commands and their syntax
  - Document all overlay files and their purpose
  - Document all include files and their purpose
  - Document config.yml structure and fields
  - Document status values and transitions
  - Document natural language invocation patterns

- [ ] 6.4.3 Update project README (if exists)
  - Add section about bert addon
  - Explain how to initialize bert
  - Link to detailed documentation
  - Provide quick start guide

**Acceptance Criteria:**
- Complete workflows function smoothly from start to finish
- All edge cases handled gracefully with clear error messages
- No conflicts with existing agent-os functionality
- Session context persists reliably
- Documentation is clear, comprehensive, and accurate
- Examples are practical and demonstrate key features

**Testing Checkpoint:**
- [ ] 6.4.4 Final validation checklist
  - All 8 core features implemented and tested
  - All acceptance criteria from spec met
  - No modifications to existing agent-os files
  - Commands follow agent-os patterns consistently
  - Config.yml is complete and well-documented
  - Natural language invocation works intuitively
  - Task numbering sorts correctly in file browsers
  - Living document tracking is non-intrusive
  - Documentation covers all features and use cases

**Risk Factors:**
- Low-Medium risk: Integration issues, documentation gaps
- Mitigation: Thorough testing of all workflows; comprehensive documentation with examples; user testing feedback

---

## Success Metrics

### Feature Completeness
- [ ] All 8 main features from spec fully implemented
- [ ] All commands follow existing agent-os command patterns
- [ ] Configuration file structure established and documented
- [ ] All overlay and include files created
- [ ] Comprehensive testing completed for each phase

### User Experience
- [ ] Session initialization is one-time per conversation
- [ ] Natural language invocation works for all features
- [ ] Task authoring handles both file paths and abstract requests
- [ ] Nested task numbering sorts correctly (up to arbitrary depth)
- [ ] Living document tracking is invisible in rendered markdown
- [ ] Error messages are clear and actionable

### Technical Quality
- [ ] Zero modifications to existing agent-os files
- [ ] Overlay system activates through session context
- [ ] Smart padding algorithm handles arbitrary nesting depth
- [ ] Configuration is centralized in config.yml
- [ ] HTML comments use valid syntax
- [ ] All code follows coding standards from agent-os/standards/

### Integration
- [ ] Works seamlessly with existing agent-os workflows
- [ ] Can be used alongside standard agent-os without conflict
- [ ] Session context persists throughout conversation
- [ ] Gracefully degrades when bert not initialized
- [ ] No performance degradation

---

## Risk Management Summary

### High Risk Areas
1. **Smart Padding Algorithm (Phase 4)** - Complex logic with many edge cases
   - Mitigation: Incremental implementation; extensive testing; clear validation

2. **Session Context Persistence (Phase 2)** - Relies on Claude's memory
   - Mitigation: Explicit, comprehensive instructions; test across long conversations

### Medium Risk Areas
1. **Task Author Analysis (Phase 3)** - Abstract request handling is complex
   - Mitigation: Clear user confirmation steps; handle edge cases gracefully

2. **Natural Language Invocation (Phase 5)** - Relies on Claude's interpretation
   - Mitigation: Document multiple invocation patterns; make instructions explicit

### Low Risk Areas
1. **Directory Setup (Phase 1)** - Standard file operations
2. **Documentation (Phase 6)** - Time-intensive but low technical risk

---

## Key Milestones

1. **M1: Foundation Complete** - End of Phase 1
   - Deliverable: Directory structure and config.yml ready

2. **M2: Session System Live** - End of Phase 2
   - Deliverable: `/agent-os:bert:start` command functional

3. **M3: Core Task Features Ready** - End of Phases 3-4
   - Deliverable: task-author and enhanced task-create operational

4. **M4: Living Docs System Complete** - End of Phase 5
   - Deliverable: Overlay and include systems functional

5. **M5: Production Ready** - End of Phase 6
   - Deliverable: All features tested, documented, and validated

---

## Implementation Notes

### Testing Philosophy
- Test after each sub-task group completes, not just at phase end
- Focus on both happy path and edge cases
- Validate each feature in isolation before integration testing
- Keep test scope focused: 6-10 tests per major feature

### Incremental Approach
- Each phase builds on previous phases
- Features are independently testable
- Early phases provide immediate value
- Later phases enhance and integrate

### Standards Compliance
Ensure alignment with project standards:
- Follow coding conventions from `agent-os/standards/global/coding-style.md`
- Apply error handling patterns from `agent-os/standards/global/error-handling.md`
- Follow naming conventions from `agent-os/standards/global/conventions.md`
- Reference tech stack from `agent-os/standards/global/tech-stack.md`
- Follow comment guidelines from `agent-os/standards/global/commenting.md`

---

**Document Version:** 1.0
**Created:** 2025-10-14
**Total Estimated Duration:** 4-6 weeks
**Critical Path:** Phase 1 → Phase 2 → Phase 4 → Phase 5 → Phase 6
**Parallel Work Possible:** Phase 3 can overlap with Phase 2
