import 'package:flutter/material.dart';

class IdentityScreen extends StatelessWidget {
  const IdentityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Identity')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Per-host identity controls will be wired in a later slice. The screen exists now to keep the route structure canonical.',
        ),
      ),
    );
  }
}
