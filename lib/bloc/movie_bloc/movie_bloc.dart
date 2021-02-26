import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_viewer_db/data/models/movie.dart';
import 'package:movie_viewer_db/data/movie_repositories.dart';

import '../base_movie_event.dart';
import '../base_movie_state.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepositoryApi movieRepository;
  Map<MovieType, List<Movie>> _movies = {};

  MovieBloc({@required this.movieRepository}) : super(MovieInitialState());

  @override
  Stream<MovieState> mapEventToState(MovieEvent event) async* {
    if (state is PreviewMovieLoadedState) {
      _movies = (state as PreviewMovieLoadedState).movies;
    }

    if (event is FetchPreviewMovieEvent) {
      try {
        List<Movie> movies = await movieRepository.fetchMovies(event.movieType);
        _movies[event.movieType] = movies;

        yield PreviewMovieLoadedState(
            movies: _movies, movieType: event.movieType);
      } catch (e) {
        print(e);
        yield MovieErrorState(exception: e, event: event);
      }
    }
  }
}
