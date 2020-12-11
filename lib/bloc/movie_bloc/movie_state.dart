import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_viewer_db/data/models/movie.dart';
import 'package:movie_viewer_db/data/models/movie_detail.dart';
import 'package:movie_viewer_db/data/movie_repositories.dart';

abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object> get props => [];
}

class MovieInitialState extends MovieState {
  const MovieInitialState();
}

class MovieLoadingState extends MovieState {
  const MovieLoadingState();
}

class MovieLoadedState extends MovieState {
  final List<Movie> movies;
  final MovieType movieType;

  const MovieLoadedState({@required this.movies, @required this.movieType});

  @override
  List<Object> get props => [movies, movieType];
}

class MoviePagesLoadedState extends MovieState {
  final List<Movie> movies;
  final int pages;
  final int totalPages;
  final MovieType movieType;

  const MoviePagesLoadedState({
    @required this.movies,
    @required this.pages,
    @required this.totalPages,
    @required this.movieType,
  });

  bool get hasReachedMax => pages == totalPages;

  @override
  List<Object> get props => [movies, pages, totalPages, movieType];
}

class MovieDetailLoadedState extends MovieState {
  final MovieDetail movieDetail;

  const MovieDetailLoadedState({@required this.movieDetail});

  @override
  List<Object> get props => [movieDetail];
}

class MovieErrorState extends MovieState {
  final String message;

  MovieErrorState({@required this.message});

  @override
  List<Object> get props => [message];
}
