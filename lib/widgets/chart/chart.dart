import 'dart:math';
import 'dart:ui' as ui;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:politikchart/model/chart.dart';
import 'package:politikchart/model/party.dart';

class Chart extends StatefulWidget {
  final ChartData data;
  final GovernmentProvider governmentProvider;
  final bool showGovernment;
  final bool governmentDelay;
  final bool animate;

  const Chart({
    required this.data,
    required this.governmentProvider,
    required this.showGovernment,
    required this.governmentDelay,
    required this.animate,
  });

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final numberFormat = NumberFormat.decimalPattern(locale);
    final numberFormatRounded = NumberFormat('###,###', locale);
    final numberFormatOnlyDecimals = NumberFormat('0.00', locale);

    return LayoutBuilder(builder: (context, constraints) {
      final displayWidth = MediaQuery.sizeOf(context).width;

      final padLeft = 50.0;
      final padRight = 10.0;
      final padBottom = 30.0;
      final padTop = switch (displayWidth) {
        < 800 => 130.0,
        _ => 80.0,
      };
      final gap = switch (constraints.maxWidth) {
        _ when constraints.maxWidth < 800 => 5.0,
        _ when constraints.maxWidth < 1200 => 10.0,
        _ => 15.0,
      };
      final widthPerBar = (constraints.maxWidth - gap * (widget.data.bars.length - 1) - padLeft - padRight) / widget.data.bars.length;

      final maxY = widget.data.bars.map((bar) => bar.y).reduce((a, b) => a > b ? a : b).ceilToDouble();
      final minY = min(0, widget.data.bars.map((bar) => bar.y).reduce((a, b) => a < b ? a : b).floorToDouble());
      final deltaY = maxY - minY;
      final maxBarHeight = constraints.maxHeight - padBottom - padTop;

      final ySteps = switch (maxY) {
        _ when maxY < 15 => 1,
        _ when maxY < 50 => 5,
        _ when maxY < 150 => 10,
        _ when maxY < 1500 => 100,
        _ when maxY < 15000 => 1000,
        _ => 10000,
      };

      final colorScheme = Theme.of(context).colorScheme;
      const textHeight = 20.0;

      final valueWidth = getTextWidth(numberFormat.format(widget.data.bars.last.y));
      final valueFormatter = valueWidth > widthPerBar
          ? widget.data.bars.last.y < 2
              ? numberFormatOnlyDecimals
              : numberFormatRounded
          : numberFormat;

      int xLabelModulo = 1;
      const yearPadding = 2; // somehow the text needs additional padding
      while (getTextWidth(widget.data.bars.last.x.toString()) >= (widthPerBar - yearPadding) * xLabelModulo) {
        xLabelModulo += 1;
      }

      final barColor = switch (colorScheme.brightness) {
        Brightness.light => Colors.cyan.shade900,
        Brightness.dark => colorScheme.primary,
      };
      final barValueColor = switch (colorScheme.brightness) {
        Brightness.light => colorScheme.onPrimary,
        Brightness.dark => colorScheme.onPrimary,
      };

      return Stack(
        children: [
          // x-axis labels
          ...widget.data.bars.mapIndexed((index, bar) {
            if (xLabelModulo != 1 && (index % xLabelModulo != 0 || (index + (xLabelModulo - 1)) >= widget.data.bars.length)) {
              return const SizedBox();
            }

            return Positioned(
              left: padLeft + index * widthPerBar + index * gap,
              bottom: 0,
              child: SizedBox(
                width: widthPerBar * xLabelModulo + gap * (xLabelModulo - 1),
                child: Text(
                  bar.x.toString(),
                  textAlign: xLabelModulo == 1 ? TextAlign.center : TextAlign.left,
                ),
              ),
            );
          }),

          // y-axis labels
          ...List.generate(
            (deltaY / ySteps).ceil() + 1,
            (index) {
              final y = (index + minY) * ySteps;
              final yPosition = ((y - minY) / deltaY) * maxBarHeight - textHeight / 2;
              if (yPosition >= maxBarHeight - textHeight) {
                return const SizedBox();
              }

              return Positioned(
                left: 0,
                bottom: padBottom + yPosition,
                child: SizedBox(
                  width: padLeft - gap - 5,
                  child: Text(
                    y.toString(),
                    textAlign: TextAlign.right,
                  ),
                ),
              );
            },
          ),

          // y-axis label
          Positioned(
            top: padTop - textHeight - 10,
            left: 0,
            child: SizedBox(
              width: padLeft - gap - 5,
              child: Text(widget.data.yLabel, textAlign: TextAlign.right),
            ),
          ),

          // government
          if (widget.showGovernment)
            Positioned(
              top: 0,
              left: padLeft,
              right: padRight,
              bottom: padBottom + 1,
              child: _Government(
                barWidth: widthPerBar,
                barGap: gap,
                startYear: widget.data.bars.first.x,
                endYear: widget.data.bars.last.x,
                governments: widget.governmentProvider.governments,
                governmentDelay: widget.governmentDelay,
                animate: widget.animate,
              ),
            ),

          // bars
          ...widget.data.bars.mapIndexed((index, bar) {
            final barHeight = (bar.y.abs() / deltaY) * maxBarHeight;

            return Positioned(
              key: ValueKey('${widget.data.hashCode}+${bar.x}'),
              left: padLeft + index * widthPerBar + index * gap,
              bottom: padBottom +
                  switch (minY) {
                    == 0 => 1,
                    _ => switch (bar.y) {
                        >= 0 => -minY / deltaY * maxBarHeight + 1,
                        _ => -minY / deltaY * maxBarHeight - barHeight,
                      }
                  },
              width: widthPerBar,
              height: barHeight,
              child: Container(
                color: barColor,
                padding: switch (bar.y) {
                  >= 0 => EdgeInsets.only(top: 5),
                  _ => EdgeInsets.only(bottom: 5),
                },
                child: Align(
                  alignment: switch (bar.y) {
                    >= 0 => Alignment.topCenter,
                    _ => Alignment.bottomCenter,
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: displayWidth < 800 || barHeight - 5 < textHeight
                        ? null
                        : FittedBox(
                            child: Text(
                              valueFormatter.format(bar.y),
                              style: TextStyle(color: barValueColor),
                            ),
                          ),
                  ),
                ),
              ).let((w) {
                if (widget.animate) {
                  return w.animate(delay: Duration(milliseconds: index * 10)).scaleY(
                        duration: const Duration(milliseconds: 300),
                        alignment: switch (bar.y) {
                          >= 0 => Alignment.bottomCenter,
                          _ => Alignment.topCenter,
                        },
                        curve: Curves.easeOutCubic,
                      );
                } else {
                  return w;
                }
              }),
            );
          }),

          // x-axis
          Positioned(
            bottom: padBottom,
            left: padLeft - gap,
            right: 0,
            child: Container(
              height: 1,
              color: colorScheme.onSurface,
            ),
          ),

          // y-axis
          Positioned(
            top: padTop - textHeight,
            left: padLeft - gap,
            bottom: padBottom,
            child: Container(
              width: 1,
              color: colorScheme.onSurface,
            ),
          ),

          // x-axis (zero)
          if (minY < 0)
            Positioned(
              bottom: padBottom + -minY / deltaY * maxBarHeight,
              left: padLeft - gap,
              right: 0,
              child: Container(
                height: 1,
                color: colorScheme.onSurface,
              ),
            ),

          // bar tooltip
          if (selectedIndex != null)
            () {
              final y = widget.data.bars[selectedIndex!].y;
              final barHeight = (y.abs() / deltaY) * maxBarHeight;
              const additionalWidth = 20;
              const lineHeight = 10.0;

              return Positioned(
                left: padLeft + selectedIndex! * widthPerBar + selectedIndex! * gap - additionalWidth / 2,
                bottom: padBottom +
                    switch (minY) {
                      == 0 => barHeight,
                      _ => switch (y) {
                          >= 0 => barHeight + -minY / deltaY * maxBarHeight + 1,
                          _ => -minY / deltaY * maxBarHeight - barHeight - textHeight - lineHeight,
                        }
                    },
                width: widthPerBar + additionalWidth,
                height: textHeight + lineHeight,
                child: Column(
                  children: [
                    if (y < 0)
                      Container(
                        height: lineHeight,
                        width: 1,
                        color: switch (colorScheme.brightness) {
                          Brightness.light => Colors.black,
                          Brightness.dark => Colors.white,
                        },
                      ),
                    Container(
                      width: widthPerBar + additionalWidth,
                      height: textHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: switch (colorScheme.brightness) {
                          Brightness.light => Colors.black,
                          Brightness.dark => Colors.white,
                        },
                      ),
                      child: FittedBox(
                        child: Text(
                          numberFormat.format(widget.data.bars[selectedIndex!].y),
                          style: TextStyle(
                            color: switch (colorScheme.brightness) {
                              Brightness.light => Colors.white,
                              Brightness.dark => Colors.black,
                            },
                          ),
                        ),
                      ),
                    ),
                    if (y >= 0)
                      Container(
                        height: lineHeight,
                        width: 1,
                        color: switch (colorScheme.brightness) {
                          Brightness.light => Colors.black,
                          Brightness.dark => Colors.white,
                        },
                      ),
                  ],
                ),
              );
            }(),

          // bars tooltip listener
          ...widget.data.bars.mapIndexed((index, bar) {
            return Positioned(
              key: ValueKey('${widget.data.hashCode}+${bar.x}+tooltip'),
              left: padLeft + index * widthPerBar + index * gap,
              bottom: padBottom + 1,
              width: widthPerBar,
              height: maxBarHeight,
              child: InkWell(
                mouseCursor: SystemMouseCursors.basic,
                splashFactory: NoSplash.splashFactory,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    selectedIndex = selectedIndex == index ? null : index;
                  });
                },
                onHover: (hover) {
                  if (hover) {
                    setState(() {
                      selectedIndex = index;
                    });
                  } else {
                    setState(() {
                      selectedIndex = null;
                    });
                  }
                },
              ),
            );
          }),
        ],
      );
    });
  }
}

class _Government extends StatelessWidget {
  final double barWidth;
  final double barGap;
  final int startYear;
  final int endYear;
  final List<Government> governments;
  final bool governmentDelay;
  final bool animate;

  const _Government({
    required this.barWidth,
    required this.barGap,
    required this.startYear,
    required this.endYear,
    required this.governments,
    required this.governmentDelay,
    required this.animate,
  });

  @override
  Widget build(BuildContext context) {
    final displayWidth = MediaQuery.sizeOf(context).width;
    final list = <Widget>[];
    int currYear = startYear;

    for (final gov in governments) {
      if (gov.end != null && gov.end!.year < startYear) {
        // gov is before the chart
        continue;
      }

      final govEndYear = min(gov.end?.year ?? endYear, endYear);
      final width = (govEndYear - currYear + 1) * barWidth + (govEndYear - currYear) * barGap;

      list.add(Column(
        children: [
          SizedBox(
            width: width,
            height: switch (displayWidth) {
              < 800 => 100,
              _ => 50,
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (displayWidth >= 800)
                  FittedBox(
                    child: Text('„${gov.alias}“'),
                  ),
                if (displayWidth < 800)
                  for (final party in gov.parties)
                    FittedBox(
                      child: Text(party.name),
                    )
                else
                  FittedBox(
                    child: Text(gov.parties.map((p) => p.name).join(' / ')),
                  ),
                const SizedBox(height: 10),
              ],
            ).let((w) {
              if (animate) {
                return w.animate().fade(delay: governmentDelay ? const Duration(milliseconds: 1000) : const Duration(milliseconds: 500));
              } else {
                return w;
              }
            }),
          ),
          Expanded(
            child: Column(
              children: [
                ...gov.parties.map((p) => Expanded(
                        child: Container(
                      color: p.color.color.withValues(alpha: 0.4),
                      width: width,
                    ))),
              ],
            ).let((w) {
              if (animate) {
                return w.animate(delay: governmentDelay ? const Duration(milliseconds: 500) : Duration.zero).fade().scaleY(
                      duration: const Duration(milliseconds: 500),
                      alignment: Alignment.bottomCenter,
                      curve: Curves.easeOutCubic,
                    );
              } else {
                return w;
              }
            }),
          ),
        ],
      ));

      currYear = govEndYear + 1;

      if (currYear > endYear) {
        break;
      }

      list.add(SizedBox(width: barGap));
    }

    return Row(
      children: list,
    );
  }
}

double getTextWidth(String text, {TextStyle? style}) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: ui.TextDirection.ltr,
  )..layout(); // Layout the text to calculate dimensions

  return textPainter.size.width; // Get the width of the rendered text
}

extension ObjectExt<T> on T {
  R let<R>(R Function(T that) op) => op(this);
}

extension on RgbColor {
  Color get color => Color(0xFF000000 | value);
}
