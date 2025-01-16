import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:politikchart/data/germany/benzin_preis.dart'
deferred as benzin_preis;
import 'package:politikchart/data/germany/solar_leistung_zubau.dart'
    deferred as solar_leistung_zubau;
import 'package:politikchart/data/germany/strom_preis.dart'
    deferred as strom_preis;
import 'package:politikchart/data/germany/windkraft_leistung_genehmigung.dart'
    deferred as windkraft_leistung_genehmigung;
import 'package:politikchart/i18n/gen/strings.g.dart';
import 'package:politikchart/widgets/chart/chart.dart';
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
    );
  }
}

enum ChartType {
  benzinPreis('Benzinpreis (E5)'),
  stromPreis('Strompreis'),
  solarLeistungZubau('Solar Leistung Zubau'),
  windkraftLeistungGenehmigung('Windkraft Leistung Genehmigung'),
  ;

  const ChartType(this.label);

  final String label;

  Future<ChartData> loadChartData() async {
    switch (this) {
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

  @override
  void initState() {
    super.initState();

    _loadChart(chartType);
  }

  void _loadChart(ChartType chart) async {
    setState(() {
      chartType = chart;
      governmentDelay = true;
    });

    final data = await chart.loadChartData();

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
                child: Text('Politik Chart',
                    style: Theme.of(context).textTheme.headlineMedium),
              ),
              const SizedBox(height: 50),
              const SizedBox(height: 50),
              Center(
                child: Text(chartType.label,
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
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
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Center(
                child: SizedBox(
                  width: 300,
                  child: SwitchListTile(
                    title: Text(t.showGovernment),
                    value: showGovernment,
                    onChanged: (value) {
                      setState(() {
                        showGovernment = value;
                        governmentDelay = false;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Wrap(
                    children: [
                      for (final type in ChartType.values)
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: chartType == type
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                              foregroundColor: chartType == type
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : null,
                            ),
                            onPressed: () => _loadChart(type),
                            child: Text(type.label),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
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
                      ref
                          .notifier(themeProvider)
                          .setState((old) => newSelection.first);
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
