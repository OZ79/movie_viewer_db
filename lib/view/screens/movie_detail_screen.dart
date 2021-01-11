import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_viewer_db/bloc/base_movie_state.dart';
import 'package:movie_viewer_db/bloc/movie_bloc/movie_bloc.dart';
import 'package:movie_viewer_db/bloc/movie_bloc/movie_event.dart';
import 'package:movie_viewer_db/bloc/movie_bloc/movie_state.dart';
import 'package:movie_viewer_db/view/ui/poster.dart';
import 'package:movie_viewer_db/view/ui/rating.dart';
import 'package:movie_viewer_db/view/ui/star_rating.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../config.dart';

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
      ..add(FetchMovieDetailEvent(movieId: 675327));
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
            final movieDetail = state.movieDetail;
            final backPosterUrl = '$IMAGE_URL_500${movieDetail.backPoster}';
            final posterUrl = '$IMAGE_URL_154${movieDetail.poster}';

            return Stack(children: [
              Column(children: [
                !backPosterUrl.contains("null")
                    ? FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                        fadeInDuration: const Duration(milliseconds: 200),
                        image: backPosterUrl)
                    : const Icon(Icons.movie),
                Padding(
                  padding: const EdgeInsets.only(top: 3, bottom: 15),
                  child: Row(children: [
                    SizedBox(width: 165),
                    Column(children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width - 165,
                          child: Rating(movieDetail.rating)),
                      Text(movieDetail.releaseDate,
                          style: TextStyle(
                            fontSize: 18,
                            color: const Color(0xFF1E88E5),
                          ))
                    ])
                  ]),
                ),
                Text(movieDetail.title,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: const Color(0xFF1E88E5),
                    )),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    movieDetail.overview,
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    maxLines: 20,
                    style:
                        TextStyle(fontSize: 21, color: const Color(0xFF1E88E5)),
                  ),
                ),
              ]),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 251,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          stops: [
                        0.01,
                        0.2,
                        0.85,
                        1
                      ],
                          colors: [
                        Colors.white,
                        Colors.white.withOpacity(0.87),
                        Colors.white.withOpacity(0.14),
                        Colors.white.withOpacity(0.0)
                      ]))),
              Poster(posterUrl: posterUrl)
            ]);
          }
          return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Center(child: const CircularProgressIndicator()));
        },
      ),
    );
  }
}
