# Python Review Checklist

## Anti-Patterns

- **Mutable default arguments** — `def f(items=[]):` or `def f(opts={}):`. Shared
  mutable state leaks across calls. Fix: default to `None`, create the mutable
  value inside the function body.
- **Bare `except:`** — swallows `KeyboardInterrupt` and `SystemExit` along with
  real errors. Fix: catch the specific exception type.
- **Broad `except Exception:` with no re-raise or logging** — hides real
  failures. Fix: catch the narrowest exception that can actually occur, or log
  and re-raise.
- **God functions/classes** — a function or class doing many unrelated things
  (parsing, I/O, business logic, formatting all in one place). Fix: split by
  responsibility.
- **Deep nesting (>3 levels)** — hard to follow control flow. Fix: extract
  helper functions, use early returns / guard clauses.
- **Global mutable state** — module-level lists/dicts mutated from multiple
  functions. Fix: pass state explicitly or encapsulate in a class/instance.
- **Using `==` for `None`/singleton checks** — should be `is None` / `is not
  None`.
- **String concatenation in a loop** (`s += x`) for building large strings —
  quadratic cost. Fix: accumulate in a list and `"".join(...)`.
- **Catching exceptions just to `pass`** — silently discarding failures.
- **Comparing types with `type(x) == SomeClass`** instead of `isinstance(x,
  SomeClass)` — breaks subclassing.
- **Using mutable class attributes as instance defaults** — same root cause as
  mutable default arguments, shared across all instances.
- **Shadowing builtins** (`list`, `dict`, `id`, `type`, `str` as variable names).
- **Returning inconsistent types** from the same function (e.g. `None` on one
  path, a list on another) without the caller being able to tell which.
- **Magic numbers/strings** repeated across the file instead of named
  constants.

## Import Hygiene

- **Wildcard imports** (`from module import *`) — pollutes namespace, hides
  origin of names. Fix: import explicit names or the module itself.
- **Unused imports** — dead weight, confuses readers about dependencies.
- **Import grouping/order** (PEP 8 + common tooling convention):
  1. Standard library imports
  2. Third-party imports
  3. Local/first-party imports
  Each group separated by a blank line, alphabetized within the group. `isort`
  enforces this automatically.
- **Circular imports** — module A imports module B which imports module A.
  Usually a sign responsibilities need to move to a third module.
- **Importing from deep internal paths** of a third-party package instead of
  its public API — breaks on upgrades.
- **Relative vs absolute imports** — prefer absolute imports for clarity unless
  the project convention is explicitly otherwise.

## PEP 8 / Style

- **Line length** — 79 characters for code, 72 for docstrings/comments (PEP 8
  default; many teams relax to 88/100 — follow the project's existing
  configuration, e.g. `pyproject.toml`/`setup.cfg`, if one exists).
- **Naming conventions**:
  - `snake_case` for functions, variables, modules.
  - `PascalCase` for classes.
  - `UPPER_CASE` for module-level constants.
  - Leading underscore (`_name`) for internal/non-public members.
- **Whitespace**:
  - No trailing whitespace.
  - Two blank lines between top-level defs/classes, one between methods.
  - No spaces immediately inside parentheses/brackets; one space around binary
    operators.
- **Docstrings** on public modules, classes, and functions describing purpose
  (not restating the signature).
- **f-strings** preferred over `%` formatting or `.format()` for new code
  (not a PEP 8 rule, but a strong modern-Python convention worth flagging).
- **Type hints** on public function signatures where the codebase already uses
  them elsewhere — flag inconsistent adoption, not absence everywhere.
- **Comparisons to booleans** (`if x == True:`) — should be `if x:` / `if not
  x:`.
