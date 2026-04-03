# Core Interfaces

## WorkspaceController responsibilities
- activate host
- open/close workspace
- hold one live SSH transport
- coordinate Browser, Shell, Editor, and Transfers
- restore context snapshot on reconnect
- expose workspace health state

## BrowserController responsibilities
- current folder path
- list refresh
- selection mode
- file/folder actions
- host-scoped file-operation clipboard
- launch editor / shell handoff actions

## ShellController responsibilities
- bind terminal to shell stream
- send input/resize
- manage command history/favorites for host
- handle GNU screen attach/create if configured

## EditorController responsibilities
- open file session
- keep in-memory text buffer
- track dirty/read-only/disconnected state
- invoke guarded save pipeline
- surface conflict/failure recovery

## TransferController responsibilities
- create/manage transfer jobs
- surface progress
- apply conflict model
- summarize partial failures
- integrate notification progress where supported

## SettingsController responsibilities
- navigate settings sections
- manage key manager flows
- manage trust/security flows
- expose app preferences

## Suggested state machines

### Workspace session state
- idle
- connecting
- live
- reconnecting
- disconnected
- unhealthy

### Editor state
- opening
- ready-clean
- ready-dirty
- saving
- conflict
- failed
- disconnected

### Transfer job state
- queued
- running
- awaiting-conflict-resolution
- completed
- completed-with-skips
- failed-partial
- failed
- canceled
