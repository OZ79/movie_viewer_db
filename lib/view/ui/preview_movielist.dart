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
    return Column(
      children: [
        Align(
            alignment: const Alignment(-0.95, 0.0),
            child: Text(
              "UPCAMING",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black54),
            )),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: data.length,
            itemBuilder: (context, index) {
              final movie = data[index];
              final imageUrl = "$IMAGE_URL_92${movie.poster}";
              return MovieIem(title: movie.title, imageUrl: imageUrl);
            },
          ),
        )
      ],
    );
  }
}

class MovieIem extends StatelessWidget {
  final String title;
  final String imageUrl;

  const MovieIem({@required this.title, @required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final imageHeight = 140.0;
    return Container(
      margin: const EdgeInsets.all(8),
      child: Column(children: [
        Container(
          height: imageHeight,
          child: ClipRRect(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(18)),
            child: Container(
                color: Colors.yellow,
                child: Image(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(imageUrl))),
          ),
        ),
        Container(
          //color: Colors.yellow,
          width: imageHeight * 0.66,
          child: Text(
            title,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black54),
          ),
        ),
      ]),
    );
  }
}
