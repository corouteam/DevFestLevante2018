import 'package:devfest_levante_2018/model/DevFestFaq.dart';
import 'package:devfest_levante_2018/repository/FaqRepository.dart';
import 'package:devfest_levante_2018/ui/info/AboutPage.dart';
import 'package:devfest_levante_2018/ui/info/FaqPage.dart';
import 'package:devfest_levante_2018/ui/info/MapPage.dart';
import 'package:devfest_levante_2018/utils/DevFestTabTextTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


import 'package:latlong/latlong.dart';class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: <Widget>[
          TabBar(
            isScrollable: false,
            tabs: [
              Tab(child: DevFestTabTextTheme("FAQ")),
              Tab(child: DevFestTabTextTheme("About")),
              Tab(child: DevFestTabTextTheme("Viaggio")),
            ],
          ),
          Expanded(child: TabBarView(children: <Widget>[FaqPage(), AboutPage(), MapPage()])),
        ],
      ),
    );
  }
}