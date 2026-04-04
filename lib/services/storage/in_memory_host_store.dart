import 'package:flutter/foundation.dart';

import '../../domain/models/host_config.dart';
import '../../domain/value_objects/host_id.dart';
import 'host_store.dart';

class InMemoryHostStore extends ChangeNotifier implements HostStore {
  final Map<String, HostConfig> _hosts = <String, HostConfig>{};

  @override
  List<HostConfig> allHosts() {
    return _hosts.values.toList(growable: false);
  }

  @override
  Future<void> deleteHost(HostId id) async {
    _hosts.remove(id.value);
    notifyListeners();
  }

  @override
  HostConfig? hostById(HostId id) {
    return _hosts[id.value];
  }

  @override
  Future<void> markHostUsed(HostId id, DateTime usedAt) async {
    final HostConfig? existing = _hosts[id.value];
    if (existing == null) {
      return;
    }
    _hosts[id.value] = existing.copyWith(lastUsedAt: usedAt);
    notifyListeners();
  }

  @override
  Future<void> upsertHost(HostConfig host) async {
    _hosts[host.id.value] = host;
    notifyListeners();
  }
}
