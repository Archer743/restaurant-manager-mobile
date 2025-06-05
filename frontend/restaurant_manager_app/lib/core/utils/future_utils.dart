/*
  It ensures that:
  - The given future (e.g., login request) runs as usual, but
  - The entire operation takes at least minimumDelay time (default: 800ms).
  This is useful in UI contexts to avoid fast flickering loading indicators.
*/
Future<T> minDelayRun<T>(Future<T> future,
    {Duration minimumDelay = const Duration(milliseconds: 800)}) async {
  final results = await Future.wait([
    future,
    Future.delayed(minimumDelay),
  ]);

  return results.first as T;
}
