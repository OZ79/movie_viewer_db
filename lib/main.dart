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
import 'bloc/navigation_bloc/navigation_bloc.dart';
import 'bloc/navigation_bloc/navigation_event.dart';
import 'bloc/navigation_bloc/navigation_state.dart';
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
  static final List<Widget> _pages = <Widget>[
    HomeScreen(key: ValueKey('HomeScreen')),
    MovieListScreen(key: ValueKey('MovieListScreen')),
    SearchScreen(key: ValueKey('MovieListScreen'))
  ];

  App({Key key, @required this.movieRepository}) : super(key: key);

  void _onItemTapped(BuildContext context, int index) {
    BlocProvider.of<NavigationBloc>(context)
        .add(NavigationEvent(pageIndex: index));
  }

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
        BlocProvider<NavigationBloc>(
          create: (context) => NavigationBloc(),
        ),
      ],
      child: MaterialApp(
        //locale: DevicePreview.locale(context),
        //builder: DevicePreview.appBuilder,
        //showPerformanceOverlay: true,
        //debugShowCheckedModeBanner: false,
        home: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
              statusBarColor: Colors.black,
              statusBarIconBrightness: Brightness.light),
          child: Scaffold(
            backgroundColor: Colors.white,
            bottomNavigationBar: Builder(builder: (BuildContext context) {
              return AppBottomNavigationBar(
                  (index) => _onItemTapped(context, index));
            }),
            body: SafeArea(child: BlocBuilder<NavigationBloc, NavigationState>(
                builder: (context, state) {
              if (state is NavigationState) {
                return _pages.elementAt(state.pageIndex);
              }
              return Container();
            })),
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
        builder = (context, animation, secondaryAnimation) => Container();
        break;
      case MovieList:
        builder = (context, animation, secondaryAnimation) =>
            MovieListScreen(key: ValueKey('MovieListScreen'));
        break;
      case Search:
        builder = (context, animation, secondaryAnimation) => Container();
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
        return child;
      },
    );
  }
}
