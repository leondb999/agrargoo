import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../widgets/layout_widgets.dart';
import '4_a_job_angebot.dart';

class HelferProfil extends StatefulWidget {
  const HelferProfil({Key? key}) : super(key: key);
  static const routename = '/helferprofil';

  @override
  _HelferProfilState createState() => _HelferProfilState();
}

class _HelferProfilState extends State<HelferProfil> {
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
                  child: Text("Mein Profil",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Open Sans',
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFffffff))))),
          SizedBox(height: MediaQuery.of(context).size.height * 0.015),
          Expanded(
              child: SingleChildScrollView(
            child: Column(children: [
              Row(
                children: <Widget>[
                  SizedBox(width: MediaQuery.of(context).size.width * 0.015),
                  Expanded(
                    flex: 4,
                    child: Column(children: [
                      const Image(
                        image: NetworkImage(
                            'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015),
                    ]),
                  ),
                  Expanded(
                    flex: 6,
                    child: Column(children: [
                      Align(
                          alignment: Alignment.topRight,
                          child: Container(
                              margin: EdgeInsets.only(top: 35.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Jobangebot()));
                                },
                                child: Text('Bearbeiten'),
                                style: ElevatedButton.styleFrom(
                                    primary: Color(0xFF9FB98B),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 20),
                                    textStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ))),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Text("Das bin ich",
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
                              child: Text('Max Mustermann, 19 Jahre',
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
                          height: MediaQuery.of(context).size.height * 0.04),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Text("Qualifikationen",
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
                          height: MediaQuery.of(context).size.height * 0.04),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Text("Erfahrungen",
                                style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontFamily: 'Open Sans',
                                    fontSize: 23.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1f623c))),
                          )),
                      Text(
                          "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr.",
                          style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Open Sans',
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF000000))),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Text("Verfügbarer Zeitraum",
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
                              child: Text('14.05.2022',
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
                              child: Text('29.06.2022',
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
                    ]),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.015),
                ],
              ),
              Divider(
                indent: 16,
                endIndent: 16,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            ]),
          ))
        ]));
  }
}
