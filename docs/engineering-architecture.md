# Mobile SSH App — Engineering Architecture

## 1. Purpose

This architecture translates the locked product spec into an implementation plan for a single codebase targeting:
- Android
- iOS
- Windows
- Linux

The goal is not maximum framework cleverness. The goal is a codebase that stays explicit, testable, drift-resistant, and aligned with the product rules already locked.

---

## 2. Chosen implementation stack

### 2.1 Framework
**Flutter**

Reasoning:
- one codebase for Android, iOS, Windows, and Linux
- strong widget/runtime model for a custom browser, shell, and editor UI
- good packaging story for desktop and mobile
- enough control to keep the app explicit rather than plugin-driven magic

### 2.2 Transport and terminal
**SSH/SFTP client:** `dartssh2`

Use it as the primary transport layer for:
- SSH connection setup and authentication
- shell channel / PTY
- SFTP subsystem
- forwarding where supported by the library and host

**Terminal renderer:** `xterm`

Use it for:
- the one real interactive shell surface
- hardware keyboard support
- terminal stream binding from the remote shell channel

### 2.3 Platform integration
Use Flutter plus narrow platform integrations only where needed:
- secure credential/keychain integration
- local auth / biometric gating
- file save/open/export system picker integration
- Android foreground notification/service behavior
- native notifications or lifecycle hooks when platform behavior truly differs

### 2.4 State management
Do **not** begin with a large global reactive state framework.

Use a simple layered state model:
- app-level router/controller
- feature-scoped controllers/notifiers
- small immutable state objects
- explicit service boundaries
- streams only where continuous transport/state change genuinely exists

The code should mirror the product boundaries:
- host management
- workspace/session
- browser
- shell
- editor
- transfers
- settings

---

## 3. Core architectural rules

### 3.1 One active workspace controller
There is exactly one active app workspace at a time.

A workspace owns:
- active host id
- one SSH transport
- shell availability
- SFTP/browser availability
- reconnect state
- transfer coordination
- editor coordination

### 3.2 One SSH transport, many logical services
The app opens one SSH connection for the active workspace.

On top of that transport:
- shell service uses a PTY/session channel
- browser/file service uses SFTP
- optional forwarding uses additional channels if/when enabled

### 3.3 Product honesty at code level
The code must not create hidden behavior that the product forbids.

That means:
- no silent autosave layer
- no silent local working-copy persistence
- no hidden shell/browser sync loop
- no silent fallback from strong save semantics to weak destructive behavior
- no implicit cross-host file-operation clipboard

### 3.4 Strategy in app, reality on host
The app chooses strategy.
The remote host and filesystem decide what actually works.

Examples:
- editor save chooses temp-file then replace strategy
- browser move chooses rename first, copy-delete fallback
- remote filesystem/server decides whether rename, replace, or fsync-like behavior is available

---

## 4. Recommended repository/package layout

```text
lib/
  app/
    app.dart
    router/
    lifecycle/
    theme/

  domain/
    models/
    enums/
    value_objects/

  features/
    hosts/
      chooser/
      new_host/
      host_detail/
      advanced_ssh/
      identity/
      trust/
      forwarding/

    workspace/
      workspace_shell.dart
      workspace_browser.dart
      workspace_switcher.dart
      workspace_status.dart

    browser/
      browser_controller.dart
      browser_state.dart
      listing/
      selection/
      file_actions/
      properties/

    shell/
      shell_controller.dart
      shell_state.dart
      terminal_view/
      command_menu/
      smart_keys/

    editor/
      editor_controller.dart
      editor_state.dart
      text_detection/
      save_pipeline/
      conflict_handling/

    transfers/
      transfer_controller.dart
      transfer_state.dart
      transfer_jobs/
      conflict_prompts/
      progress_ui/

    settings/
      settings_home/
      keys/
      security/
      app_preferences/
      diagnostics/

  services/
    ssh/
      ssh_session_service.dart
      ssh_capabilities.dart
    sftp/
      sftp_service.dart
    shell/
      shell_service.dart
    editor/
      editor_save_service.dart
      editor_file_eligibility_service.dart
    transfers/
      transfer_service.dart
    storage/
      host_store.dart
      context_snapshot_store.dart
      command_store.dart
      key_store.dart
    security/
      secure_storage_service.dart
      local_auth_service.dart
      trust_service.dart
    platform/
      notification_service.dart
      file_picker_service.dart
      lifecycle_service.dart

  platform/
    android/
    ios/
    windows/
    linux/
```

Rule:
- UI widgets stay in `features/*`
- transport, persistence, and platform logic stay in `services/*`
- product-neutral data types stay in `domain/*`

---

## 5. Core state boundaries

The following state objects should remain clearly separated.

### 5.1 App route state
Owns:
- current top-level route
- presented sheet/dialog state
- active workspace route
- settings sub-route

### 5.2 Per-host context snapshot
Saved, non-live context for reconnect.

Fields:
- host id
- last browser folder
- last browser selection
- last browser scroll anchor if practical
- last active workspace surface
- snapshot timestamp

This is not a live-session object.

### 5.3 Live workspace session state
Owns live runtime for the active host.

Fields:
- host id
- transport state
- browser channel state
- shell channel state
- session health state
- screen persistence mode/state
- reconnect state

### 5.4 Editor state
Owns one active editor session.

Fields:
- host id
- displayed path
- canonical path
- open-file snapshot attrs
- file eligibility result
- read-only flag
- dirty flag
- disconnected flag
- save-in-progress flag
- in-memory text buffer
- last save error

### 5.5 Transfer state
Owns transfer jobs for the active host.

Fields per job:
- id
- host id
- operation type
- source path(s)
- destination path
- status
- bytes transferred
- item counts
- current conflict resolution state
- errors

### 5.6 Command state
Host-scoped.

Fields:
- recent commands
- favorite commands
- optional shell metadata

### 5.7 File-operation clipboard state
Host-scoped.

Fields:
- operation type (copy/cut)
- source paths
- canonical source paths
- timestamp

### 5.8 Text clipboard integration
Global, but only for plain text/path text.

---

## 6. Domain model suggestions

## 6.1 HostConfig
```dart
class HostConfig {
  final String id;
  final String label;
  final String host;
  final int port;
  final String username;
  final AuthMethod authMethod;
  final String? selectedKeyId;
  final String? defaultRemotePath;
  final bool useScreen;
  final String? screenSessionName;
  final bool quitScreenOnLogout;
  final AdvancedSshConfig advanced;
}
```

## 6.2 AdvancedSshConfig
```dart
class AdvancedSshConfig {
  final bool identitiesOnly;
  final bool useAgent;
  final bool passwordAuthEnabled;
  final bool keyboardInteractiveEnabled;
  final StrictHostKeyCheckingMode strictHostKeyChecking;
  final String? knownHostsSource;
  final bool updateHostKeys;
  final bool verifyHostKeyDns;
  final bool visualHostKey;
  final String? proxyJump;
  final Duration? connectTimeout;
  final Duration? serverAliveInterval;
  final int? serverAliveCountMax;
  final bool tcpKeepAlive;
  final bool compression;
  final AddressFamily? addressFamily;
  final List<ForwardRule> forwardRules;
}
```

## 6.3 WorkspaceContextSnapshot
```dart
class WorkspaceContextSnapshot {
  final String hostId;
  final String? lastBrowserPath;
  final List<String> selectedPaths;
  final WorkspaceSurface lastSurface;
  final DateTime savedAt;
}
```

## 6.4 WorkspaceState
```dart
class WorkspaceState {
  final String hostId;
  final SessionHealth health;
  final TransportState transportState;
  final ChannelState shellState;
  final ChannelState browserState;
  final bool screenEnabled;
  final bool screenAttached;
}
```

## 6.5 EditorSession
```dart
class EditorSession {
  final String hostId;
  final String displayedPath;
  final String canonicalPath;
  final FileEligibility eligibility;
  final RemoteFileSnapshot openedSnapshot;
  final bool readOnly;
  final bool dirty;
  final bool disconnected;
  final bool saveInProgress;
  final String buffer;
  final EditorError? lastError;
}
```

## 6.6 TransferJob
```dart
class TransferJob {
  final String id;
  final String hostId;
  final TransferOperation operation;
  final List<String> sourcePaths;
  final String destinationPath;
  final TransferStatus status;
  final int bytesTransferred;
  final int? totalBytes;
  final int completedItems;
  final int failedItems;
  final List<TransferError> errors;
}
```

## 6.7 FavoriteCommand
```dart
class FavoriteCommand {
  final String id;
  final String? hostId; // null == global if ever allowed, otherwise host-specific only
  final String label;
  final String commandText;
  final CommandExecutionMode mode;
  final String? fixedPath;
  final bool confirmationRequired;
}
```

## 6.8 RecentCommand
```dart
class RecentCommand {
  final String id;
  final String hostId;
  final String commandText;
  final CommandSource source;
  final DateTime executedAt;
}
```

## 6.9 FileOperationClipboard
```dart
class FileOperationClipboard {
  final ClipboardOperation operation;
  final List<String> sourcePaths;
  final List<String> canonicalSourcePaths;
  final DateTime stagedAt;
}
```

---

## 7. Service interfaces

These should exist as explicit abstractions, even if the first implementation is simple.

### 7.1 SSH session service
Responsibilities:
- connect/disconnect transport
- authenticate host
- expose transport capabilities
- create shell and SFTP bindings
- surface health changes

```dart
abstract class SshSessionService {
  Future<void> connect(HostConfig host);
  Future<void> disconnect();
  bool get isConnected;
  Stream<SessionHealthEvent> get healthEvents;
  Future<ShellBinding> openShell(ShellOpenOptions options);
  Future<SftpBinding> openSftp();
  Future<SshCapabilities> detectCapabilities();
}
```

### 7.2 Shell service
Responsibilities:
- start one real interactive shell
- apply GNU screen attach/create behavior when configured
- bind shell streams to terminal UI

```dart
abstract class ShellService {
  Future<void> startShell(HostConfig host);
  Stream<ShellOutputChunk> get output;
  Future<void> write(String input);
  Future<void> resize(int cols, int rows);
  Future<void> close();
}
```

### 7.3 SFTP service
Responsibilities:
- list/stat/read/write/rename/delete/mkdir
- capability-aware file operations
- browser/file actions

```dart
abstract class SftpService {
  Future<List<RemoteEntry>> list(String path);
  Future<RemoteFileSnapshot> stat(String path);
  Future<String> readText(String path);
  Future<void> writeText(String path, String content);
  Future<void> mkdir(String path);
  Future<void> rename(String oldPath, String newPath);
  Future<void> delete(String path);
  Future<void> deleteDirectory(String path);
}
```

### 7.4 Editor file eligibility service
Responsibilities:
- decide edit/preview/refuse
- apply configurable max editable size
- detect obvious binary/text cases

```dart
abstract class EditorFileEligibilityService {
  Future<FileEligibility> evaluate(String path, RemoteFileSnapshot attrs);
}
```

### 7.5 Editor save service
Responsibilities:
- re-stat and conflict-check
- temp-file write
- fsync when supported
- rename/replace when supported
- explicit fallback path when not

```dart
abstract class EditorSaveService {
  Future<SaveResult> save(EditorSession session, String content);
}
```

### 7.6 Transfer service
Responsibilities:
- upload/download files and directories
- SFTP-first behavior
- recursive directory transfer
- conflict handling
- move fallback semantics
- progress and failure reporting

```dart
abstract class TransferService {
  Stream<TransferEvent> get events;
  Future<String> upload(TransferRequest request);
  Future<String> download(TransferRequest request);
  Future<String> copyRemote(RemoteCopyRequest request);
  Future<String> moveRemote(RemoteMoveRequest request);
  Future<void> cancel(String jobId);
  Future<void> retryFailed(String jobId);
}
```

### 7.7 Secure storage service
Responsibilities:
- store passwords/passphrases in OS-backed secure storage
- never store secrets in ordinary app settings

```dart
abstract class SecureStorageService {
  Future<void> writeSecret(String key, String value);
  Future<String?> readSecret(String key);
  Future<void> deleteSecret(String key);
}
```

### 7.8 Context snapshot store
Responsibilities:
- save/load per-host reconnect snapshot

```dart
abstract class ContextSnapshotStore {
  Future<void> save(WorkspaceContextSnapshot snapshot);
  Future<WorkspaceContextSnapshot?> load(String hostId);
  Future<void> clear(String hostId);
}
```

---

## 8. Editor lifecycle implementation guidance

### 8.1 Open pipeline
1. Stat file
2. Evaluate file eligibility
3. If editable/read-only/previewable, fetch text into memory
4. Open full-screen editor

### 8.2 Save pipeline
1. Re-stat remote file
2. Compare against open snapshot
3. If conflict, prompt user
4. Create temp file in same directory
5. Write content
6. Fsync temp file when supported
7. Replace/rename original when supported
8. Refresh remote snapshot and clear dirty flag

### 8.3 Failure policy
Never silently downgrade.

If strong replace path is unavailable:
- surface clear warning
- allow explicit user choice
- preserve buffer if save fails

### 8.4 Disconnect mid-edit
- preserve in-memory buffer only
- mark editor disconnected
- block normal save until reconnect path is resolved
- recovery options remain explicit

---

## 9. Browser and file-operation implementation guidance

### 9.1 Browser navigation
- tap folder opens
- tap file opens action sheet or preview/edit choice
- long press enters selection mode

### 9.2 File-operation clipboard
Host-scoped only.

Rules:
- one staged operation per host
- stage copy/cut explicitly
- paste targets current browser folder
- clear on full success or explicit user clear
- do not silently cross hosts

### 9.3 Move strategy
- try rename first
- if impossible, warn and offer copy-delete fallback
- never present copy-delete fallback as if it were the same operation

### 9.4 Transfer conflicts
Implement one conflict model across upload/download/copy/move:
- Replace
- Skip
- Rename copy
- Cancel
- optional Apply to all remaining conflicts for batches

### 9.5 Partial failure model
For multi-item transfers:
- keep successful items
- no rollback illusion
- final summary shows completed/skipped/failed
- actions: Retry failed / View errors / Done

---

## 10. Shell implementation guidance

### 10.1 One shell only
There is one real interactive shell surface for the active workspace.

### 10.2 GNU screen integration
When enabled for a host:
- on shell start, attach/create named screen session
- on logout/disconnect, either detach or quit according to host config

### 10.3 Terminal menu behavior
Shell menu contains:
- recent commands
- favorite commands
- paste clipboard
- insert current path
- session actions
- settings

### 10.4 Explicit command actions only
Saved commands support:
- Insert
- Run
- Run in this folder

No implicit auto-run.
No scripting/automation layer.

---

## 11. Resume and reconnect implementation guidance

### 11.1 Resume model
On resume:
- restore route and host snapshot context
- determine live transport state
- show explicit status

Never imply the browser stayed live in background.

### 11.2 Status language
Use plain, factual states:
- Live
- Reconnecting
- Disconnected
- Suspended

### 11.3 Shell persistence distinction
Browser context restore is app-side snapshot restore.
Shell persistence through GNU screen is true remote persistence.
Keep those concepts separate in both code and UI.

---

## 12. Platform-specific notes

### 12.1 Android
- allow visible background transfer/session behavior only where platform rules and notifications permit
- use notification-panel progress where supported
- do not create hidden long-running background work

### 12.2 iOS
- assume suspend/resume model
- preserve app state and reconnect honestly
- do not rely on indefinite background continuity

### 12.3 Desktop (Windows/Linux)
- same product rules
- desktop may feel roomier, but should not mutate the product into a different app
- keyboard and pointer affordances can be additive, not behaviorally different

---

## 13. Suggested implementation milestones

### Milestone 1 — Session spine
- Flutter app shell
- host chooser
- connect/disconnect
- one live workspace
- Browser/Shell switcher
- shell rendering
- SFTP directory listing

### Milestone 2 — Browser actions and transfers
- file/folder action sheets
- selection mode
- host-scoped file clipboard
- upload/download
- transfer progress
- conflict prompts

### Milestone 3 — Native editor
- file eligibility
- full-screen editor
- read-only/editable modes
- dirty state
- save pipeline
- conflict detection
- failed-save recovery

### Milestone 4 — Host depth and security
- advanced SSH screens
- trust screens
- key manager
- secure storage integration
- local auth gating

### Milestone 5 — Persistence polish
- GNU screen integration
- reconnect snapshot restore
- notification polish
- diagnostics and status refinement

### Milestone 6 — Advanced transfer options
- recursive directory polish
- optional advanced rsync-over-SSH path for supported hosts
- archive actions as explicit advanced utilities

---

## 14. Non-goals during implementation

Do not quietly add:
- autosave
- local working-copy persistence
- multi-host live workspaces
- multiple shell tabs
- sync engine behavior
- background “keep alive” claims the platform does not support
- implicit file execution guesses
- hidden destructive fallbacks

---

## 15. Exit criterion for architecture readiness

The architecture is ready for implementation once the following are pinned in code-facing terms:
- model type definitions
- service interfaces
- route tree
- session state machine
- transfer state machine
- editor state machine
- host persistence format
- secure secret handling path per platform

At that point, engineering can begin milestone-by-milestone without revisiting product philosophy.
