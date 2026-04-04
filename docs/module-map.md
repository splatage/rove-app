# Module Map

## app
Owns app bootstrap, route selection, lifecycle coordination, top-level dependency wiring, and theme.

## domain
Owns stable product-neutral types:
- HostConfig
- AdvancedSshConfig
- WorkspaceContextSnapshot
- WorkspaceState
- EditorSession
- TransferJob
- FavoriteCommand
- RecentCommand
- FileOperationClipboard

## features/hosts
Owns:
- host chooser
- new host
- host detail
- advanced SSH
- identity
- trust
- forwarding

## features/workspace
Owns:
- workspace shell/browser switcher
- top bar state
- workspace status banners
- active host header info

## features/browser
Owns:
- remote listings
- browser selection mode
- file/folder action sheets
- properties sheet
- host-scoped file clipboard presentation

## features/shell
Owns:
- terminal view
- shell menu
- command history/favorites UI
- smart key row
- session action menu

## features/editor
Owns:
- full-screen remote editor
- dirty/read-only/disconnected state UI
- conflict/failure prompts
- open/save/close flows

## features/transfers
Owns:
- transfer progress panel
- transfer detail/failure summaries
- conflict dialogs
- retry/view errors flows

## features/settings
Owns:
- settings home
- key manager
- security/trust screens
- app preferences
- diagnostics/about

## services/ssh
Owns the raw transport/session lifecycle.

## services/sftp
Owns filesystem operations and directory/file primitives.

## services/shell
Owns remote PTY session and GNU screen integration.

## services/editor
Owns file eligibility and guarded save pipeline.

## services/transfers
Owns upload/download/copy/move execution and progress.

## services/storage
Owns non-secret app persistence:
- hosts
- snapshots
- commands
- key metadata

## services/security
Owns secure storage, local auth, trust behavior.

## services/platform
Owns notifications, file pickers, lifecycle bridge hooks.
