# Navigation and Hosts

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
