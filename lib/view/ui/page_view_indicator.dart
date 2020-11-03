import 'package:flutter/material.dart';

class LineIndiator extends StatefulWidget {
  final PageController controller;

  LineIndiator({@required this.controller});

  @override
  _LineIndiatorState createState() => _LineIndiatorState();
}

class _LineIndiatorState extends State<LineIndiator> {
  Alignment _alignment = Alignment(-0.93, -0.15);

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      setState(() {
        _alignment =
            Alignment(0.93 * (-1 + 1.83 * widget.controller.page / 4), -0.15);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      alignment: _alignment,
      curve: Curves.easeOutQuint,
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
    canvas.drawRect(Offset(0, 0) & const Size(30, 3), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
