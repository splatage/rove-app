# Mobile SSH App Spec

This repository contains the current locked product specification for the mobile SSH app.

## Documents

- `docs/master-spec.md` — full master specification
- `docs/product-overview.md` — product definition, principles, scope, architecture, error handling, security, non-goals, implementation guidance
- `docs/navigation-and-hosts.md` — navigation hierarchy, workspace surfaces, host chooser, host setup, host detail, key manager
- `docs/editor-and-file-operations.md` — editor lifecycle, browser/file operations, clipboard, move/delete/properties, transfers, transfer conflicts
- `docs/shell-and-session.md` — commands, history, favorites, GNU screen, background/resume/reconnect, platform session notes
- `docs/state-model.md` — developer-facing state model

## Scope status

The major product-shape decisions are locked. Remaining work is implementation planning, UI design, and engineering decomposition rather than foundational scope discovery.

## Core direction

- Mobile-first SSH workspace
- One active live host workspace at a time
- Browser and Shell as peer workspace surfaces
- Full-screen app-native remote text editor
- Remote-first, explicit, conservative behavior
- OpenSSH/OpenBSD semantics where applicable
- No hidden automation or silent destructive fallback
