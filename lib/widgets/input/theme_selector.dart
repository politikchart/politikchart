import 'package:flutter/material.dart';
import 'package:refena_flutter/refena_flutter.dart';

final themeProvider = StateProvider((ref) => ThemeMode.system);

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch(themeProvider);
    return SegmentedButton<ThemeMode>(
      multiSelectionEnabled: false,
      emptySelectionAllowed: false,
      showSelectedIcon: false,
      selected: {themeMode},
      onSelectionChanged: (Set<ThemeMode> newSelection) {
        if (newSelection.isNotEmpty) {
          context.notifier(themeProvider).setState((old) => newSelection.first);
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
  }
}
