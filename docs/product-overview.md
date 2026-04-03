# Product Overview

## Product identity

Rove is a **mobile-first SSH workspace** with a shared product and engineering target for:

- Android
- iOS
- Windows
- Linux

The interaction model is designed primarily for touch-first mobile use. Desktop targets inherit the same product rules and gain more space for presentation, but do not change the core philosophy.

## Product sentence

Rove is a mobile-first cross-platform SSH workspace for working directly on remote systems and files through a Browser surface, a Shell surface, and an app-native remote editor, all tied to the same live remote context through explicit actions.

## Primary goals

- make remote file work and shell work feel like one coherent workflow
- preserve user trust through explicit, conservative behavior
- follow industry-standard SSH/SFTP semantics where possible
- keep the product powerful without turning it into an IDE or automation console

## Core behavior principles

### Explicit, not clever
- no hidden shell/browser sync
- no hidden automation
- no silent command execution
- no silent destructive fallback
- all smart behavior must be explicit or opt-in

### Remote-first
- remote file is authoritative
- editor buffer is in memory only
- no persistent local working copy
- local export exists only as an explicit recovery choice

### Honest lifecycle language
- `screen` is true shell persistence
- browser/workspace restore is a saved snapshot, not a live background session
- reconnect/resume copy should describe real state plainly

### Industry-standard defaults
- OpenSSH/OpenBSD semantics first
- OpenSSH SFTP extensions where available
- conservative fallbacks when unavailable

## Workspace model

### Primary surfaces
- Browser
- Shell

### Focused task surface
- Editor

### Deeper flows
- Settings
- Hosts
- Host Detail
- Advanced SSH
- Identity
- Trust
- Forwarding

## One active workspace

The app presents one active live host workspace at a time.

- users can switch hosts explicitly
- prior shell sessions may remain alive server-side if GNU screen is enabled
- the UI itself does not act like a multi-host session manager

## What the product is not

Rove is not:
- a full IDE
- a sync engine
- a desktop file manager squeezed onto a phone
- a hidden automation system
- a pretend-always-alive background session

## Scope status

The product definition is largely locked.

Remaining work is mostly:
- implementation architecture in the app repo
- UI design and interaction polish
- platform-specific integration details
- staged delivery
