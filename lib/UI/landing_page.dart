import 'dart:html';

import 'package:agrargo/UI/login/login_page.dart';
import 'package:agrargo/UI/login/profile_page.dart';
import 'package:agrargo/widgets/navigation_bar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:agrargo/services/api_helpers.dart';
import 'package:provider/provider.dart';

const API_KEY = 'sk_sand-79116408b11c4d3e8ca691a8d1935ee0';
final int _selectedIndex = 0;

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  String response = "";
  late User _currentUser;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseAuth = Provider.of<FirebaseAuth>(context);
    return StreamBuilder<User>(builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.active) {
        return snapshot.hasData ? LandingPage() : LoginPage();
      }
      return Scaffold(
        body: Center(
          child: Text("Heasdllo"), //CircularProgressIndicator(),
        ),
      );
    });
  }
}
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
