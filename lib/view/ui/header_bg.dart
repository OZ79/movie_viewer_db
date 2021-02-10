import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class HeaderBg extends StatefulWidget {
  final bool animate;

  const HeaderBg({this.animate});

  @override
  _HeaderBgState createState() => _HeaderBgState();
}

class _HeaderBgState extends State<HeaderBg> {
  double _opacity = 0;

  @override
  void initState() {
    super.initState();

    if (widget.animate) {
      Timer.run(() => setState(() {
            if (mounted) {
              setState(() => _opacity = 1.0);
            }
          }));
    }
  }

  Widget _buildHeadr() {
    return Stack(children: <Widget>[
      ClipPath(
          clipper: WaveClipperOne(),
          child: Container(
            height: 100,
            color: const Color(0x7e4ce3).withOpacity(0.6),
          )),
      ClipPath(
          clipper: WaveClipperTwo(),
          child: Container(
            height: 100,
            color: const Color(0x7e4ce3).withOpacity(0.6),
          ))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animate) {
      return AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 300),
          child: _buildHeadr());
    }
    return _buildHeadr();
  }
}
