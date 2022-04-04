import 'package:agrargo/controllers/auth_controller.dart';
import 'package:agrargo/models/jobanzeige_model.dart';
import 'package:agrargo/widgets/firebase_widgets.dart';
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
      appBar: AppBar(),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Container(
            child: Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.90),
                Icon(Icons.filter_alt_sharp, color: Colors.black87, size: 30.0),
                SizedBox(width: 25),
                Icon(Icons.sort, color: Colors.black87, size: 30.0),
              ],
            ),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Suche...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey.shade100)),
                ),
              ),
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
