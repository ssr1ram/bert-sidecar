# bert Technical Stack

## Overview

bert follows a markdown-first philosophy, prioritizing simplicity and direct communication with AI engines. The technical stack is intentionally minimal to maintain flexibility and ease of use.

---

## Core Technologies

### Primary Interface: Markdown
- **Purpose**: Primary medium for task definitions and AI communication
- **Why**: Human-readable, version-controllable, no special tools required
- **Usage**: All task definitions, includes, and feature maps stored as `.md` files

### Scripting: Bash
- **Purpose**: Installation, configuration, and system integration
- **Why**: Universal availability on Unix-like systems, simple dependency management
- **Key Files**:
  - `install.sh` - Installation script
  - Setup and configuration utilities

### Configuration: YAML
- **Purpose**: Configuration management for agent-os integration
- **Why**: Human-readable, widely supported, structured data format
- **Key Files**:
  - `agent-os/config.yml` - Command configuration
  - Task metadata (when needed)

---

## Integration Layer

### AI Code Engine Support
bert integrates with multiple AI code engines through their custom command systems:

1. **Claude Code** (Anthropic)
   - Integration: Custom slash commands via `.claude/commands/`
   - Status: Primary development target

2. **Cursor** (Anysphere)
   - Integration: Custom commands via `.cursorrules` or similar
   - Status: Supported

3. **Gemini CLI** (Google)
   - Integration: Custom command interface
   - Status: Supported

### agent-os Framework
- **Integration Type**: Addon/plugin
- **Dependencies**: Leverages agent-os context and spec system
- **Standards**: Follows agent-os directory structure and conventions

---

## Development Tools

### Version Control
- **Git**: Source control and collaboration
- **GitHub**: Repository hosting, issue tracking
- **Conventions**: Standard git workflow with meaningful commits

### Documentation
- **Markdown**: All documentation in `.md` format
- **In-code comments**: Bash scripts include descriptive comments
- **README-driven**: Feature documentation before implementation

### Testing
- **Status**: To be determined
- **Considerations**:
  - Bash script testing frameworks (bats, shunit2)
  - Integration testing with AI engines
  - Markdown validation

---

## Directory Structure

```
agent-os-addon-bert/
├── agent-os/
│   ├── bert/
│   │   ├── commands/          # Slash command definitions
│   │   ├── tasks/             # Task markdown files
│   │   ├── includes/          # Reusable task primitives
│   │   └── features/          # Feature taskmap files
│   ├── config.yml             # Configuration
│   ├── product/               # Product documentation
│   │   ├── mission.md
│   │   ├── roadmap.md
│   │   └── tech-stack.md
│   └── standards/             # Development standards
├── install.sh                 # Installation script
└── README.md                  # Project documentation
```

---

## Integration Patterns (Under Exploration)

The optimal integration approach is still being determined. Options include:

### 1. Custom Slash Commands (Current)
- **Pros**: Direct integration with AI engines, minimal setup
- **Cons**: Limited to supported AI engines, less flexible
- **Status**: Primary implementation

### 2. Custom CLI Tool
- **Pros**: Engine-agnostic, more control over functionality
- **Cons**: Requires separate installation, additional complexity
- **Status**: Under consideration

### 3. MCP Server (Model Context Protocol)
- **Pros**: Standardized AI integration, rich context sharing
- **Cons**: Newer technology, limited adoption
- **Status**: Experimental

### 4. Hybrid Approach
- **Pros**: Best of all worlds, maximum flexibility
- **Cons**: Most complex to maintain
- **Status**: Possible future direction

**Decision Criteria**: The approach that provides the best balance of:
- Ease of use for developers
- Flexibility for task authoring
- Compatibility across AI engines
- Maintenance burden

---

## Data Storage

### File-Based Storage
- **Task Files**: Individual markdown files per task
- **Feature Maps**: YAML or markdown files linking related tasks
- **Includes Library**: Markdown snippets in includes directory
- **Configuration**: YAML configuration files

**Why File-Based**:
- Version control friendly
- No database setup required
- Easy to read and edit manually
- Portable across systems
- Simple backup and sharing

### Future Considerations
- SQLite for task indexing and search
- JSON for structured metadata
- Git as a database for task history

---

## Dependencies

### Required
- **Bash** (v4.0+): Core scripting
- **Git**: Version control and installation
- **AI Code Engine**: Claude Code, Cursor, or Gemini CLI

### Optional
- **agent-os**: For full context and spec integration
- **jq**: JSON processing (if needed for API integration)
- **yq**: YAML processing (if needed for advanced config)

### Intentionally Minimal
bert aims to minimize dependencies to ensure:
- Easy installation
- Wide compatibility
- Reduced maintenance burden
- Lower barrier to contribution

---

## Development Conventions

### Markdown Standards
- Use CommonMark specification
- Front matter for metadata (YAML format)
- Consistent heading hierarchy
- Code blocks with language specification

### Bash Standards
- Follow Google Shell Style Guide basics
- Include error handling
- Descriptive variable names
- Comment complex logic

### Task Definition Standards
- Clear task descriptions
- Explicit acceptance criteria
- Context references when needed
- Include directives where applicable

### Naming Conventions
- Tasks: `task-[number]-[brief-description].md`
- Includes: `@include/[name]` or `include-[name].md`
- Features: `feature-[name]-taskmap.md` or `[name].yaml`

---

## Performance Considerations

### Optimization Targets
- Fast task lookup and loading
- Minimal startup time for commands
- Efficient context loading from agent-os
- Quick task authoring workflow

### Scalability
- Current approach: Optimized for dozens to hundreds of tasks
- Future needs: May require indexing for thousands of tasks
- File system performance is primary constraint

---

## Security & Privacy

### Current Approach
- All data stored locally
- No external API calls (except AI engines)
- No telemetry or tracking
- User controls all task data

### Future Considerations
- Secure task sharing mechanisms
- Encryption for sensitive task data
- Access control for team features
- Compliance with data regulations

---

## Evolution Strategy

### Technical Debt Management
- Prefer simple solutions initially
- Refactor when patterns emerge
- Document known limitations
- Plan architectural improvements

### Backward Compatibility
- Maintain compatibility with existing tasks
- Provide migration tools when needed
- Version configuration format
- Document breaking changes clearly

### Learning-Driven Architecture
- Experiment with integration patterns
- Validate approaches with real usage
- Iterate based on developer feedback
- Don't over-engineer prematurely

---

## Contributing

### Development Setup
1. Clone repository
2. Run `./install.sh` with LOCAL mode
3. Edit files in `agent-os/bert/`
4. Test with AI code engine
5. Submit pull request

### Technology Preferences
- Prioritize simplicity over sophistication
- Choose widely-available tools
- Minimize dependencies
- Maintain markdown-first approach
- Keep the barrier to contribution low

---

## Open Technical Questions

1. **Storage**: When should bert move from file-based to database?
2. **Indexing**: What's the best approach for fast task search?
3. **Integration**: CLI, MCP, or slash commands as primary interface?
4. **Context**: How much should bert cache vs. query from agent-os?
5. **Distribution**: Package manager distribution (brew, apt) vs. curl script?

These questions will be answered through iterative development and user feedback.
