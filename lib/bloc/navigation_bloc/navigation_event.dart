import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class NavigationEvent extends Equatable {
  final int pageIndex;

  const NavigationEvent({@required this.pageIndex});

  @override
  List<Object> get props => [pageIndex];
}
