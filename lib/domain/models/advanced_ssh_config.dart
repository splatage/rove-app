class AdvancedSshConfig {
  const AdvancedSshConfig({
    this.strictHostKeyChecking = true,
    this.knownHostsSource,
    this.updateHostKeys = false,
    this.verifyHostKeyDns = false,
    this.visualHostKey = false,
    this.proxyJump,
    this.connectTimeout,
    this.serverAliveInterval,
    this.serverAliveCountMax,
    this.tcpKeepAlive = true,
    this.compression = false,
    this.identitiesOnly = false,
    this.useAgent = false,
  });

  final bool strictHostKeyChecking;
  final String? knownHostsSource;
  final bool updateHostKeys;
  final bool verifyHostKeyDns;
  final bool visualHostKey;
  final String? proxyJump;
  final Duration? connectTimeout;
  final Duration? serverAliveInterval;
  final int? serverAliveCountMax;
  final bool tcpKeepAlive;
  final bool compression;
  final bool identitiesOnly;
  final bool useAgent;

  AdvancedSshConfig copyWith({
    bool? strictHostKeyChecking,
    String? knownHostsSource,
    bool? updateHostKeys,
    bool? verifyHostKeyDns,
    bool? visualHostKey,
    String? proxyJump,
    Duration? connectTimeout,
    Duration? serverAliveInterval,
    int? serverAliveCountMax,
    bool? tcpKeepAlive,
    bool? compression,
    bool? identitiesOnly,
    bool? useAgent,
  }) {
    return AdvancedSshConfig(
      strictHostKeyChecking:
          strictHostKeyChecking ?? this.strictHostKeyChecking,
      knownHostsSource: knownHostsSource ?? this.knownHostsSource,
      updateHostKeys: updateHostKeys ?? this.updateHostKeys,
      verifyHostKeyDns: verifyHostKeyDns ?? this.verifyHostKeyDns,
      visualHostKey: visualHostKey ?? this.visualHostKey,
      proxyJump: proxyJump ?? this.proxyJump,
      connectTimeout: connectTimeout ?? this.connectTimeout,
      serverAliveInterval: serverAliveInterval ?? this.serverAliveInterval,
      serverAliveCountMax: serverAliveCountMax ?? this.serverAliveCountMax,
      tcpKeepAlive: tcpKeepAlive ?? this.tcpKeepAlive,
      compression: compression ?? this.compression,
      identitiesOnly: identitiesOnly ?? this.identitiesOnly,
      useAgent: useAgent ?? this.useAgent,
    );
  }
}
