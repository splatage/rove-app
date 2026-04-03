# Mobile SSH App â€” Master Product Specification

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

## 5. Navigation and screen hierarchy

### 5.1 Top-level app map
- Host chooser
- Workspace
  - Browser
  - Shell
- Editor
- Settings
  - Keys / Identities
  - Security / Trust
  - App preferences
  - About / Diagnostics
- Host subflows
  - New Host
  - Host Detail
  - Advanced SSH
  - Identity
  - Trust
  - Forwarding

### 5.2 Entry point
The app entry screen is the Host chooser.

### 5.3 Workspace surfaces
Browser is the default workspace landing surface.
Shell is a peer surface accessed via the top switcher.

### 5.4 Editor surface
Editor is a focused full-screen task surface, not a peer workspace screen.
It returns to the origin surface on exit, usually Browser.

### 5.5 Settings and host management
Settings and host management are deeper flows, not workspace peers.

---

## 6. Host chooser

### 6.1 Ordering
- pinned hosts first
- remaining hosts in MRU order

### 6.2 Row contents
Each host row shows:
- pin indicator
- label
- `user@host:port`
- status badge
- last used indicator

### 6.3 Actions
- tap: connect
- long press: edit / manage
- New Host button visible on screen
- optional search/filter at top

### 6.4 Long-press actions
- Edit
- Duplicate
- Delete
- Manage

---

## 7. Host setup and configuration

## 7.1 Basic new-host/connect screen
This is a connect-first screen containing only common essentials.

### Fields
- Label
- Host / Address
- Port
- Username
- Authentication method
  - Password
  - Key
- Password field when password auth selected
- Key selector when key auth selected
- Default remote path
- Use GNU screen
- Screen session name
- Quit screen session on logout

### Actions
- Test connection
- Save
- Connect
- Advanced

### Behavior
- screen session name shown only when GNU screen is enabled
- password/key fields shown according to auth method

## 7.2 Host detail basic screen

### Status section
- current status
- last connection result
- trust state
- auth method in use
- last used
- GNU screen enabled / disabled
- screen session name if configured

### Basic editable fields
- Label
- Host / Address
- Port
- Username
- Authentication method
- Password
- Selected key
- Default remote path
- Use GNU screen
- Screen session name
- Quit screen session on logout

### Deeper navigation
- Advanced SSH
- Identity
- Trust
- Forwarding
- Delete host

## 7.3 Advanced SSH
Expose industry-standard SSH/OpenSSH options grouped by purpose.

### Connection
- HostName
- User
- Port
- Address family
- Connect timeout
- Compression

### Reliability
- Server alive interval
- Server alive count max
- TCP keepalive

### Jump / Proxy
- Jump host
- Proxy command may remain deferred unless needed

### Identity behavior
- Identities only
- Use agent

## 7.4 Identity screen
- selected key
- password authentication enabled
- keyboard-interactive authentication enabled
- use agent
- identities only
- open Key Manager

## 7.5 Trust screen
- fingerprint
- strict host key checking
- known hosts source / file
- update host keys
- verify host key DNS
- visual fingerprint
- forget trusted host
- re-check trust

## 7.6 Forwarding screen
Forwarding is a host configuration area, not a main workspace surface.

### Forwarding list item fields
- name
- type
- local / bind side
- target host
- target port
- auto-start state

### Forwarding detail fields
- Name
- Type
  - Local
  - Remote
  - Dynamic
- Bind host / address
- Source port
- Target host
- Target port
- Auto-start on connect

---

## 8. Key manager

Key Manager lives under Settings.

### 8.1 Key list fields
- label
- key type
- fingerprint
- secure-store/passphrase status

### 8.2 Actions
- import key
- generate key
- view public key
- copy public key
- rename
- delete

### 8.3 Key detail fields
- label
- key type
- fingerprint
- public key
- secure-store status for passphrase

### 8.4 Credential storage rule
Secrets are stored in device secure storage, not in plain app storage.

---

## 9. Workspace structure

## 9.1 Browser

### Top bar
- host label
- current folder / location
- top switcher showing terminal icon
- context menu

### Main content
- file/folder list
- optional breadcrumbs/path bar as appropriate

### Browser menu
- Refresh
- New folder
- Upload
- Paste
- Favorite folders
- Recent folders
- Settings

## 9.2 Shell

### Top bar
- host label
- shell/screen status
- top switcher showing folder icon
- context menu

### Main content
- one real interactive shell session

### Shell menu
- Recent commands
- Favorite commands
- Paste clipboard
- Insert current path
- Session actions
- Settings

### Shell ergonomics
- compact terminal-specific input accessory row above system keyboard
- core actions:
  - Ctrl
  - Esc
  - Tab
  - arrows
  - paste
  - path insert
- hardware keyboard shortcuts supported where available
- no hidden command execution
- no automation layer

## 9.3 Surface switching
- Browser and Shell preserve their own state when switching
- top switcher shows icon for the other surface
- no swipe-only navigation between workspace surfaces

---

## 10. Editor

## 10.1 Editor role
The editor is the appâ€™s real native editor.
It edits remote files directly through an in-memory buffer.

The editor is:
- app-native
- remote-only
- full-screen until save or exit
- explicit-save
- conservative and conflict-aware

## 10.2 Editor open eligibility
A file may open in the native editor only if all of the following hold:
- file is detected as text-like
- file is within the configured max editable size
- file is readable
- file is not obviously binary

### Read-only open
If readable but not writable:
- open read-only
- clearly display read-only state

### Preview-only
If text-like but above edit threshold, ambiguous, or user explicitly chooses Preview:
- open preview
- do not silently enter edit mode

### Refuse native edit
Do not offer native edit for:
- obvious binary files
- files above a hard safety ceiling
- unreadable files

Offer alternate actions such as:
- Download
- Properties
- Run in terminal
- Preview where safe

## 10.3 Configurable max editable size
Editor has a configurable max editable size setting.
The user decides whether to preview or edit through explicit long-press actions.

## 10.4 Long-press file actions
Long-press file actions expose Preview and Edit so the user chooses explicitly.

## 10.5 Editor top bar
- file name
- path / abbreviated path
- dirty or read-only state
- Save
- Close

## 10.6 Save model
Use copy-on-write save behavior:
1. re-stat remote file
2. detect conflict
3. write buffer to temp file
4. fsync temp file when supported
5. replace original via rename when supported

### Strong save path preference
Prefer OpenSSH/OpenBSD semantics and extensions where available.
If atomic replace semantics are unavailable, warn explicitly rather than silently downgrading without notice.

## 10.7 Conflict check on save
Before save, check whether the remote file changed since open.
If changed:
- warn
- prompt user
- never silently overwrite changed remote content

### Conflict prompt actions
- Overwrite remote
- Reload from remote
- Cancel

## 10.8 Dismissal behavior
If clean:
- close immediately

If dirty:
- prompt:
  - Save
  - Discard
  - Cancel

## 10.9 Save failure recovery
On failed save, present explicit recovery options:
- Retry
- Save as another remote file
- Export a copy locally via the system picker

No silent local draft creation.
No automatic fallback to local storage.

## 10.10 Disconnect during edit
If disconnected during edit:
- keep in-memory buffer
- mark editor as disconnected / unable to save
- block normal save until reconnect
- on reconnect, re-stat before save
- allow export locally via explicit recovery path if needed

## 10.11 Editor transformation rules
- no auto-save
- no auto-format on save
- no silent line-ending or encoding normalization
- indentation and formatting assistance only where explicitly configured

---

## 11. File browsing and selection

## 11.1 Browsing interaction
- tap folder: open
- tap file: open action sheet or configured direct action
- long press any item: enter selection mode

## 11.2 Selection mode
Selection mode changes the top bar and shows:
- selected count
- Copy
- Cut
- Delete
- more actions via menu

Selection clears when exiting selection mode.
File-operation clipboard does not automatically clear when selection ends.

## 11.3 File action sheet
### File
- Edit
- Preview
- Run in terminal
- Download
- Rename
- Copy
- Move / Cut
- Delete
- Properties

### Folder
- Open
- Open shell here
- Copy path
- Rename
- Copy
- Move / Cut
- Delete
- Properties

---

## 12. Browser/shell bridge actions

These surfaces share context through explicit handoff only.

### Core bridge actions
- Open shell here
- Copy path
- Insert path into shell

### Open shell here rule
When explicitly invoked:
- switch to Shell surface
- attach/create screen session if configured
- send `cd <target>` or equivalent explicit directory change only because the user requested it

At no other time does the app silently change shell directory.

---

## 13. Clipboard model

## 13.1 Global clipboard
Global clipboard applies only to text/plain text content such as:
- copied paths
- filenames
- command text
- other text snippets

## 13.2 File-operation clipboard
File-operation clipboard is host-scoped, not global.

### Why
This avoids unsafe or ambiguous cross-host move semantics.

### Stored fields
- operation type: copy or cut
- source paths
- source canonical paths
- timestamp

### Rules
- one staged file-operation clipboard per host
- visible staged state in UI
- paste targets the current folder on that host

### Clear/invalidate conditions
Clipboard is cleared when:
- paste succeeds fully
- user clears it
- host is deleted

Clipboard may be invalidated when:
- source items no longer exist
- source set becomes invalid

### Partial failure behavior
For cut operations with partial move success:
- do not silently clear everything
- report moved vs failed items
- keep failed items staged where practical, or prompt user explicitly

---

## 14. File operation model

## 14.1 General rule
The app chooses the operation strategy.
The remote host, SFTP server, and filesystem determine what is actually possible.

## 14.2 Move behavior
Primary move path:
- rename first

Fallback:
- copy then delete source

Hard-link/unlink is not the primary move model.

If fallback to copy-then-delete is needed, explain it explicitly.

## 14.3 Delete
Delete always requires confirmation.
Remote delete is treated as real delete, not recoverable trash.

## 14.4 Properties
Properties view should show, at minimum:
- name
- displayed path
- canonical path
- symlink target if relevant
- type
- size
- modified time
- permissions
- writable/read-only state

Optional extended fields when available:
- owner
- group
- last accessed
- link count
- MIME/type guess

### Symlink policy
- canonical path tracked internally for logic and safety
- user-facing path may remain navigated/home-relative for usability
- properties show both displayed and canonical paths

---

## 15. Transfer model

## 15.1 Transfer protocol
Default transfer protocol:
- SFTP

This applies to:
- files
- directories
- recursive directory transfer

## 15.2 Rsync
Rsync over SSH is not the default transfer mode.
It is a deferred advanced opt-in option for directory transfers when supported by the host.

## 15.3 Archive handling
Archive handling is explicit, not automatic.

The app does not automatically wrap directories into archives.
Any archive operations should be explicit actions.

## 15.4 Transfer progress
Transfer progress is surfaced in the notification panel where supported and otherwise clearly in-app.

## 15.5 Transfer panel content
- current transfer
- progress
- item counts
- current item
- failures summary if relevant

## 15.6 Transfer failure style
Transfer/save/delete/move conflict and failure handling follows the appâ€™s established explicit conservative pattern:
- warn clearly
- confirm destructive actions
- offer safe alternate where one exists
- always allow cancel
- no silent destructive fallback

---

## 16. Transfer conflict model

## 16.1 File conflicts
When the target file exists, offer:
- Replace
- Skip
- Rename copy
- Cancel

For batch operations, optionally add:
- Apply to all remaining conflicts

## 16.2 Directory conflicts
Directory transfers recurse explicitly.
Conflicts are resolved at item level rather than through vague top-level merge magic.

## 16.3 Partial failure summary
If some items succeed and others fail, present a summary with:
- Retry failed
- View errors
- Done

## 16.4 Move fallback explanation
If move must fall back to copy-then-delete, explain this explicitly before continuing.

## 16.5 Explicit prohibitions
- no silent overwrite
- no silent merge magic
- no rollback illusion for partial completion

---

## 17. Commands, history, and favorites

## 17.1 Shell model
- one real interactive shell
- command execution always happens through that shell

## 17.2 History and favorites scope
Command history and favorite commands are host-specific.

Folders recents/favorites are also host-specific.

## 17.3 Recent command object
- id
- host id
- command text
- source: typed / favorite / browser action
- timestamp

## 17.4 Favorite command object
- id
- host scope
- label
- command text
- execution mode
  - Insert
  - Run
  - Run in current browser folder
  - Run in fixed folder
- fixed folder if relevant
- confirmation required on/off

## 17.5 Command actions
All command actions are explicit:
- Insert into shell
- Run in shell
- Run in this folder

No hidden command execution.
No automation/scripting layer.

## 17.6 Path/clipboard ergonomics
Shell menu supports:
- paste clipboard
- insert current browser path
- insert selected file path
- insert selected file name where relevant
- recent commands
- favorite commands

---

## 18. GNU screen integration

## 18.1 Scope
GNU screen is an optional per-host shell persistence mechanism.

## 18.2 Settings
- Use GNU screen: on/off
- Screen session name
- Quit screen session on logout: on/off

## 18.3 Startup behavior
On shell start, if screen is enabled:
- reattach to named session if it exists
- otherwise create it

## 18.4 Logout behavior
If â€œQuit screen session on logoutâ€ is off:
- detach and keep screen session alive

If on:
- quit screen session on logout

## 18.5 Persistence boundary
GNU screen is the only true shell/session persistence mechanism.
It does not imply browser/SFTP/editor continuity.

---

## 19. Background, resume, and reconnect

## 19.1 Platform stance
Assume suspend/resume model with best effort to keep the connection alive while foregrounded.

Do not promise uninterrupted execution across backgrounding.

## 19.2 Foreground / background truth model
- foreground: live workspace
- background: best effort only
- resume: explicit status and reconnection if needed

## 19.3 Resume statuses
Use clear, plain states such as:
- Live
- Reconnecting
- Disconnected
- Suspended

## 19.4 Workspace context restore
Per-host browser/workspace context is restored as a saved snapshot, including examples like:
- last folder
- selection if still valid
- active surface
- scroll position where practical

This must not imply the browser remained live in the background.

## 19.5 Shell reattachment wording
If screen is enabled, on reconnect say:
- reattaching shell session

Do not imply the whole workspace continued live.

## 19.6 Reconnect failure options
If reconnect fails, offer:
- Retry
- Edit host
- Return to host chooser

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

## 22. Data/state model

## 22.1 Core app state
- current route/screen
- active host id
- active surface: browser or shell
- global session state
- visible sheets/dialogs

## 22.2 Per-host saved context
- last folder
- browser scroll position
- last selected item
- last active surface
- shell persistence settings
- reconnect snapshot timestamp

## 22.3 Live workspace state
- transport connected/disconnected
- shell channel state
- SFTP/browser channel state
- transfer jobs
- global text clipboard integration
- host-scoped file-operation clipboard
- screen attached/detached if enabled

## 22.4 Editor state
- host id
- path
- canonical path
- open snapshot attrs
- current buffer
- dirty flag
- read-only flag
- disconnected flag
- save-in-progress flag
- last save error
- max-size eligibility result

## 22.5 Transfer job state
- id
- host id
- direction
- source path(s)
- destination path
- status
- bytes transferred
- item counts
- current conflict choice state
- errors list

## 22.6 Command state
Per host:
- recent commands
- favorite commands
- current shell metadata
- explicit path/context handoff state where applicable

---

## 23. Platform behavior notes

### 23.1 iOS
- assume suspend/resume
- preserve UI state and reconnect context honestly
- do not promise live background persistence
- editor may export locally via system picker on failure

### 23.2 Android
- transfer progress may surface through notification panel where supported
- visible background/foreground service style behavior may be used only where appropriate and explicit
- still do not misrepresent continuity or hide failure

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
