import 'package:flutter/foundation.dart';

import '../../domain/models/host_config.dart';
import '../../domain/value_objects/host_id.dart';

abstract class HostStore extends Listenable {
  List<HostConfig> allHosts();

  HostConfig? hostById(HostId id);

  Future<void> upsertHost(HostConfig host);

  Future<void> deleteHost(HostId id);

  Future<void> markHostUsed(HostId id, DateTime usedAt);
}
