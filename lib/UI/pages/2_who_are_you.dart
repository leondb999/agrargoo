import 'package:agrargo/UI/pages/test.dart';
import 'package:flutter/cupertino.dart';
import 'package:agrargo/UI/error_screen.dart';
import 'package:agrargo/UI/login/login_page.dart';
import 'package:agrargo/widgets/layout_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';

class WhoAreYou extends StatefulWidget {
  const WhoAreYou({Key? key}) : super(key: key);

  @override
  State<WhoAreYou> createState() => _WhoAreYouState();
}

class _WhoAreYouState extends State<WhoAreYou> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false, // set it to false
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
              margin: EdgeInsets.only(top: 300.0),
              child: Center(
                  child: Text("Wer bist du?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Open Sans',
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E6C49))))),
          Container(
              margin: EdgeInsets.only(top: 35.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => test()));
                },
                child: Text('Landwirt'),
                style: ElevatedButton.styleFrom(
                    primary: Color(0xFF9FB98B),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              )),
          Container(
              margin: EdgeInsets.only(top: 35.0, bottom: 300),
              child: ElevatedButton(
                onPressed: () {
                  // Respond to button press
                },
                child: Text('Helfer'),
                style: ElevatedButton.styleFrom(
                    primary: Color(0xFF9FB98B),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ))
        ])));
  }
}
