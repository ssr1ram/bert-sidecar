# Initial Spec Idea

## User's Initial Description

I want to do two things in parallel

1. Build out the slash command "/agent-os:bert:task-author" "some very broad high level input" such as "I want to make the generated agent-os/product/roadmap.md more accurate"
    - This will generate a slash command file that takes the user input which will typically point to a file and then this slash command will direct the AI to review the file and generate a task file that identifies what would be the set of tasks that will help make that file more accurate.
2. Understand what changes need to be made to the original command ie "/agent-os:plan-product" that generated the roadmap.md file
    - As the different sections of the roadmap.md file are made more accurate - they are marked accordingly so roadmap.md now becomes a living document that can be regularly updated in parts, because it may take a few weeks before the need to elaborate on Phase 2 becomes important etc.

## Metadata
- Date Created: 2025-10-14
- Spec Name: task-author-and-living-docs
- Spec Path: agent-os/specs/2025-10-14-task-author-and-living-docs
