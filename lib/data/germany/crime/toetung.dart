import 'package:politikchart/model/chart.dart';

const chartData = ChartData(
  key: 'toetung',
  name: 'Tötung',
  description: 'Mord, Totschlag und Tötung auf Verlangen',
  sources: [
    'https://www.bka.de',
    'https://www.bka.de/DE/AktuelleInformationen/StatistikenLagebilder/PolizeilicheKriminalstatistik/pks_node.html',
    'https://www.bka.de/SharedDocs/Downloads/DE/Publikationen/PolizeilicheKriminalstatistik/2023/BundesdatenDelikte/03_MordTotschlagToetungAufVerlangenBRD.pdf?__blob=publicationFile&v=3',
  ],
  yLabel: 'Tsd',
  bars: [
    ChartBar(x: 2011, y: 2.174),
    ChartBar(x: 2012, y: 2.126),
    ChartBar(x: 2013, y: 2.122),
    ChartBar(x: 2014, y: 2.179),
    ChartBar(x: 2015, y: 2.116),
    ChartBar(x: 2016, y: 2.418),
    ChartBar(x: 2017, y: 2.379),
    ChartBar(x: 2018, y: 2.471),
    ChartBar(x: 2019, y: 2.315),
    ChartBar(x: 2020, y: 2.401),
    ChartBar(x: 2021, y: 2.111),
    ChartBar(x: 2022, y: 2.236),
    ChartBar(x: 2023, y: 2.282),
  ],
);
