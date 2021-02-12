import 'package:flutter/material.dart';

const double HEIGHT_BAR = 50;

class ButtonAppBar extends StatefulWidget {
  final ValueChanged<int> onItemSelected;

  ButtonAppBar(this.onItemSelected);

  @override
  _ButtonAppBarState createState() => _ButtonAppBarState();
}

class _ButtonAppBarState extends State<ButtonAppBar> {
  double _position = 0;
  int _selectedIndex = 0;
  int _selectedColorIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void onItemSelected(int index) {
    if (_selectedIndex != index) {
      _selectedColorIndex = -1;
      widget.onItemSelected(index);
    }

    _selectedIndex = index;
    setState(() => _position = _selectedIndex.toDouble() * getBtnWidth());
  }

  double getBtnWidth() {
    return (MediaQuery.of(context).size.width - 10) / 4;
  }

  Color getColorBtn(int index) {
    return index == _selectedColorIndex
        ? Colors.white
        : const Color(0xFF1E88E5);
  }

  void onEndSelection() {
    setState(() => _selectedColorIndex = _selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 10;
    final btnWidth = getBtnWidth();

    return Stack(clipBehavior: Clip.none, children: [
      const Bar(),
      AnimatedPositioned(
        duration: const Duration(milliseconds: 250),
        left: _position,
        curve: Curves.easeOut,
        child: ButtonSelector(btnWidth),
        onEnd: onEndSelection,
      ),
      SizedBox(
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ButtonApp(0, "POPULAR", btnWidth, getColorBtn(0), onItemSelected),
            ButtonApp(
                1, "NOW PLAYING", btnWidth, getColorBtn(1), onItemSelected),
            ButtonApp(2, "UPCOMING", btnWidth, getColorBtn(2), onItemSelected),
            ButtonApp(3, "TOP RATED", btnWidth, getColorBtn(3), onItemSelected),
          ],
        ),
      ),
    ]);
  }
}

class ButtonApp extends StatelessWidget {
  final int index;
  final String title;
  final double width;
  final Color color;
  final ValueChanged<int> onSelected;

  const ButtonApp(
      this.index, this.title, this.width, this.color, this.onSelected);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => onSelected(index),
        child: Container(
          width: width,
          height: HEIGHT_BAR,
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: getFontSize(context),
                  color: color),
            ),
          ),
        ),
      ),
    );
  }
}

class Bar extends StatelessWidget {
  const Bar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 10,
      height: HEIGHT_BAR,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black12,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class ButtonSelector extends StatelessWidget {
  final width;

  const ButtonSelector(this.width);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: HEIGHT_BAR,
      child: Container(
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: const Color(0xFF1E88E5),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

double getFontSize(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth <= 320) {
    return 12.9;
  }
  if (screenWidth <= 360) {
    return 13.3;
  }
  if (screenWidth <= 411) {
    return 13.7;
  }
  if (screenWidth <= 480) {
    return 14;
  }
  if (screenWidth <= 540) {
    return 20;
  }
  if (screenWidth <= 768) {
    return 24;
  }
  if (screenWidth <= 800) {
    return 26;
  }

  return 27;
}
