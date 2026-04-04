import 'package:flutter/material.dart';

import '../features/hosts/chooser/host_chooser_screen.dart';
import '../services/storage/in_memory_host_store.dart';
import 'lifecycle/app_lifecycle_coordinator.dart';
import 'theme/app_theme.dart';

class RoveApp extends StatefulWidget {
  const RoveApp({super.key});

  @override
  State<RoveApp> createState() => _RoveAppState();
}

class _RoveAppState extends State<RoveApp> {
  late final InMemoryHostStore _hostStore;
  late final AppLifecycleCoordinator _lifecycleCoordinator;

  @override
  void initState() {
    super.initState();
    _hostStore = InMemoryHostStore();
    _lifecycleCoordinator = AppLifecycleCoordinator();
  }

  @override
  void dispose() {
    _lifecycleCoordinator.dispose();
    _hostStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rove',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: HostChooserScreen(
        hostStore: _hostStore,
        lifecycleCoordinator: _lifecycleCoordinator,
      ),
    );
  }
}
