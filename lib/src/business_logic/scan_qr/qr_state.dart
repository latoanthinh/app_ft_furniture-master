class ScanQrState {
  final Map<String, dynamic>? history;
  final DateTime sessionTime;
  final List<String?> codes;

  const ScanQrState({required this.sessionTime, required this.codes, this.history});

  ScanQrState copyWith({
    Map<String, dynamic>? history,
    DateTime? sessionTime,
    List<String?>? codes,
  }) {
    return ScanQrState(
      history: history ?? this.history,
      sessionTime: sessionTime ?? this.sessionTime,
      codes: codes ?? this.codes,
    );
  }
}
