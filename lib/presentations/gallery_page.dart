import 'package:flutter/material.dart';
import 'package:flutter_movies/models/picture.dart';
import 'package:flutter_movies/presentations/customs/list_item_buider.dart';
import 'package:flutter_movies/presentations/image_view.dart';
import 'package:flutter_movies/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class GalleryPage extends StatelessWidget {
  static const String routeNamed = "GalleryPage";

  GalleryPage(this.imageList);

  List<Picture> imageList;

  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: ScreenUtil.instance.setHeight(20)),
        height: ScreenUtil.screenHeight,
        width: ScreenUtil.screenWidth,
        child: _staggeredImageView(context),
      ),
    );
  }

  Widget _staggeredImageView(BuildContext context) {
    List<IntSize> _sizes = Utils.createSizes(imageList.length).toList();
    return new StaggeredGridView.countBuilder(
      primary: false,
      shrinkWrap: true,
      crossAxisCount: 4,
      itemCount: imageList.length,
      staggeredTileBuilder: (index) => new StaggeredTile.fit(2),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            _navigateToImageView(context, index: index);
          },
          child: ListItemBuilder(
            url: imageList[index].mediaUrl,
            width: _sizes[index].width.toDouble(),
            height: _sizes[index].height.toDouble(),
          ),
        );
      },
    );
  }

  _navigateToImageView(BuildContext context, {int index = 0}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Scaffold(body: ImageView(index, imageList))));
  }
}
