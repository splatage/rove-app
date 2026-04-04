import 'package:flutter/material.dart';

class AdvancedSshScreen extends StatelessWidget {
  const AdvancedSshScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PlaceholderScreen(
      title: 'Advanced SSH',
      body:
          'Advanced SSH options belong here in later slices. This screen exists now to preserve the documented navigation structure without inventing behavior.',
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(body),
      ),
    );
  }
}
