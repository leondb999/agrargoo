import 'package:agrargo/UI/pages/angebot/4_a_job_angebot_landwirt.dart';
import 'package:agrargo/UI/pages/add/7_add_jobanzeige_landwirt.dart';
import 'package:agrargo/UI/pages/add/8_add_hof_page_landwirt.dart';
import 'package:agrargo/UI/pages/profil/helfer_profil_oeffentlich.dart';
import 'package:agrargo/controllers/qualifikation_controller.dart';
import 'package:agrargo/models/qualifikation_model.dart';
import 'package:agrargo/models/user_model.dart';
import 'package:agrargo/provider/hof_provider.dart';
import 'package:agrargo/provider/qualifikation_provider.dart';
import 'package:agrargo/provider/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agrargo/models/jobanzeige_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/hof_model.dart';
import 'package:provider/provider.dart' as p;

///Hof Card
Card hofCard({
  required BuildContext context,
  required HofModel hof,
}) {
  return Card(
    elevation: 6.0,
    margin: new EdgeInsets.symmetric(horizontal: 30.0, vertical: 13.0),
    child: ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      title: Text('Name:  ${hof.hofName!}'),
      leading: hof.hofImageURL != null
          ? Image.network(
              hof.hofImageURL!,
              // 'https://db3pap003files.storage.live.com/y4mXTCAYwPu3CNX67zXxTldRszq9NrkI_VDjkf3ckAkuZgv9BBmPgwGfQOeR9KZ8-jKnj-cuD8EKl7H4vIGN-Lp8JyrxVhtpB_J9KfhV_TlbtSmO2zyHmJuf4Yl1zZmpuORX8KLSoQ5PFQXOcpVhCGpJOA_90u-D9P7p3O2NyLDlziMF_yZIcekH05jop5Eb56f?width=250&height=68&cropmode=none',
            )

          ///TODO Finde ein besseres DEFAULT Bild was dem Nutzer angezeigt werden soll wenn er noch kein Bild für einen Hof hochgeladen hat
          : Image.network(
              'https://db3pap003files.storage.live.com/y4mXTCAYwPu3CNX67zXxTldRszq9NrkI_VDjkf3ckAkuZgv9BBmPgwGfQOeR9KZ8-jKnj-cuD8EKl7H4vIGN-Lp8JyrxVhtpB_J9KfhV_TlbtSmO2zyHmJuf4Yl1zZmpuORX8KLSoQ5PFQXOcpVhCGpJOA_90u-D9P7p3O2NyLDlziMF_yZIcekH05jop5Eb56f?width=250&height=68&cropmode=none',
              height: 50,
              width: 50,
            ),
      subtitle: Container(
        child: Row(
          children: [
            Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Text("HofID: ${hof.hofID}"),
                Text("Standort: ${hof.standort}"),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(AddEditJobanzeige.routename, arguments: {
                      'hofID': hof.hofID,
                      'hofName': hof.hofName,
                      'standort': hof.standort,
                    });
                  },
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    // Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Icon(Icons.add),
                      Text("Anzeige hinzufügen")
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      trailing: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.black45,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                textStyle: TextStyle(color: Colors.white54)),
            onPressed: () {
              Navigator.of(context).pushNamed(AddHofPage.routename, arguments: {
                'hofID': hof.hofID,
                'hofName': hof.hofName!,
                'besitzerID': hof.besitzerID,
                'standort': hof.standort,
                'hofImageURL': hof.hofImageURL,
              });
            },
            child: Text(
              'Edit',
            ),
          ),
        ],
      ),
    ),
  );
}

///check if Anzeige aktiv oder deaktiv ist
Widget _activeAnzeige(bool status) {
  Widget x = Text("");
  if (status == true) {
    x = Text('Active',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
  } else {
    x = Text('inactive', style: TextStyle(color: Colors.white));
  }
  return x;
}

///Jobangebot Card
Card jobAnzeigeCard(
  BuildContext context,
  JobanzeigeModel jobanzeige,
  bool landwirtMode,
  WidgetRef ref,
) {
  ///User Provider
  final auftraggeber = UserProvider().getUserNameByUserID(
      jobanzeige.auftraggeberID, p.Provider.of<List<UserModel>>(context));
//  print("auftraggeber: $auftraggeber");

  ///Hof Provider
  final hof = HofProvider().getHofByUserID(
      jobanzeige.auftraggeberID, p.Provider.of<List<HofModel>>(context));

  ///Alle Qualifikationen

  var allQualifikationenList =
      ref.read(qualifikationModelFirestoreControllerProvider.notifier).state!;
  print("allQualifikationenList: ${allQualifikationenList}");
  print("anzeige.qualifikationList: ${jobanzeige.qualifikationList}");

  final selectedQualifikationenList = QualifikationProvider()
      .filterQualifikationenByID(
          jobanzeige.qualifikationList!, allQualifikationenList);

  print("selectedQualifikationenList: $selectedQualifikationenList");
  selectedQualifikationenList.forEach((quali) {
    print(
        "jobAnzeigeCard_selectedQualifikationenList: ${quali.qualifikationName}");
  });
  return Card(
    elevation: 6.0,
    margin: new EdgeInsets.symmetric(horizontal: 70.0, vertical: 13.0),
    child: Container(
      decoration: BoxDecoration(color: Color(0xFF9FB98B)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 35.0),
        leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
                border: new Border(
                    right: new BorderSide(width: 1.0, color: Colors.white54))),
            child: CircleAvatar(
              backgroundImage: hof.first.hofImageURL != null
                  ? NetworkImage(hof.first.hofImageURL!)
                  : NetworkImage(
                      'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
            )),
        title: Text(
          jobanzeige.titel!,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: <Widget>[
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Text(
                      "Verfügbarer Zeitraum: ${jobanzeige.startDate!.day}.${jobanzeige.startDate!.month}.${jobanzeige.endDate!.year}-${jobanzeige.endDate!.day}.${jobanzeige.endDate!.month}.${jobanzeige.endDate!.year}"),
                ),
              ],
            ),
            Icon(Icons.place, color: Colors.black12),
            SizedBox(height: 30),
            landwirtMode
                ? Text(
                    'Auftraggeber ID: ${jobanzeige.auftraggeberID}, Jobanzeige ID: ${jobanzeige.jobanzeigeID!},Auftraggeber: ${auftraggeber.first.name}, Hof: ${hof.first.hofName}, Standort:${hof.first.standort}')
                : Text("${hof.first.standort}"),

            ///Liste der Qualifikationen der Anzeige

            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 100,
                width: 150,
                child: ListView.builder(
                  itemCount: selectedQualifikationenList.length,
                  itemBuilder: (context, index) {
                    var qualifikation = selectedQualifikationenList[index];
                    return Card(
                      child: ListTile(
                          title: Text(
                        "${qualifikation.qualifikationName}",
                      )),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        trailing: Column(
          children: [
            landwirtMode
                ? Column(children: [
                    _activeAnzeige(jobanzeige.status!),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.005),
                    ElevatedButton(
                      child: Text("Edit"),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(AddEditJobanzeige.routename, arguments: {
                          'hofID': jobanzeige.hofID,
                          'auftraggeberID': jobanzeige.auftraggeberID,
                          'status': jobanzeige.status,
                          'titel': jobanzeige.titel,
                          'jobanzeigeID': jobanzeige.jobanzeigeID,
                          'stundenLohn': jobanzeige.stundenLohn,
                          'qualifikationList': jobanzeige.qualifikationList,
                          'startDate': jobanzeige.startDate,
                          'endDate': jobanzeige.endDate,
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black45,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          textStyle: TextStyle(color: Colors.white54)),
                    ),
                  ])
                : Text(
                    "${jobanzeige.stundenLohn} €/h",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 25),
                  ),
          ],
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            Jobangebot.routename,
            arguments: {'jobanzeige_ID': jobanzeige.jobanzeigeID!},
          );
        },
      ),
    ),
  );
}

Card helferCard(BuildContext context, UserModel userModelHelfer) {
  print("uuuuserModel: ${userModelHelfer.userID}");
  return Card(
    elevation: 6.0,
    margin: new EdgeInsets.symmetric(horizontal: 70.0, vertical: 13.0),
    child: Container(
      decoration: BoxDecoration(color: Color(0xFF9FB98B)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 35.0),
        title: Text("${userModelHelfer.name}"),
        subtitle: Row(
          children: [Text("hi")],
        ),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white54))),
          child: CircleAvatar(
            backgroundImage: userModelHelfer.profilImageURL != null
                ? NetworkImage(userModelHelfer.profilImageURL!)
                : NetworkImage(
                    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
          ),
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            HelferProfilOeffentlich.routename,
            arguments: {'userID': userModelHelfer.userID!},
          );
        },
      ),
    ),
  );
}
