import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_viewer_db/bloc/movie_bloc/movie_bloc.dart';
import 'package:movie_viewer_db/bloc/movie_bloc/movie_state.dart';
import 'package:movie_viewer_db/bloc/base_movie_state.dart';
import 'package:movie_viewer_db/data/PageStorageIndetifier.dart';
import 'package:movie_viewer_db/data/models/movie.dart';
import 'package:movie_viewer_db/data/movie_repositories.dart';
import 'package:movie_viewer_db/util/flutter_device_type.dart';
import 'package:movie_viewer_db/view/ui/page_view_indicator.dart';

import '../../config.dart';

class UpcomingMoviesWidget extends StatelessWidget {
  UpcomingMoviesWidget({key}) : super(key: key);

  int getStartIndex(BuildContext context, int length) {
    int startIndex = PageStorage.of(context)
        .readState(context, identifier: PageStorageIndetifier.startIndex);

    if (startIndex == null) {
      startIndex = Random().nextInt(length);
      PageStorage.of(context).writeState(context, startIndex,
          identifier: PageStorageIndetifier.startIndex);
    }

    return startIndex;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieBloc, MovieState>(buildWhen: (prevstate, state) {
      if (prevstate is MovieErrorState && prevstate.isOffline) {
        return true;
      }
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
        final movies = state.movies[MovieType.upcoming];
        final startIndex = getStartIndex(context, movies.length - 6);
        return MoviePageView(data: movies.sublist(startIndex, startIndex + 5));
      } else if (state is MovieErrorState) {
        return Center(
          child: Text(
            state.exception.toString(),
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

  MoviePageView({key, this.data}) : super(key: key);

  @override
  _MoviePageViewState createState() => _MoviePageViewState();
}

class _MoviePageViewState extends State<MoviePageView> {
  PageController _pageController;
  double _pageHeight;

  @override
  void initState() {
    super.initState();

    _pageHeight = Device.get().isPhone ? 270 : 290;
    _pageController = PageController(viewportFraction: 0.9);
  }

  bool get isPortrait {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /*void jumpToPage() {
    double page = _pageController.page;
    _pageController.jumpToPage(0);
    _pageController.jumpToPage(page.toInt());
  }*/

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (_, orientation) {
      /*if (orientation == Orientation.landscape && _pageController.hasClients) {
        Future.delayed(Duration(milliseconds: 2000), jumpToPage);
      }*/
      return Column(
        children: <Widget>[
          SizedBox(
              height: _pageHeight,
              child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final movie = widget.data[index];
                    return MovieItem(
                      key: ValueKey('MovieItem_${movie.backPoster}'),
                      imageUrl: "$IMAGE_URL_500${movie.backPoster}",
                      title: movie.title,
                      index: index,
                      controller: Device.get().isPhone && isPortrait
                          ? _pageController
                          : null,
                    );
                  })),
          Expanded(
            child: LineIndiator(
              controller: _pageController,
            ),
          ),
        ],
      );
    });
  }
}

class MovieItem extends StatefulWidget {
  final String imageUrl;
  final String title;
  final int index;
  final PageController controller;

  const MovieItem(
      {key,
      @required this.imageUrl,
      @required this.title,
      @required this.index,
      this.controller})
      : super(key: key);

  @override
  _MovieItemState createState() => _MovieItemState();
}

class _MovieItemState extends State<MovieItem> {
  Alignment _alignment = Alignment(0, 0);

  @override
  void initState() {
    super.initState();

    widget.controller?.addListener(_handleChange);
  }

  @override
  void didUpdateWidget(MovieItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleChange);
      widget.controller?.addListener(_handleChange);
      if (widget.controller != null) setAlignment();
    }
  }

  void setAlignment() {
    final offset = widget.index -
        (widget.controller.page ?? widget.controller.initialPage);
    _alignment = Alignment(offset * 3, 0);
  }

  void _handleChange() {
    setState(() {
      setAlignment();
    });
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(
        child: Padding(
          key: ValueKey('Padding_${widget.imageUrl}'),
          padding: const EdgeInsets.all(10),
          child: CachedNetworkImage(
            imageUrl: widget.imageUrl,
            imageBuilder: (context, imageProvider) {
              return Container(
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
                    fit: Device.get().isPhone &&
                            MediaQuery.of(context).orientation ==
                                Orientation.portrait
                        ? BoxFit.none
                        : BoxFit.cover,
                    image: imageProvider,
                  ),
                ),
              );
            },
            placeholder: (context, url) =>
                Center(child: const CircularProgressIndicator()),
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
