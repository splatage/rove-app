# Interfaces and Service Contracts

This document defines the code-facing contracts that sit underneath the product spec. It is intentionally more concrete than the product docs and is meant to reduce implementation drift.

Examples below are written in a Dart-like pseudocode style because the current implementation direction is Flutter.

---

## 1. Core principles for code contracts

- one active workspace connection at a time
- one SSH transport per active workspace
- product behavior is explicit and conservative
- service contracts should separate policy from host/server capability
- host/server/filesystem reality always wins over client assumption

---

## 2. Core value objects

### HostId
```dart
class HostId {
  final String value;
}
```

### RemotePath
```dart
class RemotePath {
  final String displayedPath;
  final String canonicalPath;
}
```

### HostConfig
```dart
class HostConfig {
  final HostId id;
  final String label;
  final String host;
  final int port;
  final String username;
  final AuthMethod authMethod;
  final String? passwordSecretRef;
  final String? keyId;
  final String? defaultRemotePath;
  final bool useScreen;
  final String? screenSessionName;
  final bool quitScreenOnLogout;
  final AdvancedSshConfig advanced;
}
```

### AdvancedSshConfig
```dart
class AdvancedSshConfig {
  final bool strictHostKeyChecking;
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
  final bool identitiesOnly;
  final bool useAgent;
  final List<ForwardRule> forwards;
}
```

### WorkspaceContextSnapshot
```dart
class WorkspaceContextSnapshot {
  final HostId hostId;
  final WorkspaceSurface lastSurface;
  final String? lastFolderCanonicalPath;
  final String? lastSelectedItemCanonicalPath;
  final double? browserScrollOffset;
  final DateTime savedAt;
}
```

### RemoteEntry
```dart
class RemoteEntry {
  final String name;
  final RemotePath path;
  final RemoteEntryType type;
  final bool isSymlink;
  final String? symlinkTarget;
  final int? size;
  final DateTime? modifiedAt;
  final String? permissions;
  final bool readable;
  final bool writable;
}
```

### FileOperationClipboard
```dart
class FileOperationClipboard {
  final HostId hostId;
  final ClipboardOperation operation; // copy or cut
  final List<RemotePath> sourcePaths;
  final DateTime stagedAt;
}
```

### EditorSession
```dart
class EditorSession {
  final HostId hostId;
  final RemotePath path;
  final bool readOnly;
  final bool disconnected;
  final bool dirty;
  final String buffer;
  final RemoteFileSnapshot openedSnapshot;
  final int byteLength;
}
```

### RemoteFileSnapshot
```dart
class RemoteFileSnapshot {
  final int? size;
  final DateTime? modifiedAt;
  final String? permissions;
}
```

### TransferJob
```dart
class TransferJob {
  final String id;
  final HostId hostId;
  final TransferDirection direction;
  final List<RemotePath> sourcePaths;
  final String destination;
  final TransferStatus status;
  final int bytesTransferred;
  final int? totalBytes;
  final int itemsCompleted;
  final int totalItems;
  final List<TransferError> errors;
}
```

### RecentCommand
```dart
class RecentCommand {
  final String id;
  final HostId hostId;
  final String commandText;
  final CommandSource source; // typed, favorite, browserAction
  final DateTime executedAt;
}
```

### FavoriteCommand
```dart
class FavoriteCommand {
  final String id;
  final HostId hostId;
  final String label;
  final String commandText;
  final CommandExecutionMode mode; // insert, run, runInCurrentBrowserFolder, runInFixedFolder
  final String? fixedFolder;
  final bool requireConfirmation;
}
```

---

## 3. Workspace/session services

### WorkspaceController
Owns the currently active workspace.

```dart
abstract class WorkspaceController {
  ValueListenable<WorkspaceState> get state;

  Future<void> connect(HostId hostId);
  Future<void> disconnect();
  Future<void> reconnect();
  Future<void> switchSurface(WorkspaceSurface surface);
  Future<void> restoreSnapshot(WorkspaceContextSnapshot snapshot);
  Future<void> saveSnapshot();
}
```

Responsibilities:
- one active host workspace at a time
- own the live transport lifecycle
- coordinate Browser, Shell, Editor, Transfer services
- publish honest session state

### SshSessionService
```dart
abstract class SshSessionService {
  Future<void> open(HostConfig config);
  Future<void> close();
  bool get isConnected;
  Stream<SshConnectionEvent> get events;

  Future<ShellChannel> openShellChannel();
  Future<SftpSession> openSftpSession();
}
```

Rules:
- one transport per active workspace
- service exposes channel/session creation
- service reports connection loss explicitly

### ShellSessionService
```dart
abstract class ShellSessionService {
  Future<void> startShell(HostConfig config);
  Future<void> write(String data);
  Future<void> resize({required int cols, required int rows});
  Future<void> close();

  Stream<String> get output;
  ValueListenable<ShellSessionState> get state;
}
```

If GNU screen is enabled, `startShell` must attach/create using configured screen behavior.

### BrowserService
```dart
abstract class BrowserService {
  Future<List<RemoteEntry>> listDirectory(String canonicalPath);
  Future<RemoteEntry> stat(String canonicalPath);
  Future<RemoteEntry?> tryStat(String canonicalPath);
  Future<String> canonicalize(String path);
}
```

---

## 4. Editor services

### FileEligibilityService
```dart
abstract class FileEligibilityService {
  Future<FileEligibilityResult> evaluate(RemoteEntry entry);
}
```

Responsibilities:
- determine text/binary/preview-only/refuse
- respect configured max editable size
- explain why a file is not editable

### EditorService
```dart
abstract class EditorService {
  Future<EditorSession> open(RemotePath path);
  Future<EditorSaveResult> save(EditorSession session);
  Future<void> close(EditorSession session);
}
```

Save contract:
- re-stat remote file
- detect conflict
- write temp file
- use stronger safe path when available
- return explicit failure mode when not possible

### EditorSaveResult
```dart
sealed class EditorSaveResult {}

class EditorSaveSuccess extends EditorSaveResult {}
class EditorSaveConflict extends EditorSaveResult {
  final RemoteFileSnapshot currentRemoteSnapshot;
}
class EditorSavePermissionDenied extends EditorSaveResult {}
class EditorSaveTransportFailure extends EditorSaveResult {}
class EditorSaveWeakFallbackRequired extends EditorSaveResult {}
```

---

## 5. File-operation services

### FileOperationService
```dart
abstract class FileOperationService {
  Future<void> rename(RemotePath source, String newName);
  Future<MoveResult> move(List<RemotePath> sources, String targetFolderCanonicalPath);
  Future<CopyResult> copy(List<RemotePath> sources, String targetFolderCanonicalPath);
  Future<DeleteResult> delete(List<RemotePath> sources);
  Future<PropertiesResult> properties(RemotePath path);
}
```

Rules:
- move uses rename first
- fallback to copy-then-delete when needed
- hard-link/unlink is not the primary move path
- destructive operations must expose safe alternatives through caller UX

### ClipboardService
```dart
abstract class ClipboardService {
  ValueListenable<String?> get globalTextClipboard;

  FileOperationClipboard? currentHostFileClipboard(HostId hostId);
  void stageCopy(HostId hostId, List<RemotePath> paths);
  void stageCut(HostId hostId, List<RemotePath> paths);
  void clearHostClipboard(HostId hostId);
}
```

Rules:
- global clipboard is text only
- file-operation clipboard is host-scoped only

---

## 6. Transfer services

### TransferService
```dart
abstract class TransferService {
  ValueListenable<List<TransferJob>> get jobs;

  Future<String> uploadFiles({
    required HostId hostId,
    required List<String> localPaths,
    required String remoteTargetFolder,
  });

  Future<String> downloadFiles({
    required HostId hostId,
    required List<RemotePath> remotePaths,
    required String localDestination,
  });

  Future<void> cancelJob(String jobId);
  Future<void> retryFailed(String jobId);
}
```

Rules:
- default file and directory transfer uses SFTP
- recursive directory transfer supported
- rsync is advanced optional mode later, not baseline contract here
- no sync engine semantics
- no silent overwrite

### ConflictResolver
```dart
abstract class ConflictResolver {
  Future<ConflictResolution> resolveFileConflict(FileConflictContext context);
}
```

Expected resolutions:
- replace
- skip
- rename copy
- cancel
- optionally apply to all remaining conflicts

---

## 7. Host/security services

### HostRepository
```dart
abstract class HostRepository {
  Future<List<HostConfig>> listHosts();
  Future<HostConfig?> getHost(HostId id);
  Future<void> saveHost(HostConfig config);
  Future<void> deleteHost(HostId id);
}
```

### KeyManagerService
```dart
abstract class KeyManagerService {
  Future<List<KeySummary>> listKeys();
  Future<KeySummary> importKey(String localPath);
  Future<KeySummary> generateKey(KeyGenerationRequest request);
  Future<String> readPublicKey(String keyId);
  Future<void> deleteKey(String keyId);
}
```

### SecureStorageService
```dart
abstract class SecureStorageService {
  Future<void> saveSecret(String key, String value);
  Future<String?> readSecret(String key);
  Future<void> deleteSecret(String key);
}
```

### LocalAuthService
```dart
abstract class LocalAuthService {
  Future<bool> authenticate({required String reason});
  Future<bool> isAvailable();
}
```

### TrustService
```dart
abstract class TrustService {
  Future<HostTrustState> getTrustState(HostId hostId);
  Future<void> forgetHostTrust(HostId hostId);
  Future<void> acceptHostFingerprint(HostId hostId, String fingerprint);
}
```

---

## 8. Notifications and lifecycle

### NotificationService
```dart
abstract class NotificationService {
  Future<void> showTransferProgress(TransferJob job);
  Future<void> dismissTransferProgress(String jobId);
  Future<void> showConnectionStatus(WorkspaceState state);
}
```

### LifecycleService
```dart
abstract class LifecycleService {
  Stream<AppLifecycleState> get appStates;
}
```

Rules:
- preserve UI state across backgrounding
- do not promise uninterrupted transport across platforms
- reconnect language must be explicit and truthful

---

## 9. Controller boundaries

### BrowserController
Owns:
- current folder
- current listing
- selection state
- host-scoped file clipboard
- paste target folder

### ShellController
Owns:
- shell output/input binding
- screen attach/create policy
- recent commands for host
- favorite commands for host

### EditorController
Owns:
- current editor session
- dirty/read-only/disconnected state
- save pipeline
- save conflict/failure actions

### TransferController
Owns:
- transfer jobs
- progress state
- post-transfer summaries
- retry/cancel actions

---

## 10. Required UX guarantees from services

Service implementations must preserve the locked product behaviors:

- no hidden sync between Browser and Shell
- no silent destructive fallback
- no silent overwrite
- no hidden local drafts
- no hidden command execution
- explicit recovery paths on save/transfer failure
- transport/session state reported honestly
