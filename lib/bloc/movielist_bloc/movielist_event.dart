import 'package:flutter/foundation.dart';
import '../movie_event.dart';

class FetchMovieListPageEvent extends FetchMovieEvent {
  final int page;

  const FetchMovieListPageEvent({@required movieType, @required this.page})
      : super(movieType: movieType);

  @override
  List<Object> get props => [movieType, page];
}
