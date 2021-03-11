import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_viewer_db/bloc/base_movie_state.dart';
import 'package:movie_viewer_db/bloc/movie_detail_bloc/movie_detail_bloc.dart';
import 'package:movie_viewer_db/bloc/movie_detail_bloc/movie_detail_event.dart';
import 'package:movie_viewer_db/bloc/movie_detail_bloc/movie_detail_state.dart';
import 'package:movie_viewer_db/util/util.dart';
import 'package:movie_viewer_db/view/ui/InternetConnectionAlert.dart';
import 'package:movie_viewer_db/view/ui/poster.dart';
import 'package:movie_viewer_db/view/ui/rating.dart';
import 'package:movie_viewer_db/view/ui/wrap_layout.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../config.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;

  MovieDetailScreen(this.movieId);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen>
    with InternetConnectionAlert<MovieDetailScreen, MovieDetailBloc> {
  @override
  void initState() {
    super.initState();

    loadData();
  }

  void loadData() {
    BlocProvider.of<MovieDetailBloc>(context)
      ..add(FetchMovieDetailEvent(movieId: widget.movieId));
  }

  Widget buildCountryItem(List<dynamic> items, int index) {
    return Chip(
      backgroundColor: Colors.grey.withOpacity(0.03),
      avatar: Text(Util.countryCodeToFlag(items[index]['iso_3166_1']),
          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
      label: Text(items[index]['name'],
          style: TextStyle(
            fontSize: 16,
            color: const Color(0xFF1E88E5),
          )),
    );
  }

  Widget buildProdCompanyItem(List<dynamic> items, int index) {
    final logoUrl = '$IMAGE_URL_92${items[index]['logo_path']}';
    return Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.withOpacity(0.27),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8)),
        child:
            Image.network(logoUrl, width: 41, height: 41, fit: BoxFit.contain));
  }

  Widget buildGenreItem(List<dynamic> items, int index) {
    return Chip(
      backgroundColor: Colors.grey.withOpacity(0.03),
      label: Text(items[index]['name'],
          style: TextStyle(
            fontSize: 16,
            color: const Color(0xFF1E88E5),
          )),
    );
  }

  @override
  MovieDetailBloc get bloc => BlocProvider.of<MovieDetailBloc>(context);

  @override
  Widget getContent() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<MovieDetailBloc, MovieState>(
          builder: (context, state) {
            if (state is MovieDetailLoadedState) {
              final movieDetail = state.movieDetail;
              final backPosterUrl = '$IMAGE_URL_500${movieDetail.backPoster}';
              final posterUrl = '$IMAGE_URL_154${movieDetail.poster}';

              return SingleChildScrollView(
                child: Stack(clipBehavior: Clip.none, children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 40,
                    ),
                    child: Column(
                        mainAxisAlignment: movieDetail.casts.length == 0
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(children: [
                            Header(backPosterUrl),
                            Row(children: [
                              const SizedBox(width: 165),
                              Column(children: [
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 165,
                                    child: Rating(movieDetail.rating)),
                                Text(movieDetail.releaseDate,
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: const Color(0xFF1E88E5),
                                    ))
                              ])
                            ])
                          ]),
                          if (movieDetail.prodCountries.length != 0)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 12, right: 12, top: 12),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: WrapLayout(
                                      itemCount:
                                          movieDetail.prodCountries.length,
                                      spacing: 12,
                                      runSpacing: -5,
                                      itemBuilder: (context, index) {
                                        return buildCountryItem(
                                            movieDetail.prodCountries, index);
                                      })),
                            ),
                          if (movieDetail.prodCompanies.length != 0)
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 12, right: 12, top: 12),
                                child: WrapLayout(
                                    itemCount: movieDetail.prodCompanies.length,
                                    alignment: WrapAlignment.center,
                                    spacing: 12,
                                    runSpacing: 5,
                                    itemBuilder: (context, index) {
                                      return buildProdCompanyItem(
                                          movieDetail.prodCompanies, index);
                                    })),
                          if (movieDetail.genres.length != 0)
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 12, right: 12, top: 12),
                                child: WrapLayout(
                                    itemCount: movieDetail.genres.length,
                                    alignment: WrapAlignment.center,
                                    spacing: 12,
                                    runSpacing: -5,
                                    itemBuilder: (context, index) {
                                      return buildGenreItem(
                                          movieDetail.genres, index);
                                    })),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12, right: 12, top: 12),
                            child: Column(children: [
                              Text(movieDetail.title,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22.5,
                                    color: const Color(0xFF1E88E5),
                                  )),
                              const SizedBox(height: 5),
                              Text(
                                movieDetail.overview,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 19.5,
                                    color: const Color(0xFF1E88E5)),
                              )
                            ]),
                          ),
                          if (movieDetail.casts.length != 0)
                            Container(
                              height: 180,
                              margin: EdgeInsets.only(top: 15),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemExtent: 108,
                                itemCount: movieDetail.casts.length,
                                itemBuilder: (context, index) {
                                  final imageUrl =
                                      "$IMAGE_URL_92${movieDetail.casts[index].profilePath}";
                                  return CastItem(
                                      imageUrl,
                                      movieDetail.casts[index].name,
                                      movieDetail.casts[index].character);
                                },
                              ),
                            ),
                        ]),
                  ),
                  if (!posterUrl.contains("null")) Poster(posterUrl: posterUrl),
                  Container(
                    margin: const EdgeInsets.only(left: 8, top: 8),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.2)),
                    child: const BackButton(color: Colors.white),
                  )
                ]),
              );
            }
            return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Center(child: const CircularProgressIndicator()));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return super.build(context);
  }
}

class Header extends StatelessWidget {
  final String imageUrl;

  const Header(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Stack(
        clipBehavior: Clip.none,
        children: [HeaderImage(imageUrl), const HeaderGradient()]);
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
        : const Image(
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
            image: AssetImage('assets/movie_header.jpg'));
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

class CastItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String character;

  const CastItem(this.imageUrl, this.name, this.character);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.only(left: 4, right: 4, bottom: 10),
      clipBehavior: Clip.hardEdge,
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Image.network(imageUrl, width: 100, height: 100, fit: BoxFit.cover),
        const SizedBox(height: 6),
        SizedBox(
          width: 90,
          child: Text(name == null ? '' : name,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                height: 1,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E88E5),
              )),
        ),
        const SizedBox(height: 3),
        SizedBox(
          width: 90,
          child: Text(character == null ? '' : character,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                height: 1,
                fontSize: 12.5,
                color: const Color(0xFF1E88E5),
              )),
        ),
      ]),
    );
  }
}
