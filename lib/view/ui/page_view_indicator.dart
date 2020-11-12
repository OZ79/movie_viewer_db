import 'package:flutter/material.dart';

class LineIndiator extends StatelessWidget {
  final PageController controller;

  LineIndiator({@required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      AnimatedBuilder(
          animation: controller,
          builder: (_, child) {
            final double offset =
                30 * (controller.page ?? controller.initialPage.toDouble());
            return Transform.translate(
              offset: Offset(offset, 0),
              child: child,
            );
          },
          child: Container(
            alignment: const Alignment(-0.31, 0.88),
            child: const IndiatorPainter(Colors.black54),
          )),
      const IndicatorTrack(),
    ]);
  }
}

class IndicatorTrack extends StatelessWidget {
  const IndicatorTrack();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: const Alignment(0, 0.88),
      child: Container(
        width: 160,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List<Widget>.generate(
              5, (i) => const IndiatorPainter(Colors.black38)),
        ),
      ),
    );
  }
}

class IndiatorPainter extends StatelessWidget {
  final Color color;

  const IndiatorPainter(this.color);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(22, 4),
      painter: LineTrackPainter(color),
    );
  }
}

class LineTrackPainter extends CustomPainter {
  final Color color;

  LineTrackPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            const Offset(0, 0) & const Size(22, 4), Radius.circular(9)),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
