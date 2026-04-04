class HostId {
  const HostId(this.value);

  final String value;

  @override
  bool operator ==(Object other) {
    return other is HostId && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
