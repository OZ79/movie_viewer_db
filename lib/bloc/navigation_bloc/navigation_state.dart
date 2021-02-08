import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class NavigationState extends Equatable {
  final int pageIndex;

  const NavigationState({@required this.pageIndex});

  @override
  List<Object> get props => [pageIndex];
}
