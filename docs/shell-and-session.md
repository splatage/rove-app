# Shell and Session

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
If “Quit screen session on logout” is off:
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

### 23.3 Windows / Linux
- desktop targets are less constrained by mobile suspend/resume rules
- they may keep a live workspace active longer while the app remains running
- the product must still use the same explicit status language and must not fake continuity after real disconnects
- mobile-first interaction rules still govern shared behavior unless a desktop-specific enhancement is explicitly added later

---
