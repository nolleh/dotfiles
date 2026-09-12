---
name: code-explanation
description: Explain source code in small, progressive steps when the user asks what code does, how it works, or how its execution and control flow fit together. Use for code walkthroughs, line-by-line explanations, and explanations of functions, modules, snippets, or repositories.
---

# Code Explanation

Help the user understand code without presenting an intimidating wall of text.

## Explanation Flow

1. Inspect enough surrounding code to identify the total explanation scope and
   divide it into coherent units. A unit should cover one concept, responsibility,
   or step in the execution flow.
2. At the very top of every explanation response, show progress in the form
   `Progress: current/total (percentage) — current topic`. Keep the same total
   unless newly discovered code materially changes the scope; explain briefly if
   the total changes.
3. Explain exactly one unit per response, then stop. Do not continue into the next
   unit even when it is closely related. Keep each response short enough to read
   without substantial scrolling and invite the user to continue.
4. Follow the code's execution or dependency order when that is more helpful than
   file or line order.

## Each Unit

Present the following in this order:

1. **Call stack or flow context:** Above the code snippet, show the shortest useful
   call path that explains how execution reaches this code. Add a brief annotation
   to every stack entry describing that frame's role, and include its source
   location as `path/to/file.ext:line` when available. Distinguish runtime evidence
   from a call path inferred by static inspection. If the available code does not
   establish a call path, say so instead of inventing one.
2. **Code snippet:** Include only the code needed for the current unit. Preserve the
   source faithfully, and label it with its `path/to/file.ext:start-line` when
   available. When inline comments would materially improve understanding, add
   concise explanatory comments and clearly label the snippet as annotated so the
   user does not mistake those comments for the original source.
3. **Explanation:** Explain the unit's purpose, important inputs and outputs, state
   changes, and control flow as relevant. Focus on why the code exists and how its
   pieces work together rather than paraphrasing every token. Briefly define a
   technical term when it first appears and the user may not already know it.
4. **Concrete trace when useful:** Choose one representative input and trace the
   important values, branches, and state changes through the current unit. Keep the
   trace small and do not invent values that the code cannot support.
5. **Visualization when useful:** Use a compact Markdown diagram, table, sequence,
   or state transition only when relationships or flow would be clearer visually.
   Keep it scoped to the current unit.
6. **Checkpoint:** End with a one- or two-sentence summary of the current unit and a
   short preview of the next topic. Then invite the user to continue; do not explain
   the next topic yet.

## Boundaries

- Do not front-load a full explanation or a detailed outline that defeats the
  one-unit-at-a-time format. The progress label may name the current topic without
  listing every future unit.
- Do not fabricate runtime behavior, callers, types, or values. Mark assumptions
  and static inferences explicitly.
- If the requested code is too incomplete to determine the total scope, use the
  visible scope for the progress total and state that limitation briefly.
- When the user asks a focused follow-up about the current unit, answer it without
  advancing progress. Advance only when moving to the next explanation unit.
