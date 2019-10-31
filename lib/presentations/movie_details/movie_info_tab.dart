import 'package:flutter/material.dart';
import 'package:flutter_movies/containers/movie_detail_container.dart';
import 'package:flutter_movies/models/movie.dart';
import 'package:flutter_movies/models/picture.dart';
import 'package:flutter_movies/presentations/customs/gallery_section.dart';
import 'package:flutter_movies/presentations/customs/list_item_buider.dart';
import 'package:flutter_movies/presentations/gallery_page.dart';
import 'package:flutter_movies/presentations/image_view.dart';
import 'package:flutter_movies/presentations/movie_view_all_page.dart';
import 'package:flutter_movies/utils/string_value.dart';
import 'package:flutter_movies/utils/styles.dart';
import 'package:flutter_movies/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MovieInfoTabView extends StatelessWidget {
  MovieInfoTabView(
      {this.movie,
      this.changeSelectedMovie,
      this.similarMovies,
      this.recommendedMovies});

  Movie movie;
  Function changeSelectedMovie;
  List<Movie> similarMovies;
  List<Movie> recommendedMovies;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: ScreenUtil.instance.setHeight(10),
        ),
        infoWidget(),
        imageListWidget(context),
        similarWidget(context),
        recommendedWidget(context),
        SizedBox(
          height: ScreenUtil.instance.setHeight(20),
        ),
      ],
    );
  }

  Widget infoWidget() {
    return new Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(
          vertical: ScreenUtil.instance.setHeight(10),
          horizontal: ScreenUtil.instance.setWidth(15)),
      child: movie.info == null
          ? Utils.commonCircularProgress()
          : movie.info.isNotEmpty
              ? Text(
                  movie.info,
                  style:
                      TextStyle(fontSize: 19.0, fontFamily: Styles.FONT_FAMILY),
                )
              : SizedBox(),
    );
  }

  Widget imageListWidget(BuildContext context) {
    return movie.imageList == null
        ? Utils.commonCircularProgress()
        : movie.imageList.isNotEmpty
            ? galleryWidget(context, movie.imageList)
            : SizedBox();
  }

  Widget galleryWidget(BuildContext context, List<Picture> imageList) {
    return GallerySection(
      galleryTap: _navigateToGalleryPage,
      imageList: imageList,
      imageViewTap: _navigateToImageDownloadPage,
    );
  }

  Widget similarWidget(BuildContext context) {
    return similarMovies == null
        ? Utils.commonCircularProgress()
        : similarMovies.isNotEmpty
            ? movieListWidget(context, similarMovies, MovieListType.SIMILAR)
            : SizedBox();
  }

  Widget recommendedWidget(BuildContext context) {
    return recommendedMovies == null
        ? Utils.commonCircularProgress()
        : recommendedMovies.isNotEmpty
            ? movieListWidget(
                context, recommendedMovies, MovieListType.RECOMMENDED)
            : SizedBox();
  }

  Widget movieListWidget(
      BuildContext context, List<Movie> movieList, MovieListType type) {
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
                type == MovieListType.SIMILAR
                    ? StringValue.SIMILAR_MOVIES
                    : StringValue.RECOMMENDED_MOVIES,
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
                  _navigateToViewAllPage(context, movieList);
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

  _navigateToGalleryPage(BuildContext context, List<Picture> imageList) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => GalleryPage(imageList)));
  }

  _navigateToMovieDetailPage(BuildContext context, int movieId) {
    changeSelectedMovie(movieId);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => MovieDetailContainer()));
  }

  _navigateToImageDownloadPage(
      BuildContext context, int index, List<Picture> imageList) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Scaffold(body: ImageView(index, imageList))));
  }

  _navigateToViewAllPage(BuildContext context, List<Movie> movieList) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MovieViewAllPage(movieList, changeSelectedMovie)));
  }
}

enum MovieListType { SIMILAR, RECOMMENDED }
