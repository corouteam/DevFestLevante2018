
import 'dart:async';

import 'package:devfest_levante_2018/model/DevFestUser.dart';
import 'package:devfest_levante_2018/repository/UserRepository.dart';
import 'package:devfest_levante_2018/ui/SplashScreenPage.dart';
import 'package:devfest_levante_2018/ui/info/InfoPage.dart';
import 'package:devfest_levante_2018/ui/schedule/FavouriteSchedulePage.dart';
import 'package:devfest_levante_2018/ui/schedule/SchedulePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    return new MaterialApp(
        title: 'DevFest Levante 2018',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            fontFamily: "Lato"),

        // Before showing the Scaffold, we need the profile image for the appbar
        // So we build a Future with Firebase user request as future parameter
        home: FutureBuilder<FirebaseUser>(
          future: FirebaseAuth.instance.currentUser(),

          // The lambda in the builder will be run each time we have updated data from Firebase
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // Check if we're done downloading the user info
            if (snapshot.hasData) {
              // Now we can save user data in a variable
              FirebaseUser user = snapshot.data;

              return HomePageScaffold(user);
            } else {
              // Firebase has not returned data yet. Show loading screen
              // TODO: Maybe replace this with a loading dialog
              return Scaffold(body: Center(child: Text('Caricamento...')));
            }
          },
        ));
  }
}

class HomePageScaffold extends StatefulWidget {
  final FirebaseUser user;

  const HomePageScaffold(this.user);

  @override
  HomeScaffoldState createState() => new HomeScaffoldState(user);
}

class HomeScaffoldState extends State<HomePageScaffold> {
  FirebaseUser user;
  DevFestUser devFestUser;
  int tabPosition = 0;
  var currentPage;
  List<Widget> pages;
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  HomeScaffoldState(this.user);

  @override
  void initState() {
    super.initState();

    initActionBar();

    pages = [SchedulePage(), FavouriteSchedulePage(user.uid), InfoPage()];

    currentPage = pages[0];

    firebaseMessaging.configure(onLaunch: (Map<String, dynamic> msg) {
      print("on Launch called");
    }, onResume: (Map<String, dynamic> msg) {
      print("onResume called");
    }, onMessage: (Map<String, dynamic> msg) {
      print("onMessage called");
    });
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));
    firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings) {
      print('IOS Settings Registed');
    });
    firebaseMessaging.getToken().then((token) async {
      UserRepository repo = UserRepository(user.uid);
      var devFestUser = DevFestUser();
      devFestUser.notificationToken = token;
      await repo.addFcmToken(devFestUser);
    });
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var androidLocalNotifications = new AndroidInitializationSettings('mipmap/ic_launcher');
    var iOSLocalNotifications = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(androidLocalNotifications, iOSLocalNotifications);
    flutterLocalNotificationsPlugin.initialize(initSettings);

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
              icon: Icon(Icons.schedule),
              title: Text(
                "Programma",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              title: Text(
                "Preferiti",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.info),
              title: Text(
                "Info",
                style: TextStyle(fontWeight: FontWeight.bold),
              ))
        ]);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
          // Take user data
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Log out?"),
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
                              child: Text("Log out"),
                              color: Colors.blueAccent,
                              textColor: Colors.white,
                              onPressed: () {
                                FirebaseAuth.instance.signOut();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            SplashScreenPage()));
                              },
                            ),
                          )
                        ],
                      );
                    });
              },
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: new NetworkImage(user.photoUrl)))),
              ),
            ),
          ),
          title: Text(
            "DevFest Levante",
            style: TextStyle(color: Colors.black),
          ),
        ),
        bottomNavigationBar: new Theme(
            data: Theme.of(context).copyWith(
                canvasColor: Colors.blueAccent,
                primaryColor: Colors.white,
                textTheme: Theme
                    .of(context)
                    .textTheme
                    .copyWith(caption: new TextStyle(color: Colors.white70))),
            child: navBar),
        body: currentPage);
  }

  void initActionBar() async {
    await FlutterStatusbarManager.setTranslucent(false);
    await FlutterStatusbarManager.setStyle(StatusBarStyle.DARK_CONTENT);
  }
}
