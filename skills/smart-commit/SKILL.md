---
name: smart-commit
description: This skill should be used when the user asks to "create a commit", "make a commit", "commit these changes", "зроби коміт", "закоміть зміни", "commit this diff", or otherwise wants a git commit created from the current working tree changes with an automatically chosen conventional prefix.
---

# Smart Commit

Analyze the current git changes, classify their nature, and produce a commit with
a conventional prefix: `feat`, `bug`, `ref`, or `docs`.

## Prefix Rules

Classify the dominant nature of the staged (or working-tree) changes into exactly
one prefix:

- `feat` — adds new functionality or new files that implement new behavior.
- `bug` — fixes incorrect behavior, a crash, or a reported defect.
- `ref` — restructures existing code without changing external behavior
  (renames, extraction, simplification, moving files).
- `docs` — changes only documentation, comments, or README-type files.

When a diff mixes categories, pick the prefix matching the primary intent of the
change (the part that would break something if reverted), not the largest diff by
line count. If genuinely ambiguous, ask the user to confirm the prefix before
committing.

## Procedure

1. Run `git status --short` to see which files are modified, added, deleted, or
   untracked.
2. Run `git diff --staged` to inspect staged changes. If nothing is staged, run
   `git diff` to inspect unstaged changes instead, and `git diff --staged` first to
   confirm there is truly nothing staged.
3. If both staged and unstaged changes exist, ask the user whether to commit only
   the staged changes or stage everything first — do not silently stage unrelated
   work.
4. Read the actual diff content (not just filenames) to determine the category per
   the Prefix Rules above.
5. Draft a commit message in the form:

   ```
   <prefix>: <concise summary in imperative mood, under ~72 chars>

   <optional body explaining why, wrapped at ~72 chars, only if the change
   is non-trivial and the reason is not obvious from the summary>
   ```

   Write the summary in the same language the user is using in the conversation.
6. Show the drafted message to the user and the list of files that will be
   included, before running any git command that mutates the repository.
7. After the user confirms (or if the user has pre-authorized autonomous commits
   for this session), stage the intended files with `git add <files>` if needed,
   then run `git commit -m "<message>"`.
8. Never use `git commit --no-verify`, never force-push, and never amend an
   existing commit unless the user explicitly asks for it.
9. Report the resulting commit hash and message back to the user.

## Edge Cases

- No changes at all: tell the user there is nothing to commit; do not fabricate a
  commit.
- Only whitespace/formatting changes: treat as `ref` unless the user indicates
  otherwise.
- New test files alongside a feature: still classify by the primary change
  (usually `feat` or `bug`), tests are supporting evidence, not the category.
- Repository has pre-commit hooks that fail: report the hook failure to the user
  and fix the underlying issue rather than bypassing the hook.
