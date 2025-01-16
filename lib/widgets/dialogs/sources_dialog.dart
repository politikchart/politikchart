import 'package:flutter/material.dart';
import 'package:politikchart/i18n/gen/strings.g.dart';
import 'package:politikchart/utils/link.dart';

class SourcesDialog extends StatelessWidget {
  final List<String> sources;

  const SourcesDialog(this.sources);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(t.sources),
      content: SelectionArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: sources.map((source) => ListTile(
            title: Text(source),
            onTap: () => openLink(source),
          )).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(MaterialLocalizations.of(context).closeButtonLabel),
        ),
      ],
    );
  }
}
