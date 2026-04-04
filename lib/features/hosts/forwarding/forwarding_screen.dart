import 'package:flutter/material.dart';

class ForwardingScreen extends StatelessWidget {
  const ForwardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forwarding')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Forwarding rules are intentionally deferred. This placeholder preserves the documented routing and avoids inventing runtime behavior in the scaffold slice.',
        ),
      ),
    );
  }
}
