import 'package:flutter/material.dart';
import 'package:flutter_movies/utils/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewAllPageListElement extends StatelessWidget {
  ViewAllPageListElement(
      {this.width, this.id, this.onTap, this.url, this.title, this.rating});

  double width;
  String url;
  String title;
  double rating;
  Function onTap;
  int id;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
              Radius.circular(ScreenUtil.instance.setHeight(10))),
        ),
        child: GestureDetector(
          child: Row(
            children: <Widget>[
              Container(
                height: ScreenUtil.instance.setHeight(120),
                width: width,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                      Radius.circular(ScreenUtil.instance.setHeight(5))),
                  child: Image.network(
                    Styles.IMAGE_BASE_URL + url,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(),
              ),
              Expanded(
                flex: 9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          fontFamily: Styles.FONT_FAMILY),
                    ),
                    SizedBox(
                      height: ScreenUtil.instance.setHeight(10),
                    ),
                    Text('Ratings :' + "${rating}",
                        style: TextStyle(fontFamily: Styles.FONT_FAMILY))
                  ],
                ),
              )
            ],
          ),
          onTap: () {
            onTap(context, id);
          },
        ),
      ),
    );
  }
}
