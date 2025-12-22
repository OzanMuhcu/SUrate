DateTime parseCreatedAt(Object? value) {
  if (value == null) {
    return DateTime.fromMillisecondsSinceEpoch(0);
  }
  if (value is DateTime) {
    return value;
  }
  if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value);
  }
  if (value is Map<String, dynamic>) {
    final seconds = value['seconds'];
    final nanoseconds = value['nanoseconds'];
    if (seconds is int) {
      final millis = seconds * 1000 + (nanoseconds is int ? nanoseconds ~/ 1000000 : 0);
      return DateTime.fromMillisecondsSinceEpoch(millis);
    }
  }
  try {
    final dynamic maybeToDate = (value as dynamic).toDate;
    if (maybeToDate is Function) {
      final dynamic result = (value as dynamic).toDate();
      if (result is DateTime) {
        return result;
      }
    }
  } catch (_) {}
  return DateTime.fromMillisecondsSinceEpoch(0);
}
