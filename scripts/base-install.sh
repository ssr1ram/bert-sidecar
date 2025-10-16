#!/usr/bin/env bash

# bert addon installer
# This script installs the bert custom slash commands to your local repository
# Can be run locally or via: curl -fsSL https://raw.githubusercontent.com/ssr1ram/bert-sidecar/main/scripts/base-install.sh | bash

VERSION="2.0.0"
LAST_UPDATED="2025-10-16"

set -e  # Exit on error

# Determine if we're running from a local clone or via curl
SCRIPT_NAME="${BASH_SOURCE[0]}"

if [[ "$SCRIPT_NAME" == "bash" ]] || [[ "$SCRIPT_NAME" == "-bash" ]] || [[ "$SCRIPT_NAME" =~ ^/dev/fd/ ]] || [[ -z "$SCRIPT_NAME" ]]; then
    # Running via curl | bash
    INSTALL_MODE="remote"
    GITHUB_RAW_URL="https://raw.githubusercontent.com/ssr1ram/bert-sidecar/main"
    echo "Running in REMOTE mode (downloading from GitHub)"
else
    # Running from a file - check if it's a local clone
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)"
    SOURCE_REPO="$(dirname "$SCRIPT_DIR")"

    if [ -d "$SOURCE_REPO/.claude/commands/bert" ]; then
        INSTALL_MODE="local"
        echo "Running in LOCAL mode (using cloned repository)"
    else
        INSTALL_MODE="remote"
        GITHUB_RAW_URL="https://raw.githubusercontent.com/ssr1ram/bert-sidecar/main"
        echo "Running in REMOTE mode (downloading from GitHub)"
    fi
fi

echo "========================================="
echo "bert addon installer"
echo "Version: $VERSION (Updated: $LAST_UPDATED)"
echo "========================================="
echo ""

# Step 1: Determine target directory
CURRENT_DIR=$(pwd)
echo "Current directory: $CURRENT_DIR"
echo ""
read -p "Is this where you want to install the bert commands? (Y/n): " USE_CURRENT < /dev/tty

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

# Step 2: Create target directory structure
COMMANDS_DIR="$TARGET_REPO/.claude/commands/bert"

echo "Creating directory structure..."
mkdir -p "$COMMANDS_DIR"

# Step 3: Copy or download command files
echo "Installing bert command files..."

if [ "$INSTALL_MODE" = "local" ]; then
    echo "From: $SOURCE_REPO/.claude/commands/bert/"
    echo "To:   $COMMANDS_DIR/"
    echo ""

    cp -pr "$SOURCE_REPO/.claude/commands/bert"/* "$COMMANDS_DIR/"

    if [ $? -eq 0 ]; then
        echo "✓ Successfully copied command files"
    else
        echo "✗ Error: Failed to copy command files"
        exit 1
    fi
else
    echo "From: GitHub (ssr1ram/bert-sidecar)"
    echo "To:   $COMMANDS_DIR/"
    echo ""

    # Download each file from GitHub
    FILES=("config.yml" "start.md" "task-author.md" "task-create.md")
    BASE_URL="$GITHUB_RAW_URL/.claude/commands/bert"

    for FILE in "${FILES[@]}"; do
        echo "  Downloading $FILE..."
        if curl -fsSL "$BASE_URL/$FILE" -o "$COMMANDS_DIR/$FILE"; then
            echo "  ✓ Downloaded $FILE"
        else
            echo "  ✗ Failed to download $FILE"
            exit 1
        fi
    done

    echo ""
    echo "✓ Successfully downloaded all command files"
fi

# Verify installation
echo ""
echo "Installed files:"
ls -la "$COMMANDS_DIR" | tail -n +4 | awk '{print "  - " $9}'

echo ""
echo "========================================="
echo "Installation complete!"
echo "========================================="
echo ""
echo "Commands installed to: $COMMANDS_DIR"
echo ""
echo "Next steps:"
echo "1. Restart Claude Code"
echo "2. Available slash commands:"
echo "   - /bert:start"
echo "   - /bert:task-author"
echo "   - /bert:task-create"
echo ""
