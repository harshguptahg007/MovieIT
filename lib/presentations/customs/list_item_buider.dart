import 'package:flutter/material.dart';
import 'package:flutter_movies/utils/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListItemBuilder extends StatelessWidget {
  ListItemBuilder({this.url, this.width, this.height, this.text});

  double height;
  double width;
  String url;
  String text;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Card(
          margin: EdgeInsets.symmetric(
              horizontal: ScreenUtil.instance.setWidth(5),
              vertical: ScreenUtil.instance.setHeight(5)),
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(ScreenUtil.instance.setHeight(10))),
          ),
          child: Container(
            width: width,
            height: height,
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                  Radius.circular(ScreenUtil.instance.setHeight(10))),
              child: url != null
                  ? Image.network(
                      Styles.IMAGE_BASE_URL + url,
//          loadingBuilder: (BuildContext context, r, i) {
//            return SpinKitFadingCube(
//              size: 20.0,
//              itemBuilder: (_, int index) {
//                return DecoratedBox(
//                  decoration: BoxDecoration(
//                    color: Colors.blue,
//                  ),
//                );
//              },
//            );
//          },
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      Styles.PLACE_HOLDER_IMAGE,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
        text != null
            ? Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: ScreenUtil.instance.setHeight(40),
                  decoration: BoxDecoration(
                      boxShadow: [BoxShadow(color: Colors.white70)]),
                  child: Center(
                    child: Text(
                      text,
                      style: TextStyle(
                          fontSize: 20.0, fontFamily: Styles.FONT_FAMILY),
                    ),
                  ),
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
