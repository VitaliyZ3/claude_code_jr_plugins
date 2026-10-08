---
name: code-quality-check
description: This skill should be used when the user asks to "review this code", "check for antipatterns", "run a linter", "check imports", "check PEP 8 compliance", "перевір код", "перевір на антипатерни", "подивись на лінтер", or otherwise wants a Python file, diff, or directory reviewed for code smells, lint issues, import hygiene, or style compliance.
---

# Code Quality Check

Review Python code for anti-patterns, linter findings, import hygiene, and PEP 8
compliance, combining automated tool output with manual inspection.

## Procedure

1. Identify the scope: a specific file, a directory, or the current git diff
   (`git diff` / `git diff --staged`) if the user says "review my changes."
2. Run `scripts/run_linters.sh <path...>` to execute whichever of `ruff`, `flake8`,
   `pylint`, `isort`, `black`, and `mypy` are installed on the system. Tools that
   are missing are reported as skipped — do not install new dependencies into the
   user's environment without asking first.
3. Read the actual source file(s), not just the linter output. Linters miss many
   anti-patterns; manual review covers what they don't.
4. Cross-reference findings against the checklist in `references/checklist.md`
   (anti-patterns, import hygiene, PEP 8) before writing the report.
5. Produce a single report grouped by severity, not by tool:
   - **Bugs / correctness risks** — things that will misbehave.
   - **Anti-patterns** — mutable default args, bare `except`, broad `except
     Exception` swallowing errors, global mutable state, god functions/classes,
     deep nesting, duplicated logic.
   - **Imports** — wildcard imports, unused imports, wrong grouping/order
     (stdlib / third-party / local, each alphabetized), circular import risk.
   - **PEP 8 / style** — naming conventions, line length, whitespace, missing
     docstrings on public APIs where the project convention expects them.
   Each finding: file:line, a one-sentence description of the problem, and a
   concrete fix (a short diff or exact replacement code), not a vague suggestion.
6. Do not report findings for intentional, idiomatic code that merely differs
   from personal preference — only report real defects or genuine PEP 8/anti-
   pattern violations.
7. If the user asks to fix the issues (not just review), apply the fixes
   directly with Edit, then re-run `scripts/run_linters.sh` to confirm they are
   resolved, and report the diff.

## Output Format

Lead with a one-line summary ("X issues found: N anti-patterns, N import issues,
N style violations"), then the grouped list. Skip empty categories entirely —
never print "No issues found" headers for every category.

## Additional Resources

- **`references/checklist.md`** — detailed anti-pattern, import-hygiene, and
  PEP 8 checklist to consult while reviewing.
- **`scripts/run_linters.sh`** — runs available linters/formatters against given
  paths; gracefully skips tools that are not installed.
