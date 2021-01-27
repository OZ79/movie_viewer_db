import 'package:flutter/foundation.dart';
import '../base_movie_event.dart';

class FetchMovieListPageEvent extends FetchMovieEvent {
  final int page;

  const FetchMovieListPageEvent({@required movieType, @required this.page})
      : super(movieType: movieType);

  @override
  List<Object> get props => [movieType, page];
}

class FetchMovieListPageBySearchEvent extends MovieEvent {
  final String query;
  final int page;

  const FetchMovieListPageBySearchEvent(
      {@required this.query, @required this.page});

  @override
  List<Object> get props => [query, page];
}
