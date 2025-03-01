import 'package:flutter/material.dart';

class VerticalFractionBar extends StatelessWidget {
  final Color color;
  final double fraction;

  const VerticalFractionBar(
      {super.key, required this.color, required this.fraction});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        height: constraints.maxHeight,
        width: 4,
        child: Column(
          children: [
            SizedBox(
              height: (1 - fraction) * constraints.maxHeight,
              child: Container(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: fraction * constraints.maxHeight,
              child: Container(color: color),
            ),
          ],
        ),
      );
    });
  }
}
