import 'package:flutter/material.dart';
import 'package:flutter_movies/models/cast.dart';
import 'package:flutter_movies/models/movie.dart';
import 'package:flutter_movies/models/picture.dart';
import 'package:flutter_movies/presentations/cast_tab_bar.dart';
import 'package:flutter_movies/presentations/customs/chip_design.dart';
import 'package:flutter_movies/presentations/customs/review_card.dart';
import 'package:flutter_movies/presentations/image_view.dart';
import 'package:flutter_movies/presentations/movie_details/movie_info_tab.dart';
import 'package:flutter_movies/utils/clipper.dart';
import 'package:flutter_movies/utils/custom_shadow_path.dart';
import 'package:flutter_movies/utils/string_value.dart';
import 'package:flutter_movies/utils/styles.dart';
import 'package:flutter_movies/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MovieDetailPage extends StatefulWidget {
  static const String routeNamed = "MovieDetailPage";

  MovieDetailPage(
      {this.movie,
      this.changeSelectedMovie,
      this.similarMovies,
      this.recommendedMovies,
      this.castList,
      this.changeSelectedCast});

  Movie movie;
  Function changeSelectedMovie;
  List<Movie> similarMovies;
  List<Movie> recommendedMovies;
  List<Cast> castList;
  Function changeSelectedCast;

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  bool isFavorite;
  int selectedTabBarIndex;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    isFavorite = false;
    selectedTabBarIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: ScreenUtil.instance.setHeight(20)),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              coverImageWidget(),
              Container(
                margin: EdgeInsets.only(
                    left: ScreenUtil.instance.setWidth(20),
                    right: ScreenUtil.instance.setWidth(20),
                    top: ScreenUtil.instance.setHeight(15),
                    bottom: ScreenUtil.instance.setHeight(2)),
                child: Text(
                  widget.movie.title,
                  style:
                      TextStyle(fontFamily: Styles.FONT_FAMILY, fontSize: 28.0),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: ScreenUtil.instance.setWidth(30)),
                child: Text(
                  widget.movie.releaseDate,
                  style: TextStyle(
                      fontSize: 17.0,
                      fontFamily: Styles.FONT_FAMILY,
                      color: Colors.grey),
                ),
              ),
              ratingWidget(),
              genreWidget(),
              Container(
                margin: EdgeInsets.only(
                    top: ScreenUtil.instance.setHeight(15),
                    left: ScreenUtil.instance.setWidth(20),
                    right: ScreenUtil.instance.setWidth(20)),
                child: Row(
                  children: <Widget>[
                    tabBarView(StringValue.INFO, 0),
                    SizedBox(
                      width: ScreenUtil.instance.setWidth(5),
                    ),
                    tabBarView(StringValue.CASTS, 1),
                    SizedBox(
                      width: ScreenUtil.instance.setWidth(5),
                    ),
                    tabBarView(StringValue.REVIEWS, 2),
                  ],
                ),
              ),
              Container(
                height: 1,
                width: ScreenUtil.screenWidth,
                color: Styles.PRIMARY_COLOR,
                margin: EdgeInsets.symmetric(
                    horizontal: ScreenUtil.instance.setWidth(10)),
              ),
              selectedTabBarIndex == 0
                  ? MovieInfoTabView(
                      movie: widget.movie,
                      changeSelectedMovie: widget.changeSelectedMovie,
                      similarMovies: widget.similarMovies,
                      recommendedMovies: widget.recommendedMovies,
                    )
                  : selectedTabBarIndex == 1
                      ? CastTabBar(scrollController, widget.castList,
                          widget.changeSelectedCast)
                      : reviewWidget()
            ],
          ),
        ),
      ),
    );
  }

  Widget coverImageWidget() {
    return Container(
      height: ScreenUtil.instance.setHeight(330),
      width: ScreenUtil.screenWidth,
      child: Stack(
        children: <Widget>[
          ClipShadowPath(
            clipper: ClippingClass(),
            shadow: Shadow(
              blurRadius: 5.0,
            ),
            child: Container(
              height: ScreenUtil.instance.setHeight(300),
              width: ScreenUtil.screenWidth,
              child: GestureDetector(
                child: Image.network(
                  Styles.IMAGE_BASE_URL + widget.movie.posterPath,
                  fit: BoxFit.cover,
                ),
                onTap: () {
                  _navigateToImageDownloadPage(
                      context, 0, widget.movie.posterPath);
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FloatingActionButton(
              backgroundColor: Styles.PRIMARY_COLOR,
              onPressed: () {
                Utils.launchURL(widget.movie.videoList[0].key);
              },
              child: Center(
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              height: ScreenUtil.instance.setHeight(50),
              width: ScreenUtil.instance.setHeight(50),
              margin: EdgeInsets.only(
                  top: ScreenUtil.instance.setHeight(10),
                  right: ScreenUtil.instance.setWidth(10)),
              decoration: BoxDecoration(
                color: Styles.PRIMARY_COLOR,
                borderRadius:
                    BorderRadius.circular(ScreenUtil.instance.setHeight(25)),
              ),
              child: Center(
                child: IconButton(
                  icon: Icon(
                    Icons.favorite,
                    size: 28.0,
                    color: isFavorite ? Colors.red : Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                  },
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 10,
            child: IconButton(
              icon: Icon(
                Icons.add,
                size: ScreenUtil.instance.setHeight(35),
                color: Styles.PRIMARY_COLOR,
              ),
              onPressed: () {},
            ),
          ),
          Positioned(
            top: 10.0,
            left: 10.0,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                widget.changeSelectedCast(null);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget ratingWidget() {
    return Container(
      margin: EdgeInsets.all(ScreenUtil.instance.setHeight(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.star,
            color: Colors.yellow,
          ),
          Icon(
            Icons.star,
            color: Colors.yellow,
          ),
          Icon(
            Icons.star,
            color: Colors.yellow,
          ),
          Icon(
            Icons.star,
            color: Colors.yellow,
          ),
          Icon(
            Icons.star,
            color: Colors.yellow,
          ),
        ],
      ),
    );
  }

  Widget genreWidget() {
    List<Widget> genreList = List();
    int total = widget.movie.genreList.length;
    for (int index = 0; index < total; index++) {
      genreList.add(ChipDesign(
          label: widget.movie.genreList[index].name,
          color: Styles.COLOR_LIST[index % widget.movie.genreList.length]));
    }
    return Wrap(spacing: -12.0, runSpacing: -15.0, children: genreList);
  }

  Widget tabBarView(String title, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTabBarIndex = index;
        });
      },
      child: Container(
        width: ScreenUtil.instance.setWidth(80),
        child: Column(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 22.0,
                  fontFamily: Styles.FONT_FAMILY),
            ),
            SizedBox(
              height: ScreenUtil.instance.setHeight(5),
            ),
            index == selectedTabBarIndex
                ? Container(
                    height: ScreenUtil.instance.setHeight(4),
                    width: ScreenUtil.instance.setWidth(80),
                    color: Styles.PRIMARY_COLOR,
                  )
                : SizedBox(
                    height: ScreenUtil.instance.setHeight(4),
                  ),
          ],
        ),
      ),
    );
  }

  Widget reviewWidget() {
    if (widget.movie.reviewList == null) {
      return Utils.commonCircularProgress();
    } else if (widget.movie.reviewList.isEmpty) {
      return Utils.noDataWidget();
    } else {
      return ListView.builder(
        shrinkWrap: true,
        controller: scrollController,
        itemCount: widget.movie.reviewList.length,
        itemBuilder: (BuildContext context, int index) {
          return ReviewCard(
            review: widget.movie.reviewList[index],
          );
        },
      );
    }
  }

  _navigateToImageDownloadPage(
      BuildContext context, int index, String imageList) {
    Picture picture = Picture().rebuild((b) => b..mediaUrl = imageList);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Scaffold(body: ImageView(index, [picture]))));
  }
}
