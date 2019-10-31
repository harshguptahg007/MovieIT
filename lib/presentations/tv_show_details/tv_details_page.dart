import 'package:flutter/material.dart';
import 'package:flutter_movies/models/cast.dart';
import 'package:flutter_movies/models/picture.dart';
import 'package:flutter_movies/models/tv_show.dart';
import 'package:flutter_movies/presentations/cast_tab_bar.dart';
import 'package:flutter_movies/presentations/customs/chip_design.dart';
import 'package:flutter_movies/presentations/customs/review_card.dart';
import 'package:flutter_movies/presentations/image_view.dart';
import 'package:flutter_movies/presentations/tv_show_details/tv_info_tab.dart';
import 'package:flutter_movies/utils/string_value.dart';
import 'package:flutter_movies/utils/styles.dart';
import 'package:flutter_movies/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TvDetailsPage extends StatefulWidget {
  static const String routeNamed = "TvDetailsPage";

  TvDetailsPage(
      {this.tvShow,
      this.changeSelectedTvShow,
      this.similarTvShows,
      this.castList,
      this.changeSelectedCast,
      this.recommendedTvShows});

  TvShow tvShow;
  Function changeSelectedTvShow;
  List<TvShow> similarTvShows;
  List<TvShow> recommendedTvShows;
  List<Cast> castList;
  Function changeSelectedCast;

  @override
  _TvDetailsPageState createState() => _TvDetailsPageState();
}

class _TvDetailsPageState extends State<TvDetailsPage> {
  bool isFavorite;
  int selectedTabBarIndex;
  ScrollController controller = ScrollController();

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
        height: ScreenUtil.screenHeight,
        width: ScreenUtil.screenWidth,
        child: SingleChildScrollView(
          controller: controller,
          child: Column(
            children: <Widget>[
              coverImageWidget(),
              Container(
                margin: EdgeInsets.only(
                    left: ScreenUtil.instance.setWidth(20),
                    right: ScreenUtil.instance.setWidth(20),
                    top: ScreenUtil.instance.setHeight(15),
                    bottom: ScreenUtil.instance.setHeight(2)),
                child: Text(
                  widget.tvShow.name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: Styles.FONT_FAMILY,
                      fontSize: 28.0),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: ScreenUtil.instance.setWidth(30)),
                child: Text(
                  widget.tvShow.releaseDate,
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
                  ? TvInfoTabView(
                      tvShow: widget.tvShow,
                      changeSelectedTvShow: widget.changeSelectedTvShow,
                      similarTvShows: widget.similarTvShows,
                      recommendedTvShows: widget.recommendedTvShows,
                    )
                  : selectedTabBarIndex == 1
                      ? CastTabBar(controller, widget.castList,
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
      height: ScreenUtil.instance.setHeight(340),
      width: ScreenUtil.screenWidth,
      child: Stack(
        children: <Widget>[
          Container(
            height: ScreenUtil.instance.setHeight(300),
            width: ScreenUtil.screenWidth,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(ScreenUtil.instance.setWidth(30)),
                bottomLeft: Radius.circular(ScreenUtil.instance.setWidth(30)),
              ),
              child: GestureDetector(
                child: Image.network(
                  Styles.IMAGE_BASE_URL + widget.tvShow.backgroundImage,
                  fit: BoxFit.cover,
                ),
                onTap: () {
                  _navigateToImageDownloadPage(
                      context, 0, widget.tvShow.backgroundImage);
                },
              ),
            ),
          ),
          Positioned(
            bottom: ScreenUtil.instance.setHeight(15),
            right: ScreenUtil.instance.setWidth(40),
            child: FloatingActionButton(
              backgroundColor: Styles.PRIMARY_COLOR,
              onPressed: () {
                Utils.launchURL(widget.tvShow.videoList[0].key);
              },
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              height: ScreenUtil.instance.setHeight(50),
              width: ScreenUtil.instance.setWidth(50),
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
                    size: ScreenUtil.instance.setHeight(28),
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
            left: ScreenUtil.instance.setWidth(10),
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
    if (widget.tvShow.reviewList == null) {
      return Utils.commonCircularProgress();
    } else if (widget.tvShow.reviewList.isEmpty) {
      return Utils.noDataWidget();
    } else {
      return ListView.builder(
        shrinkWrap: true,
        controller: controller,
        itemCount: widget.tvShow.reviewList.length,
        itemBuilder: (BuildContext context, int index) {
          return ReviewCard(
            review: widget.tvShow.reviewList[index],
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

  Widget genreWidget() {
    List<Widget> genreList = List();
    int total = widget.tvShow.genreList.length;
    for (int index = 0; index < total; index++) {
      genreList.add(ChipDesign(
          label: widget.tvShow.genreList[index].name,
          color: Styles.COLOR_LIST[index % widget.tvShow.genreList.length]));
    }
    return Wrap(spacing: -12.0, runSpacing: -15.0, children: genreList);
  }
}
