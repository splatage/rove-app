import 'package:flutter/material.dart';

class TrustScreen extends StatelessWidget {
  const TrustScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trust')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Host-key trust and fingerprint controls will be wired in a later slice. This keeps the accepted screen hierarchy intact now.',
        ),
      ),
    );
  }
}
