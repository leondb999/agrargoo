import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/auth_controller.dart';
import '../../main.dart';
import '4_a_job_angebot.dart';

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
      body: SafeArea(
        child: Center(
          /// User Infos
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                child: authControllerState == null
                    ? Text("Nothing to See")
                    : Column(
                        children: [
                          ///Show User Name from Firestore
                          Container(
                            color: Colors.greenAccent,
                            width: MediaQuery.of(context).size.width,
                            child: FutureBuilder<DocumentSnapshot>(
                              future: usersCollection.doc(documentID).get(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Text("Something went wrong");
                                }
                                if (snapshot.hasData &&
                                    !snapshot.data!.exists) {
                                  return Text("Document does not exist");
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  Map<String, dynamic> data = snapshot.data!
                                      .data() as Map<String, dynamic>;
                                  return Column(
                                    children: [
                                      Text(
                                        "User ID:  ${ref.read(authControllerProvider.notifier).state?.uid}",
                                      ),
                                      Text(
                                        "Hi ${data['name']}",
                                        style: TextStyle(fontSize: 30),
                                      ),
                                    ],
                                  );
                                }
                                return Column(
                                  children: [
                                    Container(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 60,
                          ),

                          ///Höfe with User ID from Firestore
                          Container(
                            color: Colors.lightGreen,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                Text(
                                  "Alle Höfe",
                                  style: TextStyle(fontSize: 30),
                                ),
                                Container(
                                  height: 300,
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('höfe')
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasError) {
                                        return Text('Something went wrong');
                                      }
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Container(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      final List<DocumentSnapshot> documents =
                                          snapshot.data!.docs;

                                      return ListView(
                                        children: documents
                                            .map(
                                              (doc) => Card(
                                                child: ListTile(
                                                  title: Text(doc['name']),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            color: Colors.amber,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                Text(
                                  "Alle Anzeigen",
                                  style: TextStyle(fontSize: 30),
                                ),
                                Container(
                                  height: 300,
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('jobAnzeigen')
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasError) {
                                        return Text('Something went wrong');
                                      }
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Container(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      final List<DocumentSnapshot> documents =
                                          snapshot.data!.docs;

                                      return ListView(
                                        children: documents
                                            .map(
                                              (doc) => Card(
                                                child: ListTile(
                                                  title: Text(doc['titel']),
                                                  subtitle: _activeAnzeige(
                                                      doc['status']),
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                      context,
                                                      Jobangebot.routename,
                                                    );
                                                  },
                                                  leading:
                                                      Icon(Icons.arrow_right),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
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
