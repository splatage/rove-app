import 'package:flutter/material.dart';

import '../../domain/models/host_config.dart';

class ShellSurface extends StatelessWidget {
  const ShellSurface({required this.host, super.key});

  final HostConfig host;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Text('Shell', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          host.useScreen
              ? 'GNU screen: ${host.screenSessionName ?? '(unnamed)'}'
              : 'No screen session configured',
        ),
        const SizedBox(height: 16),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'The real PTY-backed shell, terminal renderer, smart key row, and per-host command menus are deferred to later slices. This surface keeps the workspace switcher and state boundaries canonical now.',
            ),
          ),
        ),
      ],
    );
  }
}
