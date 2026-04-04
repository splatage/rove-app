# AGENTS.md

## Purpose
This repository should be worked on with precision, restraint, and strong architectural discipline. Favor correctness, clarity, safety, performance, and long-term maintainability over speed or novelty.

## Core values
- Prioritize elegant, precise, high-performance code.
- Prioritize correctness over speed.
- Never present partial work as complete.
- Do not add features, fallback behavior, or behavioral changes without explicit approval.
- Do not silently infer missing structure or intended behavior beyond the source of truth.
- Prefer canonical ownership and clean seams over quick bolt-ons.
- Treat duplicate logic, parallel systems, and hidden fallbacks as defects unless explicitly intended.
- Keep behavior explicit and predictable; avoid hidden automation or magic.
- Preserve user trust by stating assumptions, verification limits, risks, and remaining scope clearly.

## Source of truth
- Use the latest checked-out repo state and the relevant project docs in this repo as source of truth.
- Treat docs as the intended contract unless there is a clearly newer accepted design in the codebase or task instructions.
- Do not infer missing architecture from generic framework habits.
- If source-of-truth conflicts materially, stop and surface the contradiction instead of guessing.

## Working method
- Inspect before changing anything.
- Work in bounded slices.
- For each slice:
  1. identify the exact affected files, seams, and runtime paths,
  2. inspect current behavior and surrounding architecture,
  3. implement only that slice,
  4. audit touched paths for regressions, drift, duplicate logic, dead code, incomplete flow wiring, safety issues, and performance risk,
  5. run the relevant verification,
  6. fold the corrected slice into the next slice.
- Do not build new work on top of a drifted or partially wired foundation; normalize the current layer first, then continue.
- If prior work in the current area is incomplete, drifted, or non-canonical, fix that first before moving outward.
- Do not stop for confirmation unless there is a real scope/spec conflict, contradictory source of truth, or a missing decision that materially affects behavior.

## Architecture discipline
- Keep solutions canonical to the existing architecture unless redesign is explicitly requested.
- Do not create competing flows, duplicate services, parallel state, or hidden fallback paths.
- Prefer strengthening existing seams over introducing new abstraction layers without need.
- Keep UI/API/config surfaces aligned with backend enforcement.
- Keep docs, configuration, persistence, and runtime behavior aligned.

## Safety and reliability
- Treat correctness, data integrity, and operational safety as first-class concerns.
- Protect transaction boundaries, ordering, lifecycle correctness, and failure semantics.
- Be conservative with destructive changes.
- Surface risks around persistence, concurrency, permissions, trust boundaries, and hidden state.
- Prefer explicit recovery or failure behavior over silent degradation.

## Performance discipline
- Treat performance as a primary design concern.
- Avoid unnecessary allocations, redundant passes, duplicate lookups, repeated recomputation, and avoidable I/O.
- Respect thread sensitivity, async boundaries, lifecycle ordering, and main-thread safety where relevant.
- Do not trade away correctness for speculative micro-optimizations.
- When changing hot paths or shared services, audit for runtime and scalability impact.

## QA / audit expectations
- Audit as you go, not only at the end.
- Look for:
  - regressions,
  - contract drift,
  - partial feature wiring,
  - stale documentation,
  - duplicate logic,
  - dead code,
  - hidden behavior,
  - incomplete persistence or enforcement,
  - missing failure-path handling,
  - security or permission gaps,
  - performance regressions.
- Distinguish confirmed issues from suspected risks.
- Prefer fewer high-value findings over shallow commentary.

## Testing and verification
- Run the relevant build, test, lint, and validation commands for the area touched whenever available.
- Add or update tests for runtime-risk behavior changed in the task.
- If tests are absent, state that explicitly and describe what was validated manually or statically.
- If verification cannot be completed, state exactly what remains unverified and why.

## Documentation discipline
- Keep relevant docs in sync with accepted implementation.
- If implementation changes the accepted behavior, update the docs in the same task unless explicitly told not to.
- If docs are stale relative to the accepted design, correct them by the end of the task.
- Do not leave ambiguous behavior undocumented if it materially affects future work.

## Scope control
- Do not silently absorb optional ideas into the current scope.
- Classify new ideas explicitly as one of:
  - required for current scope,
  - optional enhancement,
  - future work,
  - out of scope.
- Never imply the requested scope is fully complete when only a subset has been delivered.

## Reporting expectations
At meaningful checkpoints and at the end of a task, report clearly:
- what area or slice was audited,
- what issues were found or explicitly not found,
- what changed,
- what was verified,
- what remains,
- assumptions made,
- risks or gaps still open.

## Preferred output style
- Be concise but exact.
- Favor grounded conclusions over generic advice.
- Show decisions, seams, and consequences clearly.
- Do not pad with style nits or generic best-practice filler.
