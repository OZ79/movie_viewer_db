import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_viewer_db/bloc/base_movie_state.dart';
import 'package:movie_viewer_db/bloc/movie_bloc/movie_bloc.dart';
import 'package:movie_viewer_db/bloc/movie_bloc/movie_event.dart';
import 'package:movie_viewer_db/bloc/movie_bloc/movie_state.dart';
import 'package:movie_viewer_db/view/ui/companies.dart';
import 'package:movie_viewer_db/view/ui/countries.dart';
import 'package:movie_viewer_db/view/ui/genres.dart';
import 'package:movie_viewer_db/view/ui/poster.dart';
import 'package:movie_viewer_db/view/ui/rating.dart';
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
    // 675327 , 531219, 777670, 763440, 293863, 615761, 313369, 956, 353081
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieBloc, MovieState>(
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

          return SingleChildScrollView(
            child: Stack(children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 80,
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(children: [
                        Header(backPosterUrl),
                        Row(children: [
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
                        ])
                      ]),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 12, top: 15, bottom: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Countries(movieDetail.prodCountries),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 12, right: 12),
                        child: Companies(movieDetail.prodCompanies),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20, bottom: 20, left: 12, right: 12),
                        child: Genres(movieDetail.genres),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(children: [
                          Text(movieDetail.title,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                fontSize: 27,
                                color: const Color(0xFF1E88E5),
                              )),
                          SizedBox(height: 15),
                          Text(
                            movieDetail.overview,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 21,
                                color: const Color(0xFF1E88E5)),
                          )
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SizedBox(
                          height: 138,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemExtent: 92,
                            itemCount: movieDetail.casts.length,
                            itemBuilder: (context, index) {
                              final imageUrl =
                                  "$IMAGE_URL_92${movieDetail.casts[index].profilePath}";
                              return !imageUrl.contains('null')
                                  ? Image.network(imageUrl)
                                  : null;
                            },
                          ),
                        ),
                      ),
                    ]),
              ),
              Poster(posterUrl: posterUrl)
            ]),
          );
        }
        return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Center(child: const CircularProgressIndicator()));
      },
    );
  }
}

class Header extends StatelessWidget {
  final String imageUrl;

  const Header(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [HeaderImage(imageUrl), const HeaderGradient()]);
  }
}

class HeaderImage extends StatelessWidget {
  final String url;

  const HeaderImage(this.url);

  @override
  Widget build(BuildContext context) {
    return !url.contains("null")
        ? FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
            fadeInDuration: const Duration(milliseconds: 200),
            image: url)
        : Container(
            width: double.infinity,
            height: 250,
            child: const Icon(Icons.image));
  }
}

class HeaderGradient extends StatelessWidget {
  const HeaderGradient();

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 251,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [
              0.05,
              0.2,
              0.85,
              1
            ],
                colors: [
              Colors.white,
              Colors.white.withOpacity(0.87),
              Colors.white.withOpacity(0.14),
              Colors.white.withOpacity(0.0)
            ])));
  }
}
