import 'package:flutter/material.dart';
import 'package:flutter_movies/utils/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MoviePlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: ScreenUtil.instance.setHeight(200),
          width: ScreenUtil.instance.setWidth(140),
          foregroundDecoration: BoxDecoration(
            color: Color.fromRGBO(74, 102, 219, 0.4),
            borderRadius: BorderRadius.all(
                Radius.circular(ScreenUtil.instance.setHeight(10))),
          ),
          margin: EdgeInsets.only(right: ScreenUtil.instance.setWidth(15)),
          child: ClipRRect(
            borderRadius: BorderRadius.all(
                Radius.circular(ScreenUtil.instance.setHeight(10))),
            child: Image.asset(
              Styles.PLACE_HOLDER_IMAGE,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 0.0,
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: IconButton(
            icon: Icon(
              Icons.play_circle_outline,
              color: Colors.white,
              size: ScreenUtil.instance.setHeight(60),
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
