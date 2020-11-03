import 'package:flutter/material.dart';

class LineIndiator extends StatefulWidget {
  final PageController controller;

  LineIndiator({@required this.controller});

  @override
  _LineIndiatorState createState() => _LineIndiatorState();
}

class _LineIndiatorState extends State<LineIndiator> {
  Alignment _alignment = Alignment(-0.93, -0.12);

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      setState(() {
        _alignment =
            Alignment(0.93 * (-1 + 1.58 * widget.controller.page / 4), -0.12);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      alignment: _alignment,
      curve: Curves.easeOutQuint,
      child: const CustomPaint(
        painter: const IndiatorPainter(),
      ),
    );
  }
}

class IndiatorPainter extends CustomPainter {
  const IndiatorPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            const Offset(0, 0) & const Size(80, 4), Radius.circular(9)),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
