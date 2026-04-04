import '../enums/workspace_surface.dart';
import '../value_objects/host_id.dart';

class WorkspaceContextSnapshot {
  const WorkspaceContextSnapshot({
    required this.hostId,
    required this.lastSurface,
    required this.savedAt,
    this.lastFolderCanonicalPath,
    this.lastSelectedItemCanonicalPath,
    this.browserScrollOffset,
  });

  final HostId hostId;
  final WorkspaceSurface lastSurface;
  final String? lastFolderCanonicalPath;
  final String? lastSelectedItemCanonicalPath;
  final double? browserScrollOffset;
  final DateTime savedAt;
}
