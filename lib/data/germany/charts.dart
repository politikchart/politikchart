// ignore_for_file: always_use_package_imports, directives_ordering
import 'package:politikchart/model/chart.dart';
import 'economy/_charts.dart' deferred as economy;
import 'crime/_charts.dart' deferred as crime;
import 'energy/_charts.dart' deferred as energy;
import 'digital/_charts.dart' deferred as digital;

final chartGroups = [
  LazyChartGroup(
    key: 'economy',
    label: 'Wirtschaft',
    chartKeys: {
      'arbeitslosen-quote': 'Arbeitslosenquote',
      'bip-wachstum': 'BIP Wachstum',
    },
    load: () async {
      await economy.loadLibrary();
      return economy.charts;
    },
  ),
  LazyChartGroup(
    key: 'crime',
    label: 'Kriminalität',
    chartKeys: {
      'toetung': 'Tötung',
    },
    load: () async {
      await crime.loadLibrary();
      return crime.charts;
    },
  ),
  LazyChartGroup(
    key: 'energy',
    label: 'Energie',
    chartKeys: {
      'batterie-kapazitaet-zubau': 'Batterie-Kapazität Zubau',
      'benzin-preis': 'Benzin Preis (E5)',
      'solar-leistung-zubau': 'Solarleistung Zubau',
      'strom-preis': 'Strompreis',
      'waermepumpe-absatz': 'Wärmepumpe Absatz',
      'windkraft-leistung-genehmigung': 'Windkraft-Leistung Genehmigung',
    },
    load: () async {
      await energy.loadLibrary();
      return energy.charts;
    },
  ),
  LazyChartGroup(
    key: 'digital',
    label: 'Digitalisierung',
    chartKeys: {
      'glasfaser': 'Glasfaser',
    },
    load: () async {
      await digital.loadLibrary();
      return digital.charts;
    },
  ),
];
