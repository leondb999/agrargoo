import 'package:agrargo/UI/login_riverpod/register_riverpod.dart';
import 'package:agrargo/UI/login_riverpod/test_screen.dart';
import 'package:agrargo/UI/pages/2_who_are_you.dart';
import 'package:agrargo/controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'UI/login_riverpod/login_riverpod.dart';
import 'UI/pages/3_a_jobangebote_übersicht.dart';
import 'UI/pages/3_b_helfer_übersicht.dart';
import 'UI/pages/4_a_job_angebot.dart';
import 'UI/pages/6_a_helfer_profil.dart';
import 'UI/pages/6_b_landwirt_profil.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AgrarGo Riverpod',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/home",
      routes: {
        '/login': (context) => LoginRiverpodPage(),
        '/home': (context) => HomeScreen(),
        '/test': (context) => TestScreen(),
        '/register': (context) => RegisterRiverpodPage(),
        '/login': (context) => LoginRiverpodPage(),
        '/whoareyou': (context) => WhoAreYou(),
        '/jobangebotübersicht': (context) => JobangebotUebersichtPage(),
        '/jobangebot': (context) => Jobangebot(),
        '/helferprofil': (context) => HelferProfil(),
        '/landwirtprofil': (context) => LandwirtProfil(),
        '/helferuebersicht': (context) => HelferUebersichtPage(),
      },
    );
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // final Stream<QuerySnapshot> users =
  //   FirebaseFirestore.instance.collection('users').snapshots();
  final usersCollection = FirebaseFirestore.instance.collection('users');
  late bool landwirt;

  @override
  Widget build(BuildContext context) {
    User? authControllerState = ref.watch(authControllerProvider);
    authControllerState?.reload();
    User? authControllerStateRead = ref.read(authControllerProvider);
    String? userID = ref.read(authControllerProvider.notifier).state?.uid;
    final String? documentID =
        ref.read(authControllerProvider.notifier).state?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Agrar Go')),
        actions: [
          authControllerState != null

              ///Sign Out
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(100, 5),
                    primary: Colors.green,
                  ),
                  onPressed: () {
                    print("authControllerState Sign Out: $authControllerState");
                    ref.read(authControllerProvider.notifier).signOut();
                  },
                  child: Text("Sign Out"),
                )

              ///Sign In
              : IconButton(
                  splashColor: Colors.green,
                  icon: Icon(
                    Icons.login,
                  ),
                  onPressed: () {
                    print("authControllerState Sign Out: $authControllerState");
                    /*
                    context
                        .read(authControllerProvider.notifier)
                        .signInAnonym();
                 */
                    authControllerState != null
                        ? Navigator.pushReplacementNamed(context, "/login")
                        : Navigator.pushReplacementNamed(context, "/login");
                  },
                ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 100,
              child: authControllerState == null

                  ///Logged Out
                  ? Column(
                      children: [
                        Icon(Icons.login),
                        Text("Signed Out"),
                        Text(
                          "Name ${authControllerState?.displayName}",
                          style: TextStyle(color: Colors.red),
                        ),
                        Text(
                          "Email ${ref.read(authControllerProvider.notifier).state?.email}",
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    )

                  ///Logged In
                  : Column(
                      children: [
                        Icon(Icons.login),
                        Text(
                          "Signed In:  ${ref.read(authControllerProvider.notifier).state?.uid}",
                        ),
                        Text(
                          "Email: ${ref.read(authControllerProvider.notifier).state?.email}",
                          style: TextStyle(color: Colors.green),
                        ),
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
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              Map<String, dynamic> data =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              return Text(
                                  "name: ${data['name']} ist ein ${data['landwirt'] ? 'Landwirt' : 'Arbeiter'} | (landwirt == ${data['landwirt']})");
                            }
                            return Column(
                              children: [
                                CircularProgressIndicator(),
                              ],
                            );
                          },
                        ),
                        /*
                  Container(
                      height: 300,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: usersCollection.snapshots(),
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
                          final data = snapshot.requireData;

                          return Column(
                            children: [
                              Text("Hello"),
                              ListView.builder(
                                itemCount: data.size,
                                itemBuilder: (context, index) {
                                  return Text(
                                      'My Name is ${data.docs[index]['name']} and i am a ${data.docs[index]['landwirt'] ? 'Landwirt' : 'Arbeiter'}');
                                },
                              ),
                            ],
                          );
                        },
                      ))
                  */
                      ],
                    ),
            ),
            Expanded(
              flex: 7,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        "In 3 Schritten zum Erfolg",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Open Sans',
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: 35.0,
                            height: 35.0,
                            decoration: new BoxDecoration(
                              color: Color(0xFF2E6C49),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                                child: Text(
                              "1.",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),
                            ))),
                        SizedBox(width: 10),
                        Container(
                          child: Center(
                            child: Text(
                              "Deine Wünsche",
                              style: TextStyle(
                                fontFamily: 'Open Sans',
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 30),
                        Container(
                          width: 35.0,
                          height: 35.0,
                          decoration: new BoxDecoration(
                            color: Color(0xFF2E6C49),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              "2.",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          child: Center(
                            child: Text(
                              "Match finden",
                              style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 30),
                        Container(
                            width: 35.0,
                            height: 35.0,
                            decoration: new BoxDecoration(
                              color: Color(0xFF2E6C49),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                                child: Text(
                              "3.",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),
                            ))),
                        SizedBox(width: 10),
                        Container(
                          child: Center(
                            child: Text(
                              "Durchstarten",
                              style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 35.0, bottom: 30),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => WhoAreYou()));
                      },
                      child: Text('Los gehts!'),
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xFF9FB98B),
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          textStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<DocumentSnapshot?> getCurrentUserbyDocumentId(
    CollectionReference<Map<String, dynamic>> collection, String? id) async {
  bool? landwirt;
  DocumentSnapshot? documentSnapshot;

  await FirebaseFirestore.instance
      .collection('users')
      .doc(id)
      .get()
      .then((value) {
    documentSnapshot = value;
    landwirt = value['landwirt'];
  });
  // print("landwirt: ${landwirt.toString()} ");
  //now you can access the document field value
  // String? name = documentSnapshot!['name'];
  //bool landwirt2 = documentSnapshot!['landwirt'];
  //print("Name: '$name' ist ein ${landwirt2 ? 'Landwirt' : 'Arbeiter'} ");
  return documentSnapshot;
}
