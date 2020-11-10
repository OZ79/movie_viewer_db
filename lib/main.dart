import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_viewer_db/view/screens/home_screen.dart';

import 'bloc/movie_bloc/movie_bloc.dart';
import 'bloc/simple_bloc_observer.dart';
import 'data/movie_repositories.dart';

void main() {
  //debugPaintSizeEnabled = true;
  Bloc.observer = SimpleBlocObserver();
  runApp(App(movieRepository: MovieRepository()));
}

class App extends StatelessWidget {
  final MovieRepositoryApi movieRepository;

  App({Key key, @required this.movieRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieBloc>(
          create: (context) => MovieBloc(movieRepository: movieRepository),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
              statusBarColor: Colors.black,
              statusBarIconBrightness: Brightness.light),
          child: Scaffold(
            //backgroundColor: Colors.black,
            body: SafeArea(
              child: HomeScreen(),
            ),
          ),
        ),
      ),
    );
  }
}
