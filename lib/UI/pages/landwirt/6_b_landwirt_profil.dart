import 'package:agrargo/UI/pages/landwirt/7_add_jobanzeige.dart';
import 'package:agrargo/UI/pages/landwirt/8_add_hof_page.dart';
import 'package:agrargo/models/hof_model.dart';
import 'package:agrargo/models/jobanzeige_model.dart';
import 'package:agrargo/models/user_model.dart';
import 'package:agrargo/provider/hof_provider.dart';
import 'package:agrargo/provider/jobanzeige_provider.dart';
import 'package:agrargo/provider/user_provider.dart';
import 'package:agrargo/repositories/firebase_storage_repository.dart';
import 'package:agrargo/widgets/firebase_widgets.dart';
import 'package:agrargo/widgets/layout_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  ///Firebase Storage
  final FirebaseStorage storage = FirebaseStorage.instance;

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
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.17,
                      color: Color(0xFF1f623c),
                      child: Center(
                          child: userLoggedIn.isEmpty
                              ? Text("No User found")
                              : Text("${userLoggedIn.first.name}`s Profil",
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontFamily: 'Open Sans',
                                      fontSize: 50.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFffffff))))),

                  SizedBox(height: 30),
                  /*Expanded(
                    child: FutureBuilder(
                      future: FireStorageService().getImageList(),
                      builder: (context,
                          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ListView.builder(
                              itemBuilder: (context, index) {
                            final Map<String, dynamic> image =
                                snapshot.data![index];

                            return Card(
                              child: ListTile(
                                leading: Image.network(image['url']),
                              ),
                            );
                          });
                        }
                        return Text("Hi");
                      },
                    ),
                  ),
*/
                  ///Höfe with User ID from Firestore
                  Container(
                    height: MediaQuery.of(context).size.height * 0.20,
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

                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
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
                  Expanded(
                      child: FutureBuilder(
                    future: FireStorageService().getImageList(),
                    builder: (context,
                        AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return ListView.builder(itemBuilder: ((context, index) {
                          final Map<String, dynamic> image =
                              snapshot.data!.first;
                          return Card(
                            child: ListTile(
                              leading: Image.network(image['url']),
                            ),
                          );
                        }));
                      }
                      return Text("Hi");
                    },
                  )),

                  /// Zeige Anzeigen des Users
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height,
                            child: jobanzeigenListUser.isEmpty
                                ? Text(
                                    "Keine Jobanzeigen bis jetzt hochgeladen")
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
