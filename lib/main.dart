import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_viewer_db/view/screens/home_screen.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light),
        child: Scaffold(
          //backgroundColor: Colors.black,
          body: SafeArea(
            child: HomeScreen(),
          ),
        ),
      ),
    );
  }
}
