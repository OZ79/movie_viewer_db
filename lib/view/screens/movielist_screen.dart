import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_viewer_db/bloc/movie_bloc/movie_bloc.dart';
import 'package:movie_viewer_db/bloc/movie_bloc/movie_event.dart';
import 'package:movie_viewer_db/bloc/movie_bloc/movie_state.dart';
import 'package:movie_viewer_db/data/movie_repositories.dart';
import 'package:movie_viewer_db/view/ui/star_rating.dart';

import '../../config.dart';

class MovieListScreen extends StatefulWidget {
  MovieListScreen();

  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  @override
  void initState() {
    super.initState();

    loadPage(1);
  }

  void loadPage(int page) {
    BlocProvider.of<MovieBloc>(context)
      ..add(FetchMoviePageEvent(movieType: MovieType.upcoming, page: page));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieBloc, MovieState>(builder: (context, state) {
      if (state is MoviePagesLoadedState) {
        print("LOADED:");
        print("pages:${state.pages}");
        print("totalPages:${state.totalPages}");
        return ListView.builder(
            itemCount: state.hasReachedMax
                ? state.movies.length
                : state.movies.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index >= state.movies.length) {
                print("LOAD");
                loadPage(state.pages + 1);
                return Center(child: const CircularProgressIndicator());
              } else {
                final movie = state.movies[index];
                return MovieIem(
                  title: movie.title,
                  overview: movie.overview,
                  imageUrl: "$IMAGE_URL_92${movie.poster}",
                  rating: movie.rating,
                );
              }
            });
      }
      return Center(child: const CircularProgressIndicator());
    });
  }
}

class MovieIem extends StatelessWidget {
  final String title;
  final String overview;
  final String imageUrl;
  final double rating;

  const MovieIem(
      {@required this.title,
      @required this.overview,
      @required this.imageUrl,
      @required this.rating});

  @override
  Widget build(BuildContext context) {
    final imageHeight = 138.0;
    return Container(
      margin: const EdgeInsets.all(5),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: 92,
                height: imageHeight,
                child: ClipRRect(
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(12)),
                    child: !imageUrl.contains("null")
                        ? Image(
                            fit: BoxFit.cover, image: NetworkImage(imageUrl))
                        : const Icon(Icons.movie))),
            const SizedBox(width: 8),
            Container(
              //color: Colors.yellow,
              height: imageHeight,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 290,
                      child: Text(
                        title,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: const Color(0xFF1E88E5)),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: Text(
                        overview,
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 4,
                        style: const TextStyle(
                            //fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: const Color(0xFF1E88E5)),
                      ),
                    ),
                    StarRating(
                      rating: rating * 0.5,
                      size: 14,
                      color: Colors.yellow[700],
                      borderColor: Colors.yellow[700],
                      mainAxisAlignment: MainAxisAlignment.start,
                    )
                  ]),
            )
          ]),
    );
  }
}
