import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_viewer_db/bloc/movie_bloc/movie_bloc.dart';
import 'package:movie_viewer_db/bloc/movie_bloc/movie_state.dart';
import 'package:movie_viewer_db/data/models/movie.dart';
import 'package:movie_viewer_db/data/movie_repositories.dart';
import 'package:movie_viewer_db/view/ui/page_view_indicator.dart';

import '../../config.dart';

class UpcomingMoviesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieBloc, MovieState>(buildWhen: (_, state) {
      if (state is MovieLoadedState && state.movieType == MovieType.upcoming) {
        return true;
      }
      return false;
    }, builder: (context, state) {
      if (state is MovieLoadedState && state.movieType == MovieType.upcoming) {
        return MoviePageView(state.movies.sublist(0, 5));
      } else if (state is MovieErrorState) {
        return Center(
          child: Text(
            state.message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, color: Colors.black54),
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

    _pageController = PageController(viewportFraction: 0.91);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Stack(
        children: <Widget>[
          SizedBox(
              height: 270,
              child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final movie = widget.data[index];
                    final imageUrl = "$IMAGE_URL_500${movie.backPoster}";
                    return MovieItem(
                      imageUrl: imageUrl,
                      title: movie.title,
                      index: index,
                      controller: _pageController,
                    );
                  })),
          LineIndiator(
            controller: _pageController,
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

    widget.controller.addListener(_handleChange);
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
                    fit: BoxFit.none,
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
        width: 300,
        child: Text(
          widget.title,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 17,
              color: Colors.black54),
        ),
      )
    ]);
  }
}
