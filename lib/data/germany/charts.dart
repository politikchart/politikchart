// ignore_for_file: always_use_package_imports
import 'package:politikchart/model/chart.dart';
import 'crime/_charts.dart' deferred as crime;
import 'economy/_charts.dart' deferred as economy;
import 'energy/_charts.dart' deferred as energy;

final chartGroups = [
  LazyChartGroup(
    key: 'crime',
    chartKeys: {
      'toetung': 'Tötung',
    },
    load: () async {
      await crime.loadLibrary();
      return crime.charts;
    },
  ),
  LazyChartGroup(
    key: 'economy',
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
    key: 'energy',
    chartKeys: {
      'batterie-kapazitaet-zubau': 'Batterie-Kapazität Zubau',
      'benzin-preis': 'Benzin Preis (E5)',
      'solar-leistung-zubau': 'Solarleistung Zubau',
      'strom-preis': 'Strompreis',
      'waermepumpe_absatz': 'Wärmepumpe Absatz',
      'windkraft-leistung-genehmigung': 'Windkraft-Leistung Genehmigung',
    },
    load: () async {
      await energy.loadLibrary();
      return energy.charts;
    },
  ),
];
