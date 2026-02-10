# 🛒 MG Skills Marketplace

A curated collection of skills to extend Claude's capabilities with specialized knowledge, workflows, and tools.

## 📦 Available Skills

| Skill                                            | Description                                                                                              | Category    |
|--------------------------------------------------|----------------------------------------------------------------------------------------------------------|-------------|
| [python-clean-code](skills/python-clean-code/)   | Write clean, maintainable Python code with PEP 8, type hints, and pragmatic clean architecture           | Development |
| [python-subagent](skills/python-subagent/)       | Dispatch Python tasks to a subagent pre-loaded with python-clean-code conventions                        | Development |

## 🚀 Installation

### For Claude Code CLI (Recommended)

This is a Claude Code plugin marketplace that bundles multiple skills. You can install it as a marketplace or install individual plugins.

**Option 1: Add as Marketplace (Recommended)**

```bash
# Add the marketplace to Claude Code CLI
claude
> /plugin marketplace add https://github.com/YOUR_USERNAME/mg-skills-marketplace

# Then install skills from the marketplace
> /plugin install python-clean-code
```

**Option 2: Install Entire Marketplace as Plugin**

```bash
# Install all skills at once
claude plugin install https://github.com/YOUR_USERNAME/mg-skills-marketplace

# Or clone first, then install
git clone https://github.com/YOUR_USERNAME/mg-skills-marketplace.git
claude plugin install ./mg-skills-marketplace
```

**Option 3: Install Individual Skills**

```bash
# Install specific skill directly
claude plugin install https://github.com/YOUR_USERNAME/mg-skills-marketplace/skills/python-clean-code
```

**Option 4: Manual Installation**

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/mg-skills-marketplace.git

# Install using the installation script
cd mg-skills-marketplace
./install.sh --global --all
```

**Managing Plugins:**

```bash
# List installed plugins and marketplaces
claude
> /plugin list
> /plugin marketplace list

# Update plugins from marketplace
> /plugin update python-clean-code

# Uninstall plugins
> /plugin uninstall python-clean-code
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
├── .claude-plugin/           # Marketplace configuration
│   ├── plugin.json           # Marketplace as a plugin
│   └── marketplace.json      # Marketplace catalog
└── skills/
    └── python-clean-code/
        ├── .claude-plugin/
        │   └── plugin.json   # Skill plugin metadata
        ├── SKILL.md           # Skill instructions
        ├── scripts/           # Executable utilities
        │   └── init_project.py
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
