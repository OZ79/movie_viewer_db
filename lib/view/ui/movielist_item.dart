import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_viewer_db/bloc/movie_detail_bloc/movie_detail_bloc.dart';
import 'package:movie_viewer_db/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:movie_viewer_db/bloc/navigation_bloc/navigation_event.dart';
import 'package:movie_viewer_db/view/screens/movie_detail_screen.dart';
import 'package:movie_viewer_db/view/ui/star_rating.dart';

class MovieItem extends StatelessWidget {
  final int movieId;
  final String title;
  final String releaseDate;
  final String overview;
  final String imageUrl;
  final double rating;
  final MovieDetailBloc movieDetailBloc;
  final NavigationBloc navigationBloc;

  const MovieItem(
      {key,
      @required this.movieId,
      @required this.title,
      @required this.releaseDate,
      @required this.overview,
      @required this.imageUrl,
      @required this.rating,
      @required this.movieDetailBloc,
      @required this.navigationBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final imageHeight = 138.0;
    return GestureDetector(
      key: ValueKey('MovieItem_$movieId'),
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
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black12,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  key: ValueKey('MovieItem_$imageUrl'),
                  width: 92,
                  height: imageHeight,
                  child: ClipRRect(
                      clipBehavior: Clip.hardEdge,
                      borderRadius: const BorderRadius.only(
                          bottomRight: const Radius.circular(15),
                          topLeft: const Radius.circular(5),
                          bottomLeft: const Radius.circular(5)),
                      child: !imageUrl.contains("null")
                          ? Image(
                              fit: BoxFit.cover, image: NetworkImage(imageUrl))
                          : Container(
                              color: Colors.black.withOpacity(0.03),
                              child: Image(
                                  fit: BoxFit.contain,
                                  image: AssetImage('assets/movie_icon.png')),
                            ))),
              const SizedBox(width: 8),
              Container(
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
                          maxLines: 1,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: getFontSize(context) + 1,
                              color: const Color(0xFF1E88E5)),
                        ),
                      ),
                      Text(
                        releaseDate,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: getFontSize(context) - 2,
                            color: const Color(0xFF1E88E5)),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 120,
                        child: Text(
                          overview,
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.ellipsis,
                          maxLines: screenSize.width > 411 ||
                                  screenSize.aspectRatio > 0.6
                              ? 2
                              : 3,
                          style: TextStyle(
                              fontSize: getFontSize(context),
                              color: const Color(0xFF1E88E5)),
                        ),
                      ),
                      Row(children: [
                        StarRating(
                          rating: rating * 0.5,
                          size: 15,
                          color: Colors.yellow[700],
                          borderColor: Colors.yellow[700],
                          mainAxisAlignment: MainAxisAlignment.start,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          rating.toString(),
                          style: TextStyle(
                              fontSize: getFontSize(context) - 2,
                              color: const Color(0xFF1E88E5)),
                        ),
                      ])
                    ]),
              )
            ]),
      ),
    );
  }
}

double getFontSize(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  //print(screenWidth);
  //print(MediaQuery.of(context).size.aspectRatio);

  //return 16;
  //print(MediaQuery.of(context).orientation);

  if (MediaQuery.of(context).size.aspectRatio > 0.9) {
    return 17;
  }

  if (screenWidth <= 320) {
    return 15;
  }
  if (screenWidth <= 360) {
    return 17;
  }
  if (screenWidth <= 411) {
    return 17;
  }
  if (screenWidth <= 480) {
    return 17;
  }
  if (screenWidth <= 540) {
    return 21;
  }
  if (screenWidth <= 768) {
    return 21;
  }
  if (screenWidth <= 800) {
    return 22;
  }

  return 16;
}
