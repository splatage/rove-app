# Editor and File Operations

## 10. Editor

## 10.1 Editor role
The editor is the app’s real native editor.
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
Transfer/save/delete/move conflict and failure handling follows the app’s established explicit conservative pattern:
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
