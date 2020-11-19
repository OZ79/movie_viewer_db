import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:movie_viewer_db/data/models/movie.dart';

import '../../config.dart';
import 'star_rating.dart';

class PreviewMovieList extends StatelessWidget {
  final String title;
  final List<Movie> data;

  const PreviewMovieList(this.title, this.data);

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
                  color: Colors.black54),
            ),
            GestureDetector(
              onTap: () {
                print('Clicked');
              },
              child: const Text(
                "More ...",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black54),
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
              final imageUrl = "$IMAGE_URL_92${movie.poster}";
              return MovieIem(
                title: movie.title,
                imageUrl: imageUrl,
                rating: movie.rating,
              );
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
  final double rating;

  const MovieIem(
      {@required this.title, @required this.imageUrl, @required this.rating});

  @override
  Widget build(BuildContext context) {
    final imageHeight = 105.0;
    return Container(
      margin: const EdgeInsets.all(8),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: imageHeight,
              child: ClipRRect(
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(12)),
                child: Container(
                    color: Colors.yellow,
                    child: Image(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(imageUrl))),
              ),
            ),
            SizedBox(
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
            StarRating(
              rating: rating * 0.5,
              size: 14,
              color: Colors.yellow[700],
              borderColor: Colors.yellow[700],
            ),
          ]),
    );
  }
}
