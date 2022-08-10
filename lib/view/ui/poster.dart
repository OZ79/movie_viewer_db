import 'package:flutter/material.dart';

class Poster extends StatelessWidget {
  final String posterUrl;

  const Poster({@required this.posterUrl});

  @override
  Widget build(BuildContext context) {
    Alignment aligntment = Alignment(-0.9, 0.0);
    double opacity = 0;
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 290,
        child: Image.network(
          posterUrl,
          fit: BoxFit.cover,
          frameBuilder:
              (_, Widget child, int frame, bool wasSynchronouslyLoaded) {
            //print("$wasSynchronouslyLoaded" + " " + "$frame");
            if (frame != null || wasSynchronouslyLoaded) {
              aligntment = Alignment(-0.9, 1.0);
              opacity = 1;
            }

            return AnimatedAlign(
              alignment: aligntment,
              duration: const Duration(seconds: 1),
              curve: Curves.easeOutQuint,
              child: AnimatedOpacity(
                opacity: opacity,
                duration: const Duration(milliseconds: 200),
                child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.45),
                          offset: const Offset(1.0, 2.0), //Offset
                          blurRadius: 18.0,
                          spreadRadius: 0.1,
                        )
                      ], //BoxShadow
                    ),
                    child: ClipRRect(
                        clipBehavior: Clip.hardEdge,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child:
                            SizedBox(width: 154, height: 231, child: child))),
              ),
            );
          },
          errorBuilder: (_, error, __) {
            return const SizedBox.shrink();
          },
        ));
  }
}
