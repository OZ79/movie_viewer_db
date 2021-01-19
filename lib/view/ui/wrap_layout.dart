import 'package:flutter/material.dart';

class WrapLayout extends StatelessWidget {
  final int itemCount;
  final Axis direction;
  final double spacing;
  final IndexedWidgetBuilder itemBuilder;

  const WrapLayout(
      {@required this.itemCount,
      this.direction = Axis.horizontal,
      this.spacing = 0.0,
      @required this.itemBuilder});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: direction,
      spacing: spacing,
      children: new List.generate(
        itemCount,
        (index) => itemBuilder(context, index),
      ),
    );
  }
}
