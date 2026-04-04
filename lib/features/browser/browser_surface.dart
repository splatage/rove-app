import 'package:flutter/material.dart';

import '../../domain/models/host_config.dart';

class BrowserSurface extends StatelessWidget {
  const BrowserSurface({required this.host, super.key});

  final HostConfig host;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Text('Browser', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(host.defaultRemotePath ?? '~/'),
        const SizedBox(height: 16),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Directory listing, selection mode, file actions, and transfer flows are intentionally deferred to later slices. This screen preserves the workspace structure and top-level interaction model now.',
            ),
          ),
        ),
      ],
    );
  }
}
