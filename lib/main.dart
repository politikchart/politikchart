import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:politikchart/data/germany/arbeitslosen_quote.dart' deferred as arbeitslosen_quote;
import 'package:politikchart/data/germany/benzin_preis.dart' deferred as benzin_preis;
import 'package:politikchart/data/germany/solar_leistung_zubau.dart' deferred as solar_leistung_zubau;
import 'package:politikchart/data/germany/strom_preis.dart' deferred as strom_preis;
import 'package:politikchart/data/germany/windkraft_leistung_genehmigung.dart' deferred as windkraft_leistung_genehmigung;
import 'package:politikchart/i18n/gen/strings.g.dart';
import 'package:politikchart/utils/link.dart';
import 'package:politikchart/utils/url.dart';
import 'package:politikchart/widgets/chart/chart.dart';
import 'package:politikchart/widgets/dialogs/sources_dialog.dart';
import 'package:politikchart/widgets/input/labeled_checkbox.dart';
import 'package:recase/recase.dart';
import 'package:refena_flutter/refena_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale(); // ignore: discarded_futures
  runApp(RefenaScope(
    child: TranslationProvider(child: const MyApp()),
  ));
}

final themeProvider = StateProvider((ref) => ThemeMode.system);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Politik Chart',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: context.watch(themeProvider),
      debugShowCheckedModeBanner: false,
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: const HomePage(),
      routes: {
        for (final chart in ChartType.values)
          '/de/${ReCase(chart.name).paramCase}': (context) => HomePage(),
      },
    );
  }
}

enum ChartType {
  arbeitslosenQuote('Arbeitslosenquote'),
  benzinPreis('Benzinpreis (E5)'),
  stromPreis('Strompreis'),
  solarLeistungZubau('Solar Leistung Zubau'),
  windkraftLeistungGenehmigung('Windkraft Leistung Genehmigung'),
  ;

  const ChartType(this.label);

  final String label;

  Future<ChartData> loadChartData() async {
    switch (this) {
      case ChartType.arbeitslosenQuote:
        await arbeitslosen_quote.loadLibrary();
        return arbeitslosen_quote.arbeitslosenQuote;
      case ChartType.benzinPreis:
        await benzin_preis.loadLibrary();
        return benzin_preis.benzinPreis;
      case ChartType.solarLeistungZubau:
        await solar_leistung_zubau.loadLibrary();
        return solar_leistung_zubau.solarLeistungZubau;
      case ChartType.stromPreis:
        await strom_preis.loadLibrary();
        return strom_preis.stromPreis;
      case ChartType.windkraftLeistungGenehmigung:
        await windkraft_leistung_genehmigung.loadLibrary();
        return windkraft_leistung_genehmigung.windkraftLeistungGenehmigung;
    }
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ChartType chartType = ChartType.values.first;
  ChartData? chartData;
  bool showGovernment = true;
  bool governmentDelay = true;
  bool animate = true;

  @override
  void initState() {
    super.initState();

    // e.g. /de/arbeitslosen-quote
    final url = getBrowserUrl();
    if (url != null) {
      final chart = ChartType.values.firstWhereOrNull((e) => '/de/${ReCase(e.name).paramCase}' == url);
      if (chart != null) {
        _loadChart(chart);
      }
    } else {
      _loadChart(chartType);
    }
  }

  void _loadChart(ChartType chart) async {
    setState(() {
      chartType = chart;
      governmentDelay = true;
    });

    final data = await chart.loadChartData();

    setBrowserUrl(title: chart.label, url: '/de/${ReCase(chart.name).paramCase}');

    setState(() {
      chartData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              const SizedBox(height: 50),
              Center(
                child: Text('PolitikChart', style: Theme.of(context).textTheme.headlineLarge),
              ),
              const SizedBox(height: 100),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, right: 20, bottom: 20),
                      child: Column(
                        children: [
                          Text(chartType.label, style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 1200,
                            height: 600,
                            child: chartData == null
                                ? Center(
                                    child: const CircularProgressIndicator(),
                                  )
                                : Chart(
                                    data: chartData!,
                                    showGovernment: showGovernment,
                                    governmentDelay: governmentDelay,
                                    animate: animate,
                                  ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const SizedBox(width: 30),
                              Expanded(
                                child: Wrap(
                                  alignment: WrapAlignment.start,
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: [
                                    LabeledCheckbox(
                                      label: t.showGovernment,
                                      value: showGovernment,
                                      onChanged: (value) {
                                        setState(() {
                                          showGovernment = value;
                                          governmentDelay = false;
                                        });
                                      },
                                    ),
                                    LabeledCheckbox(
                                      label: t.animations,
                                      value: animate,
                                      onChanged: (value) {
                                        setState(() {
                                          animate = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (context) => SourcesDialog(chartData!.sources),
                                  );
                                },
                                icon: const Icon(Icons.info),
                                label: Text(t.sources),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Wrap(
                    children: [
                      for (final type in ChartType.values)
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: chartType == type ? Theme.of(context).colorScheme.primary : null,
                              foregroundColor: chartType == type ? Theme.of(context).colorScheme.onPrimary : null,
                            ),
                            onPressed: () => _loadChart(type),
                            child: Text(type.label),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Center(
                child: TextButton.icon(
                  onPressed: () => openLink('https://github.com/politikchart/politikchart'),
                  icon: const Icon(Icons.open_in_new),
                  label: Text('Github'),
                ),
              )
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Consumer(builder: (context, ref) {
                final themeMode = ref.watch(themeProvider);
                return SegmentedButton<ThemeMode>(
                  multiSelectionEnabled: false,
                  emptySelectionAllowed: false,
                  showSelectedIcon: false,
                  selected: {themeMode},
                  onSelectionChanged: (Set<ThemeMode> newSelection) {
                    if (newSelection.isNotEmpty) {
                      ref.notifier(themeProvider).setState((old) => newSelection.first);
                    }
                  },
                  segments: [
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.system,
                      label: Icon(Icons.brightness_auto),
                    ),
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.light,
                      label: Icon(Icons.light_mode),
                    ),
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.dark,
                      label: Icon(Icons.dark_mode),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
