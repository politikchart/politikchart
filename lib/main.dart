import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:politikchart/data/germany/charts.dart';
import 'package:politikchart/data/germany/government.dart';
import 'package:politikchart/i18n/gen/strings.g.dart';
import 'package:politikchart/model/chart.dart';
import 'package:politikchart/model/party.dart';
import 'package:politikchart/pages/imprint.dart';
import 'package:politikchart/utils/link.dart';
import 'package:politikchart/utils/url.dart';
import 'package:politikchart/widgets/chart/chart.dart';
import 'package:politikchart/widgets/dialogs/sources_dialog.dart';
import 'package:politikchart/widgets/input/labeled_checkbox.dart';
import 'package:politikchart/widgets/input/theme_selector.dart';
import 'package:refena_flutter/refena_flutter.dart';

const _webassembly = bool.fromEnvironment('dart.tool.dart2wasm');

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale(); // ignore: discarded_futures
  runApp(RefenaScope(
    child: TranslationProvider(child: const MyApp()),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PolitikChart',
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
        for (final group in chartGroups)
          for (final chart in group.chartKeys.keys) '/de/${group.key}/$chart': (context) => HomePage(),
        '/imprint': (context) => const ImprintPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LazyChartGroup? selectedGroup;
  ChartData? chartData;
  bool showGovernment = true;
  bool governmentDelay = true;
  bool animate = true;

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    // e.g. /de/arbeitslosen-quote
    final url = getBrowserUrl();
    if (url != null) {
      final urlComponents = url.replaceAll('/de/', '').split('/');
      if (urlComponents.length == 2) {
        final groupKey = urlComponents[0];
        final chartKey = urlComponents[1];
        final group = chartGroups.firstWhereOrNull((e) => e.key == groupKey);
        if (group != null) {
          _loadChart(group, chartKey);
          return;
        }
      }
    }

    _loadChart(chartGroups.first, chartGroups.first.chartKeys.keys.first);
  }

  void _selectGroup(LazyChartGroup group) {
    setState(() {
      selectedGroup = group;
    });
  }

  void _loadChart(LazyChartGroup group, String chartKey) async {
    setState(() {
      chartData = null;
      selectedGroup = group;
      governmentDelay = true;
    });

    final charts = await group.load();

    setBrowserUrl(url: '/de/${group.key}/$chartKey');

    setState(() {
      chartData = charts.firstWhere((e) => e.key == chartKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    final displaySize = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              const SizedBox(height: 50),
              Center(
                child: Text(
                  'PolitikChart',
                  style: Theme.of(context).textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: switch (displaySize.height) {
                  < 1000 => 50,
                  _ => 100,
                },
              ),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, right: 20, bottom: 20),
                      child: Column(
                        children: [
                          Text(
                            '${selectedGroup?.label ?? ''}: ${chartData?.name ?? ''}',
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            chartData?.description ?? '...',
                            style: Theme.of(context).textTheme.titleSmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 1200,
                            height: 0.5 * displaySize.height,
                            child: chartData == null
                                ? Center(
                                    child: const CircularProgressIndicator(),
                                  )
                                : Chart(
                                    data: chartData!,
                                    governmentProvider: GovernmentProvider(governments),
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
              const SizedBox(height: 20),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Card(
                    elevation: 5,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Text(t.category, style: Theme.of(context).textTheme.titleSmall),
                        Wrap(
                          children: [
                            for (final group in chartGroups)
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: TextButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: group == selectedGroup ? Theme.of(context).colorScheme.primary : null,
                                    foregroundColor: group == selectedGroup ? Theme.of(context).colorScheme.onPrimary : null,
                                  ),
                                  onPressed: () => _selectGroup(group),
                                  child: Text(group.label),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(t.statistics(category: selectedGroup?.label ?? ''), style: Theme.of(context).textTheme.titleSmall),
                        if (selectedGroup != null)
                          Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 1100),
                              child: Wrap(
                                children: [
                                  for (final chart in selectedGroup!.chartKeys.entries)
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: TextButton(
                                        style: FilledButton.styleFrom(
                                          backgroundColor: chart.key == chartData?.key ? Theme.of(context).colorScheme.primary : null,
                                          foregroundColor: chart.key == chartData?.key ? Theme.of(context).colorScheme.onPrimary : null,
                                        ),
                                        onPressed: () => _loadChart(selectedGroup!, chart.key),
                                        child: Text(chart.value),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () => openLink('https://github.com/politikchart/politikchart'),
                    icon: const Icon(Icons.open_in_new),
                    label: Text('Github'),
                  ),
                  const SizedBox(width: 20),
                  TextButton.icon(
                    onPressed: () async {
                      Navigator.of(context).pushNamed('/imprint'); // ignore: unawaited_futures

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        // remove base url modification
                        setBrowserUrl(url: '/imprint');
                      });
                    },
                    icon: const Icon(Icons.info),
                    label: Text('Impressum'),
                  ),
                ],
              ),
              if (displaySize.width <= 800)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Center(
                    child: const ThemeSelector(),
                  ),
                ),
              if (_webassembly)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      'Running on WebAssembly',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ),
              const SizedBox(height: 50),
            ],
          ),
          if (displaySize.width > 800)
            Positioned(
              top: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: const ThemeSelector(),
              ),
            ),
        ],
      ),
    );
  }
}
