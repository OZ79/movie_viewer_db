import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:movie_viewer_db/data/models/movie.dart';
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
        MoviePage moviePage =
            await movieRepository.fetchMoviePage(event.movieType, event.page);
        List<Movie> movies;
        if (state is MoviePagesLoadedState) {
          movies = (state as MoviePagesLoadedState).movies;
          movies.addAll(moviePage.movies);
        } else {
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
  }
}
