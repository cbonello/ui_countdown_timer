class Ticker {
  Stream<int> tick({int ticks}) {
    return Stream<int>.periodic(Duration(seconds: 1), (int x) => ticks - x - 1)
        .take(ticks);
  }
}
