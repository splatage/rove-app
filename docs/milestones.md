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

Milestone 1 acceptance boundary:
- constrain implementation to host selection, single-workspace session lifecycle, and Browser/Shell primary-surface switching
- include only Browser capabilities required for directory list/stat and shell capabilities required for one rendered interactive session
- defer editor, transfer orchestration, advanced host/security screens, and reconnect/persistence polish to later milestones

Governing seams for Milestone 1:
- `docs/master-spec.md` sections covering one active workspace, workspace switching, and one SSH transport/session model
- `docs/navigation-and-hosts.md` sections covering Host chooser, Browser/Shell workspace surfaces, and top-level navigation
- `docs/interfaces.md` workspace/session seams: `WorkspaceController`, `SshSessionService`, `ShellSessionService`, `BrowserService`
- `docs/state-model.md` core app state and live workspace state sections
- `docs/module-map.md` ownership seams for `features/hosts`, `features/workspace`, `features/browser`, `features/shell`, and `services/{ssh,sftp,shell}`

Milestone 1 audit checklist:
- no parallel workspace controllers or multi-host live workspace behavior
- no hidden Browser↔Shell sync beyond explicit bridge actions
- connect/disconnect/reconnect state transitions are explicit and user-visible
- Browser runtime behavior is limited to list/stat primitives for this milestone
- Shell runtime behavior is limited to one rendered interactive shell session for this milestone
- no editor, transfer orchestration, or advanced host/security flow requirements enforced in this milestone

Milestone 1 implementation checklist (interfaces-first):
- `WorkspaceController.connect(hostId)` opens one active workspace and one SSH transport
- `WorkspaceController.disconnect()` tears down shell/SFTP channels and returns to a disconnected workspace state
- `WorkspaceController.switchSurface(surface)` supports Browser↔Shell switching while preserving each surface state
- `SshSessionService.open(config)` + `openShellChannel()` + `openSftpSession()` are wired through one underlying connection lifecycle
- `ShellSessionService.startShell(config)` renders one interactive shell stream and exposes explicit output/state updates
- `BrowserService.listDirectory(path)` and `BrowserService.stat(path)` power Browser listing and item metadata for this milestone
- host chooser routes into the single active workspace flow; no secondary live workspace path exists
- reconnect behavior remains explicit state handling only; snapshot restore/editor/transfers remain deferred

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
