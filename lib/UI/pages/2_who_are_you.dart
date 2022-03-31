import 'package:agrargo/UI/pages/landwirt/6_b_landwirt_profil.dart';
import 'package:agrargo/controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:agrargo/widgets/layout_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../login_riverpod/login.dart';
import 'helfer/3_a_jobangebote_uebersicht.dart';

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(top: 300.0),
                child: Center(
                    child: Text("Wer bist du?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Open Sans',
                            fontSize: 50.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E6C49))))),
            Container(
                margin: EdgeInsets.only(top: 35.0),

                ///Landwirt
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
                      primary: Color(0xFF9FB98B),
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      textStyle:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                )),
            Container(
              margin: EdgeInsets.only(top: 35.0, bottom: 300),

              ///Helfer
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
                    primary: Color(0xFF9FB98B),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
