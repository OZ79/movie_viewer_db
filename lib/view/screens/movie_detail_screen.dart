import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_viewer_db/bloc/base_movie_state.dart';
import 'package:movie_viewer_db/bloc/movie_bloc/movie_bloc.dart';
import 'package:movie_viewer_db/bloc/movie_bloc/movie_event.dart';
import 'package:movie_viewer_db/bloc/movie_bloc/movie_state.dart';

class MovieDetailScreen extends StatefulWidget {
  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  void initState() {
    super.initState();

    loadData();
  }

  void loadData() {
    BlocProvider.of<MovieBloc>(context)
      ..add(FetchMovieDetailEvent(movieId: 464052));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: BlocBuilder<MovieBloc, MovieState>(
      buildWhen: (_, state) {
        if (state is MovieDetailLoadedState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is MovieDetailLoadedState) {
          print(state.movieDetail);
          return Container();
        }
        return Center(child: const CircularProgressIndicator());
      },
    ));
  }
}
