#!/usr/bin/env bash

# bert addon installer for agent-os
# This script installs the bert custom slash command addon for agent-os
# Can be run locally or via: curl -fsSL https://raw.githubusercontent.com/.../base-install.sh | bash

VERSION="1.0.0"
LAST_UPDATED="2025-10-12"

set -e  # Exit on error

# Determine if we're running from a local clone or via curl
# When piped through bash, BASH_SOURCE[0] is typically "bash" or "-bash"
SCRIPT_NAME="${BASH_SOURCE[0]}"

if [[ "$SCRIPT_NAME" == "bash" ]] || [[ "$SCRIPT_NAME" == "-bash" ]] || [[ "$SCRIPT_NAME" =~ ^/dev/fd/ ]] || [[ -z "$SCRIPT_NAME" ]]; then
    # Running via curl | bash (script name is bash, a file descriptor, or empty)
    INSTALL_MODE="remote"
    GITHUB_RAW_URL="https://raw.githubusercontent.com/ssr1ram/agent-os-addon-bert/main"
    echo "Running in REMOTE mode (downloading from GitHub)"
else
    # Running from a file, check if it's a local clone
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)" || SCRIPT_DIR=""
    if [ -n "$SCRIPT_DIR" ] && [ -d "$(dirname "$SCRIPT_DIR")/agent-os" ]; then
        # Running from local clone
        ADDON_ROOT="$(dirname "$SCRIPT_DIR")"
        INSTALL_MODE="local"
        echo "Running in LOCAL mode (using cloned repository)"
    else
        # Script exists but no agent-os directory
        INSTALL_MODE="remote"
        GITHUB_RAW_URL="https://raw.githubusercontent.com/ssr1ram/agent-os-addon-bert/main"
        echo "Running in REMOTE mode (downloading from GitHub)"
    fi
fi

echo "========================================="
echo "bert addon installer for agent-os"
echo "Version: $VERSION (Updated: $LAST_UPDATED)"
echo "========================================="
echo ""

# Step 1: Determine target directory
CURRENT_DIR=$(pwd)
echo "Current directory: $CURRENT_DIR"
echo ""
read -p "Is this the target repository where you want to install agent-os? (Y/n): " USE_CURRENT < /dev/tty

USE_CURRENT=${USE_CURRENT:-Y}  # Default to Y if empty

if [[ "$USE_CURRENT" =~ ^[Yy]$ ]]; then
    TARGET_REPO="$CURRENT_DIR"
else
    read -p "Enter the path to your target repository: " TARGET_REPO < /dev/tty
    # Expand ~ to home directory
    TARGET_REPO="${TARGET_REPO/#\~/$HOME}"
fi

# Validate target directory
if [ ! -d "$TARGET_REPO" ]; then
    echo "Error: Directory '$TARGET_REPO' does not exist."
    exit 1
fi

echo ""
echo "Target repository: $TARGET_REPO"
echo ""

# Step 2: Detect available AI agents in target directory
echo "Detecting AI agents in target directory..."
DETECTED_AGENTS=()

if [ -d "$TARGET_REPO/.claude" ]; then
    DETECTED_AGENTS+=("claude")
    echo "  ✓ Found Claude Code (.claude directory)"
fi

if [ -d "$TARGET_REPO/.cursor" ]; then
    DETECTED_AGENTS+=("cursor")
    echo "  ✓ Found Cursor (.cursor directory)"
fi

if [ -d "$TARGET_REPO/.gemini" ]; then
    DETECTED_AGENTS+=("gemini")
    echo "  ✓ Found Gemini CLI (.gemini directory)"
fi

echo ""

# If no agents detected, prompt user to select
if [ ${#DETECTED_AGENTS[@]} -eq 0 ]; then
    echo "No AI agent directories detected in target repository."
    echo "Which AI agent(s) would you like to install for?"
    echo "1) Claude Code"
    echo "2) Cursor"
    echo "3) Gemini CLI"
    echo "4) All of the above"
    read -p "Enter your choice (1-4) or comma-separated choices (e.g., 1,2): " choice < /dev/tty

    if [ "$choice" = "4" ]; then
        DETECTED_AGENTS=("claude" "cursor" "gemini")
    else
        IFS=',' read -ra CHOICES <<< "$choice"
        for c in "${CHOICES[@]}"; do
            c=$(echo "$c" | xargs)  # trim whitespace
            case $c in
                1) DETECTED_AGENTS+=("claude") ;;
                2) DETECTED_AGENTS+=("cursor") ;;
                3) DETECTED_AGENTS+=("gemini") ;;
                *) echo "Warning: Invalid choice '$c' ignored" ;;
            esac
        done
    fi

    if [ ${#DETECTED_AGENTS[@]} -eq 0 ]; then
        echo "Error: No valid agent selected. Exiting."
        exit 1
    fi
fi

# Confirm installation for detected/selected agents
echo "Will install bert addon for: ${DETECTED_AGENTS[*]}"
echo ""
read -p "Continue with installation? (Y/n): " CONFIRM < /dev/tty
CONFIRM=${CONFIRM:-Y}

if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "Installation cancelled."
    exit 0
fi

echo ""

# Create agent-os directory if it doesn't exist
AGENT_OS_DIR="$TARGET_REPO/agent-os"
if [ ! -d "$AGENT_OS_DIR" ]; then
    echo "Creating agent-os directory..."
    mkdir -p "$AGENT_OS_DIR"
fi

# Helper function to copy from local or download from remote
copy_or_download() {
    local source_path="$1"
    local dest_path="$2"

    if [ "$INSTALL_MODE" = "local" ]; then
        # Copy from local clone
        if [ -d "$ADDON_ROOT/$source_path" ]; then
            mkdir -p "$dest_path"
            cp -pr "$ADDON_ROOT/$source_path"/* "$dest_path/" 2>/dev/null || true
            return 0
        else
            return 1
        fi
    else
        # Download from GitHub
        mkdir -p "$dest_path"
        local base_url="$GITHUB_RAW_URL/$source_path"

        # For directories, we need to download individual files
        # We'll use a manifest approach - create a list of files to download
        case "$source_path" in
            "agent-os/fs-schema")
                curl -fsSL "$base_url/bert.yml" -o "$dest_path/bert.yml" 2>/dev/null || return 1
                curl -fsSL "$base_url/core.yml" -o "$dest_path/core.yml" 2>/dev/null || return 1
                ;;
            "agent-os/bert/tasks")
                # Download example task files
                curl -fsSL "$base_url/task-01-test-the-bert-slash-command.md" -o "$dest_path/task-01-test-the-bert-slash-command.md" 2>/dev/null || true
                curl -fsSL "$base_url/task-02-do-something.md" -o "$dest_path/task-02-do-something.md" 2>/dev/null || true
                ;;
            "agent-os/bert/commands.claude/bert")
                curl -fsSL "$base_url/task-create.md" -o "$dest_path/task-create.md" 2>/dev/null || return 1
                ;;
            "agent-os/bert/commands.cursor/bert")
                curl -fsSL "$base_url/task-create.md" -o "$dest_path/task-create.md" 2>/dev/null || return 1
                ;;
            "agent-os/bert/commands.gemini/bert")
                curl -fsSL "$base_url/task-create.toml" -o "$dest_path/task-create.toml" 2>/dev/null || return 1
                ;;
        esac
        return 0
    fi
}

# Step 3: Copy fs-schema directory
echo "Step 1: Installing fs-schema..."
if copy_or_download "agent-os/fs-schema" "$AGENT_OS_DIR/fs-schema"; then
    echo "✓ fs-schema installed"
else
    echo "Warning: Could not install fs-schema"
fi

# Step 4: Copy bert tasks directory (examples)
echo ""
echo "Step 2: Installing bert tasks directory..."
mkdir -p "$AGENT_OS_DIR/bert/tasks"
if copy_or_download "agent-os/bert/tasks" "$AGENT_OS_DIR/bert/tasks"; then
    echo "✓ bert tasks directory created"
else
    echo "✓ bert tasks directory created (empty)"
fi

# Step 5: Copy commands for each detected agent
echo ""
echo "Step 3: Installing slash commands..."
INSTALLED_COUNT=0

for AGENT in "${DETECTED_AGENTS[@]}"; do
    echo ""
    echo "Installing for $AGENT..."

    case $AGENT in
        claude)
            COMMANDS_DIR="$TARGET_REPO/.claude/commands/agent-os/bert"
            SOURCE_PATH="agent-os/bert/commands.claude/bert"
            ;;
        cursor)
            COMMANDS_DIR="$TARGET_REPO/.cursor/commands/agent-os/bert"
            SOURCE_PATH="agent-os/bert/commands.cursor/bert"
            ;;
        gemini)
            COMMANDS_DIR="$TARGET_REPO/.gemini/commands/agent-os/bert"
            SOURCE_PATH="agent-os/bert/commands.gemini/bert"
            ;;
    esac

    if copy_or_download "$SOURCE_PATH" "$COMMANDS_DIR"; then
        echo "  ✓ Slash commands installed to $COMMANDS_DIR"
        INSTALLED_COUNT=$((INSTALLED_COUNT + 1))
    else
        echo "  ✗ Error: Could not install commands for $AGENT"
    fi
done

echo ""
echo "========================================="
echo "Installation complete!"
echo "========================================="
echo ""
echo "Installed for $INSTALLED_COUNT agent(s): ${DETECTED_AGENTS[*]}"
echo ""
echo "Next steps:"
echo "1. Restart your AI agent(s)"
echo "2. Try the slash command: /agent-os:bert:task-create \"brief title\""
echo ""
echo "For usage instructions, see: https://github.com/ssr1ram/agent-os-addon-bert#usage"
echo ""
