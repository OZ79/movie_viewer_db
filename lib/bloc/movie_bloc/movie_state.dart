import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_viewer_db/data/models/movie.dart';

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
  final List<Movie> _movies;

  const MovieLoadedState({@required movies}) : _movies = movies;

  get movies => _movies;

  @override
  List<Object> get props => [_movies];
}

class MovieErrorState extends MovieState {
  final String message;

  MovieErrorState({@required this.message});

  @override
  List<Object> get props => [message];
}
