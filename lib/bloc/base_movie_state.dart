import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_viewer_db/data/movie_repositories.dart';

import 'base_movie_event.dart';

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
  final dynamic exception;
  final MovieEvent event;

  MovieErrorState({@required this.exception, this.event});

  bool get isOffline => (exception is SocketException &&
      (exception as SocketException)?.osError?.errorCode == 7);

  @override
  List<Object> get props => [exception];
}
