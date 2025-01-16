class ChartData {
  final List<String> sources;
  final String yLabel;
  final List<ChartBar> bars;

  const ChartData({
    required this.sources,
    required this.yLabel,
    required this.bars,
  });
}

class ChartBar {
  final int x;
  final double y;

  const ChartBar({
    required this.x,
    required this.y,
  });
}
