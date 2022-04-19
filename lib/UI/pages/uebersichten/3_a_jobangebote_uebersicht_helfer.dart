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
    // User? authControllerState = ref.watch(authControllerProvider);

    final jobAnzeigeList = p.Provider.of<List<JobanzeigeModel>>(context);
    var activeAnzeigeList = [];
    jobAnzeigeList.forEach((anzeige) {
      print("anzeige123: $anzeige");
      if (anzeige.status == true) {
        print("anzeige123 true: $anzeige");
        activeAnzeigeList.add(anzeige);
      }
    });
    print("activeAnzeigeList: $activeAnzeigeList");
    return Scaffold(
      appBar: appBar(context: context, ref: ref, home: false),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar:
          navigationBar(index: 0, context: context, ref: ref, home: false),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Container(
              child: Center(
                  child: Text("Jobs hier schnell und einfach finden",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 35.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF586015)))),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: jobAnzeigeList.isNotEmpty
                        ? ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,

                            ///TODO Bug: Wenn eine Jobanzeige offline genommen wird gibt es in der Übersicht einen Error, da jetzt weniger jobanzeigen als jobAnzeigeList.length angezeigt werden (?)
                            itemCount: jobAnzeigeList.length,
                            itemBuilder: (context, index) {
                              print(
                                  "jobAnzeigeList.length: ${jobAnzeigeList[8]}");
                              return jobAnzeigeCard(context,
                                  activeAnzeigeList[index], false, ref);
                            },
                          )
                        : Text("aktuell gibt es keine registrierten Helfer")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
