import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_movies/actions/actions.dart';
import 'package:flutter_movies/containers/splash_screen_container.dart';
import 'package:flutter_movies/middleware/store.dart';
import 'package:flutter_movies/utils/string_value.dart';
import 'package:flutter_movies/utils/styles.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MovieIT());
  });
}

class MovieIT extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    store.dispatch(CheckSession());
    FlutterStatusbarcolor.setStatusBarColor(Styles.PRIMARY_COLOR);
    return StoreProvider(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: StringValue.APP_NAME,
        home: SplashScreenContainer(),
      ),
    );
  }
}
