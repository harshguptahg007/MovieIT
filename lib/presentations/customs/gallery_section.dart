import 'package:flutter/material.dart';
import 'package:flutter_movies/models/picture.dart';
import 'package:flutter_movies/utils/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GallerySection extends StatelessWidget {
  GallerySection({this.imageList, this.galleryTap, this.imageViewTap});

  Function galleryTap;
  List<Picture> imageList;
  Function imageViewTap;

  @override
  Widget build(BuildContext context) {
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
                'Gallery',
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
                  galleryTap(context, imageList);
                },
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(
              vertical: ScreenUtil.instance.setHeight(10),
              horizontal: ScreenUtil.instance.setHeight(15)),
          height: ScreenUtil.instance.setHeight(200),
          child: new ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: imageList.length,
            itemBuilder: (BuildContext context, int index) {
              return new Container(
                margin: EdgeInsets.symmetric(
                    horizontal: ScreenUtil.instance.setHeight(5)),
                height: ScreenUtil.instance.setHeight(200),
                width: ScreenUtil.instance.setWidth(125),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                      Radius.circular(ScreenUtil.instance.setHeight(20))),
                  child: GestureDetector(
                    child: Image.network(
                      Styles.IMAGE_BASE_URL + imageList[index].mediaUrl,
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      imageViewTap(context, index, imageList);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
