# Rove Master Specification

## 1. Product definition

Rove is a **mobile-first SSH workspace** for working directly on remote systems and files through a **Browser surface**, a **Shell surface**, and an **app-native remote text editor**, all tied to the same live remote context through explicit actions.

The app targets:

- Android
- iOS
- Windows
- Linux

The interaction model is still designed phone-first. Desktop targets inherit the same product rules but may present them with more space.

## 2. Guiding principles

### 2.1 Explicit by default
- no hidden automation
- no silent coupling between Browser and Shell
- no silent destructive fallback
- smart behavior must be explicit and opt-in

### 2.2 Remote is authoritative
- remote files remain the source of truth
- app-native editing uses an in-memory buffer only
- no persistent local working copy
- local export exists only as an explicit recovery path

### 2.3 Industry-standard behavior first
Where there is a clear SSH/SFTP industry norm, follow it unless there is a strong platform reason not to.

Preferred baseline:
- OpenSSH/OpenBSD semantics
- OpenSSH SFTP extensions where available
- conservative fallbacks where unavailable
- no app-invented magic

### 2.4 Honest lifecycle language
- shell persistence through `screen` is real remote persistence
- browser/workspace restoration is a saved context snapshot, not live continuation
- resume/reconnect wording must describe reality plainly

## 3. Core product shape

### 3.1 One active live host workspace
Only one host is actively connected in the UI at a time.

- users may switch hosts explicitly
- previous server-side shell sessions may remain alive if GNU screen is enabled
- the app itself presents only one active live workspace at a time

### 3.2 Workspace surfaces
Primary workspace surfaces:
- Browser
- Shell

Focused temporary task surface:
- Editor

Deeper flows:
- Settings
- Hosts
- Host detail
- Advanced SSH
- Identity
- Trust
- Forwarding

### 3.3 Entry screen
The app entry point is the **Host chooser**.

Ordering:
- pinned hosts first
- then MRU order

Interactions:
- tap host to connect
- long press host to manage
- new host button to create a host

## 4. Navigation model

### 4.1 Workspace switching
The workspace top bar contains a switcher that shows the icon for the *other* primary surface:

- in Browser: terminal icon
- in Shell: folder icon

Rules:
- Browser is the default workspace landing surface
- Browser and Shell preserve state when switching
- no swipe-only top-level navigation requirement

### 4.2 Editor behavior
The Editor opens as a focused full-screen task surface and returns to the origin surface on close, usually Browser.

### 4.3 Settings depth
Settings and host management are deeper flows, not workspace peers.

Settings top level includes:
- Keys / Identities
- Security / Trust
- App preferences
- About / Diagnostics
- Hosts

## 5. Host model

### 5.1 Host configuration philosophy
Host configuration follows industry-standard SSH/OpenSSH concepts.

### 5.2 Basic host/connect fields
Shown on top-level host setup/detail screens:
- Label
- Host / Address
- Port
- Username
- Authentication method
- Password or selected key
- Default remote path
- Use GNU screen
- Screen session name
- Quit screen session on logout

### 5.3 Advanced SSH options
Advanced screens expose real SSH/OpenSSH-style options, especially:
- identity/authentication
- trust / host-key behavior
- jump/proxy
- keepalive / reliability
- compression
- forwarding

### 5.4 Key manager
General settings include a Key Manager.

Key Manager responsibilities:
- import key
- generate key
- rename key
- delete key
- view/copy public key
- show passphrase secure-store status

## 6. Session and connection model

### 6.1 Transport model
- one encrypted SSH connection
- multiplexed channels inside that connection
- the app chooses operation strategy
- the remote host / SSH server / SFTP server / filesystem determine what is possible

### 6.2 Global workspace health
The app uses one visible workspace health model.

Representative states:
- Live
- Reconnecting
- Disconnected
- Suspended

Rules:
- no hidden partial-survival behavior
- no pretending browser context stayed live in the background
- explicit status on resume/reconnect

### 6.3 Resume and reconnect
- preserve per-host browser/workspace context as a saved snapshot
- restore last folder, selection, and active surface where valid
- do not imply live background continuation

### 6.4 GNU screen persistence
Optional per-host GNU screen integration:
- explicit session name
- on shell start, reattach or create if missing
- config option to quit screen session on logout, otherwise detach and keep it alive

`screen` is the only true shell persistence mechanism in the product.

## 7. Browser and Shell relationship

### 7.1 No hidden sync
There is no continuous hidden shell/browser sync.

### 7.2 Explicit bridge actions
Browser and Shell are connected by explicit actions such as:
- Open shell here
- Copy path
- Insert path into shell

### 7.3 Open shell here
Open shell here means:
- switch to Shell
- explicitly move shell context to the chosen folder because the user requested it
- no other implicit shell-directory changes occur

## 8. Shell ergonomics

### 8.1 Shell model
- one real interactive shell
- one shell surface
- one active host workspace at a time

### 8.2 Mobile terminal ergonomics
Provide a compact terminal-specific input accessory row above the system keyboard with:
- Ctrl
- Esc
- Tab
- arrows
- paste
- path insert

### 8.3 Commands
Recent commands and favorite commands live in the shell menu.

Saved commands support explicit actions:
- Insert
- Run
- Run in this folder

Rules:
- recent commands are host-specific
- favorite commands are host-specific
- no automation layer
- no hidden command execution
- hardware keyboard shortcuts are supported where available

## 9. Browser and file operations

### 9.1 Browsing model
- tap opens
- long press enters selection mode

### 9.2 File-operation clipboard
File-operation clipboard is host-scoped.

- cut/copy/paste state does not cross hosts
- text clipboard is global like a system clipboard
- file-operation clipboard is not global

### 9.3 Common file actions
File long-press/action sheet includes:
- Preview
- Edit
- Run in terminal
- Download
- Rename
- Copy
- Move / Cut
- Delete
- Properties

Folder actions include:
- Open
- Open shell here
- Copy path
- Rename
- Copy
- Move / Cut
- Delete
- Properties

### 9.4 Destructive operations
Destructive or irreversible operations must follow the app’s explicit conservative pattern:
- warn clearly
- confirm explicitly
- offer a safe alternate where one exists
- always allow cancel
- no silent destructive fallback

## 10. Native remote editor

### 10.1 Scope
The editor is app-native and remote-only.

- text files only
- no persistent local working copy
- editor opens full-screen until save or exit
- remote file remains authoritative

### 10.2 Eligibility
Editor eligibility is conservative and configurable.

- configurable max editable size
- long-press file menu exposes Preview and Edit so the user decides
- editable only when text-like and within configured bounds
- read-only if readable but not writable
- binary or unsuitable files are preview/download/properties territory

### 10.3 Editing behavior
- in-memory editing buffer only
- no autosave by default
- no silent format-on-save
- no silent line-ending/encoding normalization

### 10.4 Save path
Use copy-on-write save behavior:
1. re-check remote state
2. write to temp file
3. fsync when supported
4. replace original via rename when supported

If the stronger safe path is unavailable, warn explicitly rather than silently downgrading behavior.

### 10.5 Conflict detection
Before save:
- check for remote change
- if changed, warn and prompt
- never silently overwrite a changed remote file

### 10.6 Failed save recovery
On failed save, present explicit recovery options:
- Retry
- Save as another remote file
- Export locally

No silent local draft creation and no automatic fallback to local storage.

## 11. Transfers

### 11.1 Default protocol
Default transfer uses **SFTP**, including recursive directory transfer.

### 11.2 Directory handling
- directories transfer as directories
- no automatic archive wrapping
- archive handling is explicit, not automatic

### 11.3 rsync
`rsync` over SSH is a deferred advanced opt-in option for directory transfers when supported by the host.

### 11.4 Progress and visibility
- transfer progress is surfaced in the notification panel where supported
- otherwise clearly in-app

### 11.5 Conflict model
File conflicts use:
- Replace
- Skip
- Rename copy
- Cancel

Optional for batch operations:
- Apply to all remaining conflicts

Directory transfers:
- recurse explicitly
- resolve conflicts at item level

Partial failures end with:
- Retry failed
- View errors
- Done

Move fallback to copy-then-delete is always explained.

No silent overwrite, no silent merge magic, and no rollback illusion for partial completion.

## 12. Filesystem operation model

The app chooses the strategy; the remote host/SFTP server/filesystem determines what is possible.

### 12.1 Save
- temp-file write
- replace/rename when supported

### 12.2 Move
- rename first
- fallback to copy then delete
- hard-link/unlink is not the primary move path

## 13. Properties view

Properties view surfaces:
- displayed path
- canonical path
- type
- size
- modified time
- permissions
- writability / read-only state
- symlink target where relevant
- extended filesystem metadata when available

Canonical path is used internally for operations and safety. Displayed/home-relative path is used for UI legibility.

## 14. Platform model

### 14.1 Shared product rule
The app is a presentation and control layer over server-side processes and files.

### 14.2 Background/resume
Assume suspend/resume as the base model.

- foreground: live workspace
- background: best effort only
- resume: explicit reconnect/recovery state if needed

### 14.3 Android
Visible active background work may surface through notification-backed behavior where supported.

### 14.4 iOS
Do not promise indefinite background continuity. Resume language must remain honest.

### 14.5 Windows / Linux
Desktop targets are generally less constrained by mobile background lifecycle rules, but Rove still uses the same explicit status language and must not imply continuity after a real disconnect.

## 15. State model boundary

Developer-facing state must remain clearly separated:
- app route
- per-host context snapshot
- live workspace session state
- editor state
- transfer state
- command state
- host-scoped file-operation clipboard

## 16. Non-goals

Rove is not:
- a full IDE
- a sync engine
- a desktop file manager squeezed onto a phone
- a hidden automation/orchestration tool
- a fake background-persistence illusion

## 17. Implementation direction

The implementation stack currently chosen in engineering docs is:
- Flutter for UI and cross-platform targets
- one codebase for Android, iOS, Windows, Linux
- SSH/SFTP/terminal services layered beneath a single active workspace controller

The product spec remains the source of truth for behavior.
