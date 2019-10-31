import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movies/containers/cast_detail_container.dart';
import 'package:flutter_movies/containers/movie_detail_container.dart';
import 'package:flutter_movies/containers/tv_show_detail_container.dart';
import 'package:flutter_movies/models/cast.dart';
import 'package:flutter_movies/models/movie.dart';
import 'package:flutter_movies/models/search_element.dart';
import 'package:flutter_movies/models/tv_show.dart';
import 'package:flutter_movies/presentations/customs/list_item_buider.dart';
import 'package:flutter_movies/utils/string_value.dart';
import 'package:flutter_movies/utils/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchPage extends StatefulWidget {
  static const String routeNamed = "SearchPage";

  SearchPage(
      {this.isLoading,
      this.searchQuery,
      this.searchResults,
      this.changeSelectedMovie,
      this.changeSelectedCast,
      this.changeSelectedTvShow});

  bool isLoading;
  Function searchQuery;
  List searchResults;
  Function changeSelectedMovie;
  Function changeSelectedCast;
  Function changeSelectedTvShow;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController textController = new TextEditingController();
  ScrollController controller = ScrollController();
  bool firstTime = true;

  @override
  void initState() {
    super.initState();
    if (widget.searchResults.isNotEmpty) {
      firstTime = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: ScreenUtil.screenHeight,
        width: ScreenUtil.screenWidth,
        margin: EdgeInsets.only(
            left: ScreenUtil.instance.setWidth(15),
            top: ScreenUtil.instance.setHeight(30),
            right: ScreenUtil.instance.setWidth(15)),
        child: SingleChildScrollView(
          controller: controller,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: ScreenUtil.instance.setHeight(10)),
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil.instance.setWidth(10)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(ScreenUtil.instance.setWidth(20))),
                  border: Border.all(
                    color: Colors.blue,
                  ),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: StringValue.SEARCH_FAVORITES,
                    icon: Icon(Icons.search),
                  ),
                  controller: textController,
                  onSubmitted: (data) {
                    widget.searchQuery(query: data);
                    if (firstTime) {
                      setState(() {
                        firstTime = false;
                      });
                    }
                  },
                ),
              ),
              searchWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget searchWidget() {
    if (widget.isLoading) {
      return Container(
        height: ScreenUtil.screenHeight / 4,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (widget.searchResults.isEmpty) {
      return Container(
        height: ScreenUtil.screenHeight / 4,
        child: Center(
          child: Text(
            firstTime ? StringValue.FRESH_SEARCH : StringValue.NO_DATA,
            style: TextStyle(fontFamily: Styles.FONT_FAMILY, fontSize: 24.0),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      return GridView.builder(
        controller: controller,
        shrinkWrap: true,
        itemCount: widget.searchResults.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 0.6),
        itemBuilder: (BuildContext context, int index) {
          SearchElement element = widget.searchResults[index];
          SearchMediaType type;
          String url;
          if (element.mediaType == describeEnum(SearchMediaType.MOVIE)) {
            url = element.movie.posterPath;
            type = SearchMediaType.MOVIE;
          } else if (element.mediaType ==
              describeEnum(SearchMediaType.TV_SHOW)) {
            url = element.tvShow.posterPath;
            type = SearchMediaType.TV_SHOW;
          } else {
            url = element.people.posterPath;
            type = SearchMediaType.PERSON;
          }
          return GestureDetector(
            onTap: () {
              if (type == SearchMediaType.MOVIE) {
                _navigateToMovieDetailPage(context, element.movie);
              } else if (type == SearchMediaType.TV_SHOW) {
                _navigateToTvShowDetailPage(context, element.tvShow);
              } else {
                _navigateToCastDetailPage(context, element.people);
              }
            },
            child: ListItemBuilder(
              height: ScreenUtil.instance.setHeight(160),
              width: ScreenUtil.instance.setWidth(100),
              url: url,
            ),
          );
        },
      );
    }
  }

  _navigateToMovieDetailPage(BuildContext context, Movie movie) {
    widget.changeSelectedMovie(movie);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MovieDetailContainer()));
  }

  _navigateToTvShowDetailPage(BuildContext context, TvShow tvShow) {
    widget.changeSelectedTvShow(tvShow);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => TvShowDetailContainer()));
  }

  _navigateToCastDetailPage(BuildContext context, Cast cast) {
    widget.changeSelectedCast(cast);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CastDetailContainer()));
  }
}
