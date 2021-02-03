import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:bloc/bloc.dart';
import 'package:movie_viewer_db/data/models/movie.dart';
import 'package:movie_viewer_db/data/models/movie_page.dart';
import 'package:movie_viewer_db/data/movie_repositories.dart';

import '../base_movie_event.dart';
import '../base_movie_state.dart';
import 'moviesearch_event.dart';
import 'moviesearch_state.dart';

class MovieSearchBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepositoryApi movieRepository;

  MovieSearchBloc({@required this.movieRepository})
      : super(MovieInitialState());

  @override
  Stream<MovieState> mapEventToState(MovieEvent event) async* {
    if (event is FetchMovieListPageBySearchEvent) {
      try {
        MoviePage moviePage;
        List<Movie> movies;

        if (event.page == 1) {
          yield MovieLoadingState();

          moviePage = await movieRepository.fetchMoviePageBySearch(
              event.query, event.page);
          movies = moviePage.movies;
        } else {
          moviePage = await movieRepository.fetchMoviePageBySearch(
              event.query, event.page);
          movies =
              List.from((state as MovieListPagesBySearchLoadedState).movies);
          movies.addAll(moviePage.movies);
        }

        yield MovieListPagesBySearchLoadedState(
          movies: movies,
          pages: moviePage.page,
          totalPages: moviePage.totalPages,
        );
      } catch (e) {
        print(e.toString());
        yield MovieErrorState(message: e.toString());
      }
    }
  }

  /*@override
  Stream<Transition<MovieEvent, MovieState>> transformEvents(
      Stream<MovieEvent> events, transitionFn) {
    return events.switchMap(transitionFn);
  }*/
}
