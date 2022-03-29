import 'package:agrargo/models/hof_model.dart';
import 'package:agrargo/models/jobanzeige_model.dart';
import 'package:agrargo/repositories/firestore_repository.dart';
import 'package:agrargo/repositories/hof_provider.dart';
import 'package:agrargo/repositories/jobanzeige_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as p;

import '../../controllers/auth_controller.dart';
import '../../main.dart';
import '4_a_job_angebot.dart';
import 'package:provider/provider.dart' as p;

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
    checkAuthentification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User? authControllerState = ref.watch(authControllerProvider);
    String? userID = ref.read(authControllerProvider.notifier).state?.uid;
    print("User ID : $userID");
    final firestoreService = FireStoreService();
    final hofListeFilteredByUserID =
        HofProvider().getHofByUserID(userID, p.Provider.of<List<Hof>>(context));

    //final jobAnzeigeList = p.Provider.of<List<Jobanzeige>>(context);
    ///Filter Jobanzeigen nach UserID des eingeloggten Landwirt Users
    List<Jobanzeige> jobanzeigenListUser = JobanzeigeProvider()
        .getAnzeigeByUserID(userID, p.Provider.of<List<Jobanzeige>>(context));

    final String? documentID =
        ref.read(authControllerProvider.notifier).state?.uid;

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
                  ///Show User Name from Firestore
                  FutureBuilder<DocumentSnapshot>(
                    future: usersCollection.doc(documentID).get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text("Something went wrong");
                      }
                      if (snapshot.hasData && !snapshot.data!.exists) {
                        return Text("Document does not exist");
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> data =
                            snapshot.data!.data() as Map<String, dynamic>;
                        return Container(
                          color: Colors.greenAccent,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Text(
                                "User ID:  ${ref.read(authControllerProvider.notifier).state?.uid}",
                              ),
                              Text(
                                "Hi ${data['name']}",
                                style: TextStyle(fontSize: 30),
                              ),
                            ],
                          ),
                        );
                      }
                      return SizedBox(width: 50, height: 50, child: Text(""));
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),

                  ///Höfe with User ID from Firestore
                  SingleChildScrollView(
                    child: Container(
                        height: 200,
                        child: hofListeFilteredByUserID.isEmpty
                            ? Column(
                                children: [
                                  Text(
                                      "Keine Höfe bis jetzt erstellt! Erstelle jetzt deinen ersten Hof"),
                                  ElevatedButton(
                                      onPressed: () {},
                                      child: Text("Erstelle Hof")),
                                ],
                              )
                            : ListView.builder(
                                itemCount: hofListeFilteredByUserID.length,
                                itemBuilder: (context, index) {
                                  var hof = hofListeFilteredByUserID[index];
                                  return Card(
                                    child: ListTile(
                                      title: Text(hof.hofName!),
                                    ),
                                  );
                                })),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  /// Zeige Anzeigen des Users
                  Column(
                    children: [
                      Text(
                        "Alle Anzeigen",
                        style: TextStyle(fontSize: 30),
                      ),
                      SingleChildScrollView(
                        child: Container(
                            height: MediaQuery.of(context).size.height,
                            child: jobanzeigenListUser.isEmpty
                                ? Text(
                                    "Keine Jobanzeigen bis jetzt hochgeladen")
                                : ListView.builder(
                                    itemCount: jobanzeigenListUser.length,
                                    itemBuilder: (context, index) {
                                      var jobanzeige =
                                          jobanzeigenListUser[index];

                                      return Card(
                                        color: Colors.grey,
                                        margin: EdgeInsets.only(top: 10),
                                        child: ListTile(
                                          title: Text(jobanzeige.titel!,
                                              style: TextStyle(fontSize: 30)),
                                          subtitle: Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  height: 50,
                                                  color: Colors.amber,
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                          'Auftraggeber ID: ${jobanzeige.auftraggeberID}'),
                                                      Text(
                                                          "DocID der Jobanzeige: ${jobanzeige.jobanzeigeID!}"),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          trailing: _activeAnzeige(
                                              jobanzeigenListUser[index]
                                                  .status!),
                                          leading: Image.network(
                                            "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg",
                                          ),
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              Jobangebot.routename,
                                              arguments: {
                                                'jobanzeige_ID':
                                                    jobanzeige.jobanzeigeID!
                                              },
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  )),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

Widget _activeAnzeige(bool status) {
  Widget x = Text("Hello");
  if (status == true) {
    x = Text('Active', style: TextStyle(color: Colors.green));
  } else {
    x = Text('inactive', style: TextStyle(color: Colors.red));
  }
  return x;
}

String? _getHofID(String userID) {
  String hofName = "";
  List hofList = [];
  List<String?> hofListIDs = [];

  ///Hof ID
  FirebaseFirestore.instance
      .collection('höfe')
      .where('userID', isEqualTo: userID)
      .get()
      .then((value) {
    value.docs.forEach((doc) {
      hofList.add(doc['hofName']);
      hofListIDs.add(doc.id);
    });
  });

  print("Hof ID: ${hofListIDs.first};   Hof: ${hofList.first}");
  return hofListIDs.first;
}

_getAnzeigenByHofID(String userID) async* {
  String? hofID = _getHofID(userID);
  print("_getAnzeigenByHofID: $hofID");
  List x = [];
  FirebaseFirestore.instance
      .collection('jobAnzeigen')
      .where('hofID', isEqualTo: _getHofID(userID))
      .get()
      .then((value) {
    value.docs.forEach((doc) {
      x.add(doc);
    });
  });
  x.forEach((e) {
    print("titel: ${e['titel']}; status: ${e['status']}");
  });
}
