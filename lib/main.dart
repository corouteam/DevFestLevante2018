import 'package:devfest_levante/SchedulePage.dart';
import 'package:flutter/material.dart';


void main() => runApp(new HomePage());

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: "Schedule"),
                Tab(text: "Favorites"),
                Tab(text: "Info"),
              ],
            ),
            title: Text('DevFest Levante 2018'),
          ),
          body: TabBarView(
            children: [
              new SchedulePage(),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
    );
  }
}

