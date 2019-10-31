import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_movies/containers/cast_home_page_container.dart';
import 'package:flutter_movies/containers/movie_home_page_container.dart';
import 'package:flutter_movies/containers/search_container.dart';
import 'package:flutter_movies/containers/tv_show_home_page_container.dart';
import 'package:flutter_movies/utils/string_value.dart';
import 'package:flutter_movies/utils/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  static const String routeNamed = "HomePage";

  HomePage({this.categorySelected, this.changeSelectedCategory});

  int categorySelected;
  Function changeSelectedCategory;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int selectedTabBarIndex;
  ScrollController controller = ScrollController();

  double defaultHeight = 640;
  double defaultWidth = 360;

  @override
  void initState() {
    super.initState();
    selectedTabBarIndex = widget.categorySelected;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(
        width: defaultWidth, height: defaultHeight, allowFontScaling: false)
      ..init(context);
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: ScreenUtil.instance.setHeight(20)),
        height: ScreenUtil.screenHeight,
        width: ScreenUtil.screenWidth,
        child: SingleChildScrollView(
          controller: controller,
          child: Column(
            children: <Widget>[
              titleTabBar(),
              selectedTabBarIndex == 0
                  ? MovieHomePageContainer()
                  : selectedTabBarIndex == 1
                      ? TvShowHomePageContainer()
                      : CastHomePageContainer(),
            ],
          ),
        ),
      ),
    );
  }

  titleTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Styles.PRIMARY_COLOR,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(ScreenUtil.instance.setWidth(50)),
          bottomRight: Radius.circular(ScreenUtil.instance.setWidth(50)),
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: ScreenUtil.instance.setHeight(5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Opacity(
                  opacity: 0,
                  child: IconButton(
                    icon: Icon(
                      Icons.filter_list,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ),
                Text(
                  StringValue.APP_NAME,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.0,
                    fontFamily: Styles.FONT_FAMILY,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: _navigateToSearchPage,
                )
              ],
            ),
          ),
          SizedBox(
            height: ScreenUtil.instance.setHeight(10),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                vertical: ScreenUtil.instance.setHeight(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                selectedTabBarIndex == 0
                    ? selectedTabBarView(StringValue.MOVIES)
                    : tabBarView(StringValue.MOVIES, 0),
                selectedTabBarIndex == 1
                    ? selectedTabBarView(StringValue.TV_SHOWS)
                    : tabBarView(StringValue.TV_SHOWS, 1),
                selectedTabBarIndex == 2
                    ? selectedTabBarView(StringValue.PEOPLE)
                    : tabBarView(StringValue.PEOPLE, 2),
              ],
            ),
          ),
          SizedBox(height: ScreenUtil.instance.setHeight(10))
        ],
      ),
    );
  }

  tabBarView(String text, int index) {
    return GestureDetector(
      child: Text(
        text,
        style: TextStyle(
            color: Colors.white,
            fontSize: 22.0,
            fontFamily: Styles.FONT_FAMILY),
      ),
      onTap: () {
        widget.changeSelectedCategory(index);
        setState(() {
          selectedTabBarIndex = index;
        });
      },
    );
  }

  selectedTabBarView(String text) {
    return Container(
      height: ScreenUtil.instance.setHeight(40),
      padding: EdgeInsets.symmetric(
        vertical: ScreenUtil.instance.setHeight(5),
        horizontal: ScreenUtil.instance.setWidth(10),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.all(Radius.circular(ScreenUtil.instance.setWidth(15))),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              color: Styles.PRIMARY_COLOR,
              fontSize: 28.0,
              fontFamily: Styles.FONT_FAMILY),
        ),
      ),
    );
  }

  _navigateToSearchPage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SearchContainer()));
  }
}
