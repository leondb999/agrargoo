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
                Icon(Icons.filter_alt_sharp, color: Colors.black, size: 30.0),
                SizedBox(width: 7),
                Icon(Icons.sort, color: Colors.black, size: 30.0),
              ],
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.015),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('jobAnzeigen')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator());
                    }
                    final List<DocumentSnapshot> documents =
                        snapshot.data!.docs;

                    return Container(
                      height: MediaQuery.of(context).size.height,
                      child: ListView(
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
                                              Text("Jobanzeige ID: ${doc.id}"),
                                            ],
                                          ),
                                        ),
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
                      ),
                    );
                  },
                ),
              ),
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
