import 'package:flutter/material.dart';

class LineIndiator extends StatefulWidget {
  LineIndiator({Key key}) : super(key: key);

  @override
  _LineIndiatorState createState() => _LineIndiatorState();
}

class _LineIndiatorState extends State<LineIndiator> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        painter: IndiatorPainter(),
      ),
    );
  }
}

class IndiatorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.blue[600]
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset(0, 0) & const Size(30, 4), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
