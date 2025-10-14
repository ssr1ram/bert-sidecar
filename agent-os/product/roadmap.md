# bert Product Roadmap

## Overview

This roadmap outlines the development phases for bert, transitioning from an agent-os addon to a standalone AI task management system. The roadmap is intentionally flexible, as feature priorities will be determined through feature taskmaps once core functionality is validated.

---

## Phase 1: Foundation (Current)

**Goal**: Establish core task management capabilities as an agent-os addon

### Completed Features
- ✅ Basic task creation through slash commands
- ✅ Task referencing and lookup
- ✅ Subtask creation and management
- ✅ Integration with agent-os framework
- ✅ Installation via curl script
- ✅ Support for Claude Code, Cursor, and Gemini CLI

### In Progress
- 🔄 Task workflow states (draft, todo, in progress, in review, done)
- 🔄 Feature taskmaps for grouping related tasks
- 🔄 Task includes/primitives library

### Near-Term Features (Q1 2025)
- **Task Author**: AI-assisted expansion of rough ideas into detailed task sets
  - Input: Brief task description from user
  - Process: AI engine uses existing context to flesh out details
  - Output: Structured task with clear directives and acceptance criteria

- **Task Kanban Management**: Move tasks through workflow states
  - Commands to transition tasks between states
  - Visual representation of task status
  - Filtering and querying by state

- **Task Includes Library**: Reusable task primitives
  - `@include/git-commit`: Directive to create git commit after task
  - `@include/notes-output`: Write AI responses to notes directory
  - `@include/test-validation`: Run tests and validate results
  - `@include/context-refresh`: Pull latest context from agent-os

### Discovery Items (Timing TBD)
These features need further exploration through task authoring and feature taskmaps:

- Task templates for common patterns
- Task dependencies and sequencing
- Task output capture and review
- Cross-project task sharing
- Task versioning and history
- Integration patterns (CLI vs MCP server vs slash commands)

---

## Phase 2: Maturation (Q2-Q3 2025)

**Goal**: Stabilize core features and expand capabilities based on user feedback

### Planned Features

**Enhanced Task Authoring**
- Multi-task generation from complex requirements
- Context-aware task suggestions
- Task refinement through AI collaboration

**Feature Taskmap System**
- Create and manage feature taskmaps
- Group tasks by feature regardless of creation order
- Navigate between related tasks
- Visualize feature completion status

**Task Lifecycle Management**
- Task editing and updates
- Task archiving and deletion
- Task search and filtering
- Task analytics (completion rates, time tracking)

**Collaboration Features**
- Task sharing between team members
- Task review and feedback workflows
- Shared task includes library

**Integration Exploration**
- Evaluate custom CLI effectiveness
- Prototype MCP server integration
- Refine slash command patterns
- Determine optimal markdown + tool combinations

### Success Criteria
- 50+ active users regularly creating tasks
- 20+ community-contributed task includes
- Clear data on which integration pattern works best
- Positive feedback on feature taskmap usability

---

## Phase 3: Independence (Q4 2025 - Q1 2026)

**Goal**: Transition bert from agent-os addon to standalone system

### Planned Features

**Standalone Operation**
- Work independently of agent-os framework
- Direct integration with AI code engines
- Self-contained context management

**Expanded Spec Integration**
- Create lightweight specs within bert
- Import specs from other systems
- Bidirectional sync with agent-os specs

**Advanced Task Patterns**
- Recursive task decomposition
- Parallel task execution planning
- Task rollback and recovery
- Task performance optimization

**Developer Experience**
- Comprehensive documentation
- Tutorial series and examples
- Community showcase of task patterns
- Plugin/extension system

### Migration Path
- Provide clear upgrade path for agent-os users
- Maintain backward compatibility with agent-os integration
- Document differences and benefits of standalone usage

---

## Phase 4: Ecosystem (2026+)

**Goal**: Establish bert as a comprehensive AI task/spec system

### Vision Features

**Multi-Engine Support**
- Support for new AI code engines as they emerge
- Engine-agnostic task definitions
- Engine-specific optimizations

**Enterprise Features**
- Team workspaces
- Task permissions and access control
- Audit trails and compliance
- Integration with project management tools

**Advanced Intelligence**
- AI-suggested task optimizations
- Pattern recognition across task libraries
- Predictive task creation
- Context optimization

**Community Platform**
- Marketplace for task templates and includes
- Community ratings and reviews
- Best practices documentation
- Training and certification

---

## Development Methodology

### Feature Development Process
1. **Idea Capture**: Document rough ideas in tasks using `/bert:task-author`
2. **Feature Mapping**: Group related tasks into feature taskmaps
3. **Prioritization**: Evaluate feature maps based on:
   - User needs and feedback
   - Technical dependencies
   - Strategic alignment
   - Resource availability
4. **Implementation**: Execute tasks within prioritized feature maps
5. **Learning**: Incorporate insights back into roadmap

### Flexibility Principle
This roadmap is a living document. As bert develops and user needs emerge, priorities will shift. The feature taskmap system itself will help organize and prioritize future development.

### Validation Gates
Before moving to next phase:
- Core features of current phase are stable
- User feedback indicates readiness
- Technical foundation supports next phase
- Clear value proposition established

---

## Open Questions

These questions will shape future roadmap decisions:

1. **Integration Pattern**: Which works best - custom CLI, MCP server, or slash commands? Or a combination?
2. **Context Management**: How much context should bert manage vs. relying on external systems?
3. **Task Granularity**: What's the optimal level of task breakdown?
4. **Collaboration Model**: Should bert focus on solo developers or expand to team features?
5. **AI Engine Evolution**: How will changes in AI capabilities affect task authoring patterns?

---

## Contributing to the Roadmap

Users can influence the roadmap by:
- Creating feature requests as tasks
- Building feature taskmaps for desired capabilities
- Contributing task includes to the community library
- Providing feedback on completed features
- Sharing usage patterns and workflows

The roadmap evolves with the community's needs and learnings from real-world usage.
