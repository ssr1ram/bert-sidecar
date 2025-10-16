#!/usr/bin/env bash

# bert addon installer
# This script installs the bert custom slash commands to your local repository

VERSION="2.0.0"
LAST_UPDATED="2025-10-16"

set -e  # Exit on error

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

# Step 2: Determine source directory (where this script is located)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)"
SOURCE_REPO="$(dirname "$SCRIPT_DIR")"

if [ ! -d "$SOURCE_REPO/.claude/commands/bert" ]; then
    echo "Error: Could not find .claude/commands/bert in source repository"
    echo "Source: $SOURCE_REPO"
    exit 1
fi

echo "Source repository: $SOURCE_REPO"
echo ""

# Step 3: Create target directory structure
COMMANDS_DIR="$TARGET_REPO/.claude/commands/bert"

echo "Creating directory structure..."
mkdir -p "$COMMANDS_DIR"

# Step 4: Copy command files
echo "Copying bert command files..."
echo "From: $SOURCE_REPO/.claude/commands/bert/"
echo "To:   $COMMANDS_DIR/"
echo ""

cp -pr "$SOURCE_REPO/.claude/commands/bert"/* "$COMMANDS_DIR/"

# Verify files were copied
if [ $? -eq 0 ]; then
    echo "✓ Successfully copied command files:"
    ls -la "$COMMANDS_DIR" | tail -n +4 | awk '{print "  - " $9}'
    echo ""
else
    echo "✗ Error: Failed to copy command files"
    exit 1
fi

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
echo "   - /agent-os:bert:start"
echo "   - /agent-os:bert:task-author"
echo "   - /agent-os:bert:task-create"
echo ""
