---
id: task-01
title: Smart Bert
status: pending
created: 2025-10-13
---

# Smart Bert

`/agent-os:plan-product`

## questions 1

Information Needed:
1. Product Vision & Goals:
What is the main problem bert solves for developers?
What makes bert different from other task management approaches?
What are your success metrics or goals for adoption?
2. Key Features:
Beyond task creation, subtask creation, and task referencing - are there other important features?
What specific pain points do these features solve?
3. Target User Personas:
Who are the primary users? (solo developers, team leads, AI-first developers?)
What are their typical workflows?
What pain points do they experience that bert addresses?
4. Development Roadmap Priorities:
Are the features in your README roadmap still the priorities?
Any new features or phases to include?
Priority order for upcoming features?
5. Tech Stack Confirmation:
The project uses Bash, Markdown, and YAML - anything else to document?
Testing frameworks, CI/CD, or other development tools?
Any specific conventions?
Please share as much detail as you'd like, and I'll create comprehensive mission, roadmap, and tech-stack documents in the agent-os/product/ directory.

## answers 1

1. 
bert provides task creation and task management capabilities to developers as they build prompts to drive AI engines. The first version will be an add-on to an existing set of commands built by agent-os a spec driven development framework used to leverage AI engines to assit with developing a product.

By being aware of how agent-os builds context, creates specs, tasks `bert` would allow for one to tap the context and spec that resides within agent-os as one works on individual tasks. The idea remains to find ways to break down the set of valuable tasks that agent-os instructs the AI to do into granular re-accesible directives that can be used.

For example adding a git commit after each task, can be accomplished in a few ways either by using the bert add-on to create a task to do it or of course by modifying agent-os itself to be able to do it.

2.
other key features are
- task author i.e. taking a very rough idea from the user, having the AI engine flesh that idea out into a set of tasks using the existing context
- task kanban - the ability to move a task from draft to todo to in progeress to in review and done
- feat(ure) (task)map - a way to group a set of tasks together for a feature. The idea here is that ideas for tasks come at their pace and task numbering is linear. but the grouping of tasks would nit necessarily follow that numbering system, so a feature taskmap will help us group and work with them together
- task includes - building a set of primitives that can be easily included in a task for e.g. "directive to the AI engine to write output response to a notes directory", "directive to provide a git commit message" etc.

3. solo developers, product designers, agent-os users
The idea is to have bert be a standalone AI task system - for now since agent-os is more mature the idea is to learn from agent-os and add value, but over time to take the learnings from agent-os and make it more granular and build out a task/spec system

4. I am not quitesure, I have a number of ideas that I want to flesh out in tasks with your help and then build feature maps and the i will have a good understanding of how to prioritize them in a roadmap

5. The goal is to rely primarily on markdown as being the way to talk to the AI. I am still not sure how well the custom slash command work and how best to integrate either a custom cli, a purpose-build mcp server or both with existing prompts in markdown. we will learn as we go along. 