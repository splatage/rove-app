# Rove App Specification

Rove is a **mobile-first SSH workspace** with a shared design and codebase target for **Android, iOS, Windows, and Linux**. The interaction model remains phone-first and touch-first, while desktop targets inherit the same product rules and gain more room for presentation.

The product is built around a few hard constraints:

- one active live host workspace at a time
- Browser and Shell as peer workspace surfaces
- a full-screen app-native remote text editor
- one encrypted SSH connection with multiplexed channels
- explicit, conservative behavior with no hidden automation
- OpenSSH/OpenBSD semantics where applicable
- remote-first editing with no persistent local working copy

## Canonical document set

### Product and scope
- `docs/master-spec.md` — canonical master specification
- `docs/product-overview.md` — product identity, principles, goals, and non-goals
- `docs/navigation-and-hosts.md` — navigation hierarchy, workspace surfaces, host chooser, host setup, host detail, key manager
- `docs/editor-and-file-operations.md` — editor lifecycle, browser/file operations, clipboard, move/delete/properties, transfers, transfer conflicts
- `docs/shell-and-session.md` — commands, history, favorites, GNU screen, background/resume/reconnect, platform session notes
- `docs/state-model.md` — developer-facing state model

### Engineering and implementation
- `docs/engineering-architecture.md` — Flutter-based implementation architecture and package layout
- `docs/interfaces.md` — code-facing service contracts and controller boundaries
- `docs/module-map.md` — module/package map
- `docs/milestones.md` — staged delivery plan

## Scope status

The major product-shape decisions are locked.

Remaining work is implementation and delivery detail rather than foundational scope discovery:

- final code contracts and package boundaries in the actual app repo
- UI design and component implementation
- platform-specific lifecycle and notification handling
- SSH/SFTP integration and test harnesses
- milestone-by-milestone delivery

## Core direction

- mobile-first interaction model, cross-platform binaries
- one active live host workspace at a time
- Browser is the default workspace landing surface
- Shell is a peer workspace surface via top switcher
- Editor is a focused temporary task surface returning to origin
- explicit reconnect/resume language that describes real state
- no hidden destructive fallback, hidden automation, or fake background continuity

## Documentation notes

- `docs/master-spec.md` is the canonical master spec.
- Product docs now explicitly describe the app as **cross-platform (Android, iOS, Windows, Linux)** with a **mobile-first interaction model**.
