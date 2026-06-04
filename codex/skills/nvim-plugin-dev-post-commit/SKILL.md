---
name: nvim-plugin-dev-post-commit
description: Automatically use after any successful non-documentation-only commit made while developing a Neovim plugin, including Lua/Vimscript plugin UI, commands, mappings, buffers, windows, tabs, autocmds, extmarks, highlights, floating windows, jobs, async callbacks, or tests. Write an English implementation note under Documents/tasks explaining what feature was committed, how it is implemented, and how the relevant Vimscript/Lua/Neovim plugin-development APIs and patterns work for a developer who knows basic Vim concepts but is new to plugin development.
---

# Nvim Plugin Dev Post Commit

Use this skill after a commit has been completed for a Neovim plugin project, especially when the user wants a learning-oriented record of the committed feature.

If the current repository is a Neovim plugin and Codex just created a commit, prefer invoking this skill automatically unless the user explicitly says not to write a post-commit note.

Do not write a post-commit note for documentation-only commits, changelog-only commits, README-only commits, formatting-only commits, metadata-only commits, or other commits that do not change plugin behavior, tests, or developer-facing implementation mechanics. Briefly report that the note was skipped and why.

## Reader Assumption

Assume the reader already knows basic Vim/Neovim concepts such as buffers, windows, tabs, modes, commands, and mappings.

Do not spend space explaining those basics. Instead, explain how plugin code works with those concepts through APIs, lifecycle hooks, state management, and common implementation patterns.

## Goal

Create an English note in `~/Documents/tasks` that helps a Neovim plugin development beginner understand:

- what feature or fix was committed
- why the change was needed
- which files/functions implement it
- how the feature moves through plugin state, Neovim state, and user actions
- which Vimscript, Lua, or Neovim APIs are involved and why they are used
- any tricky plugin-development pattern, edge case, or lifecycle behavior
- how the behavior can be verified

## Workflow

1. Confirm the latest commit with `git log -1 --stat`.
2. Inspect details with `git show --stat --patch --find-renames HEAD`.
3. If the commit only changes documentation, changelog, README, metadata, or formatting with no plugin behavior, tests, or implementation mechanics, stop and skip the note.
4. Read changed source and test files directly. Do not rely only on the diff if surrounding context is needed.
5. Identify the user-facing feature or behavior first, then map it to implementation details.
6. Write a new Markdown note under `~/Documents/tasks`.
7. Keep the note educational, concrete, and tied to actual file paths and function names from the repo.

## File Naming

Use a filename that sorts naturally and is easy to scan:

```text
~/Documents/tasks/YYYY-MM-DD-nvim-plugin-<short-topic>.md
```

If a same-day file already exists, append a short suffix such as `-2` or a more specific topic.

## Note Structure

Use this structure unless the commit clearly needs a different shape:

```markdown
# <Feature Name>

## One-Line Summary

<Summarize the change in 1-2 sentences from a plugin-development perspective.>

## What This Feature Does

<Describe the changed behavior from the user's perspective.>

## Key Files Changed

- `<path>`: <role>

## Implementation Flow

1. <Entry point: command, mapping, setup, autocmd, callback, etc.>
2. <Important state lookup or transformation>
3. <Neovim API call or plugin-internal state change>
4. <Final user-visible effect>

## Key Functions And APIs

### `<function or API>`

<Explain what it does, why this feature needs it, and what may confuse plugin developers.>

## Plugin Development Notes

<Explain concrete plugin-development details such as buffer/window/tab APIs, event timing, namespaces, extmarks, floating windows, user commands, keymaps, option scopes, or async callbacks.>

## Structure Or Flow Diagram

<Use Mermaid classDiagram, sequenceDiagram, or flowchart diagrams when they clarify module relationships or execution flow.>

## Verification

<Tests, manual verification steps, or reproduction commands.>

## Reading Notes

<Call out easy-to-misunderstand behavior, intentional implementation choices, or limitations.>
```

## Explanation Style

- Write in English.
- Assume the reader can read basic Lua/Vimscript and already understands Vim's user-facing concepts.
- Focus on plugin-development mechanics: API contracts, state ownership, lifecycle, event timing, and side effects.
- Explain hard Vimscript functions and Neovim Lua APIs with small examples when useful.
- Use Mermaid diagrams when they make the implementation easier to understand.
- Prefer concrete references like `lua/foo.lua` and `M.setup()` over abstract descriptions.
- Do not paste large code blocks. Quote only short snippets that are necessary to explain a concept.
- If a function name is overloaded or ambiguous, explain which module/file it belongs to.
- Make clear distinctions between user-facing behavior, plugin state, Neovim editor state, and test scaffolding.

## Diagram Guidance

Use diagrams only when they clarify real structure or flow. Do not add decorative diagrams.

- Use `sequenceDiagram` for user action -> command/keymap/autocmd -> plugin function -> Neovim API -> UI/state update flows.
- Use `classDiagram` for Lua module tables, state tables, backend/client objects, or callback ownership relationships. Treat Lua modules/tables as classes only as an explanatory model, not as literal OOP unless the code uses that pattern.
- Use `flowchart` for branching behavior, validation paths, permission/approval flows, async state machines, or retry/recovery logic.
- Keep diagrams small enough to read in a note. Prefer 4-8 nodes/participants.
- Follow each diagram with a short explanation of what the diagram intentionally omits.

## What To Inspect

Prioritize:

- plugin entry points: `plugin/`, `autoload/`, `lua/**/init.lua`
- configuration and setup functions
- commands, mappings, autocmds, user events
- buffer/window/tabpage interactions through APIs
- extmarks, namespaces, highlights, floating windows, virtual text
- option scopes: global, buffer-local, window-local
- async behavior: timers, jobs, callbacks, coroutines, scheduled functions
- tests and fixtures that reveal intended behavior

## Validation

Before finishing:

- Verify the note file exists under `~/Documents/tasks`.
- If possible, run `git status --short` to ensure the documentation note was created outside the repo or is otherwise intentionally untracked.
- Report the created note path and the commit hash/title summarized.

## Safety

- Do not amend, create, or reset commits unless the user explicitly asks.
- Do not modify repo source while using this skill unless the user asks for implementation changes.
- If the latest commit is not the relevant commit, ask which commit to document or inspect the commit the user named.
