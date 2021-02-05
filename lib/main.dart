import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
//import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_viewer_db/view/screens/home_screen.dart';

import 'bloc/movie_bloc/movie_bloc.dart';
import 'bloc/movie_bloc/movie_event.dart';
import 'bloc/movielist_bloc/movielist_bloc.dart';
import 'bloc/moviesearch_bloc/moviesearch_bloc.dart';
import 'bloc/simple_bloc_observer.dart';
import 'data/movie_repositories.dart';
import 'view/screens/movie_detail_screen.dart';
import 'view/screens/movielist_screen.dart';
import 'view/screens/search_screen.dart';
import 'view/ui/bottom_nav_bar.dart';

void main() {
  //timeDilation = 5;
  //debugDisableClipLayers = true;
  Bloc.observer = SimpleBlocObserver();
  //HttpOverrides.global = MyHttpOverrides();
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
  final _navigatorKey = GlobalKey<NavigatorState>();

  App({Key key, @required this.movieRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieBloc>(
          create: (context) => MovieBloc(movieRepository: movieRepository)
            ..add(FetchPreviewMovieEvent(movieType: MovieType.popular))
            ..add(FetchPreviewMovieEvent(movieType: MovieType.now_playing))
            ..add(FetchPreviewMovieEvent(movieType: MovieType.upcoming))
            ..add(FetchPreviewMovieEvent(movieType: MovieType.top_rated)),
        ),
        BlocProvider<MovieListBloc>(
          create: (context) => MovieListBloc(movieRepository: movieRepository),
        ),
        BlocProvider<MovieSearchBloc>(
          create: (context) =>
              MovieSearchBloc(movieRepository: movieRepository),
        ),
      ],
      child: MaterialApp(
        //locale: DevicePreview.locale(context),
        //builder: DevicePreview.appBuilder,
        showPerformanceOverlay: true,
        //debugShowCheckedModeBanner: false,
        home: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
              statusBarColor: Colors.black,
              statusBarIconBrightness: Brightness.light),
          child: Scaffold(
            backgroundColor: Colors.white,
            bottomNavigationBar: AppBottomNavigationBar((index) => {
                  _navigatorKey.currentState.pushNamed(Routes.routeNames[index])
                }),
            body: WillPopScope(
              onWillPop: () async {
                if (_navigatorKey.currentState.canPop()) {
                  _navigatorKey.currentState.pop();
                  return false;
                }
                return true;
              },
              child: Navigator(
                key: _navigatorKey,
                initialRoute: Routes.Home,
                onGenerateRoute: Routes.generateRoute,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Routes {
  static const String Home = '/';
  static const String MovieList = '/MovieList';
  static const String Search = '/Search';

  static const routeNames = [Home, MovieList, Search];

  static Route<dynamic> generateRoute(RouteSettings settings) {
    RoutePageBuilder builder;
    switch (settings.name) {
      case Home:
        builder = (context, animation, secondaryAnimation) =>
            HomeScreen(key: ValueKey('HomeScreen'));
        break;
      case MovieList:
        builder = (context, animation, secondaryAnimation) =>
            MovieListScreen(key: ValueKey('MovieListScreen'));
        break;
      case Search:
        builder = (context, animation, secondaryAnimation) =>
            SearchScreen(key: ValueKey('SearchScreen'));
        break;
      default:
        throw Exception('Invalid route: ${settings.name}');
    }

    return PageRouteBuilder(
      pageBuilder: builder,
      settings: settings,
      transitionDuration: const Duration(milliseconds: 200),
      opaque: true,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final begin = const Offset(1.0, 0.0);
        final end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
