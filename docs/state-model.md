# State Model

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
