# Codex Session Init Prompt

Use the current checked-out repo and the relevant project docs as source of truth, with docs treated as the intended contract unless there is a clearly newer accepted design.

First align to the repository before changing anything:
- inspect the relevant docs, code seams, and current implementation,
- infer the intended architecture and current implementation state,
- identify the most recently worked or currently targeted area,
- audit that area for drift, completeness, regressions, duplicate logic, parallel systems, hidden fallbacks, contract mismatches, stale docs, dead code, incomplete wiring, safety issues, and test gaps.

If issues are found in that current area, fix that area first and bring it back to a clean canonical state before proceeding.
If no meaningful issues are found, continue to the next logical scoped area.

Work in bounded slices. For each slice:
1. identify the exact files, seams, and runtime paths involved,
2. inspect current behavior and relevant docs,
3. implement only that slice,
4. audit the touched paths for regressions, drift, duplicate logic, dead code, incomplete flow wiring, safety issues, and performance risk,
5. run relevant verification,
6. fold the corrected slice into the next slice.

Rules:
- Keep the solution canonical to the existing architecture.
- Do not introduce duplicate logic, parallel implementations, hidden fallback paths, speculative refactors, or behavior changes beyond the documented and scoped intent.
- Prefer fixing drift and incomplete ownership over layering new code on top.
- Do not build new slices on top of a drifted or partially wired foundation; normalize the current layer first, then continue.
- Do not stop for confirmation unless there is a real scope/spec conflict, contradictory source of truth, or a missing decision that materially changes behavior.
- Never present partial work as complete.

At the end of each slice, report:
- what was audited,
- what issues were found or explicitly not found,
- what changed,
- what was verified,
- what remains next,
- any assumptions, risks, or verification gaps.

By the end of the task:
- update the relevant docs so they match the final accepted implementation,
- add or update tests for runtime-risk behavior touched,
- clearly distinguish what is complete from what remains.

Begin by:
1. identifying the governing docs and implementation seams,
2. summarizing the intended current contract,
3. auditing the current implementation area for drift and completeness before proceeding.
