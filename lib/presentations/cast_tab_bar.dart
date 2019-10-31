import 'package:flutter/material.dart';
import 'package:flutter_movies/containers/cast_detail_container.dart';
import 'package:flutter_movies/models/cast.dart';
import 'package:flutter_movies/presentations/customs/list_item_buider.dart';
import 'package:flutter_movies/utils/utils.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CastTabBar extends StatelessWidget {
  CastTabBar(this.scrollController, this.castList, this.changeSelectedCast);

  ScrollController scrollController;
  List<Cast> castList;
  Function changeSelectedCast;

  @override
  Widget build(BuildContext context) {
    if (castList == null) {
      return Utils.commonCircularProgress();
    } else if (castList.length > 0) {
      List<IntSize> _sizes = Utils.createSizes(castList.length).toList();
      return new StaggeredGridView.countBuilder(
        controller: scrollController,
        primary: false,
        shrinkWrap: true,
        crossAxisCount: 4,
        itemCount: castList.length,
        staggeredTileBuilder: (index) => new StaggeredTile.fit(2),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _navigateToCastDetailPage(context, castList[index].id);
            },
            child: ListItemBuilder(
              url: castList[index].posterPath,
              width: _sizes[index].width.toDouble(),
              height: _sizes[index].height.toDouble(),
              text: castList[index].name,
            ),
          );
        },
      );
    } else {
      return Utils.noDataWidget();
    }
  }

  _navigateToCastDetailPage(BuildContext context, int castId) {
    changeSelectedCast(castId);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CastDetailContainer()));
  }
}
