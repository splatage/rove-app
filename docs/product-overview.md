# Product Overview

## 1. Product definition

A mobile SSH workspace for working directly on remote files and systems through a file view, a native remote editor, and a shell, all tied to the same live remote context through explicit actions.

This is not:
- a full IDE
- a sync client
- a desktop file manager shrunk onto a phone
- a network admin console
- an automation/scripting product

It is:
- a mobile-first remote workspace
- explicit, conservative, and trustworthy
- grounded in SSH/OpenSSH and SFTP industry norms
- designed for remote browsing, shell work, safe text editing, and explicit file transfer

---

## 2. Core design principles

### 2.1 Explicit by default
No hidden behavior. No silent automation. No inferred actions without explicit user opt-in.

Smart or assisted features may exist only when:
- they are visible
- they are explicitly enabled or invoked
- they are reversible
- they do not misrepresent system state

### 2.2 Remote is authoritative
The remote host and filesystem are the source of truth.

The app may:
- fetch remote file contents into an in-memory editing buffer
- stage remote file operations
- preserve reconnect context snapshots

The app does not:
- create a persistent local working copy for normal editing
- silently persist drafts locally
- imply background continuity that did not actually occur

### 2.3 Industry-standard behavior first
Where there is a clear industry-standard SSH/SFTP practice, follow it unless there is a strong mobile-specific reason not to.

Prefer:
- OpenSSH/OpenBSD semantics
- OpenSSH SFTP extensions where available
- conservative fallbacks when unavailable
- no app-invented magic

### 2.4 Shared transport, shared trust, shared failure
The workspace uses one SSH transport with multiplexed channels.

The app presents one coherent workspace health model and does not allow silent partial-failure UX where one surface appears healthy while another has failed invisibly.

### 2.5 Mobile-first honesty
Foreground = live session.
Background = best effort only.
Resume = explicit status and reconnection handling.

The product must not promise continuity that mobile platforms do not guarantee.

---

## 3. Product scope summary

### In scope
- saved hosts
- SSH/OpenSSH-aligned host model
- secure credentials and key handling
- host trust / fingerprint handling
- one active live host workspace at a time
- Browser and Shell workspace surfaces
- app-native remote text editor
- explicit upload/download
- recursive directory transfer via SFTP
- recent/favorite commands
- recent/favorite folders
- optional GNU screen integration per host
- explicit reconnect and recovery behavior

### Out of scope for current scope
- full IDE features
- hidden sync/automation
- background sync engine
- multiple active live host workspaces at once
- multi-shell session manager
- silent local drafts
- automatic archive wrapping
- raw automation/scripting layer

---

## 4. High-level architecture

### 4.1 Session model
- one encrypted SSH connection per active workspace
- multiple logical channels multiplexed over that one connection
- browser/file operations, shell, and forwarding ride on that one live connection

### 4.2 One active host at a time
The app presents one active live workspace connection at a time.

Users may switch hosts explicitly, but the UI does not present multiple active workspaces concurrently.

### 4.3 Server-side persistence vs app-side restore
There are two distinct persistence concepts:

#### Shell persistence
True shell persistence is provided only through explicit GNU screen integration on the remote host.

#### Browser/workspace context persistence
Browser/surface state may be restored as an explicit saved context snapshot per host, including:
- last folder
- selection if still valid
- scroll position where practical
- last active surface

This restore is a snapshot restore, not a claim that the browser remained live in the background.

---

## 20. Error handling style

Across the product, error handling follows the same pattern:
- state the problem plainly
- warn before destructive consequences
- confirm destructive operations
- offer safe alternate when one exists
- always allow cancel
- no silent destructive fallback

This applies consistently to:
- editor save
- overwrite
- move fallback
- delete
- upload/download
- directory transfer
- reconnect failure

---

## 21. Security and trust model

### 21.1 Credentials
Store credentials in device secure storage.
Use platform-secure facilities rather than app-invented secret storage.

### 21.2 Trust
Host trust follows SSH/OpenSSH concepts.
Trust handling is explicit and visible.

### 21.3 Dangerous capabilities
Riskier SSH features such as forwarding and agent-related behavior belong in advanced configuration and should default conservatively.

---

## 24. Non-goals and prohibitions

The app must not:
- silently move shell directories
- silently sync shell and browser
- silently overwrite changed files
- silently downgrade save safety
- silently create local drafts
- silently change cross-host file-operation semantics
- silently persist background continuity that did not happen
- invent custom SSH semantics where standard ones exist

---

## 25. Final implementation guidance

When implementation choices are ambiguous, prefer:
1. explicitness over cleverness
2. OpenSSH/OpenBSD semantics over app-invented behavior
3. conservative safe fallback over aggressive convenience
4. visible recovery over hidden background magic
5. literal user intent over inferred automation

This is the governing product rule for the entire app.
