class RangeUtils {
  static List<int> range(int from, int to) {
    return List.generate(to - from, (index) => from + index);
  }
}
