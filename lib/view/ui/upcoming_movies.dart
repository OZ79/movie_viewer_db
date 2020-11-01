import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_viewer_db/bloc/movie_bloc/movie_bloc.dart';
import 'package:movie_viewer_db/bloc/movie_bloc/movie_state.dart';
import 'package:movie_viewer_db/data/models/movie.dart';

import '../../config.dart';

class UpcomingMoviesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: missing_return
    return BlocBuilder<MovieBloc, MovieState>(builder: (context, state) {
      if (state is MovieInitialState) {
        return CircularProgressIndicator();
      } else if (state is MovieLoadingState) {
        return CircularProgressIndicator();
      } else if (state is MovieLoadedState) {
        return MoviePageView(state.movies.sublist(0, 20));
      } else if (state is MovieErrorState) {
        return Text(
          state.message,
          style: TextStyle(
              fontFamily: "Poppins-Bold",
              fontSize: 24,
              color: Color(0xfffbfbfbf)),
        );
      }
    });
  }
}

class MoviePageView extends StatefulWidget {
  final List<Movie> data;

  MoviePageView(this.data);

  @override
  _MoviePageViewState createState() => _MoviePageViewState();
}

class _MoviePageViewState extends State<MoviePageView> {
  PageController _pageController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(viewportFraction: 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        //color: Colors.black,
        height: 270,
        child: PageView.builder(
            controller: _pageController,
            itemCount: widget.data.length,
            itemBuilder: (BuildContext context, int index) {
              final imageUrl = "$IMAGE_URL_300${widget.data[index].backPoster}";
              //print(imageUrl);
              return MovieItem(imageUrl: imageUrl);
            }));
  }
}

class MovieItem extends StatelessWidget {
  final String imageUrl;

  const MovieItem({@required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            boxShadow: [
              BoxShadow(
                offset: Offset(3, 4),
                blurRadius: 6,
                color: Colors.black54,
              )
            ],
            image: DecorationImage(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(imageUrl),
            ),
          ),
        ),
        placeholder: (context, url) => Align(
            alignment: Alignment.center, child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }
}
