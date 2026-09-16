---
name: commit-convention
description: Apply the Udacity Git Commit Message Style Guide when Codex writes, reviews, amends, or suggests Git commit messages, including after code changes or when the user asks to commit. Use this skill for commit message generation, commit message cleanup, commit type selection, and git commit commands. This local variant follows Udacity types and treats chore as build/config/tooling work, non-production-code maintenance, and small miscellaneous fixes.
---

# Commit Convention

## Rules

Follow the Udacity Git Commit Message Style Guide. Add a component scope when
it helps identify which part of a multi-component repository changed.

Use this structure when a scope is useful:

```text
type(scope): Subject
```

For a single-component repository, or when no useful scope applies, omit the
scope:

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

## Scopes

Infer the scope from the changed paths and the repository's own terminology.
Keep it concise and lowercase. In a multi-component repository, use a scope
to make the affected component clear. Prefer a specific subcomponent when it
is more useful than the top-level folder; for example, use `nvim` for Neovim
configuration under `vim/`.

For this dotfiles repository, useful scopes include `nvim`, `vim`, `alacritty`,
`kitty`, `zellij`, `lazygit`, `claude`, `codex`, `gitconfig`, `install`,
`scripts`, `os`, `func`, `includes`, and `colour-mysql-console`. Choose another
scope when that better names the changed component.

For a change spanning multiple distinct components, use comma-separated
scopes, such as `feat(nvim,codex): Add shared editor tooling`. Do not add a
scope just for consistency when the repository has only one component.

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
2. Choose one type from the allowed Udacity types and determine whether the
   repository has a useful component scope for this change.
3. Write a title in the form `type(scope): Subject` when a scope applies;
   otherwise use `type: Subject`.
4. Add a body only if the change needs explanation or multiple related
   reasons.
5. Before running `git commit`, show the exact message unless the user has
   already supplied it or explicitly asked for an automatic commit.
6. Respect repository pre-commit hooks as authoritative validation. Run a
   normal `git commit` and never use `--no-verify` unless the user explicitly
   requests bypassing hooks.
7. If a hook, including a formatter run by pre-commit, modifies files and
   aborts the commit, treat those formatting changes as part of the intended
   result. Preserve and inspect them, restage the intended files, and rerun the
   same commit so the hooks validate the final staged content. Do not revert,
   overwrite, or manually undo hook-produced formatting changes merely to
   restore the pre-hook diff.
8. If a hook fails without modifying files, report the failure, fix it when
   the fix is within scope, and rerun the commit. Do not bypass the hook.

## Examples

```text
feat(nvim): Add filtered LSP symbol picker
```

```text
fix(alacritty): Correct terminal padding
```

```text
chore(codex): Update skill metadata
```

```text
chore: Tidy small layout spacing
```
