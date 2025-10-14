# bert - AI Task Management System

## Product Vision

**bert** is a granular, markdown-driven task management system designed for developers working with AI code engines. It provides a bridge between high-level product specifications and actionable development tasks, enabling developers to break down complex work into reusable, contextual directives that AI engines can execute effectively.

## Tagline

_Making AI-driven development granular, contextual, and repeatable._

## Purpose

As developers increasingly leverage AI engines (Claude Code, Cursor, Gemini CLI) to assist with software development, there's a critical gap between high-level specifications and the granular, context-aware tasks needed for effective AI collaboration. bert fills this gap by:

- **Breaking down complexity**: Transforming broad agent-os specs into granular, executable tasks
- **Preserving context**: Tapping into agent-os context and specs while working on individual tasks
- **Creating reusability**: Building primitive task components that can be included and reused
- **Enabling flexibility**: Allowing developers to extend AI workflows without modifying core frameworks

## Target Users

### Primary Personas

1. **Solo Developers using AI code engines**
   - Working with Claude Code, Cursor, or Gemini CLI
   - Need granular control over AI-driven development tasks
   - Want to build reusable task patterns

2. **Product Designers prototyping with AI**
   - Using AI to rapidly prototype features
   - Need to organize and manage development tasks
   - Want to move tasks through design and development stages

3. **agent-os Users**
   - Already using agent-os for spec-driven development
   - Need finer-grained task management within specs
   - Want to extend agent-os capabilities without core modifications

## Core Problems Solved

### 1. Task Granularity Gap
**Problem**: agent-os provides high-level spec-driven development, but lacks granular task breakdown for complex features.

**Solution**: bert enables developers to decompose agent-os tasks into smaller, manageable units while maintaining context from the parent spec.

### 2. Context Loss Between Tasks
**Problem**: When working on individual tasks, developers lose access to the broader context and specifications.

**Solution**: bert maintains awareness of agent-os context and specs, allowing tasks to tap into that information as needed.

### 3. Repetitive Task Patterns
**Problem**: Common patterns (like git commits after tasks, writing output to notes) require repetitive prompting.

**Solution**: Task includes provide reusable primitives that can be easily incorporated into any task.

### 4. Non-linear Feature Development
**Problem**: Ideas for tasks come at their own pace, but linear task numbering doesn't reflect feature groupings.

**Solution**: Feature taskmaps allow logical grouping of related tasks regardless of creation order.

## Key Value Propositions

1. **Markdown-First Philosophy**: Tasks are defined in markdown, making them human-readable, version-controllable, and easily editable without special tools.

2. **Contextual Awareness**: Integration with agent-os means tasks inherit context from specs, reducing the need to re-explain background information.

3. **Incremental Workflow**: Move tasks through stages (draft → todo → in progress → in review → done) matching real development workflows.

4. **Composable Task Primitives**: Build a library of task includes that can be mixed and matched to create sophisticated AI directives.

5. **AI-Assisted Task Authoring**: Rough ideas can be fleshed out by AI engines into detailed task sets using existing context.

6. **Framework Independence Path**: While starting as an agent-os addon, bert is designed to eventually stand alone as a comprehensive AI task system.

## Success Metrics

### Adoption Metrics
- Number of active bert users within the agent-os community
- Task creation rate (tasks created per user per week)
- Task completion rate

### Effectiveness Metrics
- Time saved by using task includes vs. manual prompting
- Percentage of tasks using feature taskmaps
- Reuse rate of task primitives

### Product Evolution Metrics
- Community-contributed task includes
- Feature requests indicating new use cases
- Adoption outside agent-os ecosystem

## Evolution Path

**Phase 1 (Current)**: agent-os addon providing enhanced task management within the agent-os framework.

**Phase 2**: Standalone AI task system that can work with any AI code engine, incorporating learnings from agent-os while maintaining granular task control.

**Phase 3**: Comprehensive task/spec system that can serve as the foundation for AI-driven development workflows across different contexts and tools.

## Design Philosophy

- **Markdown as Interface**: Primary interaction with AI happens through markdown files, not custom CLIs or complex UIs
- **Exploration-Driven**: Features and integration patterns (custom slash commands, CLI, MCP server) will evolve based on what works best in practice
- **Context-First**: Tasks should leverage available context rather than requiring developers to repeatedly provide background information
- **Composability**: Small, reusable components that can be combined in flexible ways
