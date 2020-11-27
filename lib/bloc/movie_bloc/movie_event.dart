import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_viewer_db/data/movie_repositories.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object> get props => [];
}

class FetchMovieEvent extends MovieEvent {
  final MovieType movieType;
  final int page;

  const FetchMovieEvent({@required this.movieType, this.page = 1});

  @override
  List<Object> get props => [movieType, page];
}
