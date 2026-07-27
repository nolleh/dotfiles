---
name: commit-convention
description: Apply the Udacity Git Commit Message Style Guide when Codex writes, reviews, amends, or suggests Git commit messages, including after code changes or when the user asks to commit. Use this skill for commit message generation, commit message cleanup, commit type selection, and git commit commands. This local variant follows Udacity types and treats chore as build/config/tooling work, non-production-code maintenance, and small miscellaneous fixes.
---

# Commit Convention

## Rules

Follow the Udacity Git Commit Message Style Guide.

Use this structure:

```text
type: Subject

body

footer
```

The body and footer are optional. Keep the title concise, around 50
characters or less when practical. Start the subject with a capital letter,
use imperative mood, and do not end the subject with a period.

Use the body only when the change needs context. Explain what and why, not
how. Separate the title from the body with a blank line and wrap body lines
at about 72 characters.

Use the footer only for issue references, such as `Resolves: #123`.

## Types

- `feat`: A new feature.
- `fix`: A bug fix.
- `docs`: Documentation changes.
- `style`: Formatting, missing semicolons, whitespace, or other no-code
  semantic changes.
- `refactor`: Refactoring production code without adding a feature or fixing
  a bug.
- `test`: Adding or refactoring tests without production code changes.
- `chore`: Build task updates, package manager config, tooling/configuration
  work, non-production-code maintenance, or small miscellaneous fixes.

Prefer the most specific type that matches the user-visible purpose. Use
`chore` for small fixes only when the change is minor and does not clearly
belong to `fix`, `docs`, `style`, `refactor`, or `test`.

## Workflow

When asked to commit or write a commit message:

1. Inspect the staged diff first. If nothing is staged, inspect the working
   tree and state whether the message is based on unstaged changes.
2. Choose one type from the allowed Udacity types.
3. Write a title in the form `type: Subject`.
4. Add a body only if the change needs explanation or multiple related
   reasons.
5. Before running `git commit`, show the exact message unless the user has
   already supplied it or explicitly asked for an automatic commit.
6. Respect repository pre-commit hooks as authoritative validation. Run a
   normal `git commit` and never use `--no-verify` unless the user explicitly
   requests bypassing hooks.
7. If a hook modifies files and aborts the commit, preserve and inspect those
   changes, restage the intended files, and rerun the same commit so the hooks
   validate the final staged content. Do not revert or overwrite hook changes.
8. If a hook fails without modifying files, report the failure, fix it when
   the fix is within scope, and rerun the commit. Do not bypass the hook.

## Examples

```text
feat: Add project search filter
```

```text
fix: Prevent crash on empty response
```

```text
chore: Update package lockfile
```

```text
chore: Tidy small layout spacing
```
