import 'package:flutter/material.dart';

class SettingsHomeScreen extends StatelessWidget {
  const SettingsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: const <Widget>[
          ListTile(
            title: Text('Keys / Identities'),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            title: Text('Security / Trust'),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            title: Text('App preferences'),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            title: Text('About / Diagnostics'),
            trailing: Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
