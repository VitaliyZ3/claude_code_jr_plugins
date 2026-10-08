# smart_reviewer

Claude Code plugin with two skills:

1. **smart-commit** — analyzes the current git changes and creates a commit with an
   automatically chosen prefix (`feat` / `bug` / `ref` / `docs`).
2. **code-quality-check** — reviews Python code for anti-patterns, linter issues,
   import hygiene, and PEP 8 compliance.

This repository doubles as its own Claude Code marketplace
(`.claude-plugin/marketplace.json`), so it can be added directly from GitHub.

## Install from GitHub (marketplace)

This repo is published at
[VitaliyZ3/claude_code_jr_plugins](https://github.com/VitaliyZ3/claude_code_jr_plugins).
Add it as a marketplace and install the plugin:

```
/plugin marketplace add VitaliyZ3/claude_code_jr_plugins
/plugin install smart_reviewer@smart_reviewer
```

or from the CLI:

```bash
claude plugin marketplace add VitaliyZ3/claude_code_jr_plugins
claude plugin install smart_reviewer@smart_reviewer
```

Restart Claude Code (or run `/plugin`) and confirm both skills are discovered:

```
/help
```

They should appear as `smart_reviewer:smart-commit` and
`smart_reviewer:code-quality-check`.

> **Naming note:** `claude plugin validate .` warns that `smart_reviewer` is not
> kebab-case. Claude Code (CLI) accepts it and installs/loads it correctly, but
> the official Claude.ai marketplace *sync* (the anthropic-hosted directory)
> requires kebab-case plugin names. This only matters if this plugin is ever
> submitted to that official directory — a self-hosted GitHub marketplace like
> this one works fine with the current name.

## Local testing (before pushing to GitHub)

Validate the plugin/marketplace manifests:

```bash
claude plugin validate .
```

Load it for the current session only, without installing anything:

```bash
claude --plugin-dir "$(pwd)"
```

## Usage

- **smart-commit**: ask Claude things like "зроби коміт", "commit these changes",
  "create a commit for this diff".
- **code-quality-check**: ask Claude things like "перевір код на антипатерни",
  "review this code for PEP 8", "check imports and lint this file".

## Structure

```
.
├── .claude-plugin/
│   ├── plugin.json
│   └── marketplace.json
├── skills/
│   ├── smart-commit/
│   │   └── SKILL.md
│   └── code-quality-check/
│       ├── SKILL.md
│       ├── references/
│       │   └── checklist.md
│       └── scripts/
│           └── run_linters.sh
├── LICENSE
└── README.md
```

## Publishing

```bash
git remote add origin https://github.com/VitaliyZ3/claude_code_jr_plugins.git
git push -u origin main
```
