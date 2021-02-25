import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
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
  final MovieType movieType;

  const MovieLoadedState({this.movieType = MovieType.none});

  @override
  List<Object> get props => [movieType];
}

class MovieErrorState extends MovieState {
  final String message;

  MovieErrorState({@required this.message});

  @override
  List<Object> get props => [message];
}
