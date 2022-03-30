import 'package:agrargo/UI/pages/helfer/4_a_job_angebot.dart';
import 'package:agrargo/UI/pages/landwirt/7_add_jobanzeige.dart';
import 'package:agrargo/models/jobanzeige_model.dart';
import 'package:agrargo/widgets/firebase_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/layout_widgets.dart';

class JobangebotUebersichtPage extends StatefulWidget {
  const JobangebotUebersichtPage({Key? key}) : super(key: key);
  static const routename = '/jobangebot-uebersicht';
  @override
  State<JobangebotUebersichtPage> createState() =>
      _JobangebotUebersichtPageState();
}

class _JobangebotUebersichtPageState extends State<JobangebotUebersichtPage> {
  @override
  Widget build(BuildContext context) {
    final jobAnzeigeList = Provider.of<List<JobanzeigeModel>>(context);
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
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(AddEditJobanzeige.routename);
              },
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: jobAnzeigeList != null
                      ? ListView.builder(
                          itemCount: jobAnzeigeList.length,
                          itemBuilder: (context, index) {
                            return jobAnzeigeCard(
                                context, jobAnzeigeList[index]);
                          },
                        )
                      : Text("keine Jobanzeigen jetzt")),
            ),
          ),
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
