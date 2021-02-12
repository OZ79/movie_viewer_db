import 'dart:async';

import 'package:bloc/bloc.dart';
import 'navigation_event.dart';
import 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigateToEvent, NavigationState> {
  NavigationBloc() : super(NavigationState(pageIndex: 0));

  @override
  Stream<NavigationState> mapEventToState(
    NavigateToEvent event,
  ) async* {
    if (event is NavigateToEvent) {
      yield NavigationState(
          pageIndex: event.pageIndex,
          movieType: event.movieType,
          bottom: event.bottom);
    }
  }
}
