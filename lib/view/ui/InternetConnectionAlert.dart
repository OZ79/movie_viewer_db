import 'dart:io';

import 'package:flutter/cupertino.dart';
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
            if (Platform.isAndroid) {
              _showMaterialDialog();
            } else if (Platform.isIOS) {
              _showCupertinoDialog();
            }

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
          return AlertDialog(
            title: const Text("Offline"),
            content: Row(children: [
              const Icon(Icons.cloud_off, size: 40, color: Colors.blue),
              const SizedBox(width: 10),
              const Flexible(
                child: const FractionallySizedBox(
                  child: const Text(
                      "Your network is unavailable. Check your data or wifi connection."),
                ),
              )
            ]),
            actions: <Widget>[
              TextButton(
                child: Text('RETRY'),
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

  _showCupertinoDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text("Offline"),
            content: Row(children: [
              const Icon(Icons.cloud_off, size: 40, color: Colors.blue),
              const SizedBox(width: 10),
              const Flexible(
                child: const FractionallySizedBox(
                  child: const Text(
                      "Your network is unavailable. Check your data or wifi connection."),
                ),
              )
            ]),
            actions: <Widget>[
              TextButton(
                child: Text('RETRY'),
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
