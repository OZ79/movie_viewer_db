import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_viewer_db/data/models/movie_detail.dart';
import 'package:movie_viewer_db/data/movie_repositories.dart';

import '../base_movie_event.dart';
import '../base_movie_state.dart';
import 'movie_detail_event.dart';
import 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepositoryApi movieRepository;

  MovieDetailBloc({@required this.movieRepository})
      : super(MovieInitialState());

  @override
  Stream<MovieState> mapEventToState(MovieEvent event) async* {
    if (event is FetchMovieDetailEvent) {
      yield MovieLoadingState();

      try {
        MovieDetail movieDetail =
            await movieRepository.fetchMovieDetail(event.movieId);

        yield MovieDetailLoadedState(
            movieId: event.movieId, movieDetail: movieDetail);
      } catch (e) {
        yield MovieErrorState(message: e.toString());
      }
    }
  }
}
