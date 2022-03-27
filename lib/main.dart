import 'package:agrargo/UI/login_riverpod/register_riverpod.dart';
import 'package:agrargo/UI/login_riverpod/test_screen.dart';
import 'package:agrargo/controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:flutterfire_ui/database.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:flutterfire_ui/i10n.dart';

import 'UI/login_riverpod/login_riverpod.dart';
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
      title: 'Flutter Firebase Riverpod2',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/home",
      routes: {
        '/login': (context) => LoginRiverpodPage(),
        '/home': (context) => HomeScreen(),
        '/test': (context) => TestScreen(),
        '/register': (context) => RegisterRiverpodPage(),
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
        child: Row(
          children: [
            authControllerState == null
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
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: FutureBuilder<DocumentSnapshot>(
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
                              return Column(
                                children: [
                                  Text(
                                      "name: ${data['name']} ist ein ${data['landwirt'] ? 'Landwirt' : 'Arbeiter'} | (landwirt == ${data['landwirt']})"),
                                ],
                              );
                            }
                            return Column(
                              children: [
                                CircularProgressIndicator(),
                              ],
                            );
                          },
                        ),
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
