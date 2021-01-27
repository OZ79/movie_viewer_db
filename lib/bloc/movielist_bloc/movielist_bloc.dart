import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:movie_viewer_db/data/data_cache.dart';
import 'package:rxdart/rxdart.dart';

import 'package:bloc/bloc.dart';
import 'package:movie_viewer_db/data/models/movie.dart';
import 'package:movie_viewer_db/data/models/movie_page.dart';
import 'package:movie_viewer_db/data/movie_repositories.dart';

import '../base_movie_event.dart';
import '../base_movie_state.dart';
import 'movielist_event.dart';
import 'movielist_state.dart';

class MovieListBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepositoryApi movieRepository;

  MovieListBloc({@required this.movieRepository}) : super(MovieInitialState());

  @override
  Stream<MovieState> mapEventToState(MovieEvent event) async* {
    if (event is FetchMovieListPageEvent) {
      try {
        MoviePage moviePage;
        List<Movie> movies;

        if (event.page == 1) {
          if (DataCache.containsMoviePage(event.movieType, event.page)) {
            moviePage = DataCache.geLastMoviePage(event.movieType);
            movies = DataCache.getMovies(event.movieType);
          } else {
            yield MovieLoadingState();

            moviePage = await movieRepository.fetchMoviePage(
                event.movieType, event.page);
            movies = moviePage.movies;
            DataCache.addMoviePage(event.movieType, moviePage);
          }
        } else {
          moviePage =
              await movieRepository.fetchMoviePage(event.movieType, event.page);
          movies = List.from((state as MovieListPagesLoadedState).movies);
          movies.addAll(moviePage.movies);
          DataCache.addMoviePage(event.movieType, moviePage);
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
          movies = List.from((state as MovieListPagesLoadedState).movies);
          movies.addAll(moviePage.movies);
        }

        yield MovieListPagesLoadedState(
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

  @override
  Stream<Transition<MovieEvent, MovieState>> transformEvents(
      Stream<MovieEvent> events, transitionFn) {
    return events.switchMap(transitionFn);
  }
}
