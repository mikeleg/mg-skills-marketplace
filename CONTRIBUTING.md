# Contributing to MG Skills Marketplace

Thank you for your interest in contributing! This guide will help you add new skills to the marketplace.

## 📋 Before You Start

1. Check if a similar skill already exists
2. Ensure your skill provides value Claude doesn't already have
3. Keep it focused - one skill, one purpose

## 🏗️ Creating a New Skill

### 1. Create the skill folder

```
skills/
└── your-skill-name/
    ├── SKILL.md           # Required
    ├── scripts/           # Optional
    ├── references/        # Optional
    └── assets/            # Optional
```

### 2. Write SKILL.md

```yaml
---
name: your-skill-name
description: Clear description of what it does AND when Claude should use it. Include trigger words and use cases.
---

# Your Skill Name

Instructions for Claude...
```

**Important:**
- `name` and `description` in frontmatter are required
- Description should explain WHEN to trigger, not just WHAT it does
- Keep SKILL.md under 500 lines
- Use references/ for detailed documentation

### 3. Add supporting files (optional)

| Folder | Purpose | When to use |
|--------|---------|-------------|
| `scripts/` | Executable code | Repetitive tasks, deterministic operations |
| `references/` | Documentation | Detailed guides, schemas, examples |
| `assets/` | Templates, images | Files used in output |

## ✅ Checklist

Before submitting:

- [ ] SKILL.md has valid YAML frontmatter
- [ ] Description explains when to trigger
- [ ] No unnecessary files (README, CHANGELOG, etc.)
- [ ] Scripts are tested and working
- [ ] References are linked from SKILL.md
- [ ] Total size is reasonable (<1MB)

## 🚀 Submitting

1. Fork this repository
2. Create a branch: `git checkout -b add-skill-name`
3. Add your skill in `skills/your-skill-name/`
4. Update the skills table in README.md
5. Submit a Pull Request

## 📝 Style Guidelines

### SKILL.md

- Use imperative form ("Generate report" not "Generates report")
- Include code examples where helpful
- Link to references for detailed info
- Add a checklist if multi-step process

### Scripts

- Include docstrings
- Use type hints
- Handle errors gracefully
- Test before committing

## 🙋 Questions?

Open an issue if you need help or have suggestions!
