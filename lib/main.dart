import 'package:flutter/material.dart';
import 'package:devfest_levante/SplashScreenPage.dart';
import 'package:flutter/services.dart';

void main() {


  SystemChrome
      .setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(new SplashScreenPage());
  });
}
