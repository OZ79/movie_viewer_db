import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_viewer_db/bloc/movie_detail_bloc/movie_detail_bloc.dart';
import 'package:movie_viewer_db/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:movie_viewer_db/bloc/navigation_bloc/navigation_event.dart';
import 'package:movie_viewer_db/data/models/movie.dart';
import 'package:movie_viewer_db/data/movie_repositories.dart';
import 'package:movie_viewer_db/view/screens/movie_detail_screen.dart';

import '../../config.dart';
import 'star_rating.dart';

class PreviewMovieList extends StatelessWidget {
  final MovieType movieType;
  final String title;
  final List<Movie> data;
  // ignore: close_sinks
  final MovieDetailBloc movieDetailBloc;
  // ignore: close_sinks
  final NavigationBloc navigationBloc;

  const PreviewMovieList({
    Key key,
    this.movieType,
    this.title,
    this.data,
    this.movieDetailBloc,
    this.navigationBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: const Color(0xFF1E88E5)),
            ),
            GestureDetector(
              onTap: () {
                navigationBloc
                    .add(NavigateToEvent(pageIndex: 1, movieType: movieType));
              },
              child: const Text(
                "See more ...",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: const Color(0xFF1E88E5)),
              ),
            ),
          ]),
        ),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: data.length,
            itemBuilder: (context, index) {
              final movie = data[index];
              return MovieItem(
                  movieId: movie.id,
                  key: ValueKey('MovieItem_${movie.poster}'),
                  title: movie.title,
                  imageUrl: "$IMAGE_URL_92${movie.poster}",
                  rating: movie.rating,
                  movieDetailBloc: movieDetailBloc,
                  navigationBloc: navigationBloc);
            },
          ),
        )
      ],
    );
  }
}

class MmovieDetailBloc {}

class MovieItem extends StatelessWidget {
  final int movieId;
  final String title;
  final String imageUrl;
  final double rating;
  // ignore: close_sinks
  final MovieDetailBloc movieDetailBloc;
  // ignore: close_sinks
  final NavigationBloc navigationBloc;

  const MovieItem(
      {key,
      @required this.movieId,
      @required this.title,
      @required this.imageUrl,
      @required this.rating,
      @required this.movieDetailBloc,
      @required this.navigationBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageHeight = 105.0;
    return GestureDetector(
      onTap: () {
        navigationBloc.add(NavigateToEvent(
            pageIndex: navigationBloc.state.pageIndex, bottom: false));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return BlocProvider.value(
              value: movieDetailBloc,
              child: MovieDetailScreen(movieId),
            );
          }),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                key: ValueKey(imageUrl),
                height: imageHeight,
                child: ClipRRect(
                  clipBehavior: Clip.hardEdge,
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(12)),
                  child: Image(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(imageUrl)),
                ),
              ),
              SizedBox(
                width: imageHeight * 0.667,
                child: Text(
                  title,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: const Color(0xFF1E88E5)),
                ),
              ),
              StarRating(
                rating: rating * 0.5,
                size: 14,
                color: Colors.yellow[700],
                borderColor: Colors.yellow[700],
              ),
            ]),
      ),
    );
  }
}
