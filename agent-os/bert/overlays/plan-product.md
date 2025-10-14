# Bert Overlay: Plan Product

This overlay adds living document tracking to the plan-product command output, enabling section-level status tracking for product documentation files.

## Purpose

When generating product documentation files (roadmap.md, mission.md, tech-stack.md), this overlay instructs Claude to add status tracking comments to all h3-level headings. This makes these documents "living documents" that can track their evolution over time without modifying the original plan-product command.

## Additional Instructions

When executing the plan-product command with this bert overlay active, apply the following additional steps:

### 1. Add Status Comments to All h3 Headings

For every h3 heading (`###`) in the generated product documentation files, add a status tracking comment immediately after the heading (on the same line or next line).

**Comment Format:**
```
<!-- bert:status=draft, updated=YYYY-MM-DD -->
```

### 2. Initial Status Settings

- **status**: Set to `draft` for all newly generated sections
- **updated**: Set to current date in YYYY-MM-DD format (e.g., 2025-10-14)

### 3. Target Files

Apply these status comments to ALL h3 headings in these files:
- `agent-os/product/roadmap.md`
- `agent-os/product/mission.md`
- `agent-os/product/tech-stack.md`

### 4. Status Values Reference

According to `agent-os/bert/config.yml`, the valid status values are:
- `draft` - Initial creation (use this for new sections)
- `in-progress` - Currently being updated
- `reviewed` - Reviewed and verified accurate
- `needs-update` - Identified as requiring revision

### 5. Comment Placement Guidelines

- Insert comment **immediately after** the h3 heading
- Acceptable placements:
  - Same line: `### Section Title <!-- bert:status=draft, updated=2025-10-14 -->`
  - Next line (preferred for readability):
    ```markdown
    ### Section Title
    <!-- bert:status=draft, updated=2025-10-14 -->
    ```
- Comments are invisible in rendered markdown but visible in source view
- Use exact YAML-like syntax for parseability: `key=value, key=value`

### 6. Example Output

```markdown
# Product Roadmap

## Phase 1: Foundation
### Completed Features
<!-- bert:status=draft, updated=2025-10-14 -->

- User authentication system
- Basic API endpoints

### In Progress
<!-- bert:status=draft, updated=2025-10-14 -->

- Database schema finalization
- Frontend component library

## Phase 2: Enhancement
### Planned Features
<!-- bert:status=draft, updated=2025-10-14 -->

- Advanced search functionality
- Real-time notifications
```

## Natural Language Activation

This overlay is activated when the user says:
- "run plan-product with bert overlay"
- "use plan-product and include bert"
- "apply bert to plan-product"
- "generate product docs with bert"

The session must be initialized with `/agent-os:bert:start` for Claude to recognize these natural language triggers.

## Integration Notes

- This overlay does NOT modify the core plan-product command file
- The overlay instructions are merged with the base command instructions at execution time
- If this overlay file is not present, plan-product executes normally without status comments
- The overlay is transparent to the end user - they see the same product documentation with added tracking capability
