import 'package:agrargo/UI/pages/profil/landwirt_profil_admin.dart';
import 'package:agrargo/controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:agrargo/widgets/layout_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../login_riverpod/login.dart';
import 'uebersichten/3_a_jobangebote_uebersicht_helfer.dart';

class WhoAreYou extends ConsumerStatefulWidget {
  static const routename = '/who-are-you';

  WhoAreYou();

  @override
  _WhoAreYouState createState() => _WhoAreYouState();
}

class _WhoAreYouState extends ConsumerState<WhoAreYou> {
  bool landwirt = false;
  @override
  Widget build(BuildContext context) {
    User? authControllerState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: appBar(context: context, ref: ref, home: true),
      resizeToAvoidBottomInset: false, // set it to false
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Text("Wer bist du?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Open Sans',
                      fontSize: 52.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF586015)))),
          SizedBox(height: MediaQuery.of(context).size.height * 0.0515),

          ///Landwirt

          new SizedBox(
              width: MediaQuery.of(context).size.width * 0.12,
              height: MediaQuery.of(context).size.height * 0.06,
              child: ElevatedButton(
                child: Text('Landwirt'),
                onPressed: () {
                  setState(() {
                    landwirt = true;
                  });
                  if (authControllerState != null) {
                    Navigator.pushNamed(
                      context,
                      LandwirtProfil.routename,
                    );
                  } else {
                    Navigator.pushNamed(
                      context,
                      LoginPage.routename,
                      arguments: {'landwirt': landwirt},
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                    primary: Color(0xFFA7BB7B),
                    textStyle: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.03,
                        fontWeight: FontWeight.bold)),
              )),
          SizedBox(height: MediaQuery.of(context).size.height * 0.015),

          //margin: EdgeInsets.only(top: 35.0, bottom: 300),

          ///Helfer
          new SizedBox(
              width: MediaQuery.of(context).size.width * 0.12,
              height: MediaQuery.of(context).size.height * 0.06,
              child: ElevatedButton(
                child: Text('Helfer'),
                onPressed: () {
                  setState(() {
                    landwirt = false;
                  });
                  Navigator.pushNamed(
                    context,
                    JobangebotUebersichtPage.routename,
                    arguments: {'landwirt': landwirt},
                  );
                },
                style: ElevatedButton.styleFrom(
                    primary: Color(0xFFA7BB7B),
                    textStyle: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.03,
                        fontWeight: FontWeight.bold)),
              )),
        ],
      ),
    );
  }
}
