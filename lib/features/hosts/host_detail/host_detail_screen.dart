import 'package:flutter/material.dart';

import '../../../domain/models/host_config.dart';
import '../../../domain/value_objects/host_id.dart';
import '../../../services/storage/host_store.dart';
import '../advanced_ssh/advanced_ssh_screen.dart';
import '../forwarding/forwarding_screen.dart';
import '../identity/identity_screen.dart';
import '../trust/trust_screen.dart';

class HostDetailScreen extends StatelessWidget {
  const HostDetailScreen({
    required this.hostStore,
    required this.hostId,
    super.key,
  });

  final HostStore hostStore;
  final HostId hostId;

  @override
  Widget build(BuildContext context) {
    final HostConfig? host = hostStore.hostById(hostId);
    return Scaffold(
      appBar: AppBar(title: const Text('Host Detail')),
      body: host == null
          ? const Center(child: Text('Host not found'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(host.label, style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(host.displayAddress),
                        const SizedBox(height: 8),
                        Text('Auth: ${host.authMethod.name}'),
                        Text('Screen: ${host.useScreen ? 'Enabled' : 'Disabled'}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _SectionHeader(title: 'Common settings'),
                ListTile(
                  title: const Text('Default remote path'),
                  subtitle: Text(host.defaultRemotePath ?? 'Not set'),
                ),
                const SizedBox(height: 16),
                _SectionHeader(title: 'Advanced areas'),
                ListTile(
                  title: const Text('Advanced SSH'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const AdvancedSshScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Identity'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const IdentityScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Trust'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const TrustScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Forwarding'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const ForwardingScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleMedium);
  }
}
