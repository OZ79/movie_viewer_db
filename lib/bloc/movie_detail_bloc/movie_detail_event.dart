import 'package:flutter/foundation.dart';
import '../base_movie_event.dart';

class FetchMovieDetailEvent extends MovieEvent {
  final int movieId;

  const FetchMovieDetailEvent({@required this.movieId});

  @override
  List<Object> get props => [movieId];
}
