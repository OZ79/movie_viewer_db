import 'package:flutter/material.dart';

class LineIndiator extends StatefulWidget {
  final PageController controller;

  LineIndiator({@required this.controller});

  @override
  _LineIndiatorState createState() => _LineIndiatorState();
}

class _LineIndiatorState extends State<LineIndiator> {
  Alignment _alignment = Alignment(-0.4, 0.95);

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      setState(() {
        _alignment =
            Alignment(0.4 * (-1 + 2 * widget.controller.page / 4), 0.95);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      AnimatedContainer(
        duration: const Duration(seconds: 1),
        alignment: _alignment,
        curve: Curves.easeOutQuint,
        child: const IndiatorPainter(Colors.black87),
      ),
      Container(
        alignment: Alignment(0, 0.95),
        child: Container(
          width: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List<Widget>.generate(
                5, (i) => const IndiatorPainter(Colors.black38)),
          ),
        ),
      )
    ]);
  }
}

class IndiatorPainter extends StatelessWidget {
  final Color color;

  const IndiatorPainter(this.color);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(30, 4),
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
            const Offset(0, 0) & const Size(30, 4), Radius.circular(9)),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
