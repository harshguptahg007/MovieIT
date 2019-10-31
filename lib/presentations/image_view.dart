import 'package:flutter/material.dart';
import 'package:flutter_movies/models/picture.dart';
import 'package:flutter_movies/services/download_service.dart';
import 'package:flutter_movies/utils/string_value.dart';
import 'package:flutter_movies/utils/styles.dart';
import 'package:flutter_movies/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';

class ImageView extends StatefulWidget {
  static const String routeNamed = "ImageView";

  int index;
  List<Picture> imageList;
  bool isNetwork;

  ImageView(this.index, this.imageList, {this.isNetwork = true});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  PageController pageController;
  int selectedImageIndex;
  DownloadService downloadService = DownloadService.getInstance();
  bool buttonTapped = false;

  @override
  void initState() {
    super.initState();
    selectedImageIndex = widget.index;
    pageController = new PageController(initialPage: widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        child: buttonTapped
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Styles.WHITE_COLOR),
              )
            : Icon(
                Icons.file_download,
                color: Colors.white,
              ),
        onPressed: () {
          getPermission([PermissionGroup.storage]).then((permission) {
            if (permission)
              setState(() {
                buttonTapped = true;
              });
            downloadService
                .fileDownload(
              fileUrl: Styles.IMAGE_BASE_URL +
                  widget.imageList[selectedImageIndex].mediaUrl,
            )
                .then((data) {
              Utils.showSnackBar(StringValue.DOWNLOADED_AT + data, context);
              setState(() {
                buttonTapped = false;
              });
            });
          });
        },
      ),
      body: Container(
        height: ScreenUtil.screenHeight,
        width: ScreenUtil.screenWidth,
        child: Stack(
          children: <Widget>[
            PageView.builder(
              itemCount: widget.imageList.length,
              controller: pageController,
              itemBuilder: (BuildContext context, int index) {
                if (widget.isNetwork) {
                  return PhotoView(
                    imageProvider: NetworkImage(Styles.IMAGE_BASE_URL +
                        widget.imageList[index].mediaUrl),
                    minScale: 0.8,
                    maxScale: 3.0,
                  );
                } else {
                  return Image.asset(
                    Styles.PLACE_HOLDER_IMAGE,
                    fit: BoxFit.cover,
                  );
                }
              },
              onPageChanged: (index) {
                setState(() {
                  selectedImageIndex = index;
                });
              },
            ),
            Positioned(
              top: ScreenUtil.instance.setHeight(30),
              right: ScreenUtil.instance.setWidth(25),
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: ScreenUtil.instance.setHeight(5),
                    horizontal: ScreenUtil.instance.setWidth(15)),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(
                    Radius.circular(ScreenUtil.instance.setWidth(18)),
                  ),
                ),
                child: Center(
                  child: Text(
                    (selectedImageIndex + 1).toString() +
                        "/" +
                        widget.imageList.length.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontFamily: Styles.FONT_FAMILY),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> getPermission(List<PermissionGroup> permissionList) async {
    List<PermissionGroup> requestPermissionList = new List();
    var requestResult;
    for (int i = 0; i < permissionList.length; i++) {
      bool result = await checkPermission(permissionList[i]);
      if (!result) requestPermissionList.add(permissionList[i]);
    }

    if (requestPermissionList.length > 0) {
      requestResult = await requestPermission(requestPermissionList);

      if (requestResult == null) return false;

      for (int i = 0; i < requestPermissionList.length; i++) {
        if (requestResult[requestPermissionList[i]] !=
            PermissionStatus.granted) {
          return false;
        }
      }
    }
    return true;
  }

  Future<bool> checkPermission(PermissionGroup permissionGroup) async {
    PermissionStatus permissionStatus =
        await PermissionHandler().checkPermissionStatus(permissionGroup);
    if (permissionStatus == PermissionStatus.granted) return true;
    return false;
  }

  requestPermission(List<PermissionGroup> requestList) async {
    bool toShowSetting = false;
    List<PermissionGroup> requiredPermission = new List();
    Map<PermissionGroup, PermissionStatus> result;
    result = await PermissionHandler().requestPermissions(requestList);
    for (int i = 0; i < requestList.length; i++) {
      bool isShown = await PermissionHandler()
          .shouldShowRequestPermissionRationale(requestList[i]);
      bool isPermitted = await checkPermission(requestList[i]);
      if (!isShown && !isPermitted) {
        requiredPermission.add(requestList[i]);
        toShowSetting = true;
      }
    }
    if (toShowSetting)
      _showRequiredPermissionDialog(context, requiredPermission);
    return result;
  }

  _showRequiredPermissionDialog(
      BuildContext context, List<PermissionGroup> permissionNeeded) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String text = "";
        permissionNeeded.forEach((permission) {
          String per = permission.toString().split('.')[1];
          per = per[0].toUpperCase() + per.substring(1);
          text = text + " " + per;
        });
        return AlertDialog(
          content: Text(
            StringValue.PERMISSION + text,
            style: TextStyle(fontFamily: Styles.FONT_FAMILY),
          ),
          actions: <Widget>[
            new FlatButton(
              onPressed: () async {
                Navigator.pop(context);
                bool isOpened = await PermissionHandler().openAppSettings();
              },
              child: new Text(
                StringValue.OPEN_SETTINGS,
                style: TextStyle(fontFamily: Styles.FONT_FAMILY),
              ),
            ),
          ],
        );
      },
    );
  }
}
