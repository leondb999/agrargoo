import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/layout_widgets.dart';
import '6_b_landwirt_profil.dart';

class jobangebot extends StatefulWidget {
  const jobangebot({Key? key}) : super(key: key);

  @override
  State<jobangebot> createState() => _jobangebotState();
  static const routename = '/jobangebot';
}

class _jobangebotState extends State<jobangebot> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(),
        resizeToAvoidBottomInset: false,
        body: Column(children: [
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.17,
              color: Color(0xFF1f623c),
              child: Center(
                  child: Text("Gemüseernte - Bauernhof Meyer",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Open Sans',
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFffffff))))),
          Container(
            width: MediaQuery.of(context).size.width * 0.95,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Icon(
                    Icons.place,
                    color: Colors.black,
                    size: 25.0,
                  ),
                  SizedBox(width: 3),
                  Text("Hockenheim",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Open Sans',
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF000000))),
                ]),
                Row(
                  children: [
                    Icon(
                      Icons.date_range,
                      color: Colors.black,
                      size: 25.0,
                    ),
                    SizedBox(width: 3),
                    Text("01.04.2022 - 07.05.2022",
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Open Sans',
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF000000)))
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.015),
          Expanded(
              child: SingleChildScrollView(
            child: Column(children: [
              Row(
                children: <Widget>[
                  SizedBox(width: MediaQuery.of(context).size.width * 0.015),
                  Expanded(
                    flex: 6,
                    child: Column(children: [
                      Text(
                          "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.",
                          style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Open Sans',
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF000000))),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.07),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Text("Aufgaben",
                                style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontFamily: 'Open Sans',
                                    fontSize: 23.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1f623c))),
                          )),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.all(15.0),
                              padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black)),
                              child: Text('Ernte',
                                  style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontFamily: 'Open Sans',
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xFF000000))),
                            ),
                            Container(
                              margin: const EdgeInsets.all(15.0),
                              padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black)),
                              child: Text('Bewässerung',
                                  style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontFamily: 'Open Sans',
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xFF000000))),
                            ),
                            Container(
                              margin: const EdgeInsets.all(15.0),
                              padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black)),
                              child: Text('Düngung',
                                  style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontFamily: 'Open Sans',
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xFF000000))),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Text("Besondere Anforderungen",
                                style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontFamily: 'Open Sans',
                                    fontSize: 23.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1f623c))),
                          )),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.all(15.0),
                              padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black)),
                              child: Text('Traktor-Führerschein',
                                  style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontFamily: 'Open Sans',
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xFF000000))),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Text("Stundenlohn",
                                style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontFamily: 'Open Sans',
                                    fontSize: 23.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1f623c))),
                          )),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.all(15.0),
                              padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black)),
                              child: Text('9,25 €/h',
                                  style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontFamily: 'Open Sans',
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xFF000000))),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(children: [
                      const Image(
                        image: NetworkImage(
                            'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.message,
                                    color: Colors.black,
                                    size: 25.0,
                                  ),
                                  SizedBox(width: 3),
                                  Text("Noch Fragen?",
                                      style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontFamily: 'Open Sans',
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.normal,
                                          color: Color(0xFF000000)))
                                ],
                              )
                            ],
                          ))
                    ]),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.015),
                ],
              ),
              Container(
                  margin: EdgeInsets.only(top: 35.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfilLandwirt()));
                    },
                    child: Text('Bewerben'),
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xFF9FB98B),
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        textStyle: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  )),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            ]),
          ))
        ]));
  }
}
