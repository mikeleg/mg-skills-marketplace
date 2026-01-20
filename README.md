# 🛒 MG Skills Marketplace

A curated collection of skills to extend Claude's capabilities with specialized knowledge, workflows, and tools.

## 📦 Available Skills

| Skill | Description | Category |
|-------|-------------|----------|
| [python-clean-code](skills/python-clean-code/) | Write clean, maintainable Python code with PEP 8, type hints, and pragmatic clean architecture | Development |

## 🚀 Installation

### For Claude Code CLI (Recommended)

This is a Claude Code plugin that bundles multiple skills. Install it once to get all the skills.

**Option 1: Install from GitHub (Recommended)**

```bash
# Install directly from repository
claude plugin install https://github.com/YOUR_USERNAME/mg-skills-marketplace

# Or clone first, then install
git clone https://github.com/YOUR_USERNAME/mg-skills-marketplace.git
claude plugin install ./mg-skills-marketplace
```

**Option 2: Manual Installation**

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/mg-skills-marketplace.git

# Install using the installation script
cd mg-skills-marketplace
./install.sh --global --all
```

**Managing the Plugin:**

```bash
# List installed plugins
claude plugin list

# Update the plugin
claude plugin update mg-skills-marketplace

# Uninstall the plugin
claude plugin uninstall mg-skills-marketplace
```

### For Claude Desktop/Web

1. Go to [Releases](../../releases)
2. Download the plugin package or individual `.skill` files
3. In Claude Desktop/Web, go to **Settings → Plugins** or **Settings → Skills**
4. Click **Add** and select the downloaded file(s)

## 💡 Using Skills in Claude Code CLI

Once installed, skills are automatically available in Claude Code. Claude will detect when to use them based on your requests.

**Automatic Activation (Recommended):**

Skills activate automatically when your request matches their description:

```bash
# Claude will automatically use python-clean-code skill
claude "Help me write a Python function with proper type hints"

# Or start an interactive session
claude
> I need to refactor this Python code to follow clean architecture
```

**Manual Invocation:**

You can explicitly invoke a skill using the `/` slash command:

```bash
claude
> /python-clean-code
```

**Check Available Skills:**

```bash
claude
> What skills are available?
```

**Example Workflows:**

```bash
# Python Clean Code Skill
> Create a new Python project with best practices
> Review this Python code for clean code violations
> Refactor this function to use type hints and early returns
> What's the recommended project structure for a FastAPI app?
```

## 📁 Repository Structure

```
mg-skills-marketplace/
├── README.md                  # This file
├── LICENSE                    # MIT License
├── CONTRIBUTING.md            # Contribution guidelines
├── install.sh                # Manual installation script
├── uninstall.sh              # Manual uninstallation script
├── .claude-plugin/           # Plugin configuration
│   └── plugin.json           # Plugin metadata
└── skills/
    └── python-clean-code/
        ├── SKILL.md           # Skill metadata and instructions
        ├── scripts/           # Executable utilities (init_project.py)
        └── references/        # Detailed documentation
            ├── coding-style.md
            ├── project-structure.md
            └── vertical-slice-api.md
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
