import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_movies/containers/movie_detail_container.dart';
import 'package:flutter_movies/models/movie.dart';
import 'package:flutter_movies/presentations/customs/list_item_buider.dart';
import 'package:flutter_movies/presentations/customs/page_view_element.dart';
import 'package:flutter_movies/presentations/movie_view_all_page.dart';
import 'package:flutter_movies/utils/string_value.dart';
import 'package:flutter_movies/utils/styles.dart';
import 'package:flutter_movies/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MovieHomePage extends StatefulWidget {
  List<Movie> nowPlayingMovies;
  List<Movie> upcomingMovies;
  List<Movie> topRatedMovies;
  List<Movie> popularMovies;
  List<Movie> trendingMovies;
  Function changeSelectedMovie;

  MovieHomePage(
      {this.nowPlayingMovies,
      this.upcomingMovies,
      this.topRatedMovies,
      this.popularMovies,
      this.trendingMovies,
      this.changeSelectedMovie});

  @override
  _MovieHomePageState createState() => _MovieHomePageState();
}

class _MovieHomePageState extends State<MovieHomePage> {
  PageController pageController;

  Timer timer;
  var twentyMillis = const Duration(seconds: 4);

  static const SCALE_FRACTION = 0.7;
  static const FULL_SCALE = 1.0;
  double page = 0.0;
  double viewPortFraction = 0.8;
  var currentPage = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(
        viewportFraction: viewPortFraction, initialPage: currentPage);
    WidgetsBinding.instance.addPostFrameCallback((_) => _timer());
  }

  @override
  void dispose() {
    pageController.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        trendingMoviesWidget(),
        SizedBox(
          height: ScreenUtil.instance.setHeight(25),
        ),
        nowPlayingWidget(),
        SizedBox(
          height: ScreenUtil.instance.setHeight(25),
        ),
        upComingWidget(),
        SizedBox(
          height: ScreenUtil.instance.setHeight(25),
        ),
        topRatedWidget(),
        SizedBox(
          height: ScreenUtil.instance.setHeight(25),
        ),
        popularWidget(),
        SizedBox(
          height: ScreenUtil.instance.setHeight(25),
        ),
      ],
    );
  }

  Widget trendingMoviesWidget() {
    return widget.trendingMovies == null
        ? Container(
            child: Center(child: CircularProgressIndicator()),
            height: ScreenUtil.screenHeight / 4,
          )
        : widget.trendingMovies.length > 0
            ? Container(
                margin: EdgeInsets.only(
                  top: ScreenUtil.instance.setHeight(10),
                ),
                height: ScreenUtil.instance.setHeight(200),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification notification) {
                    if (notification is ScrollUpdateNotification) {
                      setState(() {
                        page = pageController.page;
                      });
                    }
                  },
                  child: PageView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.trendingMovies.length,
                    controller: pageController,
                    itemBuilder: (BuildContext context, index) {
                      final scale = max(
                          SCALE_FRACTION,
                          (FULL_SCALE - (index - page).abs()) +
                              viewPortFraction);
                      return pageViewBuilder(
                          index, scale, widget.trendingMovies[index]);
                    },
                    onPageChanged: ((index) {
                      setState(() {
                        currentPage = index;
                      });
                    }),
                  ),
                ),
              )
            : SizedBox();
  }

  Widget pageViewBuilder(int index, double scale, Movie movie) {
    return PageViewElement(
      onTap: _navigateToMovieDetailPage,
      id: movie.id,
      scale: scale,
      width: ScreenUtil.screenWidth - 60,
      backgroundUrl: movie.backGroundImage,
      name: movie.title,
    );
  }

  Widget nowPlayingWidget() {
    return widget.nowPlayingMovies == null
        ? Utils.commonCircularProgress()
        : widget.nowPlayingMovies.length > 0
            ? showMovieFields(
                fieldTitle: StringValue.NOW_PLAYING,
                movieList: widget.nowPlayingMovies)
            : SizedBox();
  }

  Widget upComingWidget() {
    return widget.upcomingMovies == null
        ? Utils.commonCircularProgress()
        : widget.upcomingMovies.length > 0
            ? showMovieFields(
                fieldTitle: StringValue.UPCOMING,
                movieList: widget.upcomingMovies)
            : SizedBox();
  }

  Widget topRatedWidget() {
    return widget.topRatedMovies == null
        ? Utils.commonCircularProgress()
        : widget.topRatedMovies.length > 0
            ? showMovieFields(
                fieldTitle: StringValue.TOP_RATED,
                movieList: widget.topRatedMovies)
            : SizedBox();
  }

  Widget popularWidget() {
    return widget.popularMovies == null
        ? Utils.commonCircularProgress()
        : widget.popularMovies.length > 0
            ? showMovieFields(
                fieldTitle: StringValue.POPULAR,
                movieList: widget.popularMovies)
            : SizedBox();
  }

  showMovieFields({String fieldTitle, List<Movie> movieList}) {
    return new Column(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.symmetric(
            vertical: ScreenUtil.instance.setHeight(10),
            horizontal: ScreenUtil.instance.setWidth(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                fieldTitle,
                style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: Styles.FONT_FAMILY),
              ),
              GestureDetector(
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.blue,
                  size: 20.0,
                ),
                onTap: () {
                  _navigateToFullDetailsPage(movieList);
                },
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(
              vertical: ScreenUtil.instance.setHeight(5),
              horizontal: ScreenUtil.instance.setWidth(8)),
          height: ScreenUtil.instance.setHeight(200),
          child: new ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movieList.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  _navigateToMovieDetailPage(context, movieList[index].id);
                },
                child: ListItemBuilder(
                    height: ScreenUtil.instance.setHeight(200),
                    width: ScreenUtil.instance.setWidth(125),
                    url: movieList[index].posterPath),
              );
            },
          ),
        ),
      ],
    );
  }

  _navigateToMovieDetailPage(BuildContext context, int movieId) {
    widget.changeSelectedMovie(movieId);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MovieDetailContainer()));
  }

  _navigateToFullDetailsPage(List<Movie> movieList) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            MovieViewAllPage(movieList, widget.changeSelectedMovie)));
  }

  _timer() {
    timer = new Timer.periodic(
      twentyMillis,
      (Timer t) {
        if (widget.trendingMovies != null && widget.trendingMovies.length > 0) {
          if (pageController.page != widget.trendingMovies.length - 1) {
            setState(() {
              pageController.nextPage(
                  duration: Duration(milliseconds: 600),
                  curve: Curves.easeInOut);
            });
          } else {
            pageController.animateToPage(0,
                duration: Duration(milliseconds: 600), curve: Curves.easeInOut);
          }
        }
      },
    );
  }
}
