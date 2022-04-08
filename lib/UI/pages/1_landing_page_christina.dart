import 'package:agrargo/UI/error_screen.dart';
import 'package:agrargo/UI/pages/2_who_are_you.dart';
import 'package:agrargo/UI/pages/chat/5_chat.dart';
import 'package:agrargo/widgets/layout_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LandingPageCh extends ConsumerStatefulWidget {
  const LandingPageCh({Key? key}) : super(key: key);
  static const routename = '/landingpage';

  @override
  _LandingPageChState createState() => _LandingPageChState();
}

class _LandingPageChState extends ConsumerState<LandingPageCh> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false, // set it to false
        appBar: appBar(context: context, ref: ref, home: true),
        body: Center(
            child: Container(
                child: Scrollbar(
                    isAlwaysShown: true,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 2.5,
                                height: MediaQuery.of(context).size.height,
                                child: Image.asset('images/landing2.jpg'),
                                /*
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage(
                                          'images/landing2.jpg',
                                        ))),
                                */
                              ),
                              Row(children: [
                                SizedBox(width: 10),
                                new Column(children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width /
                                          1.69,
                                      margin: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              3),
                                      child: Center(
                                          child: Text(
                                              "Auf Job- oder Helfersuche?",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  fontFamily: 'Open Sans',
                                                  fontSize: 40.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF2E6C49))))),
                                  Container(
                                      margin: EdgeInsets.only(top: 25.0),
                                      child: Center(
                                          child: Text(
                                              "In 3 Schritten zum Erfolg",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  fontFamily: 'Open Sans',
                                                  fontSize: 25.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)))),
                                  Container(
                                    margin: EdgeInsets.only(top: 70.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            width: 35.0,
                                            height: 35.0,
                                            decoration: new BoxDecoration(
                                              color: Color(0xFF2E6C49),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                                child: Text(
                                              "1.",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.0,
                                              ),
                                            ))),
                                        SizedBox(width: 10),
                                        Container(
                                          child: Center(
                                            child: Text(
                                              "Deine Wünsche",
                                              style: TextStyle(
                                                fontFamily: 'Open Sans',
                                                fontSize: 25.0,
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
                                              color: Color(0xFF2E6C49),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                                child: Text(
                                              "2.",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.0,
                                              ),
                                            ))),
                                        SizedBox(width: 10),
                                        Container(
                                          child: Center(
                                            child: Text(
                                              "Match finden",
                                              style: TextStyle(
                                                fontSize: 25.0,
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
                                              color: Color(0xFF2E6C49),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                                child: Text(
                                              "3.",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.0,
                                              ),
                                            ))),
                                        SizedBox(width: 10),
                                        Container(
                                          child: Center(
                                            child: Text(
                                              "Durchstarten",
                                              style: TextStyle(
                                                fontSize: 25.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(
                                          top: 35.0, bottom: 300),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      WhoAreYou()));
                                        },
                                        child: Text('Los gehts!'),
                                        style: ElevatedButton.styleFrom(
                                            primary: Color(0xFF9FB98B),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 50, vertical: 20),
                                            textStyle: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                      ))
                                ]),
                              ])
                            ])))))));
  }
}
