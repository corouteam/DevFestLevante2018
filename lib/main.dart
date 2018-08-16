import 'package:devfest_levante_2018/ui/SplashScreenPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {


  SystemChrome
      .setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(SplashScreenPage());
  });
}
