import 'package:flutter/material.dart';

import '../../../app/lifecycle/app_lifecycle_coordinator.dart';
import '../../../domain/models/host_config.dart';
import '../../../services/storage/host_store.dart';
import '../../settings/settings_home_screen.dart';
import '../../workspace/workspace_screen.dart';
import '../host_detail/host_detail_screen.dart';
import '../new_host/new_host_screen.dart';
import 'host_chooser_controller.dart';

class HostChooserScreen extends StatefulWidget {
  const HostChooserScreen({
    required this.hostStore,
    required this.lifecycleCoordinator,
    super.key,
  });

  final HostStore hostStore;
  final AppLifecycleCoordinator lifecycleCoordinator;

  @override
  State<HostChooserScreen> createState() => _HostChooserScreenState();
}

class _HostChooserScreenState extends State<HostChooserScreen> {
  late final HostChooserController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HostChooserController(hostStore: widget.hostStore);
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
        final List<HostConfig> hosts = _controller.hosts;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Rove'),
            actions: <Widget>[
              IconButton(
                tooltip: 'Settings',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const SettingsHomeScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.settings_outlined),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              final HostConfig? connectHost = await Navigator.of(context).push<HostConfig>(
                MaterialPageRoute<HostConfig>(
                  builder: (BuildContext context) => NewHostScreen(
                    hostStore: widget.hostStore,
                  ),
                ),
              );
              if (connectHost == null || !mounted) {
                return;
              }
              await widget.hostStore.markHostUsed(
                connectHost.id,
                DateTime.now(),
              );
              if (!mounted) {
                return;
              }
              await Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => WorkspaceScreen(
                    host: connectHost,
                    lifecycleCoordinator: widget.lifecycleCoordinator,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('New Host'),
          ),
          body: hosts.isEmpty
              ? const _EmptyHostsView()
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: hosts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (BuildContext context, int index) {
                    final HostConfig host = hosts[index];
                    return Card(
                      child: ListTile(
                        leading: Icon(
                          host.pinned ? Icons.push_pin : Icons.dns_outlined,
                        ),
                        title: Text(host.label),
                        subtitle: Text(host.displayAddress),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          await widget.hostStore.markHostUsed(
                            host.id,
                            DateTime.now(),
                          );
                          if (!mounted) {
                            return;
                          }
                          await Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => WorkspaceScreen(
                                host: host,
                                lifecycleCoordinator: widget.lifecycleCoordinator,
                              ),
                            ),
                          );
                        },
                        onLongPress: () async {
                          await showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext bottomSheetContext) {
                              return SafeArea(
                                child: Wrap(
                                  children: <Widget>[
                                    ListTile(
                                      leading: const Icon(Icons.edit_outlined),
                                      title: const Text('Edit host'),
                                      onTap: () {
                                        Navigator.of(bottomSheetContext).pop();
                                        Navigator.of(context).push(
                                          MaterialPageRoute<void>(
                                            builder: (BuildContext context) => HostDetailScreen(
                                              hostStore: widget.hostStore,
                                              hostId: host.id,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(
                                        host.pinned ? Icons.push_pin : Icons.push_pin_outlined,
                                      ),
                                      title: Text(host.pinned ? 'Unpin host' : 'Pin host'),
                                      onTap: () async {
                                        Navigator.of(bottomSheetContext).pop();
                                        await widget.hostStore.upsertHost(
                                          host.copyWith(pinned: !host.pinned),
                                        );
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.delete_outline),
                                      title: const Text('Delete host'),
                                      onTap: () async {
                                        Navigator.of(bottomSheetContext).pop();
                                        final bool? confirmed = await showDialog<bool>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Delete host?'),
                                              content: Text(
                                                'Remove ${host.label} from the chooser?',
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () => Navigator.of(context).pop(false),
                                                  child: const Text('Cancel'),
                                                ),
                                                FilledButton(
                                                  onPressed: () => Navigator.of(context).pop(true),
                                                  child: const Text('Delete'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        if (confirmed == true) {
                                          await widget.hostStore.deleteHost(host.id);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}

class _EmptyHostsView extends StatelessWidget {
  const _EmptyHostsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            Icon(Icons.dns_outlined, size: 56),
            SizedBox(height: 16),
            Text(
              'No hosts yet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              'Create a host to start building the workspace around the locked SSH model.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
