---
status: pending
created: 2025-10-13
---

# Task 02: Task Author

## Description

I want to do two things in parallel

1. Build out the slash command "/agent-os:bert:task-author" "some very broad high level input" such as  "I want to make the generated agent-os/product/roadmap.md more accurate"
    - This will generate a slash command file that takes the user input which will typically point to a file and then this slash command will direct the AI to review the file and generate a task file that identifies what would be the set of tasks that will help make that file more accurate.
2. Understand what changes need to be made to the original command ie "/agent-os:pla-product" that generated the roadmap.md file
    - As the different sections of the roadmap.md file are made more accurate - they are marked accordingly so roadmap.md now becomes a living document that can be regularly updated in parts, because it may take a few weeks befor the need to elaborate on Phase 2 becomes important etc.

## questions 1

Initial Clarifying Questions
Task-Author Command Workflow: Should /agent-os:bert:task-author work like this: user provides input like "I want to make agent-os/product/roadmap.md more accurate" → AI reads the referenced file → AI generates a NEW task file (following the task-{nn}-{slug}.md pattern) that contains a set of subtasks to improve that file? Or should it generate the subtasks directly as separate files (like task-create -p does)?
Task File Structure from Task-Author: Should the generated task file follow the same frontmatter format as existing bert tasks (with status: pending, created date) and include a ## Tasks section with checkboxes for each improvement needed? Should it also include context about WHY these improvements matter, or just focus on WHAT needs to be done?
Living Document Tracking Mechanism: For the living document feature, should sections of roadmap.md have:
Inline markers like <!-- status: reviewed, last-updated: 2025-10-14 --> after each section heading?
Front matter metadata with section-level tracking?
A separate tracking file that maps sections to their status?
Section Granularity for Living Docs: Should tracking be at the heading level (## Phase 1, ## Phase 2), or more granular (### Completed Features, ### In Progress)? Should ALL headings be tracked or only specific ones marked for tracking?
Integration with Plan-Product: When /agent-os:plan-product generates files, should they be created with living document tracking from the start (all sections marked as "needs review" or "draft"), or should tracking be added later when someone runs a command like /agent-os:living-doc:init?
Task-Author Input Flexibility: Should the task-author command accept ONLY file paths (like "agent-os/product/roadmap.md") or also more abstract requests like "improve error handling in the authentication system"? File-focused or code pattern/feature-focused?
Living Document Update Workflow: When a task that improves a section is completed, should the living document status be updated manually, via a command like /agent-os:living-doc:mark-complete [file] [section], or should task completion itself trigger an update?
Backward Compatibility: Should the living document feature support retrofitting existing files (like the mission.md, roadmap.md, tech-stack.md already generated), or only work with newly generated ones?
Scope Boundaries: Are there any features you explicitly DON'T want? For example:
Should task-author generate multi-level nested tasks or keep it to parent + subtasks only?
Should living docs track who made updates or just timestamps?
Should there be version history for living document sections?
Existing Code Reuse
Are there existing features with similar patterns we should reference? For example:
File parsing logic from /agent-os:bert:task-create
Any existing status tracking or metadata management patterns
File generation patterns from the task-create command
Similar AI-driven content generation commands
Please provide file/folder paths or names if they exist.
Visual Assets Request
Do you have any design mockups, wireframes, or screenshots? If yes, please place them in: agent-os/specs/2025-10-14-task-author-and-living-docs/planning/visuals/ Use descriptive file names like:
task-author-workflow.png
living-doc-section-format.png
roadmap-with-tracking.png
Please answer these questions so we can proceed with the detailed specification!


## answers 1

1. It should only generate the parent file ie task-{nn}-{slug}.md not subtask files. The idea is that AI would try and understand what are the parts of this file that might need to be sharpened and give me the user the opportunity to decide which ones I want to work on. Say the parent file was task-04-foo.md , now when I decide to work on one I will generate a subtask for that i.e. task-04.1-baz.md - Now as I author this file I will use Ai to help me and there might be a set of subtasks here - I might then want to do a `-p 4.1` and have Ai genenerate 4.1.1, 4.1.2 etc.

2. The frontmatter fields will change, I am not ready to focus on that now. At some time when I get to it I will provide guidance. For now, I would reccomend creating a ber/config.yml which holds the fields that frontmatter for tasks should have and then over time we can sharpen them.

3. This is where it gets a bit tricky. I don't want to clobber agent-os the system that originated it. So, I guess your suggestion of a markdown comment makes sense. You decide

4. more granular at the "### Completed Features"

5. This is where it would be good to have a concept of an "overlay" wherein instead of "modifying the agent-os directive" we find a way to generate an overlay and then figure out how the user can call the agent-os slash command and simultaneously tell the AI to use the `bert` override - not sure how we can do this. but it is important that we o not modify the agent-os command but overlay it somehow

6. it should also allow for more abstract requests and get smart about figuring out the user intent

7. The living document update should not be a slash command but an "include" and if you make it easy forthe user to "include" this directie in their task/prompt than the Ai should follow it. it should not be a separate slash command however

8. No backward compatibility needed. the user will specify the file and proceed accordingly

9. Lets not get overly ambitious forthis iteration. The whole purpose of bert is to give the user more granular control, so new tasks can be added mid stream when a better understanding of requirements is in place.

Existing code

Look at the current ".,claude/commands" and ".claude/agents" directories for an idea of what exitss., we certainly do not want to duplicate this but reuse it where we can


## questions 2

Follow-up Questions
1. Overlay Implementation Approach For the overlay concept, here are three possible approaches:
Option A: Create bert/overlays/plan-product.md with additional instructions, invoked like /agent-os:plan-product @bert/overlays/plan-product
Option B: Create wrapper command /agent-os:bert:plan-product that reads the original and appends bert-specific instructions
Option C: Create bert/includes/living-docs.md snippet that users manually reference when calling /agent-os:plan-product
Which approach aligns with your vision of "overlaying" without modifying agent-os? Or is there a different mechanism? 2. Task Auto-Numbering for Nested Subtasks When running -p 4.1 to create subtasks under task-04.1-foo.md, should numbering be:
task-04.1.1-bar.md, task-04.1.2-baz.md (dots throughout), OR
task-04-1-1-bar.md, task-04-1-2-baz.md (dashes throughout)?
In the parent file, should it show:
- [ ] 4.1.1 Task description OR
- [ ] 4.01.01 Task description (zero-padded for sorting)?
3. Smart Intent Parsing Scope For abstract requests like "improve error handling in authentication", should task-author:
Auto-search codebase for matching files and analyze them?
Ask clarifying questions first (e.g., "Found auth files in X, Y, Z - which to analyze?")?
Hybrid: auto-detect obvious files but ask for confirmation?
How "smart" should intent detection be in this first iteration? 4. Include Directive Format For the living document update "include", what format would be easiest?
File path reference: @bert/includes/update-living-docs.md in prompt
Special syntax: #include:bert:living-docs
Conventional location: Users copy text from bert/includes/living-docs.md
What feels most natural for your workflow? 5. bert/config.yml Structure Should it look like:
task_frontmatter:
  fields:
    - name: id
      type: string
      required: true
Or simpler? Should this config also define living document comment formats, or keep those separate? Please provide your thoughts on these implementation details!

## answers 2

1. I need your help to understand how an AI engine via claude code would be able to be instructed. Here is what would be ideal
    - When I start a chat session, I tell the AI I am using agent-os with bert and where any agent-os slash command is given to look for a bert overlay and if that exists to use it. In other words I want a "/agent-os:bert:start" or something similar - this is invoked once and then is in the AI context for the duration of the session - Help me understand what mechanism best works here

2. dots throught so `task-04.1.1-bar.md`, `task-04.1.2-baz.md`

3. zero-padded for sorting for the major and no padding for the minor- if you could get a bit smarter we could do `- [ ] 4.01.1 Task description`

4. more english - less syntax/code-like so user could say `include bert where appropriate` and AI does the neeful. Ideally it is in the context with the "/agent-os:bert:start" or something like that

5. See frontmatter that claude understands i.e. https://docs.claude.com/en/docs/claude-code/slash-commands#frontmatter - lets use that maybe alongwith basic frontmatter for our own purposes to track the task
