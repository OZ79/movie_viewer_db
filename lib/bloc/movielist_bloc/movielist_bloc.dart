import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import 'package:bloc/bloc.dart';
import 'package:movie_viewer_db/data/models/movie.dart';
import 'package:movie_viewer_db/data/models/movie_page.dart';
import 'package:movie_viewer_db/data/movie_repositories.dart';

import '../movie_event.dart';
import '../movie_state.dart';
import 'movielist_event.dart';
import 'movielist_state.dart';

class MovieListBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepositoryApi movieRepository;

  MovieListBloc({@required this.movieRepository}) : super(MovieInitialState());

  @override
  Stream<MovieState> mapEventToState(MovieEvent event) async* {
    if (event is FetchMovieListPageEvent) {
      try {
        if (event.page == 1) {
          yield MovieLoadingState();
        }

        MoviePage moviePage =
            await movieRepository.fetchMoviePage(event.movieType, event.page);
        List<Movie> movies;
        if (state is MovieListPagesLoadedState && event.page > 1) {
          movies = List.from((state as MovieListPagesLoadedState).movies);
          movies.addAll(moviePage.movies);
        } else if (event.page == 1) {
          movies = moviePage.movies;
        }

        yield MovieListPagesLoadedState(
            movies: movies,
            pages: moviePage.page,
            totalPages: moviePage.totalPages,
            movieType: event.movieType);
      } catch (e) {
        print(e.toString());
        yield MovieErrorState(message: e.toString());
      }
    }

    /*if (event is FetchMovieDetailEvent) {
      yield MovieLoadingState();
      try {
        MovieDetail movieDetail =
            await movieRepository.fetchMovieDetail(event.movieId);
        yield MovieDetailLoadedState(movieDetail: movieDetail);
      } catch (e) {
        yield MovieErrorState(message: e.toString());
      }
    }*/
  }

  @override
  Stream<Transition<MovieEvent, MovieState>> transformEvents(
      Stream<MovieEvent> events, transitionFn) {
    return events.switchMap(transitionFn);
  }
}
