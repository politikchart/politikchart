import 'dart:ui';

import 'package:politikchart/data/party.dart';

const cdu = Party(
  name: 'CDU',
  color: Color(0xFF000000),
);

const fdp = Party(
  name: 'FDP',
  color: Color(0xFFFFD500),
);

const greens = Party(
  name: 'Grüne',
  color: Color(0xFF64A844),
);

const spd = Party(
  name: 'SPD',
  color: Color(0xFFEB001F),
);

const governments = [
  Government(
    alias: 'Schwarz-Gelb',
    parties: [cdu, fdp],
    start: Date(1994, 11, 10),
    end: Date(1998, 10, 26),
  ),
  Government(
    alias: 'Rot-Grün',
    parties: [spd, greens],
    start: Date(1998, 10, 26),
    end: Date(2002, 10, 17),
  ),
  Government(
    alias: 'Rot-Grün',
    parties: [spd, greens],
    start: Date(2002, 10, 17),
    end: Date(2005, 10, 18),
  ),
  Government(
    alias: 'GroKo',
    parties: [cdu, spd],
    start: Date(2005, 10, 18),
    end: Date(2009, 10, 27),
  ),
  Government(
    alias: 'Schwarz-Gelb',
    parties: [cdu, fdp],
    start: Date(2009, 10, 27),
    end: Date(2013, 10, 22),
  ),
  Government(
    alias: 'GroKo',
    parties: [cdu, spd],
    start: Date(2013, 10, 22),
    end: Date(2017, 10, 24),
  ),
  Government(
    alias: 'GroKo',
    parties: [cdu, spd],
    start: Date(2017, 10, 24),
    end: Date(2021, 10, 26),
  ),
  Government(
    alias: 'Ampel',
    parties: [spd, greens, fdp],
    start: Date(2021, 10, 26),
    end: null,
  ),
];
