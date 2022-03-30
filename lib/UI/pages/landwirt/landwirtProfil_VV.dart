import 'package:agrargo/models/hof_model.dart';
import 'package:agrargo/models/jobanzeige_model.dart';
import 'package:agrargo/models/user_model.dart';
import 'package:agrargo/provider/hof_provider.dart';
import 'package:agrargo/provider/jobanzeige_provider.dart';
import 'package:agrargo/provider/user_provider.dart';
import 'package:agrargo/widgets/firebase_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as p;

import '../../../controllers/auth_controller.dart';
import '../../../main.dart';
import '7_add_jobanzeige.dart';

class LandwirtProfil extends ConsumerStatefulWidget {
  const LandwirtProfil({Key? key}) : super(key: key);
  static const routename = '/landwirtprofil';

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
      appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height * 0.09,
          backgroundColor: Colors.white,
          title: Image.network(
              'https://db3pap003files.storage.live.com/y4mXTCAYwPu3CNX67zXxTldRszq9NrkI_VDjkf3ckAkuZgv9BBmPgwGfQOeR9KZ8-jKnj-cuD8EKl7H4vIGN-Lp8JyrxVhtpB_J9KfhV_TlbtSmO2zyHmJuf4Yl1zZmpuORX8KLSoQ5PFQXOcpVhCGpJOA_90u-D9P7p3O2NyLDlziMF_yZIcekH05jop5Eb56f?width=250&height=68&cropmode=none'),
          actions: <Widget>[
            authControllerState != null

                ///Sign Out Button
                ? ElevatedButton(
                    child: Text("Sign Out"),
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(100, 5),
                      primary: Colors.green,
                    ),
                    onPressed: () {
                      print(
                          "authControllerState Sign Out: $authControllerState");
                      ref
                          .read(authControllerProvider.notifier)
                          .signOut(context);
                      Navigator.pushNamedAndRemoveUntil(
                          context, HomeScreen.routename, (route) => false);
                    },
                  )

                ///Profil Button
                : IconButton(
                    icon: const Icon(Icons.account_circle_sharp, size: 50),
                    color: Color(0xFF9FB98B),
                    tooltip: 'Profil',
                    padding: new EdgeInsets.only(right: 38.0),
                    onPressed: () {},
                  )
          ]),
      resizeToAvoidBottomInset: false,
      body: Container(
        child: authControllerState == null
            ? Text("Nothing to See")
            : Column(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.17,
                      color: Color(0xFF1f623c),
                      child: Center(
                          child: Text("${userLoggedIn.first.name}`s Profil",
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontFamily: 'Open Sans',
                                  fontSize: 50.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFffffff))))),
                  /* Container(
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
                  ),*/

                  SizedBox(height: MediaQuery.of(context).size.height * 0.015),

                  ///Höfe with User ID from Firestore
                  SingleChildScrollView(
                    child: Container(
                      child: hofListeFilteredByUserID.isEmpty
                          ? Column(
                              children: [
                                Text("Du hast bis jetzt keinen Hof erstellt!"),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.03),
                                ElevatedButton(
                                  child: Text("Erstelle deinen Hof"),
                                  style: ElevatedButton.styleFrom(
                                      primary: Color(0xFF9FB98B),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 50, vertical: 20),
                                      textStyle: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  onPressed: () {},
                                ),
                              ],
                            )
                          : ListView.builder(
                              itemCount: hofListeFilteredByUserID.length,
                              itemBuilder: (context, index) {
                                return hofCard(hofListeFilteredByUserID[index]);
                              },
                            ),
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Divider(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                  Row(children: <Widget>[
                    Expanded(flex: 1, child: Text("")),
                    Expanded(
                        flex: 10,
                        child: Center(
                          child: Text("Alle Anzeigen",
                              style: TextStyle(fontSize: 30)),
                        )),
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(AddEditJobanzeige.routename);
                          },
                        ),
                      ),
                    ),
                  ]),

                  /// Zeige Anzeigen des Users
                  Expanded(
                      child: SingleChildScrollView(
                    child: Column(children: [
                      Container(
                          height: MediaQuery.of(context).size.height,
                          child: jobanzeigenListUser.isEmpty != null
                              ? ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: jobanzeigenListUser.length,
                                  itemBuilder: (context, index) {
                                    return jobAngebotCard(
                                        context, jobanzeigenListUser[index]);
                                  },
                                )
                              : Text(
                                  "Aktuell hast du noch keine Jobanzeigen hochgeladen")),
                    ]),
                  ))
                ],
              ),
      ),
    );
  }
}