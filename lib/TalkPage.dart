import 'package:devfest_levante/DevFestActivity.dart';
import 'package:flutter/material.dart';

class TalkPage extends StatelessWidget {
  final DevFestActivity talk;

  TalkPage(this.talk);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(talk.title),
        ),
        body: Text(talk.desc));
  }
}
