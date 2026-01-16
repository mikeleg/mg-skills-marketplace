# 🛒 MG Skills Marketplace

A curated collection of skills to extend Claude's capabilities with specialized knowledge, workflows, and tools.

## 📦 Available Skills

| Skill | Description | Category |
|-------|-------------|----------|
| [python-clean-code](skills/python-clean-code/) | Write clean, maintainable Python code with PEP 8, type hints, and pragmatic clean architecture | Development |

## 🚀 Installation

### Method 1: Download .skill file

1. Go to [Releases](../../releases)
2. Download the `.skill` file you need
3. In Claude Desktop/Web, go to **Settings → Skills**
4. Click **Add Skill** and select the downloaded file

### Method 2: Clone and use directly

```bash
git clone https://github.com/YOUR_USERNAME/mg-skills-marketplace.git
```

Then point Claude to the skill folder in your project settings.

## 📁 Repository Structure

```
mg-skills-marketplace/
├── README.md
├── LICENSE
├── CONTRIBUTING.md
└── skills/
    └── python-clean-code/
        ├── SKILL.md           # Main skill file
        ├── scripts/           # Executable scripts
        └── references/        # Documentation
```

## 🔧 Skill Anatomy

Each skill follows this structure:

```
skill-name/
├── SKILL.md              # Required: metadata + instructions
├── scripts/              # Optional: reusable code
├── references/           # Optional: detailed docs
└── assets/               # Optional: templates, images
```

### SKILL.md Format

```yaml
---
name: skill-name
description: What it does and when to trigger it
---

# Skill Name

Instructions for Claude...
```

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on adding new skills.

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

---

Made with ❤️ for the Claude community
