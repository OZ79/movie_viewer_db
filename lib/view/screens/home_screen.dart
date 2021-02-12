import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_viewer_db/bloc/movie_bloc/movie_bloc.dart';
import 'package:movie_viewer_db/bloc/movie_bloc/movie_event.dart';
import 'package:movie_viewer_db/bloc/movie_bloc/movie_state.dart';
import 'package:movie_viewer_db/bloc/base_movie_state.dart';
import 'package:movie_viewer_db/data/movie_repositories.dart';
import 'package:movie_viewer_db/util/flutter_device_type.dart';
import 'package:movie_viewer_db/view/ui/header_bg.dart';
import 'package:movie_viewer_db/view/ui/preview_movielist.dart';
import 'package:movie_viewer_db/view/ui/upcoming_movies.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _animateBg;

  @override
  void initState() {
    super.initState();

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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Stack(clipBehavior: Clip.none, children: <Widget>[
          HeaderBg(animate: _animateBg),
          SizedBox(
              height: Device.get().isPhone ? 300 : 320,
              child:
                  UpcomingMoviesWidget(key: ValueKey('UpcomingMoviesWidget')))
        ]),
        const SizedBox(height: 20),
        BlocBuilder<MovieBloc, MovieState>(buildWhen: (_, state) {
          if (state is PreviewMovieLoadedState &&
              state.movieType == MovieType.popular) {
            return true;
          }
          return false;
        }, builder: (context, state) {
          if (state is PreviewMovieLoadedState &&
              state.movies[MovieType.popular] != null) {
            return Container(
                key: ValueKey(MovieType.popular),
                height: 200,
                child: PreviewMovieList(
                    "POPULAR", state.movies[MovieType.popular]));
          }
          return Container(
              height: 200,
              child: const Center(child: const CircularProgressIndicator()));
        }),
        const SizedBox(height: 20),
        BlocBuilder<MovieBloc, MovieState>(buildWhen: (_, state) {
          if (state is PreviewMovieLoadedState &&
              state.movieType == MovieType.now_playing) {
            return true;
          }
          return false;
        }, builder: (context, state) {
          if (state is PreviewMovieLoadedState &&
              state.movies[MovieType.now_playing] != null) {
            return Container(
                key: ValueKey(MovieType.now_playing),
                height: 200,
                child: PreviewMovieList(
                    "NOW PLAYING", state.movies[MovieType.now_playing]));
          }
          return Container(
              height: 200,
              child: const Center(child: const CircularProgressIndicator()));
        }),
        const SizedBox(height: 20),
        BlocBuilder<MovieBloc, MovieState>(buildWhen: (_, state) {
          if (state is PreviewMovieLoadedState &&
              state.movieType == MovieType.upcoming) {
            return true;
          }
          return false;
        }, builder: (context, state) {
          if (state is PreviewMovieLoadedState &&
              state.movies[MovieType.upcoming] != null) {
            return Container(
                key: ValueKey(MovieType.upcoming),
                height: 200,
                child: PreviewMovieList(
                    "UPCAMING", state.movies[MovieType.upcoming]));
          }
          return Container(
              height: 200,
              child: const Center(child: const CircularProgressIndicator()));
        }),
        const SizedBox(height: 20),
        BlocBuilder<MovieBloc, MovieState>(buildWhen: (_, state) {
          if (state is PreviewMovieLoadedState &&
              state.movieType == MovieType.top_rated) {
            return true;
          }
          return false;
        }, builder: (context, state) {
          if (state is PreviewMovieLoadedState &&
              state.movies[MovieType.top_rated] != null) {
            return Container(
                key: ValueKey(MovieType.top_rated),
                height: 200,
                child: PreviewMovieList(
                    "TOP RATED", state.movies[MovieType.top_rated]));
          }
          return Container(
              height: 200,
              child: const Center(child: const CircularProgressIndicator()));
        }),
      ]),
    );
  }
}
