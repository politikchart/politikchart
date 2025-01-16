import 'package:politikchart/data/germany/_parties.dart';
import 'package:politikchart/data/party.dart';
import 'package:politikchart/widgets/chart/chart.dart';

const arbeitslosenQuote = ChartData(
  sources: [
    'https://www.destatis.de/DE/Themen/Wirtschaft/Konjunkturindikatoren/Lange-Reihen/Arbeitsmarkt/lrarb003ga.html',
  ],
  yLabel: '%',
  bars: [
    ChartBar(x: 1999, y: 11.7),
    ChartBar(x: 2000, y: 10.7),
    ChartBar(x: 2001, y: 10.3),
    ChartBar(x: 2002, y: 10.8),
    ChartBar(x: 2003, y: 11.6),
    ChartBar(x: 2004, y: 11.7),
    ChartBar(x: 2005, y: 13.0),
    ChartBar(x: 2006, y: 12.0),
    ChartBar(x: 2007, y: 10.1),
    ChartBar(x: 2008, y: 8.7),
    ChartBar(x: 2009, y: 9.1),
    ChartBar(x: 2010, y: 8.6),
    ChartBar(x: 2011, y: 7.9),
    ChartBar(x: 2012, y: 7.6),
    ChartBar(x: 2013, y: 7.7),
    ChartBar(x: 2014, y: 7.5),
    ChartBar(x: 2015, y: 7.1),
    ChartBar(x: 2016, y: 6.8),
    ChartBar(x: 2017, y: 6.3),
    ChartBar(x: 2018, y: 5.8),
    ChartBar(x: 2019, y: 5.5),
    ChartBar(x: 2020, y: 6.5),
    ChartBar(x: 2021, y: 6.3),
    ChartBar(x: 2022, y: 5.8),
    ChartBar(x: 2023, y: 6.2),
    ChartBar(x: 2024, y: 6.5),
  ],
  governmentProvider: GovernmentProvider(governments),
);
