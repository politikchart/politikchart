class Party {
  final String key;
  final String name;
  final RgbColor color;

  const Party({
    required this.key,
    required this.name,
    required this.color,
  });
}

class RgbColor {
  final int value;

  const RgbColor(this.value);
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

  Date.fromDateTime(DateTime dateTime)
      : year = dateTime.year,
        month = dateTime.month,
        day = dateTime.day;
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
