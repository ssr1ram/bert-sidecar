---
description: Initialize bert addon session context
disable_model_invocation: false
---

# Bert Addon Session Initialization

You are now activating the **Bert (Better Enhancement and Refinement Toolkit)** addon system for this session.

## Session Context Established

For the remainder of this conversation, you now have access to the bert addon system with the following capabilities:

### Directory Locations

- **Overlays:** `agent-os/bert/overlays/`
  - Contains additional instructions to enhance standard agent-os commands
  - Example: `plan-product.md` adds living document tracking to plan-product

- **Includes:** `agent-os/bert/includes/`
  - Contains reusable instruction sets for common operations
  - Example: `living-docs.md` provides rules for updating document status comments

- **Configuration:** `agent-os/bert/config.yml`
  - Defines frontmatter structure for task files
  - Defines living document status values and comment format
  - Reference this file when creating task files or updating living documents

- **Tasks:** `agent-os/bert/tasks/`
  - Contains all bert task files with hierarchical numbering
  - Supports arbitrary nesting depth (e.g., task-04.1.2.3-*.md)

### Natural Language Activation Patterns

When the user invokes agent-os commands with bert enhancements, they may use natural language like:

- "**with bert overlay**" - Apply bert overlay to a command
- "**include bert**" - Apply bert include to an operation
- "**apply bert to**" - Apply bert enhancements to a command
- "**use bert when**" - Use bert functionality during an operation

When you see these patterns, follow this process:

1. Identify the base command being invoked (e.g., "plan-product", "implement-spec")
2. Check for a corresponding overlay file in `agent-os/bert/overlays/{command-name}.md`
3. If overlay exists: Read BOTH the base command AND the overlay file
4. Execute the base command workflow PLUS the additional instructions from the overlay
5. If overlay doesn't exist: Execute the base command normally (no error)

For include directives (e.g., "include bert living docs"):
1. Identify the include being requested (e.g., "living docs", "task tracking")
2. Check for corresponding include file in `agent-os/bert/includes/{include-name}.md`
3. Read the include file and apply its instructions to the current operation
4. If include doesn't exist: Proceed without it (no error)

### Bert Commands Available

- `/agent-os:bert:start` - This command (initialize session)
- `/agent-os:bert:task-author` - Generate parent task from file analysis or abstract request
- `/agent-os:bert:task-create` - Create subtasks with enhanced nested numbering support

### Key Behaviors

1. **Non-Intrusive:** Bert overlays and includes only activate when explicitly requested by the user through natural language
2. **Graceful Fallback:** If overlay or include files don't exist, proceed with base functionality
3. **Configuration Reference:** Always check `agent-os/bert/config.yml` for frontmatter structure and status values
4. **Session Scope:** This context remains active throughout this conversation until the session ends

## Confirmation

Bert addon is now **ACTIVE** for this session.

You can now use natural language to invoke bert enhancements, such as:
- "run plan-product with bert overlay"
- "include bert living docs when updating this file"
- "use bert task-author to analyze the roadmap"

The bert system is ready to enhance your agent-os workflow with:
- Session-aware context management
- Intelligent task authoring and nested task support
- Living document tracking with non-intrusive status comments
- Natural language overlay system for extending commands

**Ready to proceed with bert-enhanced workflows.**
