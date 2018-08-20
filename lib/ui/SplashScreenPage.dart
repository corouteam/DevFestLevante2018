import 'package:devfest_levante_2018/model/DevFestUser.dart';
import 'package:devfest_levante_2018/ui/HomePage.dart';
import 'package:devfest_levante_2018/repository/UserRepository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      title: 'DevFest Levante 2018',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Center(
      child: new Column(
        children: <Widget>[
          SizedBox(
            height: 36.0,
          ),
          new Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image(
              image: AssetImage('assets/heroes_orange_big.png'),
            ),
          ),
          SizedBox(
            height: 24.0,
          ),
          RaisedButton(
              color: Colors.blueAccent,
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              textColor: Colors.white,
              onPressed: () {
                _handleSignIn(context);
              },
              child: Text("Login con Google")),
        ],
      ),
    );
  }

  // We use Future and not a Stream (like in Firestore) because we need
  // to listen for only ONE event.
  // Stream will leave an open connection instead (ex for realtime database).
  // TODO: Maybe consider to use Future when downloading talks too, since they won't change often
  _handleSignIn(context) async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Login done, create user in Firestore
    UserRepository repo = UserRepository(user.uid);
    var devFestUser = DevFestUser();
    devFestUser.userId = user.uid;
    devFestUser.email = user.email;
    devFestUser.displayName = user.displayName;
    await repo.createNewUser(devFestUser);

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => HomePage()));
  }
}
