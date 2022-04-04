import 'package:agrargo/UI/login_riverpod/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controllers/auth_controller.dart';
import '../../../widgets/layout_widgets.dart';

class Jobangebot extends ConsumerStatefulWidget {
  const Jobangebot({Key? key}) : super(key: key);
  static const routename = '/jobangebot';

  @override
  _JobangebotState createState() => _JobangebotState();
}

class _JobangebotState extends ConsumerState<Jobangebot> {
  final usersCollection = FirebaseFirestore.instance.collection('users');
  String _jobanzeigeID = "";

  @override
  Widget build(BuildContext context) {
    User? authControllerState = ref.watch(authControllerProvider);
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    String jobanzeigeID = arguments['jobanzeige_ID'];
    setState(() {
      _jobanzeigeID = jobanzeigeID;
      print("setState _jobanzeigeID");
    });
    print("jobanzeigeID: $jobanzeigeID");
    return Scaffold(
      appBar: AppBar(),
      resizeToAvoidBottomInset: false,
      body: Column(children: [
        FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('jobAnzeigen')
              .doc(_jobanzeigeID)
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }
            if (snapshot.hasData && !snapshot.data!.exists) {
              return Text("Document does not exist");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              return Column(children: [
                Row(
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
              ]);
            }
            return Column(
              children: [
                CircularProgressIndicator(),
              ],
            );
          },
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        Expanded(
          child: SingleChildScrollView(
            child: Column(children: [
              Row(
                children: <Widget>[
                  SizedBox(width: MediaQuery.of(context).size.width * 0.015),
                  Expanded(
                    flex: 6,
                    child: Column(children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Text("jobanzeigeID.titel",
                                style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontFamily: 'Open Sans',
                                    fontSize: 23.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1f623c))),
                          )),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015),
                      Container(
                        margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.all(7.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                        ),
                        child: Text(
                            "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.",
                            style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontFamily: 'Open Sans',
                                fontSize: 20.0,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF000000))),
                      ),
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
                              padding: const EdgeInsets.all(7.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                border: Border.all(color: Colors.grey),
                              ),
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
                              padding: const EdgeInsets.all(7.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                border: Border.all(color: Colors.grey),
                              ),
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
                              padding: const EdgeInsets.all(7.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                border: Border.all(color: Colors.grey),
                              ),
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
                              padding: const EdgeInsets.all(7.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                border: Border.all(color: Colors.grey),
                              ),
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
                            height: 36,
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
                              padding: const EdgeInsets.all(7.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                border: Border.all(color: Colors.grey),
                              ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.message,
                                color: Colors.black,
                                size: 25.0,
                              ),
                              SizedBox(width: 3),
                              Text("Noch Fragen??",
                                  style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontFamily: 'Open Sans',
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xFF000000)))
                            ],
                          )
                        ],
                      ),
                    ]),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.015),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 35.0),

                ///Bewerben Button
                child: Center(
                  child: RaisedButton(
                    child: Text(
                      'Bewerben',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    color: Color(0xFF9FB98B),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _buildPopupDialog(context),
                      );
                    },
                  ),
                ),
              ),
              /* Container(
                  margin: EdgeInsets.only(top: 35.0),

                  ///Bewerben Button
                  child: ElevatedButton(
                    child: Text('Bewerben'),
                    onPressed: () {
                      ///TODO Implement Navigation to Jobangebot
                      ///User Logged In

                      authControllerState != null
                          ? Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Jobangebot()))
                          : Navigator.pushNamed(
                              context,
                              LoginPage.routename,
                              arguments: {'landwirt': false},
                            );
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xFF9FB98B),
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        textStyle: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  )),*/
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Deine Bewerbung'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              "Deine Daten werden für die Bewerbung an den Landwirt / die Landwirtin übermittelt."),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Senden'),
        ),
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Abbrechen'),
        ),
      ],
    );
  }
}
