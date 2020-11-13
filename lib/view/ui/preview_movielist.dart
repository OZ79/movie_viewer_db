import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:movie_viewer_db/data/models/movie.dart';

import '../../config.dart';

class PreviewMovieList extends StatelessWidget {
  final List<Movie> data;

  const PreviewMovieList(this.data);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 138,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 8, right: 8),
        itemCount: data.length,
        separatorBuilder: (BuildContext context, int index) => SizedBox(
          width: 8,
        ),
        itemBuilder: (context, index) {
          final movie = data[index];
          final imageUrl = "$IMAGE_URL_92${movie.poster}";
          return MovieIem(title: movie.title, imageUrl: imageUrl);
        },
      ),
    );
  }
}

class MovieIem extends StatelessWidget {
  final String title;
  final String imageUrl;

  const MovieIem({@required this.title, @required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(bottomRight: Radius.circular(18)),
      child: Container(
          color: Colors.yellow,
          child: Image(
              fit: BoxFit.cover, image: CachedNetworkImageProvider(imageUrl))),
    );
  }
}
