import 'package:flutter/material.dart';

class LineIndiator extends StatelessWidget {
  final PageController controller;

  LineIndiator({@required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      const IndicatorTrack(),
      AnimatedBuilder(
          animation: controller,
          builder: (_, child) {
            final double offset =
                34.5 * (controller.page ?? controller.initialPage.toDouble());
            return Transform.translate(
              offset: Offset(
                  MediaQuery.of(context).size.width * 0.5 - 80 + offset, 0),
              child: child,
            );
          },
          child: Container(
            width: 22,
            alignment: const Alignment(0, 0),
            child: const IndiatorPainter(const Color(0xFF1976D2)),
          )),
    ]);
  }
}

class IndicatorTrack extends StatelessWidget {
  const IndicatorTrack();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: const Alignment(0, 0),
        width: 160,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List<Widget>.generate(
              5, (i) => const IndiatorPainter(Color(0xFF64B5F6))),
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
