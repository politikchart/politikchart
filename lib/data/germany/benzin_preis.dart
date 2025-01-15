import 'package:politikchart/data/germany/_parties.dart';
import 'package:politikchart/data/party.dart';
import 'package:politikchart/widgets/chart/chart.dart';

const benzinPreis = ChartData(
  sources: [
    'https://de.statista.com/statistik/daten/studie/776/umfrage/durchschnittspreis-fuer-superbenzin-seit-dem-jahr-1972/',
  ],
  yLabel: '€/L',
  bars: [
    ChartBar(x: 1999, y: 0.87),
    ChartBar(x: 2000, y: 1.018),
    ChartBar(x: 2001, y: 1.024),
    ChartBar(x: 2002, y: 1.048),
    ChartBar(x: 2003, y: 1.095),
    ChartBar(x: 2004, y: 1.14),
    ChartBar(x: 2005, y: 1.223),
    ChartBar(x: 2006, y: 1.289),
    ChartBar(x: 2007, y: 1.344),
    ChartBar(x: 2008, y: 1.399),
    ChartBar(x: 2009, y: 1.278),
    ChartBar(x: 2010, y: 1.415),
    ChartBar(x: 2011, y: 1.554),
    ChartBar(x: 2012, y: 1.646),
    ChartBar(x: 2013, y: 1.592),
    ChartBar(x: 2014, y: 1.528),
    ChartBar(x: 2015, y: 1.394),
    ChartBar(x: 2016, y: 1.296),
    ChartBar(x: 2017, y: 1.366),
    ChartBar(x: 2018, y: 1.456),
    ChartBar(x: 2019, y: 1.432),
    ChartBar(x: 2020, y: 1.293),
    ChartBar(x: 2021, y: 1.579),
    ChartBar(x: 2022, y: 1.926),
    ChartBar(x: 2023, y: 1.849),
    ChartBar(x: 2024, y: 1.807),
  ],
  governmentProvider: GovernmentProvider(governments),
);
