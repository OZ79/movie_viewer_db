import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_viewer_db/bloc/movie_bloc/movie_bloc.dart';
import 'package:movie_viewer_db/bloc/movie_bloc/movie_state.dart';
import 'package:movie_viewer_db/data/models/movie.dart';
import 'package:movie_viewer_db/view/ui/page_view_indicator.dart';

import '../../config.dart';

class UpcomingMoviesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: missing_return
    return BlocBuilder<MovieBloc, MovieState>(builder: (context, state) {
      if (state is MovieInitialState) {
        return Center(child: const CircularProgressIndicator());
      } else if (state is MovieLoadingState) {
        return Center(child: const CircularProgressIndicator());
      } else if (state is MovieLoadedState) {
        return MoviePageView(state.movies.sublist(0, 5));
      } else if (state is MovieErrorState) {
        return Text(
          state.message,
          style: TextStyle(fontSize: 24, color: Color(0xfffbfbfbf)),
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

    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        SizedBox(
            height: 270,
            child: PageView.builder(
                controller: _pageController,
                itemCount: widget.data.length,
                itemBuilder: (BuildContext context, int index) {
                  final movie = widget.data[index];
                  final imageUrl = "$IMAGE_URL_300${movie.backPoster}";
                  //print(imageUrl);
                  return MovieItem(
                    imageUrl: imageUrl,
                    title: movie.title,
                    controller: _pageController,
                  );
                })),
        LineIndiator(
          controller: _pageController,
        ),
      ],
    );
  }
}

class MovieItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final PageController controller;

  const MovieItem(
      {@required this.imageUrl,
      @required this.title,
      @required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            //alignment: Alignment(-offset.abs(), 0),
            imageBuilder: (context, imageProvider) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(3, 4),
                      blurRadius: 6,
                      color: Colors.black54,
                    )
                  ],
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(imageUrl),
                  ),
                ),
              );
            },
            placeholder: (context, url) => Align(
                alignment: Alignment.center,
                child: const CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
      SizedBox(
        width: 300,
        child: Text(
          title,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 17,
              color: Colors.black54),
        ),
      )
    ]);
  }
}
