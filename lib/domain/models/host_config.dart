import '../enums/auth_method.dart';
import '../value_objects/host_id.dart';
import 'advanced_ssh_config.dart';

class HostConfig {
  const HostConfig({
    required this.id,
    required this.label,
    required this.host,
    required this.port,
    required this.username,
    required this.authMethod,
    required this.defaultRemotePath,
    required this.useScreen,
    required this.screenSessionName,
    required this.quitScreenOnLogout,
    required this.pinned,
    required this.lastUsedAt,
    this.passwordSecretRef,
    this.keyId,
    this.advanced = const AdvancedSshConfig(),
  });

  final HostId id;
  final String label;
  final String host;
  final int port;
  final String username;
  final AuthMethod authMethod;
  final String? passwordSecretRef;
  final String? keyId;
  final String? defaultRemotePath;
  final bool useScreen;
  final String? screenSessionName;
  final bool quitScreenOnLogout;
  final bool pinned;
  final DateTime? lastUsedAt;
  final AdvancedSshConfig advanced;

  HostConfig copyWith({
    HostId? id,
    String? label,
    String? host,
    int? port,
    String? username,
    AuthMethod? authMethod,
    String? passwordSecretRef,
    String? keyId,
    String? defaultRemotePath,
    bool? useScreen,
    String? screenSessionName,
    bool? quitScreenOnLogout,
    bool? pinned,
    DateTime? lastUsedAt,
    AdvancedSshConfig? advanced,
  }) {
    return HostConfig(
      id: id ?? this.id,
      label: label ?? this.label,
      host: host ?? this.host,
      port: port ?? this.port,
      username: username ?? this.username,
      authMethod: authMethod ?? this.authMethod,
      passwordSecretRef: passwordSecretRef ?? this.passwordSecretRef,
      keyId: keyId ?? this.keyId,
      defaultRemotePath: defaultRemotePath ?? this.defaultRemotePath,
      useScreen: useScreen ?? this.useScreen,
      screenSessionName: screenSessionName ?? this.screenSessionName,
      quitScreenOnLogout: quitScreenOnLogout ?? this.quitScreenOnLogout,
      pinned: pinned ?? this.pinned,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      advanced: advanced ?? this.advanced,
    );
  }
}

extension HostConfigDisplay on HostConfig {
  String get displayAddress => '$username@$host:$port';
}
