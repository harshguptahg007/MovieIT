import 'package:flutter/material.dart';

class SplashScreenPage extends StatelessWidget {
  static const String routeNamed = "SplashScreenPage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlutterLogo(
          size: 50.0,
        ),
      ),
    );
  }
}
