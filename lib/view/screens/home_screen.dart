import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_viewer_db/bloc/movie_bloc/movie_bloc.dart';
import 'package:movie_viewer_db/bloc/movie_bloc/movie_event.dart';
import 'package:movie_viewer_db/bloc/movie_bloc/movie_state.dart';
import 'package:movie_viewer_db/bloc/base_movie_state.dart';
import 'package:movie_viewer_db/bloc/movie_detail_bloc/movie_detail_bloc.dart';
import 'package:movie_viewer_db/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:movie_viewer_db/data/movie_repositories.dart';
import 'package:movie_viewer_db/util/flutter_device_type.dart';
import 'package:movie_viewer_db/view/ui/InternetConnectionAlert.dart';
import 'package:movie_viewer_db/view/ui/header_bg.dart';
import 'package:movie_viewer_db/view/ui/preview_movielist.dart';
import 'package:movie_viewer_db/view/ui/upcoming_movies.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with InternetConnectionAlert<HomeScreen, MovieBloc> {
  bool _animateBg;
  // ignore: close_sinks
  MovieDetailBloc _movieDetailBloc;
  // ignore: close_sinks
  NavigationBloc _navigationBloc;

  @override
  void initState() {
    super.initState();

    _movieDetailBloc = BlocProvider.of<MovieDetailBloc>(context);
    _navigationBloc = BlocProvider.of<NavigationBloc>(context);

    if (BlocProvider.of<MovieBloc>(context).state is MovieInitialState) {
      _animateBg = true;
      _loadData();
    } else {
      _animateBg = false;
    }
  }

  void _loadData() {
    BlocProvider.of<MovieBloc>(context)
      ..add(FetchPreviewMovieEvent(movieType: MovieType.popular))
      ..add(FetchPreviewMovieEvent(movieType: MovieType.now_playing))
      ..add(FetchPreviewMovieEvent(movieType: MovieType.upcoming))
      ..add(FetchPreviewMovieEvent(movieType: MovieType.top_rated));
  }

  @override
  MovieBloc get bloc => BlocProvider.of<MovieBloc>(context);

  @override
  Widget getContent() {
    return SingleChildScrollView(
      key: PageStorageKey('HomeScreen_SCSV'),
      child: Column(children: [
        Stack(clipBehavior: Clip.none, children: <Widget>[
          HeaderBg(animate: _animateBg),
          SizedBox(
              height: Device.get().isPhone ? 300 : 320,
              child: UpcomingMoviesWidget(
                  key: PageStorageKey('UpcomingMoviesWidget'),
                  movieDetailBloc: _movieDetailBloc))
        ]),
        const SizedBox(height: 20),
        BlocBuilder<MovieBloc, MovieState>(buildWhen: (prevstate, state) {
          if (prevstate is MovieErrorState && prevstate.isOffline) {
            return true;
          }
          if (state is PreviewMovieLoadedState &&
              state.movieType == MovieType.popular) {
            return true;
          }
          return false;
        }, builder: (context, state) {
          if (state is PreviewMovieLoadedState &&
              state.movies[MovieType.popular] != null) {
            return Container(
                height: 200,
                child: PreviewMovieList(
                    key: PageStorageKey(MovieType.popular),
                    movieType: MovieType.popular,
                    title: "POPULAR",
                    data: state.movies[MovieType.popular],
                    movieDetailBloc: _movieDetailBloc,
                    navigationBloc: _navigationBloc));
          }
          return Container(
              height: 200,
              child: const Center(child: const CircularProgressIndicator()));
        }),
        const SizedBox(height: 20),
        BlocBuilder<MovieBloc, MovieState>(buildWhen: (prevstate, state) {
          if (prevstate is MovieErrorState && prevstate.isOffline) {
            return true;
          }
          if (state is PreviewMovieLoadedState &&
              state.movieType == MovieType.now_playing) {
            return true;
          }
          return false;
        }, builder: (context, state) {
          if (state is PreviewMovieLoadedState &&
              state.movies[MovieType.now_playing] != null) {
            return Container(
                height: 200,
                child: PreviewMovieList(
                    key: PageStorageKey(MovieType.now_playing),
                    movieType: MovieType.now_playing,
                    title: "NOW PLAYING",
                    data: state.movies[MovieType.now_playing],
                    movieDetailBloc: _movieDetailBloc,
                    navigationBloc: _navigationBloc));
          }
          return Container(
              height: 200,
              child: const Center(child: const CircularProgressIndicator()));
        }),
        const SizedBox(height: 20),
        BlocBuilder<MovieBloc, MovieState>(buildWhen: (prevstate, state) {
          if (prevstate is MovieErrorState && prevstate.isOffline) {
            return true;
          }
          if (state is PreviewMovieLoadedState &&
              state.movieType == MovieType.upcoming) {
            return true;
          }
          return false;
        }, builder: (context, state) {
          if (state is PreviewMovieLoadedState &&
              state.movies[MovieType.upcoming] != null) {
            return Container(
                height: 200,
                child: PreviewMovieList(
                    key: PageStorageKey(MovieType.upcoming),
                    movieType: MovieType.upcoming,
                    title: "UPCAMING",
                    data: state.movies[MovieType.upcoming],
                    movieDetailBloc: _movieDetailBloc,
                    navigationBloc: _navigationBloc));
          }
          return Container(
              height: 200,
              child: const Center(child: const CircularProgressIndicator()));
        }),
        const SizedBox(height: 20),
        BlocBuilder<MovieBloc, MovieState>(buildWhen: (prevstate, state) {
          if (prevstate is MovieErrorState && prevstate.isOffline) {
            return true;
          }
          if (state is PreviewMovieLoadedState &&
              state.movieType == MovieType.top_rated) {
            return true;
          }
          return false;
        }, builder: (context, state) {
          if (state is PreviewMovieLoadedState &&
              state.movies[MovieType.top_rated] != null) {
            return Container(
                height: 200,
                child: PreviewMovieList(
                    key: PageStorageKey(MovieType.top_rated),
                    movieType: MovieType.top_rated,
                    title: "TOP RATED",
                    data: state.movies[MovieType.top_rated],
                    movieDetailBloc: _movieDetailBloc,
                    navigationBloc: _navigationBloc));
          }
          return Container(
              height: 200,
              child: const Center(child: const CircularProgressIndicator()));
        }),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return super.build(context);
  }
}
