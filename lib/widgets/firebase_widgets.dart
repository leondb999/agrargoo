import 'package:agrargo/UI/pages/helfer/4_a_job_angebot.dart';
import 'package:agrargo/UI/pages/landwirt/7_add_jobanzeige.dart';
import 'package:agrargo/UI/pages/landwirt/8_add_hof_page.dart';
import 'package:agrargo/models/user_model.dart';
import 'package:agrargo/provider/hof_provider.dart';
import 'package:agrargo/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:agrargo/models/jobanzeige_model.dart';
import '../models/hof_model.dart';
import 'package:provider/provider.dart' as p;

///Hof Card
Card hofCard(BuildContext context, HofModel hof) {
  return Card(
    elevation: 6.0,
    margin: new EdgeInsets.symmetric(horizontal: 30.0, vertical: 13.0),
    child: ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      title: Text('Name:  ${hof.hofName!}'),
      subtitle: Container(
        child: Row(
          children: [
            Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Text("HofID: ${hof.hofID}"),
                Text("Standort: ${hof.standort}"),
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
    BuildContext context, JobanzeigeModel jobanzeige, bool landwirtMode) {
  final auftraggeber = UserProvider().getUserNameByUserID(
      jobanzeige.auftraggeberID, p.Provider.of<List<UserModel>>(context));
  final hof = HofProvider().getHofByUserID(
      jobanzeige.auftraggeberID, p.Provider.of<List<HofModel>>(context));
  print("auftraggeber ${auftraggeber.first}");
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
              backgroundImage: NetworkImage(
                  'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
            )),
        title: Text(
          jobanzeige.titel!,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: <Widget>[
            Icon(Icons.place, color: Colors.black12),
            SizedBox(height: 30),
            landwirtMode
                ? Text(
                    'Auftraggeber ID: ${jobanzeige.auftraggeberID}, Jobanzeige ID: ${jobanzeige.jobanzeigeID!},Auftraggeber: ${auftraggeber.first.name}, Hof: ${hof.first.hofName}, Standort:${hof.first.standort}')
                : Text(
                    "Auftraggeber: ${auftraggeber.first.name}, Hof: ${hof.first.hofName}, Standort: ${hof.first.standort}")
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
                    "9,25 €/h",
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
