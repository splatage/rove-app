import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../app/lifecycle/app_lifecycle_coordinator.dart';
import '../../domain/enums/workspace_connection_status.dart';
import '../../domain/enums/workspace_surface.dart';
import '../../domain/models/host_config.dart';

class WorkspaceController extends ChangeNotifier {
  WorkspaceController({
    required this.host,
    required AppLifecycleCoordinator lifecycleCoordinator,
  }) : _lifecycleCoordinator = lifecycleCoordinator {
    _lifecycleCoordinator.addListener(_onLifecycleChanged);
  }

  final HostConfig host;
  final AppLifecycleCoordinator _lifecycleCoordinator;

  WorkspaceSurface _surface = WorkspaceSurface.browser;
  WorkspaceConnectionStatus _status = WorkspaceConnectionStatus.disconnected;

  WorkspaceSurface get surface => _surface;
  WorkspaceConnectionStatus get status => _status;

  void switchSurface() {
    _surface = _surface == WorkspaceSurface.browser
        ? WorkspaceSurface.shell
        : WorkspaceSurface.browser;
    notifyListeners();
  }

  @override
  void dispose() {
    _lifecycleCoordinator.removeListener(_onLifecycleChanged);
    super.dispose();
  }

  void _onLifecycleChanged() {
    final AppLifecycleState state = _lifecycleCoordinator.state;
    WorkspaceConnectionStatus nextStatus = WorkspaceConnectionStatus.disconnected;
    if (state == AppLifecycleState.resumed) {
      nextStatus = WorkspaceConnectionStatus.disconnected;
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      nextStatus = WorkspaceConnectionStatus.suspended;
    }
    if (nextStatus != _status) {
      _status = nextStatus;
      notifyListeners();
    }
  }
}
