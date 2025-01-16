import 'package:politikchart/model/chart.dart';

const chartData = ChartData(
  key: 'solar-leistung-zubau',
  name: 'Solarleistung Zubau',
  sources: [
    'https://strom-report.com/photovoltaik/',
  ],
  yLabel: 'GW',
  bars: [
    ChartBar(x: 2006, y: 0.8),
    ChartBar(x: 2007, y: 1.3),
    ChartBar(x: 2008, y: 2.0),
    ChartBar(x: 2009, y: 4.4),
    ChartBar(x: 2010, y: 7.4),
    ChartBar(x: 2011, y: 7.9),
    ChartBar(x: 2012, y: 7.6),
    ChartBar(x: 2013, y: 3.7),
    ChartBar(x: 2014, y: 1.2),
    ChartBar(x: 2015, y: 1.3),
    ChartBar(x: 2016, y: 1.5),
    ChartBar(x: 2017, y: 1.6),
    ChartBar(x: 2018, y: 2.9),
    ChartBar(x: 2019, y: 3.7),
    ChartBar(x: 2020, y: 5.5),
    ChartBar(x: 2021, y: 5.7),
    ChartBar(x: 2022, y: 7.3),
    ChartBar(x: 2023, y: 14.8),
    ChartBar(x: 2024, y: 15.9),
  ],
);
