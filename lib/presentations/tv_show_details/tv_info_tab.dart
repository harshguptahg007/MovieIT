import 'package:flutter/material.dart';
import 'package:flutter_movies/containers/tv_show_detail_container.dart';
import 'package:flutter_movies/models/picture.dart';
import 'package:flutter_movies/models/tv_show.dart';
import 'package:flutter_movies/presentations/customs/gallery_section.dart';
import 'package:flutter_movies/presentations/customs/list_item_buider.dart';
import 'package:flutter_movies/presentations/gallery_page.dart';
import 'package:flutter_movies/presentations/image_view.dart';
import 'package:flutter_movies/presentations/tv_view_all_page.dart';
import 'package:flutter_movies/utils/string_value.dart';
import 'package:flutter_movies/utils/styles.dart';
import 'package:flutter_movies/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TvInfoTabView extends StatelessWidget {
  TvInfoTabView(
      {this.tvShow,
      this.changeSelectedTvShow,
      this.similarTvShows,
      this.recommendedTvShows});

  TvShow tvShow;
  Function changeSelectedTvShow;
  List<TvShow> similarTvShows;
  List<TvShow> recommendedTvShows;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: ScreenUtil.instance.setHeight(10),
        ),
        infoWidget(),
        imageListWidget(context),
        similarListWidget(context),
        recommendedWidget(context),
        SizedBox(
          height: ScreenUtil.instance.setHeight(20),
        ),
      ],
    );
  }

  Widget infoWidget() {
    return tvShow.info == null
        ? Utils.commonCircularProgress()
        : tvShow.info.isNotEmpty
            ? new Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(
                    vertical: ScreenUtil.instance.setHeight(10),
                    horizontal: ScreenUtil.instance.setWidth(15)),
                child: Text(
                  tvShow.info,
                  style:
                      TextStyle(fontSize: 19.0, fontFamily: Styles.FONT_FAMILY),
                ),
              )
            : SizedBox();
  }

  Widget imageListWidget(BuildContext context) {
    return tvShow.imageList == null
        ? Utils.commonCircularProgress()
        : tvShow.imageList.isNotEmpty
            ? galleryWidget(context, tvShow.imageList)
            : SizedBox();
  }

  Widget galleryWidget(BuildContext context, List<Picture> imageList) {
    return GallerySection(
      galleryTap: _navigateToGalleryPage,
      imageList: imageList,
      imageViewTap: _navigateToImageDownloadPage,
    );
  }

  Widget similarListWidget(BuildContext context) {
    return similarTvShows == null
        ? Utils.commonCircularProgress()
        : similarTvShows.isNotEmpty
            ? tvShowListWidget(context, similarTvShows, TvShowType.SIMILAR)
            : SizedBox();
  }

  Widget recommendedWidget(BuildContext context) {
    return recommendedTvShows == null
        ? Utils.commonCircularProgress()
        : recommendedTvShows.isNotEmpty
            ? tvShowListWidget(
                context, recommendedTvShows, TvShowType.RECOMMENDED)
            : SizedBox();
  }

  Widget tvShowListWidget(
      BuildContext context, List<TvShow> tvShowList, TvShowType type) {
    return Column(
      children: <Widget>[
        new Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.symmetric(
              vertical: ScreenUtil.instance.setHeight(10),
              horizontal: ScreenUtil.instance.setWidth(15)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                type == TvShowType.SIMILAR
                    ? StringValue.SIMILAR_TV_SHOWS
                    : StringValue.RECOMMENDED_TV_SHOWS,
                style: TextStyle(
                    fontSize: 22.0,
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
              ),
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

  _navigateToGalleryPage(BuildContext context, List<Picture> imageList) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => GalleryPage(imageList)));
  }

  _navigateToTvShowDetailPage(BuildContext context, int tvShowId) {
    changeSelectedTvShow(tvShowId);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => TvShowDetailContainer()));
  }

  _navigateToImageDownloadPage(
      BuildContext context, int index, List<Picture> imageList) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Scaffold(body: ImageView(index, imageList))));
  }

  _navigateToViewAllPage(BuildContext context, List<TvShow> tvShowList) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                TvShowViewAllPage(tvShowList, changeSelectedTvShow)));
  }
}

enum TvShowType { SIMILAR, RECOMMENDED }
