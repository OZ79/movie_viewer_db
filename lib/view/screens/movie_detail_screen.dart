import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_viewer_db/bloc/base_movie_state.dart';
import 'package:movie_viewer_db/bloc/movie_bloc/movie_bloc.dart';
import 'package:movie_viewer_db/bloc/movie_bloc/movie_event.dart';
import 'package:movie_viewer_db/bloc/movie_bloc/movie_state.dart';
import 'package:movie_viewer_db/data/models/movie_detail.dart';
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
      ..add(FetchMovieDetailEvent(movieId: 531219));
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
            final backPoster = '$IMAGE_URL_500${movieDetail.backPoster}';
            final poster = '$IMAGE_URL_154${movieDetail.poster}';

            return Stack(children: [
              Column(children: [
                !backPoster.contains("null")
                    ? FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                        fadeInDuration: const Duration(milliseconds: 200),
                        image: backPoster)
                    : const Icon(Icons.movie),
                Text(movieDetail.originalTitle,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: const Color(0xFF1E88E5),
                    )),
                Placeholder(fallbackWidth: double.infinity, fallbackHeight: 100)
              ]),
              Positioned(
                top: 250.0 - 85.0,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 85,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            stops: [
                          0.05,
                          0.2,
                          1
                        ],
                            colors: [
                          Colors.white,
                          Colors.white.withOpacity(0.9),
                          Colors.white.withOpacity(0.0)
                        ]))),
              ),
              Container(
                  //color: Colors.yellow.withOpacity(0.2),
                  width: MediaQuery.of(context).size.width,
                  height: 310,
                  child: Image.network(
                    poster,
                    fit: BoxFit.cover,
                    frameBuilder: (_, Widget child, int frame,
                        bool wasSynchronouslyLoaded) {
                      return AnimatedAlign(
                        alignment: frame == null || wasSynchronouslyLoaded
                            ? Alignment(-0.9, 0.0)
                            : Alignment(-0.9, 1),
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeOutQuint,
                        child: AnimatedOpacity(
                          opacity:
                              frame == null || wasSynchronouslyLoaded ? 0 : 1,
                          duration: const Duration(milliseconds: 200),
                          child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.45),
                                    offset: const Offset(3.0, 2.0), //Offset
                                    blurRadius: 8.0,
                                    spreadRadius: 1.0,
                                  )
                                ], //BoxShadow
                              ),
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  child: SizedBox(
                                      width: 154, height: 231, child: child))),
                        ),
                      );
                    },
                  ))
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
