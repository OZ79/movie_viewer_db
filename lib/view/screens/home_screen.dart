import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_viewer_db/bloc/movie_state.dart';
import 'package:movie_viewer_db/bloc/preview_movie_bloc/preview_movie_bloc.dart';
import 'package:movie_viewer_db/bloc/preview_movie_bloc/preview_movie_event.dart';
import 'package:movie_viewer_db/bloc/preview_movie_bloc/preview_movie_state.dart';
import 'package:movie_viewer_db/data/movie_repositories.dart';
import 'package:movie_viewer_db/util/flutter_device_type.dart';
import 'package:movie_viewer_db/view/ui/header_bg.dart';
import 'package:movie_viewer_db/view/ui/preview_movielist.dart';
import 'package:movie_viewer_db/view/ui/upcoming_movies.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    loadData();
  }

  void loadData() {
    BlocProvider.of<PreviewMovieListBloc>(context)
      ..add(FetchPreviewMovieEvent(movieType: MovieType.popular));

    BlocProvider.of<PreviewMovieListBloc>(context)
      ..add(FetchPreviewMovieEvent(movieType: MovieType.now_playing));

    BlocProvider.of<PreviewMovieListBloc>(context)
      ..add(FetchPreviewMovieEvent(movieType: MovieType.upcoming));

    BlocProvider.of<PreviewMovieListBloc>(context)
      ..add(FetchPreviewMovieEvent(movieType: MovieType.top_rated));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Stack(children: <Widget>[
          const HeaderBg(),
          SizedBox(
              height: Device.get().isPhone ? 300 : 320,
              child: UpcomingMoviesWidget())
        ]),
        const SizedBox(height: 20),
        BlocBuilder<PreviewMovieListBloc, MovieState>(buildWhen: (_, state) {
          if (state is PreviewMovieLoadedState &&
              state.movieType == MovieType.popular) {
            return true;
          }
          return false;
        }, builder: (context, state) {
          if (state is PreviewMovieLoadedState &&
              state.movieType == MovieType.popular) {
            return Container(
                height: 200, child: PreviewMovieList("POPULAR", state.movies));
          }
          return Container(
              height: 200,
              child: Center(child: const CircularProgressIndicator()));
        }),
        const SizedBox(height: 20),
        BlocBuilder<PreviewMovieListBloc, MovieState>(buildWhen: (_, state) {
          if (state is PreviewMovieLoadedState &&
              state.movieType == MovieType.now_playing) {
            return true;
          }
          return false;
        }, builder: (context, state) {
          if (state is PreviewMovieLoadedState &&
              state.movieType == MovieType.now_playing) {
            return Container(
                height: 200,
                child: PreviewMovieList("NOW PLAYING", state.movies));
          }
          return Container(
              height: 200,
              child: Center(child: const CircularProgressIndicator()));
        }),
        const SizedBox(height: 20),
        BlocBuilder<PreviewMovieListBloc, MovieState>(buildWhen: (_, state) {
          if (state is PreviewMovieLoadedState &&
              state.movieType == MovieType.upcoming) {
            return true;
          }
          return false;
        }, builder: (context, state) {
          if (state is PreviewMovieLoadedState &&
              state.movieType == MovieType.upcoming) {
            return Container(
                height: 200, child: PreviewMovieList("UPCAMING", state.movies));
          }
          return Container(
              height: 200,
              child: Center(child: const CircularProgressIndicator()));
        }),
        const SizedBox(height: 20),
        BlocBuilder<PreviewMovieListBloc, MovieState>(buildWhen: (_, state) {
          if (state is PreviewMovieLoadedState &&
              state.movieType == MovieType.top_rated) {
            return true;
          }
          return false;
        }, builder: (context, state) {
          if (state is PreviewMovieLoadedState &&
              state.movieType == MovieType.top_rated) {
            return Container(
                height: 200,
                child: PreviewMovieList("TOP RATED", state.movies));
          }
          return Container(
              height: 200,
              child: Center(child: const CircularProgressIndicator()));
        }),
      ]),
    );
  }
}
