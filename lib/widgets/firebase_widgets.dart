import 'package:agrargo/UI/login_riverpod/login.dart';
import 'package:agrargo/UI/pages/helfer/4_a_job_angebot.dart';
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
    margin: new EdgeInsets.symmetric(horizontal: 70.0, vertical: 13.0),
    child: Container(
      decoration: BoxDecoration(color: Color(0xFF9FB98B)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
        leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
                border: new Border(
                    right: new BorderSide(width: 1.0, color: Colors.white54))),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
            )),
        title: Text(jobanzeige.titel!,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Row(
          children: <Widget>[
            Icon(Icons.place, color: Colors.black12),
            SizedBox(height: 30),
            Text('Auftraggeber ID: ${jobanzeige.auftraggeberID}',
                style: TextStyle(color: Colors.white))
          ],
        ),
        trailing: Text("9,50 €/h",
            style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFFFFF))),
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
