import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DevFestTabTextTheme extends StatelessWidget {
  final String text;

  const DevFestTabTextTheme(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: hexToColor("#676767")),
    );
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}
