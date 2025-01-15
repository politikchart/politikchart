import 'package:politikchart/data/germany/_parties.dart';
import 'package:politikchart/data/party.dart';
import 'package:politikchart/widgets/chart/chart.dart';

const windkraftLeistungGenehmigung = ChartData(
  sources: [
    'https://www.fachagentur-windenergie.de/veroeffentlichungen/publikationen/',
    'https://www.fachagentur-windenergie.de/aktuelles/detail/rekord-jahr-bei-den-windenergie-genehmigungen/',
    'https://www.fachagentur-windenergie.de/fileadmin/files/Veroeffentlichungen/Ausbau/Windenergie-Situation_Herbst_2024_Foliensatz.pdf',
  ],
  yLabel: 'GW',
  bars: [
    ChartBar(x: 2014, y: 4.94),
    ChartBar(x: 2015, y: 3.77),
    ChartBar(x: 2016, y: 9.41),
    ChartBar(x: 2017, y: 1.39),
    ChartBar(x: 2018, y: 1.58),
    ChartBar(x: 2019, y: 1.96),
    ChartBar(x: 2020, y: 2.96),
    ChartBar(x: 2021, y: 4.14),
    ChartBar(x: 2022, y: 4.25),
    ChartBar(x: 2023, y: 7.55),
    ChartBar(x: 2024, y: 14.06),
  ],
  governmentProvider: GovernmentProvider(governments),
);
