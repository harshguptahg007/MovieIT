import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_movies/models/review.dart';
import 'package:flutter_movies/utils/string_value.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewCard extends StatelessWidget {
  ReviewCard({this.review});

  Review review;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil.instance.setWidth(10),
          vertical: ScreenUtil.instance.setHeight(8)),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
            Radius.circular(ScreenUtil.instance.setHeight(10))),
      ),
      child: Container(
        margin: EdgeInsets.all(ScreenUtil.instance.setHeight(10)),
        child: Column(
          children: <Widget>[
            Text(
              review.content,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: ScreenUtil.instance.setHeight(8),
            ),
            Container(
              alignment: Alignment.bottomRight,
              child: Text(
                StringValue.REVIEW_BY + review.author,
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
