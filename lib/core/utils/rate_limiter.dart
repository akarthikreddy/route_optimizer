import 'dart:async';

/// Ensures at most [maxPerSecond] calls per second by inserting delays.
class RateLimiter {
  RateLimiter({this.maxPerSecond = 1});

  final int maxPerSecond;
  DateTime _lastCall = DateTime.fromMillisecondsSinceEpoch(0);

  Future<void> throttle() async {
    final now = DateTime.now();
    final minInterval = Duration(milliseconds: (1000 / maxPerSecond).ceil());
    final elapsed = now.difference(_lastCall);
    if (elapsed < minInterval) {
      await Future.delayed(minInterval - elapsed);
    }
    _lastCall = DateTime.now();
  }
}
