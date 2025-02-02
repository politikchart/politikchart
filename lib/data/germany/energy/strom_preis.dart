import 'package:politikchart/model/chart.dart';

const chartData = ChartData(
  key: 'strom-preis',
  name: 'Strompreis',
  description: 'Durchschnittlicher Strompreis',
  sources: [
    'https://de.wikipedia.org/wiki/Strompreis',
    'https://www.bdew.de/service/daten-und-grafiken/bdew-strompreisanalyse/',
  ],
  yLabel: 'ct/kWh',
  bars: [
    ChartBar(x: 1999, y: 16.53),
    ChartBar(x: 2000, y: 13.94),
    ChartBar(x: 2001, y: 14.32),
    ChartBar(x: 2002, y: 16.11),
    ChartBar(x: 2003, y: 17.19),
    ChartBar(x: 2004, y: 17.96),
    ChartBar(x: 2005, y: 18.66),
    ChartBar(x: 2006, y: 19.46),
    ChartBar(x: 2007, y: 20.64),
    ChartBar(x: 2008, y: 21.65),
    ChartBar(x: 2009, y: 23.21),
    ChartBar(x: 2010, y: 23.69),
    ChartBar(x: 2011, y: 25.23),
    ChartBar(x: 2012, y: 25.89),
    ChartBar(x: 2013, y: 28.84),
    ChartBar(x: 2014, y: 29.14),
    ChartBar(x: 2015, y: 28.7),
    ChartBar(x: 2016, y: 28.8),
    ChartBar(x: 2017, y: 29.28),
    ChartBar(x: 2018, y: 29.47),
    ChartBar(x: 2019, y: 30.46),
    ChartBar(x: 2020, y: 31.81),
    ChartBar(x: 2021, y: 32.16),
    ChartBar(x: 2022, y: 37.91),
    ChartBar(x: 2023, y: 45.73),
    ChartBar(x: 2024, y: 40.92),
  ],
);
