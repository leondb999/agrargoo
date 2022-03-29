import 'package:agrargo/UI/login_riverpod/login_riverpod.dart';
import 'package:agrargo/UI/pages/4_a_job_angebot.dart';
import 'package:agrargo/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agrargo/models/jobanzeige_model.dart';
import '../models/hof_model.dart';

///Hof Card
Card hofCard(HofModel hof) {
  return Card(
    child: ListTile(
      title: Text(hof.hofName!),
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
Card jobAngebotCard(BuildContext context, JobanzeigeModel jobanzeige) {
  return Card(
    color: Colors.grey,
    margin: EdgeInsets.only(top: 10),
    child: ListTile(
      title: Text(jobanzeige.titel!, style: TextStyle(fontSize: 30)),
      subtitle: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              color: Colors.amber,
              child: Column(
                children: [
                  Text('Auftraggeber ID: ${jobanzeige.auftraggeberID}'),
                  Text("DocID der Jobanzeige: ${jobanzeige.jobanzeigeID!}"),
                ],
              ),
            ),
          ),
        ],
      ),
      trailing: _activeAnzeige(jobanzeige.status!),
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
