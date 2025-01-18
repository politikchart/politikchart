class LazyChartGroup {
  final String key;
  final String label;
  final Map<String, String> chartKeys;
  final Future<List<ChartData>> Function() load;

  LazyChartGroup({
    required this.key,
    required this.label,
    required this.chartKeys,
    required this.load,
  });
}

class ChartData {
  final String key;
  final String name;
  final String description;
  final List<String> sources;
  final String yLabel;
  final List<ChartBar> bars;

  const ChartData({
    required this.key,
    required this.name,
    required this.description,
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
