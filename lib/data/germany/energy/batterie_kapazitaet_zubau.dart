import 'package:politikchart/model/chart.dart';

const chartData = ChartData(
  key: 'batterie-kapazitaet-zubau',
  name: 'Batterie-Kapazität Zubau',
  sources: [
    'https://scarica.isea.rwth-aachen.de/mastr/d/lA4kI2GVz/battery-status?orgId=1&from=now-20y&to=now%2B1M&viewPanel=39&inspect=39&inspectTab=data',
  ],
  yLabel: 'GWh',
  bars: [
    ChartBar(x: 2006, y: 0.0002),
    ChartBar(x: 2007, y: 0.0003),
    ChartBar(x: 2008, y: 0.001),
    ChartBar(x: 2009, y: 0.0006),
    ChartBar(x: 2010, y: 0.0016),
    ChartBar(x: 2011, y: 0.0021),
    ChartBar(x: 2012, y: 0.0058),
    ChartBar(x: 2013, y: 0.0184),
    ChartBar(x: 2014, y: 0.0451),
    ChartBar(x: 2015, y: 0.0578),
    ChartBar(x: 2016, y: 0.1898),
    ChartBar(x: 2017, y: 0.2494),
    ChartBar(x: 2018, y: 0.3922),
    ChartBar(x: 2019, y: 0.4311),
    ChartBar(x: 2020, y: 0.8),
    ChartBar(x: 2021, y: 1.4),
    ChartBar(x: 2022, y: 2.2),
    ChartBar(x: 2023, y: 6.0),
    ChartBar(x: 2024, y: 5.5),
  ],
);
