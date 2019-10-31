import 'package:flutter/material.dart';
import 'package:flutter_movies/utils/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChipDesign extends StatelessWidget {
  String label;
  Color color;

  ChipDesign({this.label, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Chip(
        label: Text(
          label,
          style: TextStyle(
              color: Styles.WHITE_COLOR,
              fontFamily: Styles.FONT_FAMILY,
              fontSize: 18.0),
        ),
        backgroundColor: color,
        elevation: 4,
        shadowColor: Colors.grey[50],
        padding: EdgeInsets.all(ScreenUtil.instance.setHeight(4)),
      ),
      margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil.instance.setWidth(12),
          vertical: ScreenUtil.instance.setHeight(2)),
    );
  }
}
