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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    loadPage();
  }

  void loadPage([int page = 1]) {
    if (_isLoading) {
      return;
    }

    _isLoading = true;
    BlocProvider.of<MovieBloc>(context)
      ..add(FetchMoviePageEvent(movieType: MovieType.top_rated, page: page));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieBloc, MovieState>(builder: (context, state) {
      if (state is MoviePagesLoadedState) {
        _isLoading = false;
        return ListView.builder(
            itemCount: state.hasReachedMax
                ? state.movies.length
                : state.movies.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index >= state.movies.length) {
                loadPage(state.pages + 1);
                return Center(child: const CircularProgressIndicator());
              } else {
                final movie = state.movies[index];
                return MovieIem(
                  movieId: movie.id,
                  title: movie.title,
                  releaseDate: movie.releaseDate,
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
  final int movieId;
  final String title;
  final String releaseDate;
  final String overview;
  final String imageUrl;
  final double rating;

  const MovieIem(
      {@required this.movieId,
      @required this.title,
      @required this.releaseDate,
      @required this.overview,
      @required this.imageUrl,
      @required this.rating});

  @override
  Widget build(BuildContext context) {
    final imageHeight = 138.0;
    return GestureDetector(
      onTap: () {
        print(movieId);
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              offset: const Offset(1, 1),
              blurRadius: 1,
              color: Colors.black12,
            )
          ],
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: 92,
                  height: imageHeight,
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(15),
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5)),
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
                        width: MediaQuery.of(context).size.width - 120,
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
                      Text(
                        releaseDate,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            fontSize: 14, color: const Color(0xFF1E88E5)),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 120,
                        child: Text(
                          overview,
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          maxLines: 3,
                          style: const TextStyle(
                              fontSize: 16, color: const Color(0xFF1E88E5)),
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
      ),
    );
  }
}
