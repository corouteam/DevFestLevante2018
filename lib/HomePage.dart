import 'package:devfest_levante/SchedulePage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<HomePage> {
  int tabPosition = 0;
  var currentPage;
  List<Widget> pages;

  @override
  void initState() {
    super.initState();

    pages = [
      SchedulePage(),
      Icon(Icons.favorite_border),
      Icon(Icons.directions_bike)
    ];

    currentPage = pages[0];
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar navBar = BottomNavigationBar(
        currentIndex: tabPosition,
        onTap: (int pressedTab) {
          setState(() {
            tabPosition = pressedTab;
            currentPage = pages[pressedTab];
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.schedule), title: Text("Schedule")),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), title: Text("Favourites")),
          BottomNavigationBarItem(
              icon: Icon(Icons.directions_bike), title: Text("Info"))
        ]);

    return new MaterialApp(
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            appBar: AppBar(
              title: Text("DevFest Levante"),
            ),
            bottomNavigationBar: navBar,
            body: currentPage));
  }
}
