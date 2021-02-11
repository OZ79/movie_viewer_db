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
import 'bloc/movielist_bloc/movielist_bloc.dart';
import 'bloc/moviesearch_bloc/moviesearch_bloc.dart';
import 'bloc/navigation_bloc/navigation_bloc.dart';
import 'bloc/navigation_bloc/navigation_event.dart';
import 'bloc/navigation_bloc/navigation_state.dart';
import 'bloc/simple_bloc_observer.dart';
import 'data/movie_repositories.dart';
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
    PageAnimation(
        key: ValueKey(0), child: HomeScreen(key: ValueKey('HomeScreen'))),
    PageAnimation(
        key: ValueKey(1),
        child: MovieListScreen(key: ValueKey('MovieListScreen'))),
    PageAnimation(
        key: ValueKey(2), child: SearchScreen(key: ValueKey('SearchScreen')))
  ];

  App({Key key, @required this.movieRepository}) : super(key: key);

  void _onItemTapped(BuildContext context, int index) {
    if (index != BlocProvider.of<NavigationBloc>(context).state.pageIndex) {
      BlocProvider.of<NavigationBloc>(context)
          .add(NavigationEvent(pageIndex: index));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        //locale: DevicePreview.locale(context),
        //builder: DevicePreview.appBuilder,
        //showPerformanceOverlay: true,
        //debugShowCheckedModeBanner: false,
        //checkerboardRasterCacheImages: false,
        home: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<MovieBloc>(
            create: (context) => MovieBloc(movieRepository: movieRepository),
          ),
          BlocProvider<MovieListBloc>(
            create: (context) =>
                MovieListBloc(movieRepository: movieRepository),
          ),
          BlocProvider<MovieSearchBloc>(
            create: (context) =>
                MovieSearchBloc(movieRepository: movieRepository),
          ),
          BlocProvider<NavigationBloc>(
            create: (context) => NavigationBloc(),
          ),
        ],
        child: Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: Builder(builder: (BuildContext context) {
            return AppBottomNavigationBar(
                (index) => _onItemTapped(context, index));
          }),
          body: SafeArea(child: BlocBuilder<NavigationBloc, NavigationState>(
              builder: (context, state) {
            if (state is NavigationState) {
              return IndexedStack(
                key: ValueKey('IndexedStack'),
                children: _pages,
                index: state.pageIndex,
              );
            }
            return Container();
          })),
        ),
      ),
    ));
  }
}

class PageAnimation extends StatefulWidget {
  final Widget child;

  PageAnimation({Key key, @required this.child}) : super(key: key);

  @override
  _PageAnimationState createState() => _PageAnimationState();
}

class _PageAnimationState extends State<PageAnimation>
    with TickerProviderStateMixin {
  bool _isInit = true;
  AnimationController _controller;
  Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: const Offset(0.05, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.decelerate,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(buildWhen: (_, state) {
      if ((widget.key as ValueKey).value == state.pageIndex && state.bottom) {
        return true;
      }
      return false;
    }, builder: (context, state) {
      if ((widget.key as ValueKey).value == state.pageIndex &&
          BlocProvider.of<NavigationBloc>(context).state.bottom) {
        _controller.reset();
        _controller.duration = (widget.key as ValueKey).value == 0 && _isInit
            ? Duration(milliseconds: 0)
            : Duration(milliseconds: 300);
        _controller.forward();
        _isInit = false;
      }

      return SlideTransition(
        position: _animation,
        child: widget.child,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
