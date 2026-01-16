#!/usr/bin/env python3
"""Initialize a new Python project with clean architecture structure."""

import argparse
from pathlib import Path

PYPROJECT_TEMPLATE = '''\
[project]
name = "{name}"
version = "0.1.0"
description = ""
requires-python = ">=3.11"
dependencies = []

[project.optional-dependencies]
dev = ["pytest", "ruff", "mypy"]

[tool.ruff]
line-length = 100
target-version = "py311"

[tool.ruff.lint]
select = ["E", "F", "I", "UP", "B", "SIM"]

[tool.mypy]
strict = true
python_version = "3.11"

[tool.pytest.ini_options]
testpaths = ["tests"]
pythonpath = ["src"]
'''

MAKEFILE_TEMPLATE = '''\
.PHONY: install test lint format typecheck all

install:
\tuv sync

test:
\tuv run pytest

lint:
\tuv run ruff check src tests

format:
\tuv run ruff format src tests

typecheck:
\tuv run mypy src

all: format lint typecheck test
'''

GITIGNORE_TEMPLATE = '''\
__pycache__/
*.py[cod]
*$py.class
.venv/
venv/
.env
*.egg-info/
dist/
build/
.mypy_cache/
.pytest_cache/
.ruff_cache/
'''

BASE_PY_TEMPLATE = '''\
"""Abstract base classes for dependency injection."""

from abc import ABC, abstractmethod
from typing import TypeVar

T = TypeVar("T")


class Repository(ABC):
    """Base repository interface."""

    @abstractmethod
    def save(self, entity: T) -> None:
        """Persist an entity."""
        ...

    @abstractmethod
    def find_by_id(self, entity_id: str) -> T | None:
        """Retrieve an entity by ID."""
        ...
'''

CONFIG_PY_TEMPLATE = '''\
"""Application configuration."""

from dataclasses import dataclass, field
from pathlib import Path


@dataclass
class Config:
    """Main application configuration."""

    debug: bool = False
    log_level: str = "INFO"
    data_dir: Path = field(default_factory=lambda: Path("data"))
'''

INIT_TEMPLATE = '''\
"""{description}"""

__version__ = "0.1.0"
'''


def create_project(name: str, output_dir: Path) -> None:
    """Create a new Python project structure."""
    project_dir = output_dir / name
    package_name = name.replace("-", "_")
    src_dir = project_dir / "src" / package_name

    directories = [
        project_dir / "configs",
        project_dir / "scripts",
        project_dir / "tests" / "unit",
        project_dir / "tests" / "integration",
        src_dir / "entities",
        src_dir / "services",
        src_dir / "workflows",
        src_dir / "infrastructure",
    ]

    for directory in directories:
        directory.mkdir(parents=True, exist_ok=True)
        init_file = directory / "__init__.py"
        if "src" in str(directory) and not init_file.exists():
            init_file.write_text('"""Package."""\n')

    (project_dir / "pyproject.toml").write_text(PYPROJECT_TEMPLATE.format(name=name))
    (project_dir / "Makefile").write_text(MAKEFILE_TEMPLATE)
    (project_dir / ".gitignore").write_text(GITIGNORE_TEMPLATE)

    (src_dir / "__init__.py").write_text(INIT_TEMPLATE.format(description=f"{name} package"))
    (src_dir / "base.py").write_text(BASE_PY_TEMPLATE)
    (src_dir / "config.py").write_text(CONFIG_PY_TEMPLATE)

    (project_dir / "tests" / "__init__.py").write_text("")
    (project_dir / "tests" / "unit" / "__init__.py").write_text("")
    (project_dir / "tests" / "integration" / "__init__.py").write_text("")

    print(f"✅ Created project: {project_dir}")
    print(f"\nStructure:")
    print(f"  {name}/")
    print(f"  ├── pyproject.toml")
    print(f"  ├── Makefile")
    print(f"  ├── configs/")
    print(f"  ├── scripts/")
    print(f"  ├── tests/")
    print(f"  └── src/{package_name}/")
    print(f"      ├── base.py")
    print(f"      ├── config.py")
    print(f"      ├── entities/")
    print(f"      ├── services/")
    print(f"      ├── workflows/")
    print(f"      └── infrastructure/")
    print(f"\nNext steps:")
    print(f"  cd {name}")
    print(f"  uv sync")


def main() -> None:
    parser = argparse.ArgumentParser(description="Initialize a Python project")
    parser.add_argument("name", help="Project name (e.g., my-project)")
    parser.add_argument(
        "--output",
        "-o",
        type=Path,
        default=Path.cwd(),
        help="Output directory (default: current directory)",
    )
    args = parser.parse_args()

    create_project(args.name, args.output)


if __name__ == "__main__":
    main()
