import 'package:agrargo/UI/pages/4_a_job_angebot.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/layout_widgets.dart';

class JobangebotUebersichtPage extends StatefulWidget {
  const JobangebotUebersichtPage({Key? key}) : super(key: key);
  static const routename = '/jobangebotuebersicht';
  @override
  State<JobangebotUebersichtPage> createState() =>
      _JobangebotUebersichtPageState();
}

class _JobangebotUebersichtPageState extends State<JobangebotUebersichtPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.17,
              color: Color(0xFF1f623c),
              child: Center(
                  child: Text("Aktuelle Stellenangebote",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Open Sans',
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFffffff))))),
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            child: Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.89),
                Icon(
                  Icons.filter_alt_sharp,
                  color: Colors.black,
                  size: 30.0,
                ),
                SizedBox(width: 7),
                Icon(
                  Icons.sort,
                  color: Colors.black,
                  size: 30.0,
                ),
              ],
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.015),
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('jobAnzeigen')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(),
                        );
                      }
                      final List<DocumentSnapshot> documents =
                          snapshot.data!.docs;

                      return ListView(
                        children: documents
                            .map(
                              (doc) => Card(
                                color: Colors.grey,
                                margin: EdgeInsets.only(top: 40),
                                child: ListTile(
                                  title: Text(
                                    doc['titel'],
                                    style: TextStyle(fontSize: 30),
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                            height: 100,
                                            color: Colors.amber,
                                            child: Row(
                                              children: [
                                                Text(
                                                    "Jobanzeige ID: ${doc.id}"),
                                              ],
                                            )),
                                      ),
                                    ],
                                  ),
                                  trailing: _activeAnzeige(doc['status']),
                                  leading: Image.network(
                                    "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg",
                                  ),
                                  onTap: () {
                                    print("document: ${doc.id}");

                                    Navigator.pushNamed(
                                      context,
                                      Jobangebot.routename,
                                      arguments: {
                                        'jobanzeige_ID': doc.id.toString()
                                      },
                                    );
                                  },
                                ),
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                ),
                /*
    Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: new Container(
                      decoration: new BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(40.0),
                            topRight: const Radius.circular(40.0),
                            bottomLeft: const Radius.circular(40.0),
                            bottomRight: const Radius.circular(40.0),
                          )),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 2,
                              child: const Image(
                                image: NetworkImage(
                                    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                              )),
                          Expanded(
                              flex: 6,
                              child: Text("Gemüseernte - Bauernhof Meyer",
                                  style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontFamily: 'Open Sans',
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF000000)))),
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Text("9,25 €/h",
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontFamily: 'Open Sans',
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF000000))),
                                SizedBox(width: 50),
                                IconButton(
                                  icon: const Icon(Icons.arrow_right),
                                  onPressed: () async {
                                    Navigator.pushNamed(
                                      context,
                                      Jobangebot.routename,
                                      arguments: {'landwirt': _landwirt},
                                    );
                                  },
                                  color: Colors.black,
                                  iconSize: 50,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                SizedBox(height: 20),
                Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: new Container(
                      decoration: new BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(40.0),
                            topRight: const Radius.circular(40.0),
                            bottomLeft: const Radius.circular(40.0),
                            bottomRight: const Radius.circular(40.0),
                          )),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 2,
                              child: const Image(
                                image: NetworkImage(
                                    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                              )),
                          Expanded(
                              flex: 6,
                              child: Text(
                                  "Viel zu tun im Kuhstall - Bauernhof Laier",
                                  style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontFamily: 'Open Sans',
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF000000)))),
                          Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Text("13,50 €/h",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontFamily: 'Open Sans',
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF000000))),
                                  SizedBox(width: 50),
                                  Icon(
                                    Icons.arrow_right,
                                    color: Colors.black,
                                    size: 50.0,
                                  ),
                                ],
                              )),
                        ],
                      ),
                    )),
                SizedBox(height: 20),
                Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: new Container(
                      decoration: new BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(40.0),
                            topRight: const Radius.circular(40.0),
                            bottomLeft: const Radius.circular(40.0),
                            bottomRight: const Radius.circular(40.0),
                          )),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 2,
                              child: const Image(
                                image: NetworkImage(
                                    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                              )),
                          Expanded(
                              flex: 6,
                              child: Text("Spargelernte - Familie Leuer",
                                  style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontFamily: 'Open Sans',
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF000000)))),
                          Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Text("10,00 €/h",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontFamily: 'Open Sans',
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF000000))),
                                  SizedBox(width: 50),
                                  Icon(
                                    Icons.arrow_right,
                                    color: Colors.black,
                                    size: 50.0,
                                  ),
                                ],
                              )),
                        ],
                      ),
                    )),
                SizedBox(height: 20),
                Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: new Container(
                      decoration: new BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(40.0),
                            topRight: const Radius.circular(40.0),
                            bottomLeft: const Radius.circular(40.0),
                            bottomRight: const Radius.circular(40.0),
                          )),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 2,
                              child: const Image(
                                image: NetworkImage(
                                    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                              )),
                          Expanded(
                              flex: 6,
                              child: Text(
                                  "Traktorfahrer*in gesucht - Bauernhof Riedel",
                                  style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontFamily: 'Open Sans',
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF000000)))),
                          Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Text("9,50 €/h",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontFamily: 'Open Sans',
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF000000))),
                                  SizedBox(width: 50),
                                  Icon(
                                    Icons.arrow_right,
                                    color: Colors.black,
                                    size: 50.0,
                                  ),
                                ],
                              )),
                        ],
                      ),
                    )),
                */
              ]),
            ),
          )
        ],
      ),
    );
  }
}

Widget _activeAnzeige(bool status) {
  Widget x = Text("Hello");
  if (status == true) {
    x = Text('Active', style: TextStyle(color: Colors.green));
  } else {
    x = Text('inactive', style: TextStyle(color: Colors.red));
  }
  return x;
}
