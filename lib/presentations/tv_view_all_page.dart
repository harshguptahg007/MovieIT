import 'package:flutter/material.dart';
import 'package:flutter_movies/containers/tv_show_detail_container.dart';
import 'package:flutter_movies/models/tv_show.dart';
import 'package:flutter_movies/presentations/customs/list_item_buider.dart';
import 'package:flutter_movies/presentations/customs/view_all_page_list_element.dart';
import 'package:flutter_movies/utils/string_value.dart';
import 'package:flutter_movies/utils/styles.dart';
import 'package:flutter_movies/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class TvShowViewAllPage extends StatefulWidget {
  static const String routeNamed = "TvShowViewAllPage";

  TvShowViewAllPage(this.tvShowList, this.changeSelectedTvShow);

  List<TvShow> tvShowList;
  Function changeSelectedTvShow;

  @override
  _TvShowViewAllPageState createState() => _TvShowViewAllPageState();
}

class _TvShowViewAllPageState extends State<TvShowViewAllPage> {
  bool gridViewSelected = true;
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          StringValue.TV_SHOWS,
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
              vertical: ScreenUtil.instance.setHeight(15),
              horizontal: ScreenUtil.instance.setWidth(15)),
          child: gridViewSelected
              ? _gridViewSelected(context)
              : _listViewSelected(context)),
    );
  }

  _gridViewSelected(BuildContext context) {
    List<IntSize> _sizes = Utils.createSizes(widget.tvShowList.length).toList();
    return new StaggeredGridView.countBuilder(
      primary: false,
      shrinkWrap: true,
      crossAxisCount: 4,
      itemCount: widget.tvShowList.length,
      staggeredTileBuilder: (index) => new StaggeredTile.fit(2),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            _navigateToTvShowDetails(context, widget.tvShowList[index].id);
          },
          child: ListItemBuilder(
            url: widget.tvShowList[index].posterPath,
            width: _sizes[index].width.toDouble(),
            height: _sizes[index].height.toDouble(),
          ),
        );
      },
    );
  }

  _listViewSelected(BuildContext context) {
    return ListView.builder(
      itemCount: widget.tvShowList.length,
      itemBuilder: (BuildContext context, index) {
        return ViewAllPageListElement(
          width: ScreenUtil.screenWidth * 0.1,
          url: widget.tvShowList[index].posterPath,
          title: widget.tvShowList[index].name,
          rating: widget.tvShowList[index].ratings,
          onTap: _navigateToTvShowDetails,
          id: widget.tvShowList[index].id,
        );
      },
    );
  }

  _navigateToTvShowDetails(BuildContext context, int tvShowId) {
    widget.changeSelectedTvShow(tvShowId);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => TvShowDetailContainer()));
  }
}
