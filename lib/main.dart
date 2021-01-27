import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_viewer_db/view/screens/home_screen.dart';

import 'bloc/movie_bloc/movie_bloc.dart';
import 'bloc/movielist_bloc/movielist_bloc.dart';
import 'bloc/simple_bloc_observer.dart';
import 'data/movie_repositories.dart';
import 'view/screens/movie_detail_screen.dart';
import 'view/screens/movielist_screen.dart';
import 'view/screens/search_screen.dart';
import 'view/ui/bottom_nav_bar.dart';

void main() {
  //debugPaintSizeEnabled = true;
  Bloc.observer = SimpleBlocObserver();
  runApp(App(movieRepository: MovieRepository()));
}

/*void main() => runApp(
      DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) =>
            App(movieRepository: MovieRepository()), // Wrap your app
      ),
    );*/

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
        BlocProvider<MovieListBloc>(
          create: (context) => MovieListBloc(movieRepository: movieRepository),
        ),
      ],
      child: MaterialApp(
        //locale: DevicePreview.locale(context),
        //builder: DevicePreview.appBuilder,
        debugShowCheckedModeBanner: false,
        home: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
              statusBarColor: Colors.black,
              statusBarIconBrightness: Brightness.light),
          child: Scaffold(
            backgroundColor: Colors.white,
            bottomNavigationBar: AppBottomNavigationBar(),
            body: SafeArea(
              child:
                  SearchScreen(), //SearchScreen(), MovieDetailScreen(), // HomeScreen(), //MovieListScreen(),
            ),
          ),
        ),
      ),
    );
  }
}
