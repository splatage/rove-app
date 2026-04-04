import 'package:flutter/foundation.dart';

import '../../../domain/models/host_config.dart';
import '../../../services/storage/host_store.dart';

class HostChooserController extends ChangeNotifier {
  HostChooserController({required HostStore hostStore}) : _hostStore = hostStore {
    _hostStore.addListener(_onStoreChanged);
  }

  final HostStore _hostStore;

  List<HostConfig> get hosts {
    final List<HostConfig> sorted = _hostStore.allHosts().toList(growable: false);
    sorted.sort((HostConfig a, HostConfig b) {
      if (a.pinned != b.pinned) {
        return a.pinned ? -1 : 1;
      }
      final DateTime aUsed = a.lastUsedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final DateTime bUsed = b.lastUsedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bUsed.compareTo(aUsed);
    });
    return sorted;
  }

  @override
  void dispose() {
    _hostStore.removeListener(_onStoreChanged);
    super.dispose();
  }

  void _onStoreChanged() {
    notifyListeners();
  }
}
