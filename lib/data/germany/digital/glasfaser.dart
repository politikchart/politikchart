import 'package:politikchart/model/chart.dart';

const chartData = ChartData(
  key: 'glasfaser',
  name: 'Glasfaser',
  description: 'Aktive Glasfaseranschlüsse über FTTH/B in Millionen',
  sources: [
    'https://www.bundesnetzagentur.de',
    'https://www.bundesnetzagentur.de/DE/Fachthemen/Datenportal/1_Digitales_Telekommunikation/_svg_TK/TK_Festnetz/Aktive%20Anschluesse%20FTTH%20FTTB/Aktive%20Anschluesse%20FTTH%20FTTB.html',
  ],
  yLabel: 'Mio',
  bars: [
    ChartBar(x: 2014, y: 0.3),
    ChartBar(x: 2015, y: 0.4),
    ChartBar(x: 2016, y: 0.6),
    ChartBar(x: 2017, y: 0.8),
    ChartBar(x: 2018, y: 1.1),
    ChartBar(x: 2019, y: 1.5),
    ChartBar(x: 2020, y: 2.0),
    ChartBar(x: 2021, y: 2.6),
    ChartBar(x: 2022, y: 3.4),
    ChartBar(x: 2023, y: 4.3),
  ],
);
