# Python Project Structure Reference

## Pragmatic Clean Architecture

Four **virtual** layers (not rigid folders):

| Layer | Purpose | Contains |
|-------|---------|----------|
| **Domain** | Core business logic | Entities, value objects, domain services |
| **Application** | Orchestration | Use cases, workflows, coordinators |
| **Infrastructure** | External systems | DB clients, API clients, file loaders |
| **Serving** | Entry points | CLI, REST API, MCP server |

**Key rule**: Dependencies point inward only. Domain/Application never import from Infrastructure/Serving.

## Recommended Project Layout

```
my-project/
├── pyproject.toml          # Dependencies (uv/poetry/pip)
├── Makefile                 # Command shortcuts
├── configs/                 # YAML/TOML configurations
├── scripts/                 # CLI entry points
├── notebooks/               # Exploration (optional)
├── tests/
│   ├── unit/
│   └── integration/
└── src/
    └── my_package/
        ├── __init__.py
        ├── config.py           # Configuration loading
        ├── base.py             # Abstract interfaces (ABC)
        │
        ├── entities/           # Domain: data models
        │   ├── __init__.py
        │   ├── user.py
        │   └── order.py
        │
        ├── services/           # Domain: business logic units
        │   ├── __init__.py
        │   ├── pricing.py
        │   └── validation.py
        │
        ├── workflows/          # Application: orchestration
        │   ├── __init__.py
        │   └── order_processing.py
        │
        ├── repositories/       # Infrastructure: data access
        │   ├── __init__.py
        │   ├── base.py
        │   └── postgres.py
        │
        ├── clients/            # Infrastructure: external APIs
        │   ├── __init__.py
        │   └── payment_gateway.py
        │
        ├── api/                # Serving: REST endpoints
        │   ├── __init__.py
        │   └── routes.py
        │
        └── cli/                # Serving: command line
            ├── __init__.py
            └── main.py
```

## Organizing by Actionability

Group related code together, not by type:

```python
# ❌ Bad: scattered across folders
prompts/
    order_processor.py
nodes/
    order_processor.py
chains/
    order_processor.py

# ✅ Good: self-contained module
order_processor/
    __init__.py
    prompts.py
    nodes.py
    workflow.py
```

**Test**: Can you copy-paste this module to another project and have it work?

## Dependency Injection Pattern

Define interfaces in `base.py`, implement in infrastructure:

```python
# base.py - Abstract interface
from abc import ABC, abstractmethod

class LLMClient(ABC):
    @abstractmethod
    def generate(self, prompt: str) -> str:
        ...

class Repository(ABC):
    @abstractmethod
    def save(self, entity: Entity) -> None:
        ...

    @abstractmethod
    def find_by_id(self, id: str) -> Entity | None:
        ...


# infrastructure/openai_client.py - Concrete implementation
class OpenAIClient(LLMClient):
    def __init__(self, api_key: str, model: str = "gpt-4") -> None:
        self._client = openai.Client(api_key=api_key)
        self._model = model

    def generate(self, prompt: str) -> str:
        response = self._client.chat.completions.create(
            model=self._model,
            messages=[{"role": "user", "content": prompt}],
        )
        return response.choices[0].message.content


# application/workflow.py - Uses interface, not implementation
class ContentGenerator:
    def __init__(self, llm: LLMClient, repository: Repository) -> None:
        self._llm = llm
        self._repository = repository

    def generate_and_save(self, topic: str) -> Content:
        text = self._llm.generate(f"Write about: {topic}")
        content = Content(topic=topic, text=text)
        self._repository.save(content)
        return content
```

## Builder Pattern for Wiring

```python
# builders.py
from dataclasses import dataclass

@dataclass
class AppConfig:
    llm_provider: str
    db_url: str
    debug: bool = False


def build_llm_client(config: AppConfig) -> LLMClient:
    match config.llm_provider:
        case "openai":
            return OpenAIClient(api_key=os.environ["OPENAI_API_KEY"])
        case "fake":
            return FakeLLMClient()
        case _:
            raise ValueError(f"Unknown LLM provider: {config.llm_provider}")


def build_repository(config: AppConfig) -> Repository:
    if config.debug:
        return InMemoryRepository()
    return PostgresRepository(config.db_url)


def build_app(config: AppConfig) -> ContentGenerator:
    return ContentGenerator(
        llm=build_llm_client(config),
        repository=build_repository(config),
    )
```

## Minimal pyproject.toml

```toml
[project]
name = "my-project"
version = "0.1.0"
requires-python = ">=3.11"
dependencies = []

[project.optional-dependencies]
dev = ["pytest", "ruff", "mypy"]

[tool.ruff]
line-length = 100
target-version = "py311"

[tool.ruff.lint]
select = ["E", "F", "I", "UP"]

[tool.mypy]
strict = true
python_version = "3.11"

[tool.pytest.ini_options]
testpaths = ["tests"]
```

## Common Anti-Patterns

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| Rigid 4-folder structure | Circular imports, confusion | Flat modules, virtual layers |
| Folder-per-type | Feature logic scattered | Group by actionability |
| Over-abstraction | Complexity without benefit | Abstract only what you'll swap |
| God classes | Untestable, hard to modify | Single responsibility |
