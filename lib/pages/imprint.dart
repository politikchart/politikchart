import 'package:flutter/material.dart';
import 'package:politikchart/utils/link.dart';

class ImprintPage extends StatelessWidget {
  const ImprintPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SelectionArea(
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Text(
              'Impressum',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('Zuletzt aktualisiert: 18. Januar 2025'),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Angaben gemäß § 5 TMG',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Text('''Tien Do Nam
${const String.fromEnvironment('IMPRINT_STREET')}
${const String.fromEnvironment('IMPRINT_CITY')}
Deutschland'''),
                      const SizedBox(height: 20),
                      Text('Vetreten durch:'),
                      Text('Tien Do Nam'),
                      const SizedBox(height: 20),
                      Text('Kontakt:'),
                      Text('E-Mail: dev.tien.donam@gmail.com'),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => openLink('https://tienisto.com/contact'),
                          child: Text(
                            'oder zum Kontaktformular',
                            style: TextStyle(fontSize: 16, decoration: TextDecoration.underline),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Zurück'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
