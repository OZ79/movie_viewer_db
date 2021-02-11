import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class NavigationState extends Equatable {
  final int pageIndex;
  final bool bottom;

  const NavigationState({@required this.pageIndex, this.bottom = true});

  @override
  List<Object> get props => [pageIndex, bottom];
}
