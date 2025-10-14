# Bert Examples and Use Cases

Real-world examples of using bert for task management and documentation.

---

## Example 1: Improving Product Documentation

### Scenario
You have a roadmap.md file that needs more detail and clarity.

### Workflow

**Step 1: Initialize Session**
```
/agent-os:bert:start
```

**Step 2: Analyze the Roadmap**
```
/agent-os:bert:task-author agent-os/product/roadmap.md
```

**Output:**
```
Created: agent-os/bert/tasks/task-03-enhance-roadmap-detail.md

Identified 10 improvement areas:
- Add acceptance criteria to in-progress features
- Define success metrics for Phase 1
- Add timeline estimates for near-term features
- Elaborate on technical architecture for discovery items
- Add examples for task include types
- Define validation criteria for phase transitions
- Add technical dependencies between phases
- Expand integration exploration section
- Define metrics for success criteria
- Add rollback strategies for features
```

**Step 3: Review the Parent Task**

Open `task-03-enhance-roadmap-detail.md`:

```markdown
---
status: pending
created: 2025-10-14
---

# Task 03: Enhance Roadmap Detail and Clarity

## Description

After analyzing agent-os/product/roadmap.md, several sections would benefit
from enhanced detail and specificity...

## Tasks

- [ ] 3.01 Add acceptance criteria to in-progress features
- [ ] 3.02 Define success metrics for Phase 1
- [ ] 3.03 Add timeline estimates for near-term features
...

## Rationale

The roadmap provides excellent strategic vision but lacks tactical details
needed for execution...
```

**Step 4: Create Subtasks**
```
/agent-os:bert:task-create -p 3
```

**Output:**
```
Created 10 subtask files:
- task-03.1-add-acceptance-criteria.md
- task-03.2-define-success-metrics.md
- task-03.3-add-timeline-estimates.md
...

Updated parent: task-03-enhance-roadmap-detail.md
```

**Step 5: Break Down Complex Subtask**

One subtask needs more detail:

```
/agent-os:bert:task-create -p 3.1
```

**Output:**
```
Created nested subtasks:
- task-03.1.1-define-workflow-states-criteria.md
- task-03.1.2-define-taskmaps-criteria.md
- task-03.1.3-define-includes-criteria.md
```

**Result:** Clear hierarchy of tasks from high-level improvements down to specific implementation details.

---

## Example 2: Abstract Request for Error Handling

### Scenario
You want to improve error handling but don't know which files need work.

### Workflow

**Step 1: Make Abstract Request**
```
/agent-os:bert:task-author improve error handling in authentication
```

**Bert Response:**
```
Searching codebase for authentication-related files...

Found:
- src/auth/jwt-validator.js
- src/auth/oauth-handler.js
- lib/auth.js
- config/auth.yml
- test/auth/auth-test.js

Would you like me to analyze these files?
```

**Your Response:**
```
Yes, analyze those files
```

**Output:**
```
Created: agent-os/bert/tasks/task-06-improve-auth-error-handling.md

Identified 10 improvement areas:
- Add specific error codes for JWT validation failures
- Implement user-friendly error messages for failed logins
- Add structured logging for authentication events
- Create error recovery flow for expired tokens
- Add monitoring alerts for suspicious patterns
...
```

**Step 2: Create Subtasks**
```
/agent-os:bert:task-create -p 6
```

**Result:** From a vague request to concrete, actionable tasks.

---

## Example 3: Living Document Workflow

### Scenario
Generate product documentation with status tracking that updates as you work.

### Workflow

**Step 1: Initialize Bert**
```
/agent-os:bert:start
```

**Step 2: Generate Documents with Overlay**
```
run plan-product with bert overlay
```

**Output:**
```
Generated:
- agent-os/product/mission.md
- agent-os/product/roadmap.md
- agent-os/product/tech-stack.md

All h3 headings have status tracking comments added.
```

**Step 3: Check Generated File**

Open `agent-os/product/roadmap.md`:

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
```

**Step 4: Update a Section**
```
I need to update the "Completed Features" section with more details.
Include bert living docs to track the changes.
```

**Bert Process:**
1. Reads living-docs include file
2. Modifies section content
3. Updates status comment

**Updated Section:**
```markdown
### Completed Features
<!-- bert:status=reviewed, updated=2025-10-15 -->

- User authentication system (JWT-based, OAuth2 support)
- Basic API endpoints (CRUD operations for users, tasks)
- Rate limiting (100 requests/minute per user)
- API documentation (OpenAPI 3.0 spec)
```

**Status changed:** `draft` → `reviewed`
**Date updated:** `2025-10-14` → `2025-10-15`

**Step 5: Mark Section Needing Update**
```
The "In Progress" section is outdated. Mark it as needs-update.
Include bert living docs.
```

**Updated:**
```markdown
### In Progress
<!-- bert:status=needs-update, updated=2025-10-15 -->

- Database schema finalization
- Frontend component library
```

**Result:** Living document with section-level tracking that evolves over time.

---

## Example 4: Deep Task Nesting

### Scenario
Break down a complex feature into multiple levels of detail.

### Workflow

**Step 1: Create Parent Task**
```
/agent-os:bert:task-author agent-os/product/tech-stack.md
```

**Creates:** `task-07-enhance-tech-stack-documentation.md`

**Step 2: Create First-Level Subtasks**
```
/agent-os:bert:task-create -p 7
```

**Creates:**
```
task-07.1-add-backend-framework-details.md
task-07.2-add-frontend-framework-details.md
task-07.3-add-database-details.md
task-07.4-add-devops-details.md
```

**Step 3: Drill Into Backend Details**
```
/agent-os:bert:task-create -p 7.1
```

**Creates:**
```
task-07.1.1-document-api-framework.md
task-07.1.2-document-authentication-library.md
task-07.1.3-document-orm-choice.md
```

**Step 4: Drill Even Deeper**
```
/agent-os:bert:task-create -p 7.1.1
```

**Creates:**
```
task-07.1.1.1-document-routing-patterns.md
task-07.1.1.2-document-middleware-stack.md
task-07.1.1.3-document-error-handling.md
```

**Step 5: One More Level**
```
/agent-os:bert:task-create -p 7.1.1.1
```

**Creates:**
```
task-07.1.1.1.1-document-route-definitions.md
task-07.1.1.1.2-document-route-validation.md
```

**Task Hierarchy:**
```
task-07-enhance-tech-stack-documentation.md
  └── task-07.1-add-backend-framework-details.md
      └── task-07.1.1-document-api-framework.md
          └── task-07.1.1.1-document-routing-patterns.md
              └── task-07.1.1.1.1-document-route-definitions.md
```

**All files sort correctly!**

**Parent file checkbox numbers:**
```markdown
# In task-07.1.1.1-document-routing-patterns.md

## Tasks

- [ ] 7.01.1.1.1 Document route definitions
- [ ] 7.01.1.1.2 Document route validation
- [ ] 7.01.1.1.3 Document route error handling
```

**Smart padding applied:** `7.01.1.1.1` (pads `.01` only)

---

## Example 5: Combining Task Author with Living Docs

### Scenario
Use task-author to identify documentation improvements, then update docs with tracking.

### Workflow

**Step 1: Identify Improvements**
```
/agent-os:bert:task-author agent-os/product/mission.md
```

**Creates:** `task-08-enhance-mission-clarity.md` with specific improvements

**Step 2: Update Mission Document**
```
Update the mission.md file based on task 8.1 suggestions.
Include bert living docs to track changes.
```

**Bert Process:**
1. Reads task-08.1 for guidance
2. Updates mission.md sections
3. Updates status comments as it goes

**Before:**
```markdown
### Target Audience
<!-- bert:status=draft, updated=2025-10-14 -->

Solo developers and small teams
```

**After:**
```markdown
### Target Audience
<!-- bert:status=reviewed, updated=2025-10-15 -->

**Primary:** Solo developers building AI-powered applications
- Independent developers working with AI code engines
- Freelancers managing client projects with AI assistance
- Open source maintainers coordinating AI-assisted development

**Secondary:** Small teams (2-5 developers)
- Startup teams rapidly prototyping features
- Small agencies delivering client work
- Research teams building experimental systems
```

**Step 3: Mark Task Complete**
```
Update task-08.1 status to completed
```

**Result:** Improved documentation with tracking, clear audit trail of what changed and when.

---

## Example 6: Natural Language Variations

### Scenario
Testing different ways to invoke bert features.

### All These Work:

**Overlay Invocation:**
```
run plan-product with bert overlay
use plan-product and include bert
apply bert to plan-product
execute plan-product with bert enhancement
```

**Include Invocation:**
```
include bert living docs when updating
use bert to track changes
apply bert overlay while modifying
track changes with bert living docs
```

**Task Creation:**
```
create subtasks for task 5
make subtasks under task 5
break down task 5 into subtasks
expand task 5
```

**Result:** Natural language flexibility reduces need to memorize exact syntax.

---

## Example 7: Multi-Phase Project Planning

### Scenario
Plan a large project with multiple phases and dependencies.

### Workflow

**Phase 1: Identify High-Level Tasks**
```
/agent-os:bert:task-author plan a multi-tenant SaaS authentication system
```

**Creates:** `task-09-plan-saas-authentication.md`

```markdown
## Tasks

- [ ] 9.01 Research multi-tenancy patterns
- [ ] 9.02 Design database schema for tenant isolation
- [ ] 9.03 Plan authentication flow
- [ ] 9.04 Plan authorization system
- [ ] 9.05 Design API security
```

**Phase 2: Expand Each Area**
```
/agent-os:bert:task-create -p 9
```

Creates 5 subtasks (9.1 through 9.5)

**Phase 3: Deep Dive on Schema Design**
```
/agent-os:bert:task-create -p 9.2
```

**Creates:**
```
task-09.2.1-evaluate-schema-strategies.md
task-09.2.2-design-tenant-table-structure.md
task-09.2.3-design-data-isolation-mechanism.md
task-09.2.4-plan-migration-strategy.md
```

**Phase 4: Implementation Details**
```
/agent-os:bert:task-create -p 9.2.3
```

**Creates:**
```
task-09.2.3.1-implement-row-level-security.md
task-09.2.3.2-implement-tenant-scoping.md
task-09.2.3.3-implement-data-validation.md
```

**Result:** Project broken down from high-level vision to implementation tasks.

**Task Count:**
- Level 1: 1 task (task-09)
- Level 2: 5 tasks (9.1 - 9.5)
- Level 3: 4 tasks (9.2.1 - 9.2.4)
- Level 4: 3 tasks (9.2.3.1 - 9.2.3.3)
- **Total: 13 tasks** organized hierarchically

---

## Example 8: Refactoring Documentation

### Scenario
Existing documentation needs restructuring based on user feedback.

### Workflow

**Step 1: Analyze Current State**
```
/agent-os:bert:task-author agent-os/product/tech-stack.md
```

**Creates:** Parent task identifying restructuring needs

**Step 2: Generate Living Docs**
```
run plan-product with bert overlay
```

**Step 3: Work Through Improvements**

For each improvement task:
```
Update tech-stack.md section on [topic].
Include bert living docs to track progress.
```

**Step 4: Track Progress**

Check which sections still need work:
```bash
# Search for sections needing updates
grep -r "needs-update" agent-os/product/
```

**Output:**
```
agent-os/product/tech-stack.md:<!-- bert:status=needs-update, updated=2025-10-14 -->
agent-os/product/roadmap.md:<!-- bert:status=needs-update, updated=2025-10-13 -->
```

**Step 5: Complete Updates**

Update those sections:
```
Update the tech-stack sections marked as needs-update.
Include bert living docs.
```

**Result:** Systematic refactoring with progress tracking.

---

## Common Patterns

### Pattern 1: Analysis → Tasks → Implementation

```
1. /agent-os:bert:task-author <file>
2. Review generated parent task
3. /agent-os:bert:task-create -p <num>
4. Work through subtasks
5. Mark as complete as you go
```

### Pattern 2: Generate → Track → Update

```
1. run plan-product with bert overlay
2. Work on sections over time
3. include bert living docs when updating
4. Check status comments to see progress
```

### Pattern 3: Abstract → Concrete → Detailed

```
1. /agent-os:bert:task-author <abstract concept>
2. /agent-os:bert:task-create -p <num>
3. /agent-os:bert:task-create -p <num>.<sub>
4. Continue drilling down as needed
```

---

## Tips from Real Usage

### Tip 1: Review Before Creating Subtasks
Always review the parent task before running task-create. Edit task descriptions if they're not specific enough.

### Tip 2: Use Living Docs for Long-Running Projects
Generate docs with bert overlay at project start. Update sections incrementally over weeks/months. Status comments show progress.

### Tip 3: Break Down When You Get Stuck
If a task feels overwhelming, use `/agent-os:bert:task-create -p <num>` to break it into smaller pieces.

### Tip 4: Abstract Requests Work Better Than You Think
Don't know which files need work? Try: `/agent-os:bert:task-author improve <concept>`

### Tip 5: Natural Language is More Flexible
Don't memorize exact syntax. Say what you want: "with bert overlay", "include bert", "apply bert", etc.

---

## Next Steps

- See [Command Reference](command-reference.md) for detailed syntax
- Check [Troubleshooting](troubleshooting.md) if you encounter issues
- Read [Getting Started](getting-started.md) for basic setup
