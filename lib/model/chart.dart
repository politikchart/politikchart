class LazyChartGroup {
  final String key;
  final Map<String, String> chartKeys;
  final Future<List<ChartData>> Function() load;

  LazyChartGroup({
    required this.key,
    required this.chartKeys,
    required this.load,
  });
}

class ChartGroup {
  final String key;
  final List<ChartData> charts;

  const ChartGroup({
    required this.key,
    required this.charts,
  });
}

class ChartData {
  final String key;
  final String name;
  final List<String> sources;
  final String yLabel;
  final List<ChartBar> bars;

  const ChartData({
    required this.key,
    required this.name,
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
