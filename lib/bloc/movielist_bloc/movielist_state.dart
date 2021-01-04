import 'package:flutter/foundation.dart';
import '../base_movie_state.dart';

class MovieListPagesLoadedState extends MovieLoadedState {
  final int pages;
  final int totalPages;

  const MovieListPagesLoadedState({
    @required movies,
    @required this.pages,
    @required this.totalPages,
    @required movieType,
  }) : super(
          movieType: movieType,
          movies: movies,
        );

  bool get hasReachedMax => pages == totalPages;

  @override
  List<Object> get props => [movies, pages, totalPages, movieType];
}
