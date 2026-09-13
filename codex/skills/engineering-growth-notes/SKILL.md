---
name: engineering-growth-notes
description: Turn lessons from a development, debugging, refactoring, or code-review cycle into durable personal engineering notes with reusable design patterns, memory-triggering code examples, and review checklists. Use when the user asks to preserve what they learned or improve recurring technical weaknesses; do not use for ordinary project README, API, changelog, or feature documentation.
---

# Engineering Growth Notes

Create notes that help the user reconstruct the reasoning months later and apply it to a different codebase. Do not merely summarize the conversation or produce a generic list of best practices.

## Establish the Evidence

Recover the meaningful development cycle from the available conversation, source, diffs, tests, logs, and existing notes. Inspect only artifacts relevant to the requested lessons.

For each lesson, distinguish:

- observed symptom or failure;
- verified root cause;
- missing mental model or design assumption;
- implemented correction and its evidence;
- remaining tradeoff or unresolved question.

Do not turn an inference into a confirmed fact. Preserve useful corrections made during the discussion, especially when an early explanation was later refined.

## Choose the Smallest Useful Artifact Set

Inspect the destination's existing organization and index before writing. Reuse its naming, language, and links. Create only the artifact types justified by the material:

- **Retrospective:** project-specific chronology, evidence, mistaken assumptions, corrections, and demonstrated strengths.
- **Pattern:** a reusable implementation shape with ownership, control flow, invariants, code, tradeoffs, and applicability boundaries.
- **Checklist:** short questions that catch the same class of omission before implementation or review.

Do not force every cycle into all three forms. Keep project-specific facts in a retrospective; promote only transferable reasoning into patterns and checklists. Update an existing index when one exists.

Read [references/artifact-shapes.md](references/artifact-shapes.md) when creating or substantially extending any of these artifact types.

## Make Design Knowledge Recallable

When the lesson concerns architecture, concurrency, networking, state, lifetime, or protocol behavior, preserve the actual design shape rather than only advice about it. Include as appropriate:

- a compact execution-flow or ownership diagram;
- a minimal code skeleton showing the important control flow;
- owner, executor/thread, synchronization boundary, invariant, and shutdown path;
- one concrete message or state trace;
- why the earlier structure was reasonable under its original requirements;
- what later requirement invalidated the assumption;
- latency, throughput, ordering, backpressure, and lifecycle tradeoffs;
- conditions under which a different design should be chosen;
- tests that demonstrate the invariant rather than match incidental wording.

For example, advice such as “use one I/O owner” is incomplete without a skeleton showing that callers only enqueue, one permanent loop drains sends and receives messages, and shutdown prevents enqueue-after-drain races.

Use source snippets faithfully when they are short and reusable. Otherwise write an adapted skeleton and label it clearly as illustrative or non-compiling. Never silently present pseudocode as exact production code. In concurrent examples, check the example itself for races and ambiguous ownership before preserving it as guidance.

## Write for Growth, Not Blame

Name the technical gap precisely, but avoid framing the document as a list of personal defects. Record what the user already understood, what assumption changed, and which reusable mechanism now catches the problem. Prefer:

```text
Missed invariant → observable failure → structural guard → verification
```

Avoid “be more careful” as remediation. Prefer types, bounded queues, explicit state machines, single ownership, executor boundaries, lifecycle protocols, compiler diagnostics, sanitizers, or tests.

## Preserve Scope and Privacy

Use the destination the user specifies. Do not place personal retrospectives or candid learning notes in a project repository unless they explicitly ask for that. If the destination is outside the writable workspace, obtain the required authorization immediately before writing there.

Do not commit, publish, or install the notes unless requested. Avoid copying secrets, private identifiers, full logs, or embarrassing raw commentary when the technical lesson can be preserved without them.

## Finish with a Consistency Pass

Before reporting completion:

1. Verify new files exist and index links resolve.
2. Check that reusable claims are separated from project-specific context.
3. Confirm code examples preserve the stated invariants.
4. Confirm unresolved items are labeled rather than presented as completed.
5. State which files changed and whether any project repository was touched.
