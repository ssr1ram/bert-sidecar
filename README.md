# bert custom slash commands

bert provides custom slash commands for Claude Code to help you manage tasks and workflows.

## Getting Started

### Requirements

- Claude Code CLI installed and configured

### Installation

#### Quick Install (One-Liner)

Run this command from your project directory:

```bash
curl -fsSL https://raw.githubusercontent.com/ssr1ram/bert-sidecar/main/scripts/base-install.sh | bash
```

This will:
- Ask if the current directory is where you want to install the commands
- Download the bert command files from GitHub to your project's `.claude/commands/bert`
- Verify the installation

#### Local Install

If you prefer to install from a local clone:

1. Clone this repository:
```bash
git clone https://github.com/ssr1ram/bert-sidecar.git
```

2. Navigate to your project directory and run the installer:
```bash
cd /path/to/your/project
bash /path/to/bert-sidecar/scripts/base-install.sh
```

The installer will:
- Ask if the current directory is where you want to install the commands
- Copy the bert command files from the local clone to your project
- Verify the installation

#### Manual Install

If you prefer to install manually:

1. Clone this repository:
```bash
git clone https://github.com/ssr1ram/bert-sidecar.git
```

2. Copy the command files to your project:
```bash
cp -pr bert-sidecar/.claude/commands/bert /path/to/your/project/.claude/commands/bert
```

3. Restart Claude Code

## Usage

After installation, the following slash commands will be available in Claude Code:

### `/bert:start`
Initialize a bert session context for your project.

### `/bert:task-author`
Generate a parent task that identifies improvement areas for your project.

### `/bert:task-create`
Create a new task file with structured frontmatter.

Example:
```
/bert:task-create "implement user authentication"
```

## What Gets Installed

The installation copies the following files to your project's `.claude/commands/bert/` directory:
- `start.md` - Session initialization command
- `task-author.md` - Task authoring command
- `task-create.md` - Task creation command
- `config.yml` - Configuration file

## Troubleshooting

If the slash commands don't appear after installation:
1. Make sure you've restarted Claude Code
2. Verify the files are in `.claude/commands/bert/` in your project directory
3. Check that the files have proper read permissions

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the MIT License.
