import 'package:devfest_levante/SchedulePage.dart';
import 'package:devfest_levante/SplashScreenPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

        // Before showing the Scaffold, we need the profile image for the appbar
        // So we build a Future with Firebase user request as future parameter
        home: FutureBuilder<FirebaseUser>(
          future: FirebaseAuth.instance.currentUser(),

          // The lambda in the builder will be run each time we have updated data from Firebase
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // Check if we're done downloading the user info
            if (snapshot.connectionState == ConnectionState.done) {
              // Now we can save user data in a variable
              FirebaseUser user = snapshot.data;

              return Scaffold(
                  appBar: AppBar(
                    // Take user data
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Sign out?"),
                                  content: Text(
                                      "Tutte le sesioni salvate e le preferenze rimarranno comunque sincronizzate con il tuo account."),
                                  actions: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FlatButton(
                                        child: Text("Non ora"),
                                        textColor: Colors.blueAccent,
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RaisedButton(
                                        child: Text("Sign out"),
                                        color: Colors.blueAccent,
                                        textColor: Colors.white,
                                        onPressed: () {
                                          FirebaseAuth.instance.signOut();
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          SplashScreenPage()));
                                        },
                                      ),
                                    )
                                  ],
                                );
                              });
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: new NetworkImage(user.photoUrl)))),
                      ),
                    ),
                    title: Text("DevFest Levante"),
                  ),
                  bottomNavigationBar: navBar,
                  body: currentPage);
            } else {
              // Firebase has not returned data yet. Show loading screen
              // TODO: Maybe replace this with a loading dialog
              return new Text('Loading...');
            }
          },
        ));
  }

  _showLogOutDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Log out"),
            content: Text("Sicuro di voler effettuare il log out?"),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              SplashScreenPage()));
                },
              )
            ],
          );
        });
  }
}
