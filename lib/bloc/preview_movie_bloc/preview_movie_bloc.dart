import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_viewer_db/data/models/movie.dart';
import 'package:movie_viewer_db/data/movie_repositories.dart';

import '../movie_event.dart';
import '../movie_state.dart';
import 'preview_movie_event.dart';
import 'preview_movie_state.dart';

class PreviewMovieListBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepositoryApi movieRepository;

  PreviewMovieListBloc({@required this.movieRepository})
      : super(MovieInitialState());

  @override
  Stream<MovieState> mapEventToState(MovieEvent event) async* {
    if (event is FetchPreviewMovieEvent) {
      yield MovieLoadingState();
      try {
        List<Movie> movies = await movieRepository.fetchMovies(event.movieType);
        yield PreviewMovieLoadedState(
            movies: movies, movieType: event.movieType);
      } catch (e) {
        yield MovieErrorState(message: e.toString());
      }
    }
  }
}
