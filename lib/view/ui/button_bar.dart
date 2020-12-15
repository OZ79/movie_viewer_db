import 'package:flutter/material.dart';

class ButtonAppBar extends StatefulWidget {
  @override
  _ButtonAppBarState createState() => _ButtonAppBarState();
}

class _ButtonAppBarState extends State<ButtonAppBar> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      const Bar(),
      SizedBox(
        width: MediaQuery.of(context).size.width - 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ButtonApp(0, "POPULAR"),
            ButtonApp(1, "NOW PLAYING"),
            ButtonApp(2, "UPCOMING"),
            ButtonApp(3, "TOP RATED"),
          ],
        ),
      )
    ]);
  }
}

class ButtonApp extends StatefulWidget {
  final int index;
  final String title;

  ButtonApp(this.index, this.title);

  @override
  _ButtonAppState createState() => _ButtonAppState();
}

class _ButtonAppState extends State<ButtonApp> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => print("onTap"),
        child: Container(
          width: (MediaQuery.of(context).size.width - 10 - 5) / 4,
          height: 40,
          //color: Colors.yellow,
          child: Center(
            child: Text(
              widget.title,
              textAlign: TextAlign.left,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.2,
                  color: const Color(0xFF1E88E5)),
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
      height: 40,
      child: Container(
        //margin: const EdgeInsets.all(5),
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
