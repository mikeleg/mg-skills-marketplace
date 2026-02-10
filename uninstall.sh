#!/usr/bin/env bash

# Wrapper script for uninstalling skills
# Simply calls install.sh with --uninstall flag

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

exec "${SCRIPT_DIR}/install.sh" --uninstall "$@"
