# Bert Include: Living Document Updates

This include file provides reusable instructions for updating status comments in living documents that contain bert status tracking.

## Purpose

When modifying files that contain bert status tracking comments, use these instructions to ensure status comments are properly updated to reflect the current state of each section. This maintains an accurate history of document evolution without requiring manual tracking.

## How to Invoke

This is NOT a slash command. Instead, include it naturally in your prompts when working with living documents:
- "include bert living docs when updating this file"
- "apply bert overlay while modifying these sections"
- "use bert to track changes"
- "update with bert living docs"

## Instructions for Updating Living Documents

### 1. Locate Status Comments

Look for HTML comments with this format:
```html
<!-- bert:status=<value>, updated=YYYY-MM-DD -->
```

These comments appear immediately after h3 (`###`) headings in living documents.

**Example:**
```markdown
### Implementation Details
<!-- bert:status=draft, updated=2025-10-14 -->

Section content here...
```

### 2. When to Update Status Comments

Update the status comment whenever you:
- Modify the content of a section
- Review a section for accuracy
- Identify a section as needing updates
- Make any substantive changes to the text

**Do NOT update** if you only:
- Fix typos or formatting
- Make trivial whitespace changes
- Update unrelated sections

### 3. How to Update Status Comments

When updating a status comment:

a) **Update the status value** according to the transition rules (see below)
b) **Update the date** to the current date (YYYY-MM-DD format)
c) **Preserve the exact comment format** - do not change the syntax

**Before:**
```markdown
### Features Overview
<!-- bert:status=draft, updated=2025-10-14 -->
```

**After (when edited):**
```markdown
### Features Overview
<!-- bert:status=in-progress, updated=2025-10-15 -->
```

### 4. Adding Comments to Sections Without Them

If you're modifying a section that doesn't have a bert status comment, add one with:
- **status**: `in-progress` (since you're actively editing it)
- **updated**: Current date

**Example:**
```markdown
### New Section Being Updated
<!-- bert:status=in-progress, updated=2025-10-15 -->

Updated content here...
```

### 5. Status Transition Logic

Follow these rules for status transitions:

#### From `draft` (initial creation)
- → `in-progress`: When making first edits to the section
- → `reviewed`: When performing comprehensive review without needing changes

#### From `in-progress` (actively being edited)
- → `reviewed`: When edits are complete and section is verified accurate
- → `needs-update`: When identifying issues that need addressing

#### From `reviewed` (verified accurate)
- → `needs-update`: When section becomes outdated or issues are identified
- → `in-progress`: When making substantial revisions to reviewed content

#### From `needs-update` (identified as needing revision)
- → `in-progress`: When starting to address the needed updates
- → `reviewed`: Only if needs-update was added in error

### 6. Status Transition Examples

**Example 1: First Edit**
```markdown
<!-- Before -->
### Authentication Flow
<!-- bert:status=draft, updated=2025-10-14 -->

Basic auth description.

<!-- After editing -->
### Authentication Flow
<!-- bert:status=in-progress, updated=2025-10-15 -->

Comprehensive auth description with JWT details and OAuth2 integration...
```

**Example 2: Completing Updates**
```markdown
<!-- Before -->
### Authentication Flow
<!-- bert:status=in-progress, updated=2025-10-15 -->

Content being worked on...

<!-- After review and completion -->
### Authentication Flow
<!-- bert:status=reviewed, updated=2025-10-16 -->

Final, verified content.
```

**Example 3: Identifying Need for Update**
```markdown
<!-- Before -->
### API Endpoints
<!-- bert:status=reviewed, updated=2025-10-10 -->

Lists old endpoints...

<!-- After identifying it's outdated -->
### API Endpoints
<!-- bert:status=needs-update, updated=2025-10-16 -->

Lists old endpoints...
[Note: This section needs updating to reflect new v2 API]
```

**Example 4: Starting to Fix Outdated Content**
```markdown
<!-- Before -->
### API Endpoints
<!-- bert:status=needs-update, updated=2025-10-16 -->

Lists old endpoints...

<!-- After starting updates -->
### API Endpoints
<!-- bert:status=in-progress, updated=2025-10-17 -->

Lists updated v2 endpoints...
```

### 7. Preservation Rules

**ALWAYS:**
- Preserve the exact HTML comment syntax
- Use YAML-like key=value format
- Update both status AND date when making changes
- Keep comments immediately after h3 headings

**NEVER:**
- Remove bert status comments
- Change the comment format or structure
- Skip updating the date
- Add comments to h1 or h2 headings (only h3)

### 8. Reference: Valid Status Values

According to `agent-os/bert/config.yml`:
- `draft` - Initial creation
- `in-progress` - Currently being updated
- `reviewed` - Reviewed and verified accurate
- `needs-update` - Identified as requiring revision

## Integration with Bert Session

This include file works in conjunction with:
- **Session initialization**: `/agent-os:bert:start` must be run first
- **Overlay system**: Comments may be initially added via plan-product overlay
- **Configuration**: Status values defined in `agent-os/bert/config.yml`

## Natural Language Recognition

When you say "include bert living docs", Claude will:
1. Read this include file
2. Apply these instructions to your modifications
3. Update status comments according to these rules
4. Ensure all changes track document evolution

## Purpose and Benefits

Living document tracking enables:
- **Incremental evolution**: Track which sections have been updated
- **Review status**: Know which sections have been verified
- **Maintenance awareness**: Identify sections needing attention
- **Historical context**: Understand when sections were last reviewed
- **Non-intrusive tracking**: No separate tracking files needed
