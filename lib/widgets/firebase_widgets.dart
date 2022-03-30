import 'package:agrargo/UI/login_riverpod/login.dart';
import 'package:agrargo/UI/pages/helfer/4_a_job_angebot.dart';
import 'package:agrargo/UI/pages/landwirt/7_add_jobanzeige.dart';
import 'package:agrargo/UI/pages/landwirt/8_add_hof_page.dart';
import 'package:agrargo/main.dart';
import 'package:agrargo/models/user_model.dart';
import 'package:agrargo/provider/hof_provider.dart';
import 'package:agrargo/provider/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agrargo/models/jobanzeige_model.dart';
import '../models/hof_model.dart';
import 'package:provider/provider.dart' as p;

///Hof Card
Card hofCard(BuildContext context, HofModel hof) {
  return Card(
    child: ListTile(
      title: Text('Name ${hof.hofName!}'),
      subtitle: Container(
        height: 300,
        child: Row(
          children: [
            Column(
              children: [
                Text("HofID: ${hof.hofID}"),
                Text("Besitzer: ${hof.besitzerID}"),
                Text("Standort: ${hof.standort}"),
                ElevatedButton(
                  child: Text('Add Jobanzeige'),
                  onPressed: () {
                    print("Navigate ${hof.hofID}");
                    Navigator.of(context)
                        .pushNamed(AddEditJobanzeige.routename, arguments: {
                      'hofID': hof.hofID,
                      'hofName': hof.hofName,
                      'standort': hof.standort,
                    });
                  },
                )
              ],
            ),
          ],
        ),
      ),
      trailing: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddHofPage.routename, arguments: {
                'hofID': hof.hofID,
                'hofName': hof.hofName!,
                'besitzerID': hof.besitzerID,
                'standort': hof.standort,
              });
            },
            child: Text('Edit'),
          ),
        ],
      ),
    ),
  );
}

///check if Anzeige aktiv oder deaktiv ist
Widget _activeAnzeige(bool status) {
  Widget x = Text("Hello");
  if (status == true) {
    x = Text('Active', style: TextStyle(color: Colors.green));
  } else {
    x = Text('inactive', style: TextStyle(color: Colors.red));
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
  return Card(
    margin: EdgeInsets.only(top: 10),
    child: ListTile(
      title: Text(jobanzeige.titel!, style: TextStyle(fontSize: 30)),
      subtitle: Row(
        children: [
          Expanded(
            child: Container(
              height: 100,
              color: Colors.amber,
              child: landwirtMode
                  ? Column(
                      children: [
                        Text('Auftraggeber ID: ${jobanzeige.auftraggeberID}'),
                        Text("Jobanzeige ID: ${jobanzeige.jobanzeigeID!}"),
                        Text("Auftraggeber: ${auftraggeber.first.name}"),
                        Text('Hof: ${hof.first.hofName}'),
                        Text('Standort:${hof.first.standort}'),
                      ],
                    )
                  : Column(
                      children: [
                        Text("Auftraggeber: ${auftraggeber.first.name}"),
                        Text('Hof: ${hof.first.hofName}'),
                        Text('Standort: ${hof.first.standort}'),
                      ],
                    ),
            ),
          ),
        ],
      ),
      trailing: Column(
        children: [
          _activeAnzeige(jobanzeige.status!),
          landwirtMode
              ? ElevatedButton(
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
                )
              : Text("")
        ],
      ),
      leading: Image.network(
        "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg",
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          Jobangebot.routename,
          arguments: {'jobanzeige_ID': jobanzeige.jobanzeigeID!},
        );
      },
    ),
  );
}
