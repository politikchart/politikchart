import 'package:politikchart/model/chart.dart';

const chartData = ChartData(
  key: 'waermepumpe-absatz',
  name: 'Wärmepumpe Absatz',
  description: 'Anzahl der verkauften Wärmepumpen',
  sources: [
    'https://www.waermepumpe.de',
    'https://www.waermepumpe.de/fileadmin/user_upload/Diagramm_Absatz_WP_2004-2023.jpg',
  ],
  yLabel: 'Tsd',
  bars: [
    ChartBar(x: 2004, y: 18.5),
    ChartBar(x: 2005, y: 25.5),
    ChartBar(x: 2006, y: 57.5),
    ChartBar(x: 2007, y: 57.5),
    ChartBar(x: 2008, y: 78.0),
    ChartBar(x: 2009, y: 67.5),
    ChartBar(x: 2010, y: 60.0),
    ChartBar(x: 2011, y: 66.0),
    ChartBar(x: 2012, y: 70.0),
    ChartBar(x: 2013, y: 72.0),
    ChartBar(x: 2014, y: 71.5),
    ChartBar(x: 2015, y: 69.5),
    ChartBar(x: 2016, y: 79.0),
    ChartBar(x: 2017, y: 91.5),
    ChartBar(x: 2018, y: 99.0),
    ChartBar(x: 2019, y: 101.0),
    ChartBar(x: 2020, y: 140.5),
    ChartBar(x: 2021, y: 177.5),
    ChartBar(x: 2022, y: 281.0),
    ChartBar(x: 2023, y: 438.5),
  ],
);
