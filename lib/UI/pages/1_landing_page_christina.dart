import 'package:agrargo/UI/error_screen.dart';
import 'package:agrargo/UI/pages/2_who_are_you.dart';
import 'package:agrargo/UI/pages/chat/5_chat.dart';
import 'package:agrargo/widgets/layout_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'impressum.dart';

class LandingPageCh extends ConsumerStatefulWidget {
  const LandingPageCh({Key? key}) : super(key: key);
  static const routename = '/landingpage';

  @override
  _LandingPageChState createState() => _LandingPageChState();
}

class _LandingPageChState extends ConsumerState<LandingPageCh> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false, // set it to false
            appBar: appBar(context: context, ref: ref, home: true),
            body: new SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.91,
                    child: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/agrargo-2571b.appspot.com/o/landing2.jpg?alt=media&token=45800aef-3899-48ce-a48f-b6b87f532f4f'),
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment
                          .center, //Center Column contents horizontally,
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height * 0.070,
                          child: Image.network(
                              "https://firebasestorage.googleapis.com/v0/b/agrargo-2571b.appspot.com/o/logo_large.png?alt=media&token=d4af03b7-4191-495c-8d63-946be214fff8"),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.08),
                        Center(
                            child: Container(
                                width: MediaQuery.of(context).size.width / 1.65,
                                child: Text(
                                    "Auf Job- oder Helfersuche in der Landwirtschaft?",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontFamily: 'Open Sans',
                                        fontSize: 39.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF586015))))),
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 90),
                        Container(
                            child: Center(
                                child: Text("In 3 Schritten zum Erfolg",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontFamily: 'Open Sans',
                                        fontSize: 31.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)))),
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 14),
                        Container(
                            child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .center, //Center Row contents horizontally,
                            crossAxisAlignment: CrossAxisAlignment
                                .center, //Center Row contents vertically,
                            children: [
                              Container(
                                  width: 35.0,
                                  height: 35.0,
                                  decoration: new BoxDecoration(
                                    color: Color(0xFF586015),
                                    //color: Color(0xFF586015),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                      child: Text(
                                    "1.",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 19.5,
                                    ),
                                  ))),
                              SizedBox(width: 10),
                              Container(
                                child: Center(
                                  child: Text(
                                    "Registrieren",
                                    style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontSize: 27.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 30),
                              Container(
                                  width: 35.0,
                                  height: 35.0,
                                  decoration: new BoxDecoration(
                                    color: Color(0xFF586015),
                                    //color: Color(0xFF586015),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                      child: Text(
                                    "2.",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 19.5,
                                    ),
                                  ))),
                              SizedBox(width: 10),
                              Container(
                                child: Center(
                                  child: Text(
                                    "Match finden",
                                    style: TextStyle(
                                      fontSize: 27.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 30),
                              Container(
                                  width: 35.0,
                                  height: 35.0,
                                  decoration: new BoxDecoration(
                                    color: Color(0xFF586015),
                                    //color: Color(0xFF586015),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                      child: Text(
                                    "3.",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 19.5,
                                    ),
                                  ))),
                              SizedBox(width: 10),
                              Container(
                                child: Center(
                                  child: Text(
                                    "Durchstarten",
                                    style: TextStyle(
                                      fontSize: 27.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 30),
                        Container(
                            child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => WhoAreYou()));
                          },
                          child: Text('Los gehts!'),
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xFFA7BB7B),
                              //primary: Color(0xFFA7BB7B),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 20),
                              textStyle: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ))
                      ]),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(ImpressumPage.routename);
                      },
                      child: Text(
                        "Impressum",
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0x0000000)),
                      ),
                      // color: Colors.blue,
                    ),
                  ),
                ]))));
  }
}
