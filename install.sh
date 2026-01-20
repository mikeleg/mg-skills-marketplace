#!/usr/bin/env bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="${SCRIPT_DIR}/skills"

# Installation targets
GLOBAL_SKILLS_DIR="${HOME}/.claude/skills"
LOCAL_SKILLS_DIR=".claude/skills"

# Functions
print_header() {
    echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║   MG Skills Marketplace - Installation    ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"
    echo
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

show_help() {
    cat << EOF
Usage: ./install.sh [OPTIONS] [SKILLS...]

Install Claude Code skills from MG Skills Marketplace.

OPTIONS:
    -g, --global          Install skills globally (~/.claude/skills/)
    -l, --local           Install skills locally (.claude/skills/)
    -a, --all             Install all available skills
    -h, --help            Show this help message
    --list                List available skills
    --uninstall           Uninstall specified skills

EXAMPLES:
    ./install.sh --global --all
        Install all skills globally

    ./install.sh --local python-clean-code
        Install python-clean-code skill locally

    ./install.sh --global python-clean-code typescript-best-practices
        Install multiple skills globally

    ./install.sh --list
        Show all available skills

    ./install.sh --uninstall --global python-clean-code
        Uninstall python-clean-code from global skills

EOF
}

list_available_skills() {
    echo -e "${BLUE}Available Skills:${NC}\n"

    if [ ! -d "$SKILLS_DIR" ]; then
        print_error "Skills directory not found: $SKILLS_DIR"
        exit 1
    fi

    local count=0
    for skill_path in "$SKILLS_DIR"/*; do
        if [ -d "$skill_path" ] && [ -f "$skill_path/SKILL.md" ]; then
            skill_name=$(basename "$skill_path")

            # Extract description from SKILL.md
            description=$(sed -n '/^description:/,/^---/p' "$skill_path/SKILL.md" | \
                         sed -n 's/^description: \(.*\)/\1/p' | \
                         head -1)

            count=$((count + 1))
            echo -e "  ${GREEN}$skill_name${NC}"
            echo -e "    $description"
            echo
        fi
    done

    if [ $count -eq 0 ]; then
        print_warning "No skills found in $SKILLS_DIR"
    else
        echo -e "${BLUE}Total: $count skill(s)${NC}"
    fi
}

get_all_skills() {
    local skills=()
    for skill_path in "$SKILLS_DIR"/*; do
        if [ -d "$skill_path" ] && [ -f "$skill_path/SKILL.md" ]; then
            skills+=("$(basename "$skill_path")")
        fi
    done
    echo "${skills[@]}"
}

validate_skill() {
    local skill_name=$1
    local skill_path="$SKILLS_DIR/$skill_name"

    if [ ! -d "$skill_path" ]; then
        print_error "Skill not found: $skill_name"
        return 1
    fi

    if [ ! -f "$skill_path/SKILL.md" ]; then
        print_error "Invalid skill (missing SKILL.md): $skill_name"
        return 1
    fi

    return 0
}

install_skill() {
    local skill_name=$1
    local target_dir=$2

    local source_path="$SKILLS_DIR/$skill_name"
    local dest_path="$target_dir/$skill_name"

    # Validate skill
    if ! validate_skill "$skill_name"; then
        return 1
    fi

    # Create target directory
    mkdir -p "$target_dir"

    # Check if skill already exists
    if [ -d "$dest_path" ]; then
        print_warning "Skill already exists: $dest_path"
        read -p "Overwrite? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Skipping $skill_name"
            return 0
        fi
        rm -rf "$dest_path"
    fi

    # Copy skill
    cp -r "$source_path" "$dest_path"
    print_success "Installed: $skill_name → $dest_path"

    return 0
}

uninstall_skill() {
    local skill_name=$1
    local target_dir=$2

    local dest_path="$target_dir/$skill_name"

    if [ ! -d "$dest_path" ]; then
        print_error "Skill not installed: $skill_name"
        return 1
    fi

    rm -rf "$dest_path"
    print_success "Uninstalled: $skill_name from $dest_path"

    return 0
}

# Parse arguments
MODE=""
INSTALL_ALL=false
UNINSTALL=false
SKILLS_TO_INSTALL=()

while [[ $# -gt 0 ]]; do
    case $1 in
        -g|--global)
            MODE="global"
            shift
            ;;
        -l|--local)
            MODE="local"
            shift
            ;;
        -a|--all)
            INSTALL_ALL=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        --list)
            list_available_skills
            exit 0
            ;;
        --uninstall)
            UNINSTALL=true
            shift
            ;;
        -*)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
        *)
            SKILLS_TO_INSTALL+=("$1")
            shift
            ;;
    esac
done

# Main execution
print_header

# If no mode specified, ask user
if [ -z "$MODE" ]; then
    echo "Select installation mode:"
    echo "  1) Global (all projects) → ~/.claude/skills/"
    echo "  2) Local (current project) → .claude/skills/"
    echo
    read -p "Enter choice (1 or 2): " choice

    case $choice in
        1)
            MODE="global"
            ;;
        2)
            MODE="local"
            ;;
        *)
            print_error "Invalid choice"
            exit 1
            ;;
    esac
fi

# Set target directory
if [ "$MODE" = "global" ]; then
    TARGET_DIR="$GLOBAL_SKILLS_DIR"
    print_info "Installing skills globally: $TARGET_DIR"
else
    TARGET_DIR="$LOCAL_SKILLS_DIR"
    print_info "Installing skills locally: $TARGET_DIR"
fi

echo

# Determine which skills to install
if [ "$INSTALL_ALL" = true ]; then
    SKILLS_TO_INSTALL=($(get_all_skills))
    print_info "Installing all skills: ${SKILLS_TO_INSTALL[*]}"
elif [ ${#SKILLS_TO_INSTALL[@]} -eq 0 ]; then
    # Interactive mode - show available skills and ask
    list_available_skills
    echo
    read -p "Enter skill names to install (space-separated) or 'all': " input

    if [ "$input" = "all" ]; then
        SKILLS_TO_INSTALL=($(get_all_skills))
    else
        read -ra SKILLS_TO_INSTALL <<< "$input"
    fi
fi

# Validate we have skills to process
if [ ${#SKILLS_TO_INSTALL[@]} -eq 0 ]; then
    print_error "No skills specified"
    exit 1
fi

echo
echo "────────────────────────────────────────────"
echo

# Install or uninstall skills
SUCCESS_COUNT=0
FAILED_COUNT=0

for skill in "${SKILLS_TO_INSTALL[@]}"; do
    if [ "$UNINSTALL" = true ]; then
        if uninstall_skill "$skill" "$TARGET_DIR"; then
            SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
        else
            FAILED_COUNT=$((FAILED_COUNT + 1))
        fi
    else
        if install_skill "$skill" "$TARGET_DIR"; then
            SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
        else
            FAILED_COUNT=$((FAILED_COUNT + 1))
        fi
    fi
done

echo
echo "────────────────────────────────────────────"
echo

# Summary
if [ "$UNINSTALL" = true ]; then
    print_success "Uninstalled: $SUCCESS_COUNT skill(s)"
else
    print_success "Installed: $SUCCESS_COUNT skill(s)"
fi

if [ $FAILED_COUNT -gt 0 ]; then
    print_warning "Failed: $FAILED_COUNT skill(s)"
fi

echo
if [ "$UNINSTALL" = false ]; then
    print_info "Skills are now available in Claude Code CLI!"
    echo
    echo "Try them by asking Claude:"
    echo "  - \"Help me write clean Python code\""
    echo "  - Or manually invoke: /python-clean-code"
fi

exit 0
