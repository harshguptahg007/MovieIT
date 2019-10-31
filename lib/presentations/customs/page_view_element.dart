import 'package:flutter/material.dart';
import 'package:flutter_movies/utils/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PageViewElement extends StatelessWidget {
  PageViewElement(
      {this.onTap,
      this.id,
      this.scale,
      this.width,
      this.backgroundUrl,
      this.name});

  Function onTap;
  int id;
  double scale;
  double width;
  String backgroundUrl;
  String name;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(context, id);
      },
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            height: ScreenUtil.instance.setHeight(200) * scale,
            width: width,
            margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil.instance.setWidth(10)),
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                  Radius.circular(ScreenUtil.instance.setHeight(10))),
              child: Image.network(
                Styles.IMAGE_BASE_URL + backgroundUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: ScreenUtil.instance.setHeight(40),
              decoration:
                  BoxDecoration(boxShadow: [BoxShadow(color: Colors.white70)]),
              child: Center(
                child: Text(
                  name,
                  style:
                      TextStyle(fontSize: 20.0, fontFamily: Styles.FONT_FAMILY),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
