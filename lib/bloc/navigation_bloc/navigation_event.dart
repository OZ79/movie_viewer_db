import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_viewer_db/data/movie_repositories.dart';

class NavigateToEvent extends Equatable {
  final int pageIndex;
  final MovieType movieType;
  final bool bottom;

  const NavigateToEvent(
      {@required this.pageIndex,
      this.movieType = MovieType.none,
      this.bottom = true});

  @override
  List<Object> get props => [pageIndex];
}
