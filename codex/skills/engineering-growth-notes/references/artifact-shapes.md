# Artifact Shapes

Use these as selection guides, not mandatory heading templates. Omit sections that add no durable value and adapt language to the user's existing notes.

## Reusable Design Pattern

A strong pattern note lets the reader rebuild the mental model without reopening the original repository.

Suggested content:

1. **Intent:** the problem and constraints the pattern addresses.
2. **One-screen model:** compact ownership/control-flow diagram.
3. **Invariants:** facts that must remain true in every implementation.
4. **Implementation skeleton:** minimal, annotated code that exposes the control flow.
5. **Concrete trace:** one representative request, event, frame, or state transition.
6. **Why each structural choice exists:** queue swap, single owner, callback outside lock, bounded length, and similar decisions.
7. **Failure of the tempting alternative:** explain the mismatch without claiming it is universally wrong.
8. **Tradeoffs and evolution path:** latency, throughput, memory, complexity, and scaling limits.
9. **Shutdown and failure behavior:** rejection, draining, cancellation, timeout, and object lifetime.
10. **Verification scenarios:** concurrency, ordering, boundary, failure, and shutdown tests.
11. **Recall template:** a small group of blanks or questions reusable during the next design.

For asynchronous code, make this table or equivalent facts recoverable:

```text
State owner:
Execution context:
Who may enqueue:
Who may touch the resource:
Synchronization boundary:
Ordering guarantee and scope:
Queue bound/backpressure:
Timeout owner:
Shutdown sequence:
```

### Code Example Standard

- Keep only details needed to reveal the design.
- State whether it is copied, adapted, or pseudocode.
- Show resource creation and destruction when thread affinity matters.
- Show registration-before-send when a fast response could race registration.
- Move user callbacks outside locks unless the lock is intentionally part of the contract.
- Show how stop prevents new work from appearing after the final drain.
- Name omitted production concerns such as exception propagation or queue limits.

## Cycle Retrospective

Suggested content:

- original goal and constraints;
- symptom and reproduction evidence;
- initial assumption;
- what inspection or test disproved it;
- root cause;
- correction and verification;
- refined mental model;
- strengths demonstrated during investigation;
- lessons promoted to patterns/checklists;
- unresolved work, clearly separated from completed work.

Prefer a small evidence table when several bugs or commits are involved:

| Observation | Root cause | Structural correction | Evidence |
|---|---|---|---|
| What was seen | What was verified | What now prevents recurrence | Test/log/diagnostic |

Do not preserve self-criticism that has no diagnostic value. Preserve the assumption that produced the bug because it can identify the next review question.

## Reusable Checklist

Checklist items should be answerable and should lead to evidence. Prefer:

```text
Who exclusively owns this socket, and what code proves it?
What is the maximum accepted frame length before allocation?
Can two writes be outstanding on this stream?
How are pending operations completed during shutdown?
```

Avoid:

```text
Be careful with sockets.
Check buffer safety.
Handle shutdown correctly.
```

Group questions by a stable mental model rather than by filenames from one project. Useful categories include state, ownership, executor, invariant, shutdown, framing, bounds, ordering, correlation, backpressure, and test evidence.

## Index Entry

An index entry should say what future situation should send the reader to the document:

```markdown
- [`patterns/async-message-channel.md`](patterns/async-message-channel.md)
  - Use when several threads send through a socket owned by one I/O loop.
```

Avoid descriptions that merely repeat the title.
