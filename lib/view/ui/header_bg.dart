import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class HeaderBg extends StatefulWidget {
  const HeaderBg();

  @override
  _HeaderBgState createState() => _HeaderBgState();
}

class _HeaderBgState extends State<HeaderBg> {
  double _opacity;

  @override
  void initState() {
    super.initState();

    _opacity = 0;

    Future.delayed(const Duration(seconds: 1), () {
      setState(() => _opacity = 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(milliseconds: 400),
      child: Stack(children: <Widget>[
        ClipPath(
            clipper: WaveClipperOne(),
            child: Container(
              height: 160,
              color: const Color(0x7e4ce3).withOpacity(0.6),
            )),
        ClipPath(
            clipper: WaveClipperTwo(),
            child: Container(
              height: 160,
              color: const Color(0x7e4ce3).withOpacity(0.6),
            ))
      ]),
    );
  }
}
