import 'package:flutter/material.dart';

class WrapLayout extends StatelessWidget {
  final int itemCount;
  final Axis direction;
  final WrapAlignment alignment;
  final double spacing;
  final double runSpacing;
  final IndexedWidgetBuilder itemBuilder;

  const WrapLayout(
      {@required this.itemCount,
      this.direction = Axis.horizontal,
      this.alignment = WrapAlignment.start,
      this.spacing = 0.0,
      this.runSpacing = 0.0,
      @required this.itemBuilder});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: direction,
      alignment: alignment,
      spacing: spacing,
      runSpacing: runSpacing,
      children: new List.generate(
        itemCount,
        (index) => itemBuilder(context, index),
      ),
    );
  }
}
