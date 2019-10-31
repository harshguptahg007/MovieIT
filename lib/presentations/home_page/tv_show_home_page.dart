import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movies/containers/tv_show_detail_container.dart';
import 'package:flutter_movies/models/tv_show.dart';
import 'package:flutter_movies/presentations/customs/list_item_buider.dart';
import 'package:flutter_movies/presentations/customs/page_view_element.dart';
import 'package:flutter_movies/presentations/tv_view_all_page.dart';
import 'package:flutter_movies/utils/string_value.dart';
import 'package:flutter_movies/utils/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TvShowHomePage extends StatefulWidget {
  List<TvShow> tvShowAiringToday;
  List<TvShow> tvShowOnTheAir;
  List<TvShow> popularTvShow;
  List<TvShow> topRatedTvShow;
  List<TvShow> trendingTvShow;
  Function changeSelectedTvShow;

  TvShowHomePage({
    this.tvShowAiringToday,
    this.tvShowOnTheAir,
    this.popularTvShow,
    this.topRatedTvShow,
    this.changeSelectedTvShow,
    this.trendingTvShow,
  });

  @override
  _TvShowHomePageState createState() => _TvShowHomePageState();
}

class _TvShowHomePageState extends State<TvShowHomePage> {
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
        trendingWidget(),
        SizedBox(
          height: ScreenUtil.instance.setHeight(25),
        ),
        tvAiringWidget(),
        SizedBox(
          height: ScreenUtil.instance.setHeight(25),
        ),
        tvOnAirWidget(),
        SizedBox(
          height: ScreenUtil.instance.setHeight(25),
        ),
        popularWidget(),
        SizedBox(
          height: ScreenUtil.instance.setHeight(25),
        ),
        topRatedWidget(),
        SizedBox(
          height: ScreenUtil.instance.setHeight(25),
        ),
      ],
    );
  }

  Widget trendingWidget() {
    return widget.trendingTvShow == null
        ? Container(
            height: ScreenUtil.screenHeight / 4,
            child: Center(child: CircularProgressIndicator()),
          )
        : widget.trendingTvShow.length > 0
            ? Container(
                margin: EdgeInsets.only(top: ScreenUtil.instance.setHeight(10)),
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
                    itemCount: widget.trendingTvShow.length,
                    controller: pageController,
                    itemBuilder: (BuildContext context, index) {
                      final scale = max(
                          SCALE_FRACTION,
                          (FULL_SCALE - (index - page).abs()) +
                              viewPortFraction);
                      return pageViewBuilder(
                          index, scale, widget.trendingTvShow[index]);
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

  Widget pageViewBuilder(int index, double scale, TvShow tvShow) {
    return PageViewElement(
        onTap: _navigateToTvShowDetailPage,
        id: tvShow.id,
        scale: scale,
        width: ScreenUtil.screenWidth - 60,
        backgroundUrl: tvShow.backgroundImage,
        name: tvShow.name);
  }

  Widget tvAiringWidget() {
    return widget.tvShowAiringToday == null
        ? Container(
            height: ScreenUtil.instance.setHeight(220),
            child: Center(child: CircularProgressIndicator()),
          )
        : widget.tvShowAiringToday.length > 0
            ? showTvShowFields(
                fieldTitle: StringValue.TV_SHOW_AIRING,
                tvShowList: widget.tvShowAiringToday)
            : SizedBox();
  }

  Widget tvOnAirWidget() {
    return widget.tvShowOnTheAir == null
        ? Container(
            height: ScreenUtil.instance.setHeight(220),
            child: Center(child: CircularProgressIndicator()),
          )
        : widget.tvShowOnTheAir.length > 0
            ? showTvShowFields(
                fieldTitle: StringValue.TV_ON_AIR,
                tvShowList: widget.tvShowOnTheAir)
            : SizedBox();
  }

  Widget popularWidget() {
    return widget.popularTvShow == null
        ? Container(
            height: ScreenUtil.instance.setHeight(220),
            child: Center(child: CircularProgressIndicator()),
          )
        : widget.popularTvShow.length > 0
            ? showTvShowFields(
                fieldTitle: StringValue.POPULAR,
                tvShowList: widget.popularTvShow,
              )
            : SizedBox();
  }

  Widget topRatedWidget() {
    return widget.topRatedTvShow == null
        ? Container(
            height: ScreenUtil.instance.setHeight(220),
            child: Center(child: CircularProgressIndicator()),
          )
        : widget.topRatedTvShow.length > 0
            ? showTvShowFields(
                fieldTitle: StringValue.TOP_RATED,
                tvShowList: widget.topRatedTvShow,
              )
            : SizedBox();
  }

  showTvShowFields({String fieldTitle, List<TvShow> tvShowList}) {
    return new Column(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.symmetric(
              vertical: ScreenUtil.instance.setHeight(10),
              horizontal: ScreenUtil.instance.setWidth(15)),
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
                  Icons.view_comfy,
                  color: Colors.blue,
                  size: ScreenUtil.instance.setHeight(20),
                ),
                onTap: () {
                  _navigateToViewAllPage(context, tvShowList);
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
            itemCount: tvShowList.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  _navigateToTvShowDetailPage(context, tvShowList[index].id);
                },
                child: ListItemBuilder(
                    height: ScreenUtil.instance.setHeight(200),
                    width: ScreenUtil.instance.setWidth(125),
                    url: tvShowList[index].posterPath),
              );
            },
          ),
        ),
      ],
    );
  }

  _navigateToViewAllPage(BuildContext context, List<TvShow> tvShowList) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                TvShowViewAllPage(tvShowList, widget.changeSelectedTvShow)));
  }

  _navigateToTvShowDetailPage(BuildContext context, int tvShowId) {
    widget.changeSelectedTvShow(tvShowId);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => TvShowDetailContainer()));
  }

  _timer() {
    timer = new Timer.periodic(twentyMillis, (Timer t) {
      if (widget.trendingTvShow != null && widget.trendingTvShow.length > 0) {
        if (pageController.page != widget.trendingTvShow.length - 1) {
          setState(() {
            pageController.nextPage(
                duration: Duration(milliseconds: 600), curve: Curves.easeInOut);
          });
        } else {
          pageController.animateToPage(0,
              duration: Duration(milliseconds: 600), curve: Curves.easeInOut);
        }
      }
    });
  }
}
