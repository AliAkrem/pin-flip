import 'package:flutter/material.dart';
import 'package:pin_flip/utils/colors.dart';
import 'package:pin_flip/utils/data.dart';
import 'package:pin_flip/data/pin_flip_options.dart';
import 'package:pin_flip/formatters.dart';
import 'dart:math' as math;

import 'package:pin_flip/layout/letter_spacing.dart';
import 'package:pin_flip/layout/text_scale.dart';

/// A colored piece of the [PinFlipPieChart].
class PinFlipPieChartSegment {
  const PinFlipPieChartSegment({required this.color, required this.value});

  final Color color;
  final double value;
}

/// The max height and width of the [PinFlipPieChart].
const pieChartMaxSize = 500.0;

List<PinFlipPieChartSegment> buildSegmentsFromAccountItems(
    List<AccountData> items) {
  return List<PinFlipPieChartSegment>.generate(
    items.length,
    (i) {
      return PinFlipPieChartSegment(
        color: PinFlipColors.accountColor(i),
        value: items[i].primaryAmount,
      );
    },
  );
}

List<PinFlipPieChartSegment> buildSegmentsFromBillItems(List<BillData> items) {
  return List<PinFlipPieChartSegment>.generate(
    items.length,
    (i) {
      return PinFlipPieChartSegment(
        color: PinFlipColors.billColor(i),
        value: items[i].primaryAmount,
      );
    },
  );
}

List<PinFlipPieChartSegment> buildSegmentsFromBudgetItems(
    List<BudgetData> items) {
  return List<PinFlipPieChartSegment>.generate(
    items.length,
    (i) {
      return PinFlipPieChartSegment(
        color: PinFlipColors.budgetColor(i),
        value: items[i].primaryAmount - items[i].amountUsed,
      );
    },
  );
}

/// An animated circular pie chart to represent pieces of a whole, which can
/// have empty space.
class PinFlipPieChart extends StatefulWidget {
  const PinFlipPieChart({
    super.key,
    required this.heroLabel,
    required this.heroAmount,
    required this.wholeAmount,
    required this.segments,
  });

  final String heroLabel;
  final double heroAmount;
  final double wholeAmount;
  final List<PinFlipPieChartSegment> segments;

  @override
  _PinFlipPieChartState createState() => _PinFlipPieChartState();
}

class _PinFlipPieChartState extends State<PinFlipPieChart>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    animation = CurvedAnimation(
        parent: TweenSequence<double>(<TweenSequenceItem<double>>[
          TweenSequenceItem<double>(
            tween: Tween<double>(begin: 0, end: 0),
            weight: 1,
          ),
          TweenSequenceItem<double>(
            tween: Tween<double>(begin: 0, end: 1),
            weight: 1.5,
          ),
        ]).animate(controller),
        curve: Curves.decelerate);
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: _AnimatedPinFlipPieChart(
        animation: animation,
        centerLabel: widget.heroLabel,
        centerAmount: widget.heroAmount,
        total: widget.wholeAmount,
        segments: widget.segments,
      ),
    );
  }
}

class _AnimatedPinFlipPieChart extends AnimatedWidget {
  const _AnimatedPinFlipPieChart({
    required this.animation,
    required this.centerLabel,
    required this.centerAmount,
    required this.total,
    required this.segments,
  }) : super(listenable: animation);

  final Animation<double> animation;
  final String centerLabel;
  final double centerAmount;
  final double total;
  final List<PinFlipPieChartSegment> segments;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final labelTextStyle = textTheme.bodyMedium!.copyWith(
      fontSize: 14,
      letterSpacing: letterSpacingOrNone(0.5),
    );

    return LayoutBuilder(builder: (context, constraints) {
      // When the widget is larger, we increase the font size.
      var headlineStyle = constraints.maxHeight >= pieChartMaxSize
          ? textTheme.headlineSmall!.copyWith(fontSize: 70)
          : textTheme.headlineSmall!;

      // With a large text scale factor, we set a max font size.
      if (PinFlipOptions.of(context).textScaleFactor(context) > 1.0) {
        headlineStyle = headlineStyle.copyWith(
          fontSize: (headlineStyle.fontSize! / reducedTextScale(context)),
        );
      }

      return DecoratedBox(
        decoration: _PinFlipPieChartOutlineDecoration(
          maxFraction: animation.value,
          total: total,
          segments: segments,
        ),
        child: Container(
          height: constraints.maxHeight,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                centerLabel,
                style: labelTextStyle,
              ),
              Text(
                usdWithSignFormat(context).format(centerAmount),
                style: headlineStyle,
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _PinFlipPieChartOutlineDecoration extends Decoration {
  const _PinFlipPieChartOutlineDecoration(
      {required this.maxFraction, required this.total, required this.segments});

  final double maxFraction;
  final double total;
  final List<PinFlipPieChartSegment> segments;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _PinFlipPieChartOutlineBoxPainter(
      maxFraction: maxFraction,
      wholeAmount: total,
      segments: segments,
    );
  }
}

class _PinFlipPieChartOutlineBoxPainter extends BoxPainter {
  _PinFlipPieChartOutlineBoxPainter(
      {required this.maxFraction,
      required this.wholeAmount,
      required this.segments});

  final double maxFraction;
  final double wholeAmount;
  final List<PinFlipPieChartSegment> segments;
  static const double wholeRadians = 2 * math.pi;
  static const double spaceRadians = wholeRadians / 180;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    // Create two padded reacts to draw arcs in: one for colored arcs and one for
    // inner bg arc.
    const strokeWidth = 4.0;
    final outerRadius = math.min(
          configuration.size!.width,
          configuration.size!.height,
        ) /
        2;
    final outerRect = Rect.fromCircle(
      center: configuration.size!.center(offset),
      radius: outerRadius - strokeWidth * 3,
    );
    final innerRect = Rect.fromCircle(
      center: configuration.size!.center(offset),
      radius: outerRadius - strokeWidth * 4,
    );

    // Paint each arc with spacing.
    var cumulativeSpace = 0.0;
    var cumulativeTotal = 0.0;
    for (final segment in segments) {
      final paint = Paint()..color = segment.color;
      final startAngle = _calculateStartAngle(cumulativeTotal, cumulativeSpace);
      final sweepAngle = _calculateSweepAngle(segment.value, 0);
      canvas.drawArc(outerRect, startAngle, sweepAngle, true, paint);
      cumulativeTotal += segment.value;
      cumulativeSpace += spaceRadians;
    }

    // Paint any remaining space black (e.g. budget amount remaining).
    final remaining = wholeAmount - cumulativeTotal;
    if (remaining > 0) {
      final paint = Paint()..color = Colors.black;
      final startAngle =
          _calculateStartAngle(cumulativeTotal, spaceRadians * segments.length);
      final sweepAngle = _calculateSweepAngle(remaining, -spaceRadians);
      canvas.drawArc(outerRect, startAngle, sweepAngle, true, paint);
    }

    // Paint a smaller inner circle to cover the painted arcs, so they are
    // display as segments.
    final bgPaint = Paint()..color = PinFlipColors.primaryBackground;
    canvas.drawArc(innerRect, 0, 2 * math.pi, true, bgPaint);
  }

  double _calculateAngle(double amount, double offset) {
    final wholeMinusSpacesRadians =
        wholeRadians - (segments.length * spaceRadians);
    return maxFraction *
        (amount / wholeAmount * wholeMinusSpacesRadians + offset);
  }

  double _calculateStartAngle(double total, double offset) =>
      _calculateAngle(total, offset) - math.pi / 2;

  double _calculateSweepAngle(double total, double offset) =>
      _calculateAngle(total, offset);
}
