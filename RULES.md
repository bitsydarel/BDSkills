# Development Guidelines for DBChunker

This document outlines the mandatory coding standards, design principles, and development philosophy for the DBChunker project. Adherence to these guidelines is crucial for maintaining code quality, readability, and maintainability.

## Environment Setup

**MANDATORY**: This project uses a virtual environment for dependency management. Always activate it before running any Python commands.

```bash
# Activate the virtual environment
source .venv/bin/activate
```

All subsequent commands in this document assume the virtual environment is active.

## Core Philosophy

### 1. Tree of Thoughts Problem-Solving

When faced with a technical challenge, adopt a "tree-of-thoughts" approach. Explore multiple potential solutions and evaluate their trade-offs (e.g., complexity, maintainability, performance). The selected solution **must address the underlying root cause** of the problem, not just the immediate symptom. We prioritize effective, well-designed solutions over quick fixes that merely suppress or postpone an issue.

### 2. Code Comprehension Strategy

To understand existing code, use a "graph-of-thoughts" analysis to map out how different components (classes, functions, modules) interact. Combine this with both a **top-down analysis** (starting from the high-level architecture and drilling down into details) and a **bottom-up analysis** (starting with individual functions and understanding how they contribute to the larger system). This ensures a holistic understanding of the codebase.

### 3. Clean Architecture

The project adheres to Clean Architecture principles. Dependencies must always point inwards, from outer layers (e.g., frameworks, UI, delivery mechanisms) to inner layers (domain logic). The core domain logic in each feature must have zero dependencies on external frameworks or libraries.

### 4. Clean Code

- **Readability is Key**: Write code that is easy to read, understand, and maintain. Use meaningful, descriptive names for variables, functions, and classes. Prefer self-documenting code over excessive comments. Comments should explain *why*, not *what*.
- **Keep It Simple, Stupid (KISS)**: Avoid unnecessary complexity. Simple, straightforward code is less prone to bugs and easier to evolve.
- **Don't Repeat Yourself (DRY)**: Avoid code duplication. Encapsulate and abstract common patterns and logic into reusable functions, classes, or modules.
- **Avoid Spaghetti Code**: Ensure a clear and logical control flow. Avoid deeply nested structures, complex conditional logic, and circular dependencies that make the code hard to follow.

### 5. SOLID Principles

- **Single Responsibility**: Each class or module should have one, and only one, reason to change.
- **Open/Closed**: Software entities should be open for extension but closed for modification.
- **Liskov Substitution**: Objects should be replaceable with instances of their subtypes without altering the correctness of the program.
- **Interface Segregation**: Clients should not be forced to depend on interfaces they do not use.
- **Dependency Inversion**: Depend on abstractions, not on concretions.

## Mandatory Coding Standards

### SOLID Principles Adherence

**MANDATORY**: All code must be written while strictly following SOLID principles:

- **Single Responsibility Principle (SRP)**
- **Open-Closed Principle (OCP)**
- **Liskov Substitution Principle (LSP)**
- **Interface Segregation Principle (ISP)**
- **Dependency Inversion Principle (DIP)**

### Object-Oriented Approach

- **Prefer Classes and Objects**: Structure code using an object-oriented approach. Encapsulate data and behavior within classes to create modular, reusable, and maintainable components.

### Function and Method Design

- **Small and Focused**: Functions and methods must be small and do one thing well. A function should not be larger than what can be viewed on a single screen.
- **Cognitive Complexity Limit**: The Cognitive Complexity of any function or method **must not exceed 15**. If a function is more complex, it is a strong indicator that it needs to be refactored into smaller, more manageable units.
- **No Side Effects**: Prefer pure functions that do not have observable side effects.

### Strict Typing

- **Full Annotation**: All function parameters and return types must have explicit type annotations.
- **Precise Generics**: Use `TypeVar` and proper generic typing for reusable components.
- **Specific Collections**: Use specific collection types like `List[str]` or `Dict[str, int]` instead of `list` or `dict`.
- **Handle Nullability**: Use `Optional[T]` or `Union[T, None]` for values that can be `None`.

### Function Arguments

- **Keyword Arguments Only**: All function and method calls **MUST** use keyword arguments. Positional arguments are forbidden to improve clarity and reduce errors.

    ```python
    # ✅ CORRECT
    chunker = ContextAwareHeaderChunker(chunk_size=4096)

    # ❌ INCORRECT
    chunker = ContextAwareHeaderChunker(4096)
    ```

- **No **kwargs in Production Code**: The use of `**kwargs` is **STRICTLY PROHIBITED** in all production code (`src/`). Every function and method parameter must be explicitly declared and documented.

    **Rationale:**
    - **API Clarity**: Callers must know exactly what arguments a function accepts without inspecting implementations
    - **Type Safety**: Static type checkers can validate all arguments at compile time
    - **Documentation**: Explicit parameters are self-documenting and IDE-discoverable
    - **Refactoring Safety**: Changes to parameters are caught immediately by type checkers
    - **SOLID Compliance**: Violates Interface Segregation Principle by hiding dependencies

    **Exceptions:**
    - **Test Code**: Test fixtures, mocks, and stubs in `tests/` MAY use `**kwargs` for flexibility
    - **Advanced Typing Patterns**: The following patterns are PERMITTED when properly typed:
      - `**kwargs: Unpack[TypedDict]` - For structured keyword arguments with known keys
      - `**kwargs: P.kwargs` - For ParamSpec in decorators preserving exact signatures
      - These must ONLY be used when the alternative is genuinely less maintainable

    **Correct Alternatives:**
    ```python
    # ❌ INCORRECT - Hidden parameters
    def process_data(data: str, **kwargs: object) -> Result:
        timeout = kwargs.get('timeout', 30)
        retry = kwargs.get('retry', True)
        ...

    # ✅ CORRECT - Explicit parameters
    def process_data(
        *,
        data: str,
        timeout: int = 30,
        retry: bool = True,
    ) -> Result:
        ...

    # ❌ INCORRECT - Abstract method with **kwargs
    @abstractmethod
    def process(self, *, doc: Document, **kwargs: object) -> Iterator[Result]:
        """Process document with additional options."""

    # ✅ CORRECT - Explicit optional parameters
    @abstractmethod
    def process(
        self,
        *,
        doc: Document,
        validation_mode: Optional[str] = None,
        max_retries: int = 3,
    ) -> Iterator[Result]:
        """Process document with validation mode and retry configuration."""

    # ✅ CORRECT - Method overloading for different signatures
    @overload
    def create_config(self, *, path: str) -> Config: ...
    @overload
    def create_config(self, *, dict_data: dict) -> Config: ...

    def create_config(
        self,
        *,
        path: Optional[str] = None,
        dict_data: Optional[dict] = None,
    ) -> Config:
        """Create config from file path or dictionary."""
        ...

    # ✅ PERMITTED - TypedDict with Unpack (structured kwargs)
    class RuntimeParameters(TypedDict):
        chunk_size_override: NotRequired[int]
        enable_cache: NotRequired[bool]

    def configure(self, **kwargs: Unpack[RuntimeParameters]) -> None:
        """All possible kwargs are explicitly typed in RuntimeParameters."""
        ...

    # ✅ PERMITTED - ParamSpec in decorators (preserving signatures)
    P = ParamSpec("P")
    R = TypeVar("R")

    def with_logging(func: Callable[P, R]) -> Callable[P, R]:
        def wrapper(*args: P.args, **kwargs: P.kwargs) -> R:
            logger.info(f"Calling {func.__name__}")
            return func(*args, **kwargs)
        return wrapper
    ```

    **Migration Strategy:**
    - When you encounter `**kwargs` in existing code, refactor to explicit parameters
    - If the parameter set is truly variable, consider using a configuration object (Pydantic model)
    - For wrapper/decorator patterns, use ParamSpec to preserve exact signatures
    - Document the rationale if using permitted advanced typing patterns

### No Magic Strings for Bound Values

**MANDATORY**: String literals must NOT be used for bounded values (parameters with fixed valid options, field values, return values). All bounded string values must use string enums (`str, Enum`) or `Literal` types.

**Rationale:**
- **Type Safety**: Static type checkers validate all string values at compile time
- **API Clarity**: All valid options are discoverable via IDE autocomplete and type hints
- **Refactoring Safety**: Renaming enum values is caught immediately by type checkers across the codebase
- **Documentation**: Enum members are self-documenting and eliminate ambiguity
- **Prevention of Typos**: Compile-time validation prevents runtime errors from typos

**What Constitutes a Bounded Value:**
- Function/method parameters that accept only specific string values
- Model fields with a fixed set of valid options
- Return values that are always one of a known set of strings
- Configuration options with enumerated choices

**Scope:**

- **PROHIBITED**:
  - String literals as defaults when values are bounded: `mode: str = "auto"`
  - Validation sets with string literals: `valid_modes = {"auto", "manual"}`
  - Hardcoded string returns: `return "success"`
  - Magic strings in comparisons: `if mode == "auto":`

- **REQUIRED**:
  - String enums for all bounded values: `class Mode(str, Enum): AUTO = "auto"`
  - Enum members in signatures: `mode: Mode = Mode.AUTO`
  - Enum members in comparisons: `if mode == Mode.AUTO:`

- **ACCEPTABLE**:
  - Dynamic strings (user input, file paths, API responses, generated content)
  - Empty string checks: `if text == ""`
  - String operations: `prefix = f"Header: {title}"`
  - Display/formatting strings: `print(f"Status: {status.value}")`

**Examples:**

```python
# ❌ INCORRECT - Magic strings with validation
class Config(BaseModel):
    mode: str = Field(default="auto")  # Magic string default

    @field_validator("mode")
    def validate_mode(cls, v: str) -> str:
        valid_modes = {"auto", "manual", "hybrid"}  # Magic string set
        if v not in valid_modes:
            raise ValueError(f"Invalid mode: {v}")
        return v

# ❌ INCORRECT - Magic strings in dataclass
@dataclass
class Settings:
    strategy: str = "sentence"  # Magic string

    def _validate_strategy(self) -> None:
        valid = {"sentence", "paragraph", "word"}  # Magic strings
        if self.strategy not in valid:
            raise ValueError(f"Invalid strategy")

# ❌ INCORRECT - Magic string return value
@property
def config_type(self) -> str:
    return "default"  # Magic string

# ❌ INCORRECT - Magic string comparison
def process(mode: str) -> None:
    if mode == "auto":  # Magic string comparison
        auto_process()

# ✅ CORRECT - String enum with Pydantic
from enum import Enum

class ProcessMode(str, Enum):
    """Available processing modes."""
    AUTO = "auto"
    MANUAL = "manual"
    HYBRID = "hybrid"

class Config(BaseModel):
    """Configuration with type-safe enum field."""
    mode: ProcessMode = Field(
        default=ProcessMode.AUTO,
        description="Processing mode selection"
    )

    model_config = ConfigDict(
        use_enum_values=True,  # Serialize enum as string value
    )

# ✅ CORRECT - String enum with dataclass
from enum import Enum
from dataclasses import dataclass

class SplitStrategy(str, Enum):
    """Content splitting strategies."""
    SENTENCE = "sentence"
    PARAGRAPH = "paragraph"
    WORD = "word"
    CHARACTER = "character"

@dataclass
class Settings:
    """Settings with type-safe enum field."""
    strategy: SplitStrategy = SplitStrategy.SENTENCE
    # No validation needed - type system enforces correctness

# ✅ CORRECT - Enum return value
@property
def config_type(self) -> ConfigType:
    """Return the configuration type identifier."""
    return ConfigType.DEFAULT

# ✅ CORRECT - Type-safe enum comparison
def process(*, mode: ProcessMode) -> None:
    """Process with type-safe mode check."""
    if mode == ProcessMode.AUTO:  # Type-safe comparison
        auto_process()
    elif mode in (ProcessMode.MANUAL, ProcessMode.HYBRID):
        manual_process()

# ✅ CORRECT - Literal type for very small fixed sets
from typing import Literal

def set_log_level(
    *,
    level: Literal["DEBUG", "INFO", "WARNING", "ERROR"] = "INFO"
) -> None:
    """Set logging level (Literal acceptable for <5 known values)."""
    pass

# ✅ ACCEPTABLE - Dynamic strings (not bounded)
def load_file(*, path: str) -> str:  # Path is dynamic, not bounded
    """Load file from dynamic path."""
    with open(path) as f:
        return f.read()

def format_message(*, name: str, status: Status) -> str:  # Return is dynamic
    """Format message with dynamic content."""
    return f"User {name} has status: {status.value}"

def is_empty(*, text: str) -> bool:  # String check is acceptable
    """Check if text is empty."""
    return text == ""  # Empty string literal OK
```

**Migration Strategy:**

When refactoring code with magic strings:

1. **Identify bounded values**: Find all function parameters, fields, and return values that use string literals from a fixed set
2. **Create enum**: Define a `str, Enum` class with all valid values
3. **Place enum appropriately**:
   - Domain enums in `models/` (e.g., ItemType, MimeType)
   - Config enums in `config.py` or near their config class
   - Module-specific enums in the same module they're used
4. **Update all usages**: Replace string literals with enum members
5. **Update type hints**: Change `str` to the enum type
6. **Pydantic integration**: Use `use_enum_values=True` in model_config for serialization
7. **Remove validation code**: Enum type enforcement replaces manual validation

**Common Enum Patterns:**

```python
# Pattern 1: Basic string enum
class ItemType(str, Enum):
    """Document item types."""
    TEXT = "text"
    TITLE = "title"
    SECTION_HEADER = "section_header"

# Pattern 2: Enum with methods
class Device(str, Enum):
    """Processing device types."""
    AUTO = "auto"
    CPU = "cpu"
    CUDA = "cuda"
    MPS = "mps"

    def is_gpu(self) -> bool:
        """Check if device is GPU-based."""
        return self in (Device.CUDA, Device.MPS)

# Pattern 3: Enum with metadata
class MimeType(str, Enum):
    """Document MIME types with file extensions."""
    PDF = "application/pdf"
    DOCX = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    MARKDOWN = "text/markdown"

    @property
    def extension(self) -> str:
        """Get file extension for this MIME type."""
        extensions = {
            MimeType.PDF: ".pdf",
            MimeType.DOCX: ".docx",
            MimeType.MARKDOWN: ".md",
        }
        return extensions[self]
```

**Exceptions:**

The following patterns DO NOT require enums:

1. **Dynamic content**: User input, file paths, API responses, generated text
2. **String operations**: Concatenation, formatting, templating
3. **Empty/whitespace checks**: `if text == ""` or `if line.strip() == ""`
4. **Regular expressions**: Pattern strings are acceptable
5. **Test assertions**: Test code may use string literals for flexibility
6. **Very small Literal types**: For 2-3 values, `Literal["a", "b"]` is acceptable

**Enforcement:**

- Code reviews must reject magic strings for bounded values
- Mypy and type checkers will catch enum type violations
- New code must use enums from the start
- Existing code should be refactored when touched

### Pydantic for Data Models

- **BaseModel Everywhere**: Use Pydantic's `BaseModel` for all data transfer objects and models. Do not use standard dataclasses.
- **Validation and Descriptions**: Use `Field()` to provide descriptions, validation rules, and default values for model attributes.

### Installation for Development

**MANDATORY**: To ensure that tests run correctly and imports are handled properly, the project must be installed in "editable mode" within the activated virtual environment. This makes the `dbchunker` package available for import.

```bash
# Install the project in editable mode
pip install -e .
```

### Environment Configuration

**MANDATORY**: This project uses a `.env` file for managing environment variables. This allows developers to configure document parsing pipelines and other settings without modifying code.

#### Setup Instructions

1. **Copy the template file to create your local configuration**:
   ```bash
   cp .env.example .env
   ```

2. **Edit `.env` for your environment**:
   Open the `.env` file and fill in values according to your needs. The file is well-documented with descriptions and examples for each configuration option.

3. **Never commit the `.env` file**:
   The `.env` file is in `.gitignore` and should never be committed to version control, as it may contain sensitive information like API tokens. The `.env.example` file is the authoritative template and is committed for all developers to use.


### Import Conventions

- **Application Code**: Within the `src/dbchunker` directory, relative imports (`.`) are preferred for sibling modules.
- **Test Code**: Tests **MUST** import application code using the package name, for example: `from dbchunker.models import Chunk`. This ensures tests are run against the installed package.
- **No `sys.path` Manipulation**: Manually altering `sys.path` in any script or test is strictly forbidden. An editable install makes this unnecessary and dangerous, as it can hide packaging issues.

## Project Structure

This project follows the standard "src layout".

- **`src/`**: All application source code resides within the `src` directory.
- **`tests/`**: All tests reside in the `tests` directory, which is at the project root, parallel to `src`.
- **`__init__.py`**: All directories that are part of the package (in `src` and `tests`) must contain an `__init__.py` file.

## Testing Requirements

- **Structure**: The `tests/` directory should mirror the `src/dbchunker` directory structure.
- **Framework**: Use pytest for all test code.
- **Test Execution**: Tests **MUST** be run from the project root directory using pytest:

    ```bash
    # Run all tests with verbose output
    pytest -v

    # Run tests with coverage report
    pytest --cov

    # Run specific test file or directory
    pytest tests/chunkers/test_header_chunker.py -v

    # Run tests matching a pattern
    pytest -k "test_chunk" -v
    ```

- **Fixtures**: Common test fixtures are defined in `tests/conftest.py`:
  - `build_normalized_item` - Create NormalizedItem instances with sensible defaults
  - `build_normalized_document` - Create NormalizedDocument instances
  - `build_simple_document` - Create structured documents with title and sections
  - `make_chunk` - Create Chunk instances for testing
  - `build_context` - Create ChunkContext instances
  - `header_chunker` - Provides a HeaderChunker instance
  - `error_handler` - Provides an ErrorHandler instance
  - `context_adjustment_strategy` - Provides a ContextAdjustmentStrategy instance

- **Test Class Structure**: Use plain class definitions (not inheriting from unittest.TestCase):

    ```python
    class TestMyFeature:
        """Tests for MyFeature."""

        def test_something(self, build_normalized_item: callable) -> None:
            """Description of what is being tested."""
            item = build_normalized_item(text="test")
            assert item.text == "test"
    ```

- **Assertions**: Use plain `assert` statements or `pytest.raises()` for exception testing:

    ```python
    assert result == expected
    assert value > 0
    assert "text" in chunk.text
    with pytest.raises(ValueError, match="error message"):
        function_that_raises()
    ```

- **Coverage**: A minimum of 80% test coverage is required for all new and modified code.
- **Comprehensive Edge Case Testing**: Tests must cover a wide range of edge cases, including but not limited to empty inputs, invalid data types, large inputs, and unexpected or malformed data.
- **Test Design Criteria**: All tests must follow the following criteria:
  - Equivalence Partitioning (EP)
  - Boundary Value Analysis (BVA)
  - CORRECT Boundary Heuristic
  - Right-BICEP Result Heuristic
  - Zero–One–Many & “Off-by-One”
  - Happy Path / Sad Path / Ugly Path
  - Arrange–Act–Assert / Given–When–Then
  - Input Model & Property-Based Thinking
  - Combinatorial / Pairwise Testing
- **Naming Convention**: Use `test_*.py` for files, `Test*` for classes, and `test_*` for methods.
- **No Performance Tests in Production Code**: If performance monitoring is required, write separate benchmark tests. Do not include performance measurement logic (e.g., timing decorators) in the production application code.

## Development Workflow

1. **Tests First (TDD)**: Write or update tests before implementing new features or fixing bugs, where applicable.
2. **Keep API Simple**: The public API should remain minimal and stable. Avoid exposing internal implementation details.
3. **Document Changes**: Update documentation and docstrings to reflect any changes.
4. **MANDATORY: Code Quality, Type Checking, Linting, and Testing**: Before committing, you **MUST** run ALL of the following checks. Changes that do not pass all checks cannot be committed and pull requests will be rejected:

    ```bash
    # Format code (entire project)
    black .

    # Type checking
    mypy src/

    # Linting
    ruff check src/ tests/ --fix

    # Run all tests
    pytest -v --cov
    ```

    All of these commands must complete successfully with no errors or failures. Any pull request that has failing checks will NOT be accepted.

## Quality Checks Enforcement

**CRITICAL**: The following quality checks are **NON-NEGOTIABLE** and must pass before any code can be committed:

1. **Code Formatting** (`black .`): All code must be formatted consistently using Black
2. **Type Safety** (`mypy src/`): All type hints must be correct with zero mypy errors
3. **Code Linting** (`ruff check src/ tests/ --fix`): All linting rules must pass
4. **Test Coverage** (`pytest -v --cov`): All tests must pass with no failures or errors

**Important**:

- No commits are accepted without passing all checks
- No pull requests are accepted without passing all checks
- Before pushing to remote, verify all checks pass locally