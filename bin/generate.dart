import 'dart:io';

import 'package:politikchart/model/chart.dart';
import 'package:politikchart/model/party.dart';
import 'package:yaml/yaml.dart';

void main() {
  final parties = scanParties('data/germany');
  final gov = scanGovernment('data/germany', parties);

  final govFile = generateGovernmentFile(gov, parties);
  File('lib/data/germany/government.dart').writeAsStringSync(govFile);

  final chartGroups = scanChartGroups('data/germany');
  File('lib/data/germany/charts.dart').writeAsStringSync(generateMainChart(chartGroups));

  for (final group in chartGroups) {
    final dir = Directory('lib/data/germany/${group.key}');
    if (!dir.existsSync()) {
      dir.createSync();
    }

    final groupFile = generateChartGroupFile(group);
    File('lib/data/germany/${group.key}/_charts.dart').writeAsStringSync(groupFile);

    for (final chart in group.charts) {
      final chartFile = generateChartFile(chart);
      File('lib/data/germany/${group.key}/${chart.key.replaceAll('-', '_')}.dart').writeAsStringSync(chartFile);
    }
  }
}

List<Government> scanGovernment(String countryDir, Map<String, Party> parties) {
  final govRaw = File('$countryDir/governments.yaml').readAsStringSync();
  final govParsed = loadYaml(govRaw);

  final result = <Government>[];
  for (final entry in govParsed) {
    final gov = Government(
      alias: entry['alias'],
      parties: entry['parties'].map((partyName) => parties[partyName]).cast<Party>().toList(),
      start: Date.fromDateTime(DateTime.parse(entry['start'])),
      end: entry['end'] == null ? null : Date.fromDateTime(DateTime.parse(entry['end'])),
    );
    result.add(gov);
  }

  return result;
}

Map<String, Party> scanParties(String countryDir) {
  final partyRaw = File('$countryDir/parties.yaml').readAsStringSync();
  final partyParsed = loadYaml(partyRaw);

  final result = <String, Party>{};
  for (final entry in partyParsed.entries) {
    final party = Party(
      key: entry.key,
      name: entry.value['name'],
      color: RgbColor(int.parse(entry.value['color'], radix: 16)),
    );
    result[entry.key] = party;
  }

  return result;
}

String generateGovernmentFile(
  List<Government> governments,
  Map<String, Party> parties,
) {
  final buffer = StringBuffer();
  buffer.writeln("import 'package:politikchart/model/party.dart';");
  buffer.writeln();

  for (final party in parties.values) {
    buffer.writeln('const ${party.key} = Party(');
    buffer.writeln("  key: '${party.key}',");
    buffer.writeln("  name: '${party.name}',");
    buffer.writeln('  color: RgbColor(0x${party.color.value.toRadixString(16).padLeft(6, '0')}),');
    buffer.writeln(');');
    buffer.writeln();
  }

  buffer.writeln('const governments = [');
  for (final gov in governments) {
    buffer.writeln('  Government(');
    buffer.writeln("    alias: '${gov.alias}',");
    buffer.writeln('    parties: [${gov.parties.map((party) => party.key).join(', ')}],');
    buffer.writeln('    start: Date(${gov.start.year}, ${gov.start.month}, ${gov.start.day}),');
    buffer.writeln('    end: ${gov.end == null ? 'null' : 'Date(${gov.end!.year}, ${gov.end!.month}, ${gov.end!.day})'},');
    buffer.writeln('  ),');
  }
  buffer.writeln('];');

  return buffer.toString();
}

List<ParsedChartGroup> scanChartGroups(String countryDir) {
  final groupsFile = File('$countryDir/groups.yaml').readAsStringSync();
  final Map<String, String> groupsParsed = loadYaml(groupsFile).cast<String, String>();

  final directories = Directory(countryDir).listSync();

  final result = <String, ParsedChartGroup>{};
  for (final dir in directories) {
    if (dir is! Directory) {
      continue;
    }

    final dirName = dir.path.replaceAll('\\', '/').split('/').last;

    if (!groupsParsed.containsKey(dirName)) {
      // ignore: avoid_print
      print('Group $dirName not found in groups.yaml');
      continue;
    }

    final groupDir = dir.path;
    final charts = scanCharts(groupDir);

    result[dirName] = ParsedChartGroup(
      key: dirName,
      label: groupsParsed[dirName]!,
      charts: charts,
    );
  }

  // Using keys from groupsParsed to keep the order
  return groupsParsed.keys.map((key) => result[key]!).toList();
}

List<ChartData> scanCharts(String groupDir) {
  final files = Directory(groupDir).listSync();

  final result = <ChartData>[];
  for (final file in files) {
    if (!file.path.endsWith('.yaml')) {
      continue;
    }

    final raw = (file as File).readAsStringSync();
    final parsed = loadYaml(raw);

    final name = parsed['name'];
    final description = parsed['description'];
    final sources = parsed['sources'].cast<String>();
    final yLabel = parsed['yLabel'];
    final bars = parsed['bars']
        .entries
        .map((entry) {
          return ChartBar(x: entry.key, y: entry.value.toDouble());
        })
        .cast<ChartBar>()
        .toList();

    result.add(ChartData(
      key: file.path.replaceAll('\\', '/').split('/').last.replaceAll('.yaml', ''),
      name: name,
      description: description,
      sources: sources,
      yLabel: yLabel,
      bars: bars,
    ));
  }

  result.sort((a, b) => a.key.compareTo(b.key));

  return result;
}

String generateMainChart(List<ParsedChartGroup> groups) {
  final buffer = StringBuffer();

  buffer.writeln('// ignore_for_file: always_use_package_imports, directives_ordering');
  buffer.writeln("import 'package:politikchart/model/chart.dart';");
  for (final group in groups) {
    buffer.writeln("import '${group.key}/_charts.dart' deferred as ${group.key.replaceAll('-', '_')};");
  }

  buffer.writeln();
  buffer.writeln('final chartGroups = [');
  for (final group in groups) {
    buffer.writeln('  LazyChartGroup(');
    buffer.writeln("    key: '${group.key}',");
    buffer.writeln("    label: '${group.label}',");
    buffer.writeln('    chartKeys: {');
    for (final chart in group.charts) {
      buffer.writeln("      '${chart.key}': '${chart.name}',");
    }
    buffer.writeln('    },');
    buffer.writeln('    load: () async {');
    buffer.writeln('      await ${group.key.replaceAll('-', '_')}.loadLibrary();');
    buffer.writeln('      return ${group.key.replaceAll('-', '_')}.charts;');
    buffer.writeln('    },');
    buffer.writeln('  ),');
  }
  buffer.writeln('];');

  return buffer.toString();
}

String generateChartGroupFile(ParsedChartGroup group) {
  final buffer = StringBuffer();
  buffer.writeln('// ignore_for_file: always_use_package_imports');
  for (final chart in group.charts) {
    buffer.writeln("import '${chart.key.replaceAll('-', '_')}.dart' as ${chart.key.replaceAll('-', '_')};");
  }
  buffer.writeln();

  buffer.writeln('const charts = [');
  for (final chart in group.charts) {
    buffer.writeln('    ${chart.key.replaceAll('-', '_')}.chartData,');
  }
  buffer.writeln('];');

  return buffer.toString();
}

String generateChartFile(ChartData data) {
  final buffer = StringBuffer();
  buffer.writeln("import 'package:politikchart/model/chart.dart';");
  buffer.writeln();

  buffer.writeln('const chartData = ChartData(');
  buffer.writeln("  key: '${data.key}',");
  buffer.writeln("  name: '${data.name}',");
  buffer.writeln("  description: '${data.description}',");
  buffer.writeln('  sources: [');
  for (final source in data.sources) {
    buffer.writeln("    '$source',");
  }
  buffer.writeln('  ],');
  buffer.writeln("  yLabel: '${data.yLabel}',");
  buffer.writeln('  bars: [');
  for (final bar in data.bars) {
    buffer.writeln('    ChartBar(x: ${bar.x}, y: ${bar.y}),');
  }
  buffer.writeln('  ],');
  buffer.writeln(');');

  return buffer.toString();
}

class ParsedChartGroup {
  final String key;
  final String label;
  final List<ChartData> charts;

  const ParsedChartGroup({
    required this.key,
    required this.label,
    required this.charts,
  });
}
