import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class NavigationEvent extends Equatable {
  final int pageIndex;
  final bool bottom;

  const NavigationEvent({@required this.pageIndex, this.bottom = true});

  @override
  List<Object> get props => [pageIndex];
}
