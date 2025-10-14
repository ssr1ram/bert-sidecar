# bert custom slash command addon for agent-os

bert provides a custom slash command to AI code cli agents such as claude and gemini.

This custom slash command works as an addon to an existing set of slash commands that agent-os provides.

## Getting Started

### Requirements

- You should be using either `claude code`, `cursor` or `gemini cli`
- You should have `agent-os` installed

### Installing the bert addon

#### Quick Install (Recommended)

Run this one-line command from your terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/ssr1ram/agent-os-addon-bert/main/scripts/base-install.sh | bash
```

The installer will:
- Detect your AI agent (Claude, Cursor, or Gemini)
- Prompt you for your target repository path
- Install all necessary files and commands
- Provide next steps

#### Manual Install

If you prefer to install manually:

1. Clone this repo to agent-os-addon-bert

2. Add required files to the `<repo-root>/agent-os` directory

    2.1 Copy over the fs-schema directory
    This gives `bert` a good understanding of the filesystem schema that agent-os uses

    ```
    cp -pr path/to/agent-os-addon-bert/agent-os/fs-schema path/to/<your-repo-root>/agent-os/fs-schema
    ```

    2.2 Copy over the custom slash command

    This lets you invoke the custom slash command from the claude code cli

    - For claude
        - copy recursively dir: agent-os/bert/commands.claude/bert to: .claude/commands/agent-os/bert
    - For cursor
        - copy recursively dir: agent-os/bert/commands.cursor/bert to: .cursor/commands/agent-os/bert
    - For gemini
        - copy recursively dir: agent-os/bert/commands.gemini/bert to: .gemini/commands/agent-os/bert

3. Restart your AI agent and find slash command "/agent-os:bert:task-create" available.


## Usage

### Create a new task

1. Use the slash command
```
/agent-os:bert:task-create "brief title"
```

2. Edit the task file created
This will create a task file with basic frontmatter. 
```
<repo-root>/
    agent-os/
        bert/
            tasks/
                task-01-brief-title.md
```

3. Reference this task file in your prompt within `<repo-root>` as follows
```
@agent-os/bert/tasks/task-01-brief-title.md run this
```

4. Create subtasks for a task
    - In the parent task say `task-03-foo.md` if you have a Tasks section with a set of tasks laid out like
    ```
    ## Task
    - [ ] foo
    - [ ] baz
    ```
    - `/agent-os/bert/task-create -p 3` would automatically create task-3.1 and task-3.2



## Roadmap

### Coming soon...
- `save task output` - Create an easy way to prompt the AI to save task output
- `/agent-os:bert:task-edit` <num> - edits the created task bases on user input. This is where the user could use unstructured conversation to reference spec files, tasks and other artefacts that agent-os has produced 
    - Once AI edits the file, the user can choose to manuallly make any additional edits and then have the AI execute the whole file
- `/agent-os:bert:task-kanban` <num> - change the tasks status, archive, delete etc.