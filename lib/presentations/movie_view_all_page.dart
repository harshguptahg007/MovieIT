import 'package:flutter/material.dart';
import 'package:flutter_movies/containers/movie_detail_container.dart';
import 'package:flutter_movies/models/movie.dart';
import 'package:flutter_movies/presentations/customs/list_item_buider.dart';
import 'package:flutter_movies/presentations/customs/view_all_page_list_element.dart';
import 'package:flutter_movies/utils/string_value.dart';
import 'package:flutter_movies/utils/styles.dart';
import 'package:flutter_movies/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MovieViewAllPage extends StatefulWidget {
  static const String routeNamed = "MovieViewAllPage";

  List<Movie> movieList;
  Function changeSelectedMovie;

  MovieViewAllPage(this.movieList, this.changeSelectedMovie);

  @override
  _MovieViewAllPageState createState() => _MovieViewAllPageState();
}

class _MovieViewAllPageState extends State<MovieViewAllPage> {
  bool gridViewSelected = true;
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          StringValue.MOVIES,
          style: TextStyle(
              color: Colors.black,
              fontFamily: Styles.FONT_FAMILY,
              fontSize: 25.0),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              gridViewSelected ? Icons.grid_on : Icons.list,
              color: Colors.blue,
            ),
            onPressed: () {
              setState(() {
                gridViewSelected = !gridViewSelected;
              });
            },
          )
        ],
      ),
      body: Container(
          width: ScreenUtil.screenWidth,
          height: ScreenUtil.screenHeight,
          margin: EdgeInsets.symmetric(
              vertical: ScreenUtil.instance.setHeight(10),
              horizontal: ScreenUtil.instance.setWidth(10)),
          child: gridViewSelected
              ? _gridViewSelected(context)
              : _listViewSelected(context)),
    );
  }

  _gridViewSelected(BuildContext context) {
    List<IntSize> _sizes = Utils.createSizes(widget.movieList.length).toList();
    return new StaggeredGridView.countBuilder(
      primary: false,
      shrinkWrap: true,
      crossAxisCount: 4,
      itemCount: widget.movieList.length,
      staggeredTileBuilder: (index) => new StaggeredTile.fit(2),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            _navigateToMovieDetails(context, widget.movieList[index].id);
          },
          child: ListItemBuilder(
            url: widget.movieList[index].posterPath,
            width: _sizes[index].width.toDouble(),
            height: _sizes[index].height.toDouble(),
          ),
        );
      },
    );
  }

  _listViewSelected(BuildContext context) {
    return ListView.builder(
      itemCount: widget.movieList.length,
      itemBuilder: (BuildContext context, index) {
        return ViewAllPageListElement(
          width: ScreenUtil.screenWidth * 0.1,
          url: widget.movieList[index].posterPath,
          title: widget.movieList[index].title,
          rating: widget.movieList[index].rating,
          onTap: _navigateToMovieDetails,
          id: widget.movieList[index].id,
        );
      },
    );
  }

  _navigateToMovieDetails(BuildContext context, int movieId) {
    widget.changeSelectedMovie(movieId);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => MovieDetailContainer()));
  }
}
