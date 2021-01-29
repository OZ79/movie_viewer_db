import 'package:flutter/foundation.dart';
import 'package:movie_viewer_db/data/models/movie.dart';
import 'package:movie_viewer_db/data/movie_repositories.dart';
import '../base_movie_state.dart';

class MovieListPagesLoadedState extends MovieLoadedState {
  final List<Movie> movies;
  final int pages;
  final int totalPages;

  const MovieListPagesLoadedState({
    @required this.movies,
    @required this.pages,
    @required this.totalPages,
    movieType = MovieType.none,
  }) : super(
          movieType: movieType,
        );

  bool get hasReachedMax => pages == totalPages;

  @override
  List<Object> get props => [movies, pages, totalPages, movieType];
}

class MovieListPagesBySearchLoadedState extends MovieListPagesLoadedState {
  final List<Movie> movies;
  final int pages;
  final int totalPages;

  const MovieListPagesBySearchLoadedState({
    @required this.movies,
    @required this.pages,
    @required this.totalPages,
    movieType = MovieType.none,
  }) : super(
          movies: movies,
          pages: pages,
          totalPages: totalPages,
          movieType: movieType,
        );

  bool get hasReachedMax => pages == totalPages;

  @override
  List<Object> get props => [movies, pages, totalPages, movieType];
}
