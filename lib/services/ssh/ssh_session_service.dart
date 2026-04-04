import '../../domain/models/host_config.dart';

abstract class SshSessionService {
  Future<void> connect(HostConfig host);

  Future<void> disconnect();

  bool get isConnected;
}
