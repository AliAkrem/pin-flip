import 'dart:math';

// import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pin_flip/utils/colors.dart';

class FlutterScatterChart extends StatefulWidget {
  FlutterScatterChart({super.key});

  @override
  State<StatefulWidget> createState() => FlutterScatterChartState();
}

class FlutterScatterChartState extends State<FlutterScatterChart> {
  final maxX = 50.0;
  final maxY = 50.0;
  final radius = 8.0;

  bool showFlutter = true;

  final green2 = PinFlipColors.primaryColors[3];
  final green1 = PinFlipColors.primaryColors[0];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showFlutter = !showFlutter;
        });
      },
      child: AspectRatio(
        aspectRatio: 1,
        child: ScatterChart(
          ScatterChartData(
            scatterSpots: showFlutter ? flutterLogoData() : randomData(),
            minX: 0,
            maxX: maxX,
            minY: 0,
            maxY: maxY,
            borderData: FlBorderData(
              show: false,
            ),
            gridData: const FlGridData(
              show: false,
            ),
            titlesData: const FlTitlesData(
              show: false,
            ),
            scatterTouchData: ScatterTouchData(
              enabled: false,
            ),
          ),
          duration: const Duration(milliseconds: 600),
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
  }

  List<ScatterSpot> flutterLogoData() {
    return [
      /// section 1
      ScatterSpot(
        20,
        14.5,
        dotPainter: FlDotCirclePainter(color: green1, radius: radius),
      ),
      ScatterSpot(
        20,
        14.5,
        dotPainter: FlDotCirclePainter(color: green1, radius: radius),
      ),
      ScatterSpot(
        22,
        16.5,
        dotPainter: FlDotCirclePainter(color: green1, radius: radius),
      ),
      ScatterSpot(
        24,
        18.5,
        dotPainter: FlDotCirclePainter(color: green1, radius: radius),
      ),

      ScatterSpot(
        22,
        12.5,
        dotPainter: FlDotCirclePainter(color: green1, radius: radius),
      ),
      ScatterSpot(
        24,
        14.5,
        dotPainter: FlDotCirclePainter(color: green1, radius: radius),
      ),
      ScatterSpot(
        26,
        16.5,
        dotPainter: FlDotCirclePainter(color: green1, radius: radius),
      ),

      ScatterSpot(
        24,
        10.5,
        dotPainter: FlDotCirclePainter(color: green1, radius: radius),
      ),
      ScatterSpot(
        26,
        12.5,
        dotPainter: FlDotCirclePainter(color: green1, radius: radius),
      ),
      ScatterSpot(
        28,
        14.5,
        dotPainter: FlDotCirclePainter(color: green1, radius: radius),
      ),

      ScatterSpot(
        26,
        8.5,
        dotPainter: FlDotCirclePainter(color: green1, radius: radius),
      ),
      ScatterSpot(
        28,
        10.5,
        dotPainter: FlDotCirclePainter(color: green1, radius: radius),
      ),
      ScatterSpot(
        30,
        12.5,
        dotPainter: FlDotCirclePainter(color: green1, radius: radius),
      ),

      ScatterSpot(
        28,
        6.5,
        dotPainter: FlDotCirclePainter(color: green1, radius: radius),
      ),
      ScatterSpot(
        30,
        8.5,
        dotPainter: FlDotCirclePainter(color: green1, radius: radius),
      ),
      ScatterSpot(
        32,
        10.5,
        dotPainter: FlDotCirclePainter(color: green1, radius: radius),
      ),

      ScatterSpot(
        30,
        4.5,
        dotPainter: FlDotCirclePainter(color: green1, radius: radius),
      ),
      ScatterSpot(
        32,
        6.5,
        dotPainter: FlDotCirclePainter(color: green1, radius: radius),
      ),
      ScatterSpot(
        34,
        8.5,
        dotPainter: FlDotCirclePainter(color: green1, radius: radius),
      ),

      ScatterSpot(
        34,
        4.5,
        dotPainter: FlDotCirclePainter(color: green1, radius: radius),
      ),
      ScatterSpot(
        36,
        6.5,
        dotPainter: FlDotCirclePainter(color: green1, radius: radius),
      ),

      ScatterSpot(
        38,
        4.5,
        dotPainter: FlDotCirclePainter(color: green1, radius: radius),
      ),

      /// section 2
      ScatterSpot(
        20,
        14.5,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),
      ScatterSpot(
        22,
        12.5,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),
      ScatterSpot(
        24,
        10.5,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),

      ScatterSpot(
        22,
        16.5,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),
      ScatterSpot(
        24,
        14.5,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),
      ScatterSpot(
        26,
        12.5,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),

      ScatterSpot(
        24,
        18.5,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),
      ScatterSpot(
        26,
        16.5,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),
      ScatterSpot(
        28,
        14.5,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),

      ScatterSpot(
        26,
        20.5,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),
      ScatterSpot(
        28,
        18.5,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),
      ScatterSpot(
        30,
        16.5,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),

      ScatterSpot(
        28,
        22.5,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),
      ScatterSpot(
        30,
        20.5,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),
      ScatterSpot(
        32,
        18.5,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),

      ScatterSpot(
        30,
        24.5,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),
      ScatterSpot(
        32,
        22.5,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),
      ScatterSpot(
        34,
        20.5,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),

      ScatterSpot(
        34,
        24.5,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),
      ScatterSpot(
        36,
        22.5,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),

      ScatterSpot(
        38,
        24.5,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),

      /// section 3
      ScatterSpot(
        10,
        25,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),
      ScatterSpot(
        12,
        23,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),
      ScatterSpot(
        14,
        21,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),

      ScatterSpot(
        12,
        27,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),
      ScatterSpot(
        14,
        25,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),
      ScatterSpot(
        16,
        23,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),

      ScatterSpot(
        14,
        29,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),
      ScatterSpot(
        16,
        27,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),
      ScatterSpot(
        18,
        25,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),

      ScatterSpot(
        16,
        31,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),
      ScatterSpot(
        18,
        29,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),
      ScatterSpot(
        20,
        27,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),

      ScatterSpot(
        18,
        33,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),
      ScatterSpot(
        20,
        31,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),
      ScatterSpot(
        22,
        29,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),

      ScatterSpot(
        20,
        35,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),
      ScatterSpot(
        22,
        33,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),
      ScatterSpot(
        24,
        31,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),

      ScatterSpot(
        22,
        37,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),
      ScatterSpot(
        24,
        35,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),
      ScatterSpot(
        26,
        33,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),

      ScatterSpot(
        24,
        39,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),
      ScatterSpot(
        26,
        37,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),
      ScatterSpot(
        28,
        35,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),

      ScatterSpot(
        26,
        41,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),
      ScatterSpot(
        28,
        39,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),
      ScatterSpot(
        30,
        37,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),

      ScatterSpot(
        28,
        43,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),
      ScatterSpot(
        30,
        41,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),
      ScatterSpot(
        32,
        39,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),

      ScatterSpot(
        30,
        45,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),
      ScatterSpot(
        32,
        43,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),
      ScatterSpot(
        34,
        41,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),

      ScatterSpot(
        34,
        45,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),
      ScatterSpot(
        36,
        43,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),

      ScatterSpot(
        38,
        45,
        dotPainter: FlDotCirclePainter(color: green2, radius: radius),
      ),
    ];
  }

  List<ScatterSpot> randomData() {
    const green1Count = 21;
    const green2Count = 57;
    return List.generate(green1Count + green2Count, (i) {
      Color color;
      if (i < green1Count) {
        color = green1;
      } else {
        color = green2;
      }

      return ScatterSpot(
        (Random().nextDouble() * (maxX - 8)) + 4,
        (Random().nextDouble() * (maxY - 8)) + 4,
        dotPainter: FlDotCirclePainter(
          color: color,
          radius: (Random().nextDouble() * 16) + 4,
        ),
      );
    });
  }
}
