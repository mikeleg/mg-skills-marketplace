---
name: python-subagent
description: Dispatch a Python implementation task to a dedicated subagent pre-loaded with python-clean-code conventions. Use when executing Python tasks from a plan that must follow project coding standards.
tools: Read, Write, Edit, Bash, Glob, Grep
model: sonnet
---



# Python Subagent Dispatcher

Dispatch a Python task to a `voltagent-lang:python-pro` subagent with all python-clean-code conventions embedded.

## When Triggered

You have been asked to implement a Python task using a dedicated subagent.

**Immediately do the following steps in order — no confirmation needed:**

### Step 1 — Read the guidelines

Read these three files in parallel:
- `python-clean-code/references/coding-style.md`
- `python-clean-code/references/project-structure.md`
- `python-clean-code/references/vertical-slice-api.md`

The paths are relative to the `skills/` directory of the `mg-skills-marketplace` plugin.
Absolute base path: `C:/Users/MicheleGatti/.claude/plugins/marketplaces/mg-skills-marketplace/skills/`

### Step 2 — Build the subagent prompt

Compose a prompt that contains:
1. The full content of `coding-style.md` under a `## Coding Style` section
2. The full content of `project-structure.md` under a `## Project Structure` section
3. The full content of `vertical-slice-api.md` under a `## Vertical Slice API` section (include only if the task involves FastAPI/REST)
4. The task description provided by the user
5. This closing instruction:

```
Apply ALL conventions above strictly. Every function must have type hints.
No nested functions. No magic numbers. Use early returns. Group imports correctly.
Return the complete, ready-to-write file contents.
```

### Step 3 — Launch the subagent

Call the Task tool with:
- `subagent_type`: `voltagent-lang:python-pro`
- `description`: short description of the Python task (3-5 words)
- `prompt`: the composed prompt from Step 2

### Step 4 — Apply the result

Take the subagent's output and write the files to disk using the Write or Edit tools.

## Code Review Checklist (verify before finishing)

After writing the files, confirm:

- [ ] Type hints on every function and class attribute
- [ ] `snake_case` variables, `PascalCase` classes, `UPPER_SNAKE_CASE` constants
- [ ] No magic numbers — named constants used
- [ ] Functions single-responsibility, max ~25 lines
- [ ] Early returns instead of nested conditions
- [ ] No nested function definitions
- [ ] Imports grouped: stdlib → third-party → local
- [ ] Comments explain *why*, not *what*
