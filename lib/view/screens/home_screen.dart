import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_viewer_db/bloc/movie_bloc/movie_bloc.dart';
import 'package:movie_viewer_db/bloc/movie_bloc/movie_event.dart';
import 'package:movie_viewer_db/bloc/movie_bloc/movie_state.dart';
import 'package:movie_viewer_db/data/movie_repositories.dart';
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

  void loadData() async {
    BlocProvider.of<MovieBloc>(context)
      ..add(FetchMovieEvent(movieType: MovieType.popular));

    BlocProvider.of<MovieBloc>(context)
      ..add(FetchMovieEvent(movieType: MovieType.now_playing));

    BlocProvider.of<MovieBloc>(context)
      ..add(FetchMovieEvent(movieType: MovieType.upcoming));

    BlocProvider.of<MovieBloc>(context)
      ..add(FetchMovieEvent(movieType: MovieType.top_rated));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        SizedBox(height: 300, child: UpcomingMoviesWidget()),
        SizedBox(height: 20),
        BlocBuilder<MovieBloc, MovieState>(buildWhen: (_, state) {
          if (state is MovieLoadedState &&
              state.movieType == MovieType.popular) {
            return true;
          }
          return false;
        }, builder: (context, state) {
          if (state is MovieLoadedState &&
              state.movieType == MovieType.popular) {
            return Container(
                height: 200, child: PreviewMovieList("POPULAR", state.movies));
          }
          return Center(child: const CircularProgressIndicator());
        }),
        SizedBox(height: 20),
        BlocBuilder<MovieBloc, MovieState>(buildWhen: (_, state) {
          if (state is MovieLoadedState &&
              state.movieType == MovieType.now_playing) {
            return true;
          }
          return false;
        }, builder: (context, state) {
          if (state is MovieLoadedState &&
              state.movieType == MovieType.now_playing) {
            return Container(
                height: 200,
                child: PreviewMovieList("NOW PLAYING", state.movies));
          }
          return Center(child: const CircularProgressIndicator());
        }),
        SizedBox(height: 20),
        BlocBuilder<MovieBloc, MovieState>(buildWhen: (_, state) {
          if (state is MovieLoadedState &&
              state.movieType == MovieType.upcoming) {
            return true;
          }
          return false;
        }, builder: (context, state) {
          if (state is MovieLoadedState &&
              state.movieType == MovieType.upcoming) {
            return Container(
                height: 200, child: PreviewMovieList("UPCAMING", state.movies));
          }
          return Center(child: const CircularProgressIndicator());
        }),
        SizedBox(height: 20),
        BlocBuilder<MovieBloc, MovieState>(buildWhen: (_, state) {
          if (state is MovieLoadedState &&
              state.movieType == MovieType.top_rated) {
            return true;
          }
          return false;
        }, builder: (context, state) {
          if (state is MovieLoadedState &&
              state.movieType == MovieType.top_rated) {
            return Container(
                height: 200,
                child: PreviewMovieList("TOP RATED", state.movies));
          }
          return Center(child: const CircularProgressIndicator());
        }),
      ]),
    );
  }
}
