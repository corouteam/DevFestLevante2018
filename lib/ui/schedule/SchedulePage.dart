import 'package:devfest_levante_2018/utils/DevFestTabTextTheme.dart';
import 'package:devfest_levante_2018/ui/schedule/SingleSchedulePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SchedulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8,
      child: Column(
        children: <Widget>[
          TabBar(
            isScrollable: true,
            tabs: [
              Tab(child: DevFestTabTextTheme("25 Ago")),
              Tab(child: DevFestTabTextTheme("26 Ago")),
              Tab(child: DevFestTabTextTheme("27 Ago")),
              Tab(child: DevFestTabTextTheme("28 Ago")),
              Tab(child: DevFestTabTextTheme("29 Ago")),
              Tab(child: DevFestTabTextTheme("30 Ago")),
              Tab(child: DevFestTabTextTheme("31 Ago")),
              Tab(child: DevFestTabTextTheme("01 Sep")),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                SingleSchedulePage(25),
                SingleSchedulePage(26),
                SingleSchedulePage(27),
                SingleSchedulePage(28),
                SingleSchedulePage(29),
                SingleSchedulePage(30),
                SingleSchedulePage(31),
                SingleSchedulePage(1)
              ],
            ),
          )
        ],
      ),
    );
  }
}
