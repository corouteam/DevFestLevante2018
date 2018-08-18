import 'package:devfest_levante_2018/ui/SplashScreenPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {

  // Ignore deprecated tag, see issue: https://github.com/flutter/flutter/issues/13736
  MaterialPageRoute.debugEnableFadingRoutes = true;

  SystemChrome
      .setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(SplashScreenPage());
  });
}
