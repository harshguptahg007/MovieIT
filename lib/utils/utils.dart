import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_movies/utils/string_value.dart';
import 'package:flutter_movies/utils/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class Utils {
  static List<IntSize> createSizes(int count) {
    Random rnd = new Random();
    return new List.generate(
        count,
        (i) => new IntSize(ScreenUtil.instance.setWidth(200),
            (rnd.nextInt(150) + 150).toDouble()));
  }

  static launchURL(String key) async {
    const url = 'https://www.youtube.com/watch?v=';
    if (Platform.isIOS) {
      if (await canLaunch('${url + key}')) {
        await launch('${url + key}', forceSafariVC: false);
      } else {
        throw 'Could not launch ${url + key}';
      }
    } else {
      if (await canLaunch(url + key)) {
        await launch(url + key);
      } else {
        throw 'Could not launch ${url + key}';
      }
    }
  }

  static Widget noDataWidget() {
    return Container(
      height: ScreenUtil.instance.setHeight(220),
      child: Center(
        child: Text(
          StringValue.NO_DATA,
          style: TextStyle(
            color: Colors.black,
            fontSize: 22.0,
            fontFamily: Styles.FONT_FAMILY,
          ),
        ),
      ),
    );
  }

  static showSnackBar(String text, BuildContext context) {
    if (context != null) {
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              text,
              style: TextStyle(color: Styles.WHITE_COLOR),
            ),
            duration: Duration(milliseconds: 3000),
          ),
        );
    }
  }

  static Widget commonCircularProgress() {
    return Container(
      height: ScreenUtil.instance.setHeight(220),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class IntSize {
  const IntSize(this.width, this.height);

  final double width;
  final double height;
}
