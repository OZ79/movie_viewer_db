import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_viewer_db/bloc/movie_bloc/movie_bloc.dart';
import 'package:movie_viewer_db/bloc/movie_bloc/movie_event.dart';
import 'package:movie_viewer_db/bloc/movie_bloc/movie_state.dart';
import 'package:movie_viewer_db/data/movie_repositories.dart';
import 'package:movie_viewer_db/view/ui/preview_movielist.dart';
import 'package:movie_viewer_db/view/ui/upcoming_movies.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<MovieBloc>(context)
      ..add(FetchMovieEvent(movieType: MovieType.upcoming));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(height: 300, child: UpcomingMoviesWidget()),
      SizedBox(
        height: 40,
      ),
      BlocBuilder<MovieBloc, MovieState>(builder: (context, state) {
        if (state is MovieLoadedState &&
            state.movieType == MovieType.upcoming) {
          return PreviewMovieList(state.movies);
        }
        return Center(child: const CircularProgressIndicator());
      }),
    ]);
  }
}
