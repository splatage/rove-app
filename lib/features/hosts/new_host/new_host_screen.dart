import 'package:flutter/material.dart';

import '../../../domain/enums/auth_method.dart';
import '../../../domain/models/host_config.dart';
import '../../../domain/value_objects/host_id.dart';
import '../../../services/storage/host_store.dart';
import '../advanced_ssh/advanced_ssh_screen.dart';

class NewHostScreen extends StatefulWidget {
  const NewHostScreen({required this.hostStore, super.key});

  final HostStore hostStore;

  @override
  State<NewHostScreen> createState() => _NewHostScreenState();
}

class _NewHostScreenState extends State<NewHostScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _labelController = TextEditingController();
  final TextEditingController _hostController = TextEditingController();
  final TextEditingController _portController = TextEditingController(text: '22');
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _defaultPathController = TextEditingController();
  final TextEditingController _screenSessionNameController = TextEditingController();

  AuthMethod _authMethod = AuthMethod.password;
  bool _useScreen = false;
  bool _quitScreenOnLogout = false;

  @override
  void dispose() {
    _labelController.dispose();
    _hostController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _keyController.dispose();
    _defaultPathController.dispose();
    _screenSessionNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Host'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const AdvancedSshScreen(),
                ),
              );
            },
            child: const Text('Advanced'),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              TextFormField(
                controller: _labelController,
                decoration: const InputDecoration(labelText: 'Label'),
                validator: _required,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _hostController,
                decoration: const InputDecoration(labelText: 'Host / Address'),
                validator: _required,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _portController,
                decoration: const InputDecoration(labelText: 'Port'),
                keyboardType: TextInputType.number,
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Port is required';
                  }
                  final int? parsed = int.tryParse(value);
                  if (parsed == null || parsed < 1 || parsed > 65535) {
                    return 'Enter a valid port';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: _required,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<AuthMethod>(
                value: _authMethod,
                decoration:
                    const InputDecoration(labelText: 'Authentication method'),
                items: const <DropdownMenuItem<AuthMethod>>[
                  DropdownMenuItem<AuthMethod>(
                    value: AuthMethod.password,
                    child: Text('Password'),
                  ),
                  DropdownMenuItem<AuthMethod>(
                    value: AuthMethod.key,
                    child: Text('Private key'),
                  ),
                ],
                onChanged: (AuthMethod? value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _authMethod = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              if (_authMethod == AuthMethod.password)
                TextFormField(
                  controller: _passwordController,
                  decoration:
                      const InputDecoration(labelText: 'Password reference'),
                  validator: _required,
                )
              else
                TextFormField(
                  controller: _keyController,
                  decoration: const InputDecoration(labelText: 'Key id'),
                  validator: _required,
                ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _defaultPathController,
                decoration:
                    const InputDecoration(labelText: 'Default remote path'),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Use GNU screen'),
                value: _useScreen,
                onChanged: (bool value) {
                  setState(() {
                    _useScreen = value;
                  });
                },
              ),
              if (_useScreen) ...<Widget>[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _screenSessionNameController,
                  decoration:
                      const InputDecoration(labelText: 'Screen session name'),
                  validator: (String? value) {
                    if (!_useScreen) {
                      return null;
                    }
                    return _required(value);
                  },
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Quit screen session on logout'),
                  value: _quitScreenOnLogout,
                  onChanged: (bool value) {
                    setState(() {
                      _quitScreenOnLogout = value;
                    });
                  },
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _testConnectionUnavailable,
                  child: const Text('Test connection'),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _save(connectAfterSave: false),
                      child: const Text('Save'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => _save(connectAfterSave: true),
                      child: const Text('Connect'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    return null;
  }

  Future<void> _save({required bool connectAfterSave}) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final HostConfig host = HostConfig(
      id: HostId(DateTime.now().microsecondsSinceEpoch.toString()),
      label: _labelController.text.trim(),
      host: _hostController.text.trim(),
      port: int.parse(_portController.text.trim()),
      username: _usernameController.text.trim(),
      authMethod: _authMethod,
      passwordSecretRef: _authMethod == AuthMethod.password
          ? _passwordController.text.trim()
          : null,
      keyId: _authMethod == AuthMethod.key ? _keyController.text.trim() : null,
      defaultRemotePath: _defaultPathController.text.trim().isEmpty
          ? null
          : _defaultPathController.text.trim(),
      useScreen: _useScreen,
      screenSessionName: _useScreen
          ? _screenSessionNameController.text.trim()
          : null,
      quitScreenOnLogout: _useScreen && _quitScreenOnLogout,
      pinned: false,
      lastUsedAt: null,
    );
    await widget.hostStore.upsertHost(host);
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop(connectAfterSave ? host : null);
  }

  void _testConnectionUnavailable() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'SSH transport is not wired in Slice 1, so test connection is intentionally unavailable.',
        ),
      ),
    );
  }
}
