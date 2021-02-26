import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_viewer_db/bloc/base_movie_event.dart';
import 'package:movie_viewer_db/bloc/base_movie_state.dart';

mixin InternetConnectionAlert<T extends StatefulWidget,
    R extends Bloc<MovieEvent, MovieState>> on State<T> {
  bool isDialogOpened = false;
  List<MovieEvent> events = [];

  @mustCallSuper
  @override
  Widget build(BuildContext context) {
    return BlocListener<R, MovieState>(
        cubit: bloc,
        listenWhen: (previousState, state) {
          if (state is MovieErrorState && state.isOffline) {
            return true;
          }
          return false;
        },
        listener: (context, state) {
          if (!isDialogOpened) {
            _showMaterialDialog();
            isDialogOpened = true;
          }
          events.add((state as MovieErrorState).event);
        },
        child: getContent());
  }

  _showMaterialDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text("Material Dialog"),
            content: new Text("Hey! I'm Coflutter!"),
            actions: <Widget>[
              FlatButton(
                child: Text('Close me!'),
                onPressed: () {
                  doActionBeforeCloseDialog();
                  Navigator.of(context).pop();
                  isDialogOpened = false;
                  Future.delayed(Duration(milliseconds: 50), () {
                    events.forEach((event) {
                      bloc.add(event);
                    });
                    events.clear();
                  });
                },
              )
            ],
          );
        });
  }

  R get bloc;

  Widget getContent();

  void doActionBeforeCloseDialog() {}
}
