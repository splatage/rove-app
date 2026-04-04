import 'package:flutter/material.dart';

import '../../app/lifecycle/app_lifecycle_coordinator.dart';
import '../../domain/enums/workspace_connection_status.dart';
import '../../domain/enums/workspace_surface.dart';
import '../../domain/models/host_config.dart';
import '../browser/browser_surface.dart';
import '../shell/shell_surface.dart';
import 'workspace_controller.dart';

class WorkspaceScreen extends StatefulWidget {
  const WorkspaceScreen({
    required this.host,
    required this.lifecycleCoordinator,
    super.key,
  });

  final HostConfig host;
  final AppLifecycleCoordinator lifecycleCoordinator;

  @override
  State<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends State<WorkspaceScreen> {
  late final WorkspaceController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WorkspaceController(
      host: widget.host,
      lifecycleCoordinator: widget.lifecycleCoordinator,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.host.label),
            actions: <Widget>[
              IconButton(
                tooltip: _controller.surface == WorkspaceSurface.browser
                    ? 'Open shell'
                    : 'Open browser',
                onPressed: _controller.switchSurface,
                icon: Icon(
                  _controller.surface == WorkspaceSurface.browser
                      ? Icons.terminal
                      : Icons.folder_open,
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (_) {},
                itemBuilder: (BuildContext context) {
                  if (_controller.surface == WorkspaceSurface.browser) {
                    return const <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'refresh',
                        child: Text('Refresh'),
                      ),
                      PopupMenuItem<String>(
                        value: 'new-folder',
                        child: Text('New folder'),
                      ),
                      PopupMenuItem<String>(
                        value: 'upload',
                        child: Text('Upload'),
                      ),
                    ];
                  }
                  return const <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'recent',
                      child: Text('Recent commands'),
                    ),
                    PopupMenuItem<String>(
                      value: 'favorites',
                      child: Text('Favorite commands'),
                    ),
                    PopupMenuItem<String>(
                      value: 'paste',
                      child: Text('Paste clipboard'),
                    ),
                  ];
                },
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: _WorkspaceStatusBanner(status: _controller.status),
            ),
          ),
          body: IndexedStack(
            index: _controller.surface == WorkspaceSurface.browser ? 0 : 1,
            children: <Widget>[
              BrowserSurface(host: widget.host),
              ShellSurface(host: widget.host),
            ],
          ),
        );
      },
    );
  }
}

class _WorkspaceStatusBanner extends StatelessWidget {
  const _WorkspaceStatusBanner({required this.status});

  final WorkspaceConnectionStatus status;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final String text;
    switch (status) {
      case WorkspaceConnectionStatus.live:
        text = 'Live';
        break;
      case WorkspaceConnectionStatus.reconnecting:
        text = 'Reconnecting';
        break;
      case WorkspaceConnectionStatus.disconnected:
        text = 'Workspace scaffold only — transport not wired in this slice';
        break;
      case WorkspaceConnectionStatus.suspended:
        text = 'App backgrounded — context preserved, live transport not assumed';
        break;
    }
    return Container(
      width: double.infinity,
      color: colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(text, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
