import 'package:agrargo/UI/error_screen.dart';
import 'package:agrargo/widgets/layout_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';

import '../../providers/auth_providers.dart';
import '../loading_screen.dart';

const API_KEY = 'sk_sand-79116408b11c4d3e8ca691a8d1935ee0';
final int NAV_INDEX = 0;
/*
class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  bool isSignedIn = false;
  String userData = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User? _user = ref.watch(fireBaseAuthProvider).currentUser;
    final _auth = ref.watch(authenticationProvider).authStateChange;
    _auth.listen((User? user) {
      if (this.user != null) {
        print("this.user != nulll: ${user!.email}");
        setState(() {
          this.user = user;
          this.isSignedIn = true;
        });
      }
    });

    return Consumer(builder: (context, ref, child) {
      print("context: $context");
      print("ref: $ref");
      print("ref: $child");

      return Scaffold(
        appBar: appBar(),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Landing Page", style: TextStyle(fontSize: 30)),
                SizedBox(height: 50.0),
                _user != null
                    ? Text("User name: ${_user.email}")
                    : Text("User null"),
                isSignedIn ? Text("SignedIn") : Text("Signed Out"),
                ElevatedButton(
                  child: Text("Check Login Status"),
                  onPressed: () {
                    print("User: $_user");
                    setState(() {
                      if (_user != null) {
                        userData = _user.toString();
                      } else {
                        userData = "null";
                      }

                      //  userData = _user!.refreshToken.toString();
                    });
                  },
                ),
                Text("Userdata: $userData"),
              ],
            ),
          ),
        ),
        bottomNavigationBar: navigationBar(NAV_INDEX, context, _user),
      );
    });
  }
}
*/
/*

 return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Landing Page")),
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.green[50],
          child: Center(
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: Colors.white,
                  height: 100,
                  child: Center(
                      child: Text(
                    "Unsere Visionasd",
                    style: TextStyle(fontSize: 25.0),
                  )),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "Auf Job- oder Helfersuche?",
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20.0),
                        child: Text(
                          "In 3 Schritten zum Erfolg",
                          style: TextStyle(fontSize: 15.0),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 50.0),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  "1. Deine Wünsche",
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  "2. Match finden",
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  "3. Durchstarten lol345",
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(child: Text(response)),
                Container(child: Text("Hallo Christina")),
                Container(child: Text("Hallo Verena")),
                Container(
                  margin: EdgeInsets.only(top: 0),
                  child: ElevatedButton(
                    child: Text("Find your Jobs!"),
                    onPressed: () async {
                      //  var data = await getWeatherData();
                      var data = await getRandevuUser();
                      setState(() {
                        response = data;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: navigationBar(_selectedIndex, context, _currentUser),
    );
 */
