import 'package:agrargo/UI/pages/landwirt/7_add_jobanzeige.dart';
import 'package:agrargo/UI/pages/landwirt/8_add_hof_page.dart';
import 'package:agrargo/models/hof_model.dart';
import 'package:agrargo/models/jobanzeige_model.dart';
import 'package:agrargo/models/user_model.dart';
import 'package:agrargo/provider/hof_provider.dart';
import 'package:agrargo/provider/jobanzeige_provider.dart';
import 'package:agrargo/provider/user_provider.dart';
import 'package:agrargo/widgets/firebase_widgets.dart';
import 'package:agrargo/widgets/layout_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as p;

import '../../../controllers/auth_controller.dart';
import '../../../main.dart';

class LandwirtProfil extends ConsumerStatefulWidget {
  const LandwirtProfil({Key? key}) : super(key: key);
  static const routename = '/landwirt-profil';

  @override
  _LandwirtProfilState createState() => _LandwirtProfilState();
}

class _LandwirtProfilState extends ConsumerState<LandwirtProfil> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ///User Collection
  final usersCollection = FirebaseFirestore.instance.collection('users');
  final jobAnzeigenCollection =
      FirebaseFirestore.instance.collection('jobAnzeigen');

  ///Hof Collection
  final hofCollection =
      FirebaseFirestore.instance.collection('höfe').snapshots();

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
      } else {
        print("checkAuthentification User: $user");
        Navigator.pushReplacementNamed(context, "/home");
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    // checkAuthentification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User? authControllerState = ref.watch(authControllerProvider);
    String? userID = ref.read(authControllerProvider.notifier).state?.uid;
    print("User ID : $userID");

    /// User Liste
    final userLoggedIn = UserProvider()
        .getUserNameByUserID(userID, p.Provider.of<List<UserModel>>(context));

    ///Hof Liste
    final hofListeFilteredByUserID = HofProvider()
        .getHofByUserID(userID, p.Provider.of<List<HofModel>>(context));

    ///Jobanzeigen Filtered by UserID
    List<JobanzeigeModel> jobanzeigenListUser = JobanzeigeProvider()
        .getAnzeigeByUserID(
            userID, p.Provider.of<List<JobanzeigeModel>>(context));

    return Scaffold(
      appBar: appBar(context: context, ref: ref, home: false),
      bottomNavigationBar:
          navigationBar(index: 2, context: context, ref: ref, home: false),
      resizeToAvoidBottomInset: false,
      body: Container(
        child: authControllerState == null
            ? Text("Nothing to See")
            : Column(
                children: [
                  Container(
                    color: Colors.greenAccent,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        userLoggedIn.isEmpty
                            ? Text("No User found")
                            : Column(
                                children: [
                                  Text(
                                    " Hi ${userLoggedIn.first.name}",
                                    style: TextStyle(fontSize: 30),
                                  ),
                                  Text("User ID: $userID"),
                                ],
                              ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),

                  ///Höfe with User ID from Firestore
                  Container(
                    height: 300,
                    child: hofListeFilteredByUserID.isEmpty
                        ? Column(
                            children: [
                              Text(
                                  "Keine Höfe bis jetzt erstellt! Erstelle jetzt deinen ersten Hof"),
                              ElevatedButton(
                                child: Text("Erstelle Hof"),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(AddHofPage.routename);
                                },
                              ),
                            ],
                          )
                        : ListView.builder(
                            itemCount: hofListeFilteredByUserID.length,
                            itemBuilder: (context, index) {
                              return hofCard(
                                  context, hofListeFilteredByUserID[index]);
                            },
                          ),
                  ),

                  /// Zeige Anzeigen des Users
                  Column(
                    children: [
                      Text("Alle Anzeigen", style: TextStyle(fontSize: 30)),
                      SingleChildScrollView(
                        child: Container(
                          height: 300,
                          child: jobanzeigenListUser.isEmpty
                              ? Text("Keine Jobanzeigen bis jetzt hochgeladen")
                              : ListView.builder(
                                  itemCount: jobanzeigenListUser.length,
                                  itemBuilder: (context, index) {
                                    return jobAnzeigeCard(
                                      context,
                                      jobanzeigenListUser[index],
                                      true,
                                    );
                                  },
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}