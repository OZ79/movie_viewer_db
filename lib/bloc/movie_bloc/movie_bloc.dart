import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:movie_viewer_db/data/models/movie.dart';
import 'package:movie_viewer_db/data/models/movie_detail.dart';
import 'package:movie_viewer_db/data/models/movie_page.dart';
import 'package:movie_viewer_db/data/movie_repositories.dart';

import './movie_event.dart';
import './movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepositoryApi movieRepository;

  MovieBloc({@required this.movieRepository}) : super(MovieInitialState());

  @override
  Stream<MovieState> mapEventToState(MovieEvent event) async* {
    if (event is FetchMovieEvent) {
      yield MovieLoadingState();
      try {
        List<Movie> movies = await movieRepository.fetchMovies(event.movieType);
        yield MovieLoadedState(movies: movies, movieType: event.movieType);
      } catch (e) {
        yield MovieErrorState(message: e.toString());
      }
    }

    if (event is FetchMoviePageEvent) {
      try {
        if (event.page == 1) {
          yield MovieLoadingState();
        }

        MoviePage moviePage =
            await movieRepository.fetchMoviePage(event.movieType, event.page);
        List<Movie> movies;
        if (state is MoviePagesLoadedState && event.page > 1) {
          movies = (state as MoviePagesLoadedState).movies;
          movies.addAll(moviePage.movies);
        } else if (event.page == 1) {
          movies = moviePage.movies;
        }

        yield MoviePagesLoadedState(
            movies: movies,
            pages: moviePage.page,
            totalPages: moviePage.totalPages,
            movieType: event.movieType);
      } catch (e) {
        print(e.toString());
        yield MovieErrorState(message: e.toString());
      }
    }

    if (event is FetchMovieDetailEvent) {
      yield MovieLoadingState();
      try {
        MovieDetail movieDetail =
            await movieRepository.fetchMovieDetail(event.movieId);
        yield MovieDetailLoadedState(movieDetail: movieDetail);
      } catch (e) {
        yield MovieErrorState(message: e.toString());
      }
    }
  }

  /*@override
  Stream<Transition<MovieEvent, MovieState>> transformEvents(
      Stream<MovieEvent> events, transitionFn) {
    return events.switchMap(transitionFn);

    /*final nonDebounceStream = events.where((event) {
      return (event is! FetchMoviePageEvent ||
          (event is FetchMoviePageEvent && event.page != 1));
    });

    final debounceStream = events.where((event) {
      return (event is FetchMoviePageEvent && event.page == 1);
    }).debounceTime(Duration(milliseconds: 300));

    return nonDebounceStream
        .mergeWith([debounceStream]).switchMap(transitionFn);*/
  }*/
}
