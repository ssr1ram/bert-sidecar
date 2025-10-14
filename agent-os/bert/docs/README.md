# Bert Documentation

Welcome to Bert (Better Enhancement and Refinement Toolkit) - an addon system for agent-os that provides intelligent task authoring and living document tracking.

## Quick Links

- [Getting Started](getting-started.md) - Installation and first steps
- [Command Reference](command-reference.md) - Complete command documentation
- [Examples & Use Cases](examples.md) - Practical examples
- [Troubleshooting](troubleshooting.md) - Common issues and solutions

## What is Bert?

Bert extends agent-os with:

1. **Intelligent Task Authoring** - Generate detailed task breakdowns from file analysis or abstract requests
2. **Deep Nested Tasks** - Support for arbitrary depth task hierarchies (4.1.2.3.4...)
3. **Smart Numbering** - Automatic padding for proper task sorting
4. **Living Documents** - Track section-level review status in generated docs
5. **Natural Language Overlays** - Extend agent-os commands without modifying them

## Core Features

### Session-Aware Context
Initialize bert once per conversation and use natural language to activate features throughout your session.

### Task Author Command
Analyze files or abstract concepts to generate actionable improvement tasks with clear rationale.

### Enhanced Task Numbering
Create deeply nested subtasks with automatic smart padding that ensures proper sorting at any depth.

### Living Document Tracking
Non-intrusive HTML comments track review status in markdown documents without affecting rendering.

### Overlay System
Extend existing agent-os commands with bert functionality using natural language invocation.

## Getting Started

1. **Initialize Session**
   ```
   /agent-os:bert:start
   ```

2. **Create Your First Task**
   ```
   /agent-os:bert:task-author agent-os/product/roadmap.md
   ```

3. **Create Subtasks**
   ```
   /agent-os:bert:task-create -p 3
   ```

See [Getting Started Guide](getting-started.md) for detailed walkthrough.

## Documentation Structure

- **getting-started.md** - Step-by-step setup and first tasks
- **command-reference.md** - Detailed command documentation
- **examples.md** - Real-world usage examples
- **troubleshooting.md** - Common issues and solutions
- **architecture.md** - Technical architecture and design decisions
- **contributing.md** - How to extend bert

## Support

For issues or questions:
- Check the [Troubleshooting Guide](troubleshooting.md)
- Review [Examples](examples.md) for common patterns
- See agent-os documentation for base functionality

## Philosophy

Bert follows the principle of "more English, less syntax" - using natural language and conversation context rather than rigid command structures. It extends agent-os without modifying it, providing graceful fallback when features aren't available.
