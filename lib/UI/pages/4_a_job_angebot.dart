import 'package:agrargo/UI/login_riverpod/login_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/auth_controller.dart';
import '../../widgets/layout_widgets.dart';

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
      appBar: appBar(),
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
              return Container(
                width: MediaQuery.of(context).size.width * 0.95,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Text("Title: ${data['titel']}"),
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
              );
            }
            return Column(
              children: [
                CircularProgressIndicator(),
              ],
            );
          },
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("weitere Infos zum Hof",
                              style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontFamily: 'Open Sans',
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF000000))),
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
                              LoginRiverpodPage.routename,
                              arguments: {'landwirt': false},
                            );
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xFF9FB98B),
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        textStyle: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  )),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            ]),
          ),
        ),
      ]),
    );
  }
}
