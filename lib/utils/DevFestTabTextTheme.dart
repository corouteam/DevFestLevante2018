import 'package:devfest_levante_2018/utils/ColorUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DevFestTabTextTheme extends StatelessWidget {
  final String text;

  const DevFestTabTextTheme(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: ColorUtils.hexToColor("#676767")),
    );
  }
}
