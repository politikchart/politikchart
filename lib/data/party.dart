import 'dart:ui';

class Party {
  final String name;
  final Color color;

  const Party({
    required this.name,
    required this.color,
  });
}

class Government {
  final String alias;
  final List<Party> parties;
  final Date start;
  final Date? end;

  const Government({
    required this.alias,
    required this.parties,
    required this.start,
    required this.end,
  });
}

class Date {
  final int year;
  final int month;
  final int day;

  const Date(this.year, this.month, this.day);
}

class GovernmentProvider {
  final List<Government> governments;

  const GovernmentProvider(this.governments);

  List<Government> getGovernments(int year) {
    return governments.where((government) {
      if (government.end == null) {
        return government.start.year <= year;
      }
      return government.start.year <= year && government.end!.year >= year;
    }).toList();
  }
}
