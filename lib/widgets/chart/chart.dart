import 'dart:math';
import 'dart:ui' as ui;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:politikchart/data/party.dart';

class ChartData {
  final List<String> sources;
  final String yLabel;
  final List<ChartBar> bars;
  final GovernmentProvider governmentProvider;

  const ChartData({
    required this.sources,
    required this.yLabel,
    required this.bars,
    required this.governmentProvider,
  });
}

class ChartBar {
  final int x;
  final double y;

  const ChartBar({
    required this.x,
    required this.y,
  });
}

class Chart extends StatefulWidget {
  final ChartData data;
  final bool showGovernment;
  final bool governmentDelay;
  final bool animate;

  const Chart({
    required this.data,
    required this.showGovernment,
    required this.governmentDelay,
    required this.animate,
  });

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final numberFormat = NumberFormat.decimalPattern(locale);
    final numberFormatRounded = NumberFormat('###,###', locale);
    final numberFormatOnlyDecimals = NumberFormat('0.00', locale);

    return LayoutBuilder(builder: (context, sizingInformation) {
      final padLeft = 70.0;
      final padRight = 10.0;
      final padBottom = 30.0;
      final padTop = 80.0;
      final gap = switch (sizingInformation.maxWidth) {
        _ when sizingInformation.maxWidth < 800 => 5.0,
        _ when sizingInformation.maxWidth < 1200 => 10.0,
        _ => 15.0,
      };
      final widthPerBar = (sizingInformation.maxWidth - gap * (widget.data.bars.length - 1) - padLeft - padRight) / widget.data.bars.length;

      final maxY = widget.data.bars.map((bar) => bar.y).reduce((a, b) => a > b ? a : b);
      final maxBarHeight = sizingInformation.maxHeight - padBottom - padTop;

      final ySteps = switch (maxY) {
        _ when maxY < 15 => 1,
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

      final yearWidth = getTextWidth(widget.data.bars.last.x.toString());
      const yearPadding = 2; // somehow the text needs additional padding
      final xLabelOnlyEven = yearWidth + yearPadding >= widthPerBar;

      return Stack(
        children: [
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

          // x-axis labels
          ...widget.data.bars.asMap().entries.map((entry) {
            if (xLabelOnlyEven && entry.key % 2 == 1) {
              return const SizedBox();
            }

            final index = entry.key;
            final bar = entry.value;

            return Positioned(
              left: padLeft + index * widthPerBar + index * gap - (xLabelOnlyEven ? widthPerBar / 2 : 0),
              bottom: 0,
              child: SizedBox(
                width: xLabelOnlyEven ? widthPerBar * 2 : widthPerBar,
                child: Text(
                  bar.x.toString(),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }),

          // y-axis labels
          ...List.generate(
            (maxY / ySteps).ceil(),
            (index) {
              final y = index * ySteps;
              final yPosition = (y / maxY) * maxBarHeight - textHeight / 2;

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
                governments: widget.data.governmentProvider.governments,
                governmentDelay: widget.governmentDelay,
                animate: widget.animate,
              ),
            ),

          // bars
          ...widget.data.bars.asMap().entries.mapIndexed((index, entry) {
            final index = entry.key;
            final bar = entry.value;

            return Positioned(
              key: ValueKey('${widget.data.hashCode}+${bar.x}'),
              left: padLeft + index * widthPerBar + index * gap,
              bottom: padBottom + 1,
              width: widthPerBar,
              height: (bar.y / maxY) * maxBarHeight,
              child: Container(
                color: colorScheme.primary,
                padding: const EdgeInsets.only(top: 5),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: FittedBox(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Text(
                        valueFormatter.format(bar.y),
                        style: TextStyle(color: colorScheme.onPrimary),
                      ),
                    ),
                  ),
                ),
              ).let((w) {
                if (widget.animate) {
                  return w.animate(delay: Duration(milliseconds: index * 10)).scaleY(
                        duration: const Duration(milliseconds: 300),
                        alignment: Alignment.bottomCenter,
                        curve: Curves.easeOutCubic,
                      );
                } else {
                  return w;
                }
              }),
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
            child: Column(
              children: [
                FittedBox(
                  child: Text('„${gov.alias}“'),
                ),
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
                      color: p.color.withValues(alpha: 0.5),
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
