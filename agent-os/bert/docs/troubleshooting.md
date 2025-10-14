# Troubleshooting Guide

Common issues and solutions when using bert.

---

## Session Issues

### Issue: Bert Features Not Working

**Symptoms:**
- Overlay commands don't apply bert enhancements
- Natural language invocations ignored
- Living docs not tracked

**Cause:**
Bert session not initialized for current conversation.

**Solution:**
Run the initialization command:
```
/agent-os:bert:start
```

**Prevention:**
Always start conversations where you'll use bert with `/agent-os:bert:start`.

---

### Issue: Session Context Lost

**Symptoms:**
- Bert was working but suddenly stops
- Need to re-initialize mid-conversation

**Cause:**
- Very long conversations may lose context
- Session ended and restarted

**Solution:**
Re-run initialization:
```
/agent-os:bert:start
```

**Note:**
Bert relies on conversation context. Starting a new session requires re-initialization.

---

## Task Creation Issues

### Issue: "Parent Task Not Found"

**Symptoms:**
```
Error: Parent task file not found for -p 4.1
```

**Cause:**
No file matching pattern `task-04.1-*.md` exists.

**Solution:**

1. Check what tasks exist:
```bash
ls agent-os/bert/tasks/
```

2. Verify parent file exists:
```bash
ls agent-os/bert/tasks/task-04.1-*.md
```

3. If missing, create parent first or use correct number.

**Common Mistake:**
Using `-p 4.1` when only `task-04-*.md` exists. Create `task-04.1` first:
```
/agent-os:bert:task-create -p 4
```

---

### Issue: Task Files Not Sorting Correctly

**Symptoms:**
Files appear out of order:
```
task-03.1-xxx.md
task-03.10-xxx.md
task-03.2-xxx.md    # Wrong position!
```

**Cause:**
Incorrect padding or file naming format.

**Solution:**

Check file names use dots, not dashes:
- ✅ Correct: `task-03.1-xxx.md`, `task-03.10-xxx.md`
- ❌ Wrong: `task-03-1-xxx.md`, `task-03-10-xxx.md`

Check checkbox padding in parent file:
- ✅ Correct: `3.01`, `3.02`, ..., `3.10`
- ❌ Wrong: `3.1`, `3.2`, ..., `3.10`

**Prevention:**
Let bert handle file creation and numbering automatically.

---

### Issue: Checkbox Numbers Not Padded

**Symptoms:**
Parent file has unpadded numbers:
```markdown
- [ ] 3.1 Task one
- [ ] 3.2 Task two
- [ ] 3.10 Task ten    # Sorts wrong!
```

**Cause:**
Manual editing or smart padding not applied.

**Solution:**

1. Calculate required padding (max 10 needs 2 digits)
2. Update manually:
```markdown
- [ ] 3.01 Task one
- [ ] 3.02 Task two
- [ ] 3.10 Task ten
```

Or regenerate with task-create.

**Prevention:**
Use `/agent-os:bert:task-create` which applies smart padding automatically.

---

## Task Author Issues

### Issue: Task Author Creates Too Many/Few Tasks

**Symptoms:**
- Generated 20 tasks when you expected 5
- Generated 2 tasks when file has many issues

**Cause:**
AI interpretation of what constitutes an "improvement area."

**Solution:**

1. Review generated parent task
2. Edit the `## Tasks` section manually
3. Remove tasks you don't want
4. Add tasks you need
5. Then run task-create

**Example Edit:**
```markdown
## Tasks

- [ ] 3.01 Keep this one
- [ ] 3.02 Keep this too
~~- [ ] 3.03 Remove this one~~
- [ ] 3.03 Add this new one manually
```

**Prevention:**
Provide more specific input to task-author:
```
/agent-os:bert:task-author focus on improving error handling in auth.js
```

---

### Issue: Abstract Request Finds Wrong Files

**Symptoms:**
```
/agent-os:bert:task-author improve error handling

Found:
- test/error-test.js
- docs/error-guide.md
- unrelated-file.js
```

**Cause:**
Search terms too broad or ambiguous.

**Solution:**

1. When bert presents findings, decline:
```
No, that's not what I meant. Let me be more specific.
```

2. Refine request:
```
/agent-os:bert:task-author improve error handling in src/auth/*.js files
```

**Prevention:**
Be specific about file paths or concepts in abstract requests.

---

### Issue: File Doesn't Exist

**Symptoms:**
```
Error: File not found: agent-os/product/roadmap.md
```

**Cause:**
File path incorrect or file doesn't exist.

**Solution:**

1. Verify file exists:
```bash
ls agent-os/product/roadmap.md
```

2. Check current directory:
```bash
pwd
```

3. Use correct relative or absolute path.

**Common Mistakes:**
- Missing `agent-os/` prefix
- Typos in filename
- Wrong directory

---

## Living Document Issues

### Issue: Status Comments Not Added

**Symptoms:**
Generated file doesn't have bert status comments.

**Cause:**
- Overlay not applied
- Session not initialized
- Command invoked without "with bert overlay"

**Solution:**

1. Ensure session initialized:
```
/agent-os:bert:start
```

2. Use natural language invocation:
```
run plan-product with bert overlay
```

Not just:
```
/agent-os:plan-product
```

**Prevention:**
Always include "with bert overlay" in command.

---

### Issue: Status Not Updating

**Symptoms:**
Modified section but status comment unchanged.

**Cause:**
Didn't invoke bert living docs include.

**Solution:**

When updating sections, use natural language:
```
Update this section and include bert living docs to track changes.
```

**Prevention:**
Always mention "include bert living docs" when modifying tracked sections.

---

### Issue: Wrong Status Value

**Symptoms:**
Status changed to unexpected value.

**Cause:**
AI misinterpreted the type of change.

**Solution:**

Edit status comment manually:
```markdown
<!-- bert:status=reviewed, updated=2025-10-15 -->
```

Valid statuses (from config.yml):
- `draft`
- `in-progress`
- `reviewed`
- `needs-update`

**Prevention:**
Be explicit about intended status:
```
Update section and mark status as reviewed. Include bert living docs.
```

---

## File Naming Issues

### Issue: Slug Too Long

**Symptoms:**
Generated filename:
```
task-04.1-add-comprehensive-acceptance-criteria-for-all-in-progress-features.md
```

**Cause:**
Task description very long; slug generated from full description.

**Solution:**

Rename file manually:
```bash
mv task-04.1-add-comprehensive-acceptance-criteria-for-all-in-progress-features.md \
   task-04.1-add-acceptance-criteria.md
```

Or edit parent task description before running task-create.

**Prevention:**
Keep task descriptions concise (< 50 characters).

---

### Issue: Special Characters in Filename

**Symptoms:**
Generated filename:
```
task-05-improve-user's-authentication-flow.md
```

**Cause:**
Task description contains apostrophes or special characters.

**Solution:**

Rename to kebab-case:
```bash
mv "task-05-improve-user's-authentication-flow.md" \
   task-05-improve-users-authentication-flow.md
```

**Prevention:**
Avoid special characters in task descriptions.

---

## Configuration Issues

### Issue: Config File Not Found

**Symptoms:**
```
Warning: Could not read agent-os/bert/config.yml
```

**Cause:**
Configuration file missing or wrong location.

**Solution:**

1. Check file exists:
```bash
ls agent-os/bert/config.yml
```

2. If missing, create from template (see command-reference.md)

3. Verify path is correct relative to project root.

**Prevention:**
Don't delete or move config.yml.

---

### Issue: Invalid Frontmatter

**Symptoms:**
```
Error: Invalid frontmatter in task file
```

**Cause:**
- YAML syntax error
- Missing required fields
- Wrong field format

**Solution:**

Check task file frontmatter:
```yaml
---
status: pending     # Must be valid status
created: 2025-10-14 # Must be YYYY-MM-DD
---
```

Required fields:
- `status`
- `created`

Optional fields:
- `updated`
- `parent`
- `related`

**Prevention:**
Let bert create files; it generates correct frontmatter automatically.

---

## Command Invocation Issues

### Issue: Slash Command Not Found

**Symptoms:**
```
Unknown slash command: /agent-os:bert:task-author
```

**Cause:**
- Command files not installed
- Wrong command syntax
- Commands not registered

**Solution:**

1. Verify command file exists:
```bash
ls .claude/commands/agent-os/bert/task-author.md
```

2. Check syntax is correct:
```
/agent-os:bert:task-author (not /bert:task-author)
```

3. Restart AI engine if needed.

**Prevention:**
Ensure bert is properly installed before use.

---

### Issue: Natural Language Not Working

**Symptoms:**
```
run plan-product with bert overlay
```
Executes plan-product without bert.

**Cause:**
Session not initialized.

**Solution:**
```
/agent-os:bert:start
```

Then retry:
```
run plan-product with bert overlay
```

**Prevention:**
Always initialize session before using natural language invocations.

---

## Edge Cases

### Issue: Parent Has No Unchecked Tasks

**Symptoms:**
```
/agent-os:bert:task-create -p 3

Warning: Parent task has no unchecked tasks
```

**Cause:**
All tasks in parent file are checked:
```markdown
- [x] 3.01 Completed task
- [x] 3.02 Another completed task
```

**Solution:**

Add new tasks to parent manually:
```markdown
- [x] 3.01 Completed task
- [x] 3.02 Another completed task
- [ ] 3.03 New task to work on
- [ ] 3.04 Another new task
```

Then run task-create again.

---

### Issue: Very Deep Nesting (5+ Levels)

**Symptoms:**
File: `task-04.1.2.3.4.5-xxx.md`
Checkbox: `4.01.2.3.4.5`

**Cause:**
Created tasks at very deep nesting level.

**Solution:**

This is supported but consider if this much nesting is necessary. Deep nesting might indicate task breakdown is too granular.

**Alternative:**
Flatten hierarchy or group related tasks differently.

---

### Issue: More Than 99 Subtasks

**Symptoms:**
Have 100+ subtasks under one parent.

**Cause:**
Created many subtasks at same level.

**Solution:**

Smart padding handles this:
```markdown
- [ ] 4.001 Task 1
- [ ] 4.002 Task 2
...
- [ ] 4.100 Task 100
```

Files still sort correctly with 3-digit padding.

**Alternative:**
Consider grouping into categories with intermediate levels.

---

## Performance Issues

### Issue: Slow Task Creation

**Symptoms:**
Creating subtasks takes longer than expected.

**Cause:**
- Many tasks to create (10+)
- Complex file analysis
- Large parent file

**Solution:**

This is normal for large task sets. Wait for completion.

**Prevention:**
Break parent tasks into smaller groups if needed.

---

### Issue: Large Task Files

**Symptoms:**
Task file is very large (1000+ lines).

**Cause:**
Task description very detailed or many subtasks.

**Solution:**

Consider breaking into multiple tasks:
- Create parent task
- Create first-level subtasks
- Break those down further as needed

**Prevention:**
Keep individual task files focused and concise.

---

## Getting Help

### Check Documentation First

1. [Getting Started](getting-started.md) - Basic usage
2. [Command Reference](command-reference.md) - Detailed syntax
3. [Examples](examples.md) - Real-world use cases

### Verify Setup

```bash
# Check directory structure
ls -R agent-os/bert/

# Check command files
ls .claude/commands/agent-os/bert/

# Check config
cat agent-os/bert/config.yml
```

### Common Checklist

- [ ] Session initialized with `/agent-os:bert:start`
- [ ] Using correct command syntax
- [ ] File paths are correct
- [ ] Parent tasks exist before creating subtasks
- [ ] Natural language includes "with bert overlay" or "include bert"
- [ ] Config file exists and is valid YAML

---

## Still Having Issues?

If you've checked everything above and still have problems:

1. **Review error messages carefully** - they usually indicate the problem
2. **Check file paths and names** - most issues are path-related
3. **Verify session initialized** - many features require `/agent-os:bert:start`
4. **Test with simple example** - isolate the problem
5. **Check agent-os base functionality** - ensure agent-os itself works

---

## Known Limitations

### Current Limitations

1. **No Visual Task Board** - Tasks are files, not GUI
2. **No Automatic Updates** - Must manually update status
3. **No Search Interface** - Use grep/find for searching tasks
4. **Session Bound** - Context doesn't persist across sessions
5. **No Undo** - File changes are permanent (use git!)

### Future Enhancements

See [agent-os/product/roadmap.md](../../product/roadmap.md) for planned features.

---

## See Also

- [Getting Started](getting-started.md)
- [Command Reference](command-reference.md)
- [Examples](examples.md)
