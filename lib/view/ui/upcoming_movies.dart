import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_viewer_db/bloc/movie_bloc/movie_bloc.dart';
import 'package:movie_viewer_db/bloc/movie_bloc/movie_state.dart';
import 'package:movie_viewer_db/bloc/base_movie_state.dart';
import 'package:movie_viewer_db/data/models/movie.dart';
import 'package:movie_viewer_db/data/movie_repositories.dart';
import 'package:movie_viewer_db/util/flutter_device_type.dart';
import 'package:movie_viewer_db/view/ui/page_view_indicator.dart';

import '../../config.dart';

class UpcomingMoviesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieBloc, MovieState>(buildWhen: (_, state) {
      if (state is PreviewMovieLoadedState &&
              state.movieType == MovieType.upcoming ||
          state is MovieErrorState) {
        return true;
      }
      return false;
    }, builder: (context, state) {
      if (state is PreviewMovieLoadedState &&
          state.movies != null &&
          state.movies[MovieType.upcoming] != null) {
        final random = Random();
        final movies = state.movies[MovieType.upcoming];
        final startIndex = random.nextInt(movies.length - 6);
        return MoviePageView(movies.sublist(startIndex, startIndex + 5));
      } else if (state is MovieErrorState) {
        return Center(
          child: Text(
            state.message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, color: Colors.black54),
          ),
        );
      }

      return Center(child: const CircularProgressIndicator());
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

    _pageController =
        PageController(viewportFraction: Device.get().isPhone ? 0.91 : 0.75);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Device.get().isPhone ? 300 : 320,
      child: Column(
        children: <Widget>[
          SizedBox(
              height: Device.get().isPhone ? 270 : 290,
              child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final movie = widget.data[index];
                    return MovieItem(
                      imageUrl: "$IMAGE_URL_500${movie.backPoster}",
                      title: movie.title,
                      index: index,
                      controller: _pageController,
                    );
                  })),
          Expanded(
            child: LineIndiator(
              controller: _pageController,
            ),
          ),
        ],
      ),
    );
  }
}

class MovieItem extends StatefulWidget {
  final String imageUrl;
  final String title;
  final int index;
  final PageController controller;

  const MovieItem(
      {@required this.imageUrl,
      @required this.title,
      @required this.index,
      @required this.controller});

  @override
  _MovieItemState createState() => _MovieItemState();
}

class _MovieItemState extends State<MovieItem> {
  Alignment _alignment = Alignment(0, 0);

  @override
  void initState() {
    super.initState();

    if (Device.get().isPhone) {
      widget.controller.addListener(_handleChange);
    }
  }

  @override
  void didUpdateWidget(MovieItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_handleChange);
      widget.controller.addListener(_handleChange);
    }
  }

  void _handleChange() {
    setState(() {
      final offset = widget.index -
          (widget.controller.page ?? widget.controller.initialPage);
      _alignment = Alignment(offset * 3, 0);
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: CachedNetworkImage(
            imageUrl: widget.imageUrl,
            imageBuilder: (context, imageProvider) {
              return Container(
                width: MediaQuery.of(context).size.shortestSide < 600
                    ? double.infinity
                    : 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(3, 4),
                      blurRadius: 6,
                      color: Colors.black26,
                    )
                  ],
                  image: DecorationImage(
                    alignment: _alignment,
                    fit: Device.get().isPhone ? BoxFit.none : BoxFit.cover,
                    image: imageProvider,
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
        width: Device.get().isPhone ? 300 : 400,
        child: Text(
          widget.title,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 17,
              color: const Color(0xFF1E88E5)),
        ),
      )
    ]);
  }
}
