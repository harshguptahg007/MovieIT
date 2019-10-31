import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movies/models/cast.dart';
import 'package:flutter_movies/models/picture.dart';
import 'package:flutter_movies/presentations/customs/list_item_buider.dart';
import 'package:flutter_movies/presentations/image_view.dart';
import 'package:flutter_movies/utils/string_value.dart';
import 'package:flutter_movies/utils/styles.dart';
import 'package:flutter_movies/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CastsProfilePage extends StatefulWidget {
  CastsProfilePage({this.cast, this.changeSelectedCast});

  Cast cast;
  Function changeSelectedCast;

  @override
  _CastsProfilePageState createState() => _CastsProfilePageState();
}

class _CastsProfilePageState extends State<CastsProfilePage> {
  int selectedTabBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: ScreenUtil.screenHeight,
        margin: EdgeInsets.only(top: ScreenUtil.instance.setHeight(20)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              coverImage(),
              SizedBox(
                height: ScreenUtil.instance.setHeight(20),
              ),
              Text(
                widget.cast.name != null ? widget.cast.name : '',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: Styles.FONT_FAMILY,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0),
              ),
              SizedBox(
                height: ScreenUtil.instance.setHeight(5),
              ),
              widget.cast.placeOfBirth != null
                  ? Text(
                      widget.cast.placeOfBirth,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          fontFamily: Styles.FONT_FAMILY),
                    )
                  : SizedBox(),
              SizedBox(
                height: ScreenUtil.instance.setHeight(20),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: ScreenUtil.instance.setWidth(10)),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: tabBarView(StringValue.OVERVIEW, 0),
                    ),
                    Expanded(
                      flex: 3,
                      child: tabBarView(StringValue.PHOTOS, 1),
                    ),
                    Expanded(
                      flex: 3,
                      child: tabBarView(StringValue.MOVIE_CREDITS, 2),
                    ),
                  ],
                ),
              ),
              Container(
                height: ScreenUtil.instance.setHeight(2),
                width: ScreenUtil.screenWidth,
                color: Styles.PRIMARY_COLOR,
                margin: EdgeInsets.symmetric(
                    horizontal: ScreenUtil.instance.setWidth(10)),
              ),
              selectedTabBarIndex == 0
                  ? _biographyWidget()
                  : selectedTabBarIndex == 1
                      ? _gridViewSelected()
                      : Utils.noDataWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget coverImage() {
    return Container(
      height: ScreenUtil.instance.setHeight(315),
      child: Stack(
        children: <Widget>[
          GestureDetector(
            child: Container(
              height: ScreenUtil.instance.setHeight(250),
              width: ScreenUtil.screenWidth,
              child: imageViewWidget(widget.cast.posterPath),
            ),
            onTap: () {
              imageViewTap(widget.cast.posterPath);
            },
          ),
          Positioned(
            left: ScreenUtil.instance.setWidth(30),
            bottom: ScreenUtil.instance.setHeight(0),
            child: GestureDetector(
              child: Container(
                height: ScreenUtil.instance.setHeight(130),
                width: ScreenUtil.instance.setWidth(130),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.white,
                      width: ScreenUtil.instance.setWidth(5)),
                ),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(ScreenUtil.instance.setHeight(65)),
                  child: imageViewWidget(widget.cast.posterPath),
                ),
              ),
              onTap: () {
                imageViewTap(widget.cast.posterPath);
              },
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
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  _biographyWidget() {
    return widget.cast.biography == null
        ? Utils.commonCircularProgress()
        : Container(
            margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil.instance.setWidth(15),
                vertical: ScreenUtil.instance.setHeight(10)),
            child: widget.cast.biography.isNotEmpty
                ? Text(
                    widget.cast.biography,
                    style: TextStyle(fontSize: 18),
                  )
                : Utils.noDataWidget(),
          );
  }

  _gridViewSelected() {
    if (widget.cast.imageList == null) {
      return Utils.commonCircularProgress();
    } else if (widget.cast.imageList != null &&
        widget.cast.imageList.length > 0) {
      List<IntSize> _sizes =
          Utils.createSizes(widget.cast.imageList.length).toList();
      return new StaggeredGridView.countBuilder(
        primary: false,
        shrinkWrap: true,
        crossAxisCount: 4,
        itemCount: widget.cast.imageList.length,
        staggeredTileBuilder: (index) => new StaggeredTile.fit(2),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _navigateToImageDownloadPage(index, widget.cast.imageList);
            },
            child: ListItemBuilder(
              url: widget.cast.imageList[index].mediaUrl,
              width: _sizes[index].width.toDouble(),
              height: _sizes[index].height.toDouble(),
            ),
          );
        },
      );
    } else {
      return Utils.noDataWidget();
    }
  }

  Widget tabBarView(String title, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTabBarIndex = index;
        });
      },
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: ScreenUtil.instance.setWidth(5)),
        child: Column(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 22.0,
                fontFamily: Styles.FONT_FAMILY,
              ),
              textAlign: TextAlign.justify,
            ),
            SizedBox(
              height: ScreenUtil.instance.setHeight(5),
            ),
            index == selectedTabBarIndex
                ? Container(
                    height: ScreenUtil.instance.setHeight(4),
                    color: Styles.PRIMARY_COLOR,
                    child: Center(),
                  )
                : SizedBox(
                    height: ScreenUtil.instance.setHeight(4),
                  ),
          ],
        ),
      ),
    );
  }

  Widget imageViewWidget(String url) {
    if (url != null) {
      return Image.network(
        Styles.IMAGE_BASE_URL + url,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        Styles.PLACE_HOLDER_IMAGE,
        fit: BoxFit.cover,
      );
    }
  }

  Function imageViewTap(String url) {
    Picture picture = Picture();
    if (url != null) {
      picture = picture.rebuild((b) => b..mediaUrl = url);
      _navigateToImageDownloadPage(0, [picture], isNetwork: true);
    } else {
      picture = picture.rebuild((b) => b..mediaUrl = Styles.PLACE_HOLDER_IMAGE);
      _navigateToImageDownloadPage(0, [picture], isNetwork: false);
    }
  }

  _navigateToImageDownloadPage(int index, List<Picture> imageList,
      {bool isNetwork = true}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          body: ImageView(
            index,
            imageList,
            isNetwork: isNetwork,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.changeSelectedCast(null);
    super.dispose();
  }
}
