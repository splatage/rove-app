# Milestones

## 1. Session spine
Goal: prove the core transport/session architecture.

Deliver:
- app shell
- host chooser
- connect/disconnect
- one workspace controller
- Browser/Shell switcher
- shell rendering
- SFTP list/stat

## 2. Browser actions and transfers
Goal: prove operational file work.

Deliver:
- file/folder action sheets
- selection mode
- file clipboard
- upload/download
- transfer progress UI
- conflict prompts
- partial-failure summaries

## 3. Native editor
Goal: prove trustworthy remote editing.

Deliver:
- text-file eligibility rules
- preview/edit flow
- full-screen editor
- dirty-state handling
- guarded temp-file save path
- conflict check on save
- failed-save recovery

## 4. Host/security depth
Goal: expose the full SSH/OpenSSH-aligned model cleanly.

Deliver:
- host detail screens
- advanced SSH screens
- identity screen
- trust screen
- key manager
- secure storage integration

## 5. Reconnect/persistence polish
Goal: make the app feel coherent under mobile lifecycle constraints.

Deliver:
- context snapshot restore
- explicit reconnect status handling
- GNU screen integration
- notification-panel transfer progress where supported

## 6. Advanced transfer options
Goal: add deeper but still explicit file movement options.

Deliver:
- recursive directory transfer polish
- optional advanced rsync-over-SSH path for supported hosts
- explicit archive actions as advanced utilities
