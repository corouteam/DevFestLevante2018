import 'dart:async';

import 'package:devfest_levante/HomePage.dart';
import 'package:devfest_levante/SchedulePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreenPage> {
  bool isLoggedIn;

  @override
  void initState() {
    isLoggedIn = false;

    // Check from Firebase if user is logged in or not
    // Update isLoggedIn value in state
    FirebaseAuth.instance.currentUser().then((user) => user != null
        ? setState(() {
            isLoggedIn = true;
          })
        : null);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Return SchedulePage or LoginPage
    return isLoggedIn ? HomePage() : LoginScreen();
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("DevFest levante"),
        ),
        body: SplashScreenWidget(),
      ),
    );
  }
}

class SplashScreenWidget extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
          color: Colors.blueAccent,
          textColor: Colors.white,
          onPressed: () {
            _handleSignIn(context);
          },
          child: Text("Login with Google")),
    );
  }

  // We use Future and not a Stream (like in Firestore) because we need
  // to listen for only ONE event.
  // Stream will leave an open connection instead (ex for realtime database).
  // TODO: Maybe consider to use Future when downloading talks too, since they won't change often
  Future<FirebaseUser> _handleSignIn(context) async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Login done, restart SplashScreenPage
    print("signed in " + user.displayName);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    return user;
  }
}
