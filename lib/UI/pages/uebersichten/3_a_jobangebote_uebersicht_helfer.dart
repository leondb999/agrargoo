import 'package:agrargo/controllers/auth_controller.dart';
import 'package:agrargo/models/jobanzeige_model.dart';
import 'package:agrargo/widgets/firebase_widgets.dart';
import 'package:agrargo/widgets/layout_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as p;

class JobangebotUebersichtPage extends ConsumerStatefulWidget {
  const JobangebotUebersichtPage({Key? key}) : super(key: key);
  static const routename = '/jobangebot-uebersicht';
  @override
  _JobangebotUebersichtPageState createState() =>
      _JobangebotUebersichtPageState();
}

class _JobangebotUebersichtPageState
    extends ConsumerState<JobangebotUebersichtPage> {
  @override
  Widget build(BuildContext context) {
    User? authControllerState = ref.watch(authControllerProvider);

    final jobAnzeigeList = p.Provider.of<List<JobanzeigeModel>>(context);
    var activeAnzeigeList = [];
    jobAnzeigeList.forEach((anzeige) {
      if (anzeige.status == true) {
        activeAnzeigeList.add(anzeige);
      }
    });
    print("activeAnzeigeList: $activeAnzeigeList");
    return Scaffold(
      appBar: appBar(context: context, ref: ref, home: false),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar:
          navigationBar(index: 0, context: context, ref: ref, home: true),
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
                  height: MediaQuery.of(context).size.height,
                  child: jobAnzeigeList != null
                      ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: jobAnzeigeList.length,
                          itemBuilder: (context, index) {
                            return jobAnzeigeCard(
                                context, activeAnzeigeList[index], false);
                          },
                        )
                      : Text("aktuell gibt es keine Jobanzeigen")),
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
