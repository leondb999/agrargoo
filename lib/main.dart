import 'dart:math';

import 'package:agrargo/UI/login_riverpod/register.dart';
import 'package:agrargo/UI/login_riverpod/test_screen.dart';
import 'package:agrargo/UI/pages/2_who_are_you.dart';
import 'package:agrargo/UI/pages/add/7_add_jobanzeige_landwirt.dart';
import 'package:agrargo/UI/pages/add/8_add_hof_page_landwirt.dart';
import 'package:agrargo/UI/pages/chat/chat_leon.dart';
import 'package:agrargo/UI/pages/chat/users_page_leon.dart';
import 'package:agrargo/controllers/auth_controller.dart';
import 'package:agrargo/controllers/user_controller.dart';
import 'package:agrargo/models/hof_model.dart';
import 'package:agrargo/models/jobanzeige_model.dart';
import 'package:agrargo/models/user_model.dart';
import 'package:agrargo/provider/qualifikation_provider.dart';
import 'package:agrargo/provider/user_provider.dart';
import 'package:agrargo/repositories/firestore_jobanzeige_model_riverpod_repository.dart';
import 'package:agrargo/repositories/firestore_repository.dart';
import 'package:agrargo/provider/hof_provider.dart';
import 'package:agrargo/provider/jobanzeige_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as p;
import 'UI/pages/1_landing_page_christina.dart';
import 'UI/pages/chat/5_chat.dart';
import 'widgets/layout_widgets.dart';
import 'UI/login_riverpod/login.dart';
import 'UI/pages/uebersichten/3_a_jobangebote_uebersicht_helfer.dart';
import 'UI/pages/uebersichten/3_b_helfer_übersicht_landwirt.dart';
import 'UI/pages/angebot/4_a_job_angebot_landwirt.dart';
import 'UI/pages/profil/6_a_helfer_profil.dart';
import 'UI/pages/profil/landwirt_profil.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firestoreService = FireStoreService();
    return p.MultiProvider(
      providers: [
        ///User Provider
        p.ChangeNotifierProvider.value(value: UserProvider()),

        p.StreamProvider<List<UserModel>>.value(
          value: firestoreService.getUserList(),
          initialData: [],
          child: StreamBuilder(builder: (context, snapshot) {
            if (!snapshot.hasError) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text(
                    'Offline!',
                    style: TextStyle(fontSize: 24, color: Colors.red),
                    textAlign: TextAlign.center,
                  );
                case ConnectionState.waiting:
                  return SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(),
                  );
                default:
                  return ListView.builder(itemBuilder: (context, index) {
                    return Text("Hier könnten ihre Jobanzeigen stehen");
                  });
              }
            } else {
              return Text(
                "Error: ${snapshot.error}",
                style: TextStyle(fontSize: 17, color: Colors.red),
                textAlign: TextAlign.center,
              );
            }
          }),
        ),

        ///QualifikationModel Provider
        p.ChangeNotifierProvider.value(value: QualifikationProvider()),

        ///HofModel Provider
        p.ChangeNotifierProvider.value(value: HofProvider()),
        p.StreamProvider<List<HofModel>>.value(
          value: firestoreService.getHoefeList(),
          initialData: [],
          child: StreamBuilder(builder: (context, snapshot) {
            if (!snapshot.hasError) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text(
                    'Offline!',
                    style: TextStyle(fontSize: 24, color: Colors.red),
                    textAlign: TextAlign.center,
                  );
                case ConnectionState.waiting:
                  return SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(),
                  );
                default:
                  return ListView.builder(itemBuilder: (context, index) {
                    return Text("Her könnten ihre Jobanzeigen stehen");
                  });
              }
            } else {
              return Text(
                "Error: ${snapshot.error}",
                style: TextStyle(fontSize: 17, color: Colors.red),
                textAlign: TextAlign.center,
              );
            }
          }),
        ),

        ///JobanzeigeModel Provider
        p.ChangeNotifierProvider.value(value: JobanzeigeProvider()),
        p.StreamProvider<List<JobanzeigeModel>>.value(
          value: firestoreService.getJobanzeigenList(),
          child: StreamBuilder(
            builder: (context, snapshot) {
              if (!snapshot.hasError) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text(
                      'Offline!',
                      style: TextStyle(fontSize: 24, color: Colors.red),
                      textAlign: TextAlign.center,
                    );
                  case ConnectionState.waiting:
                    return SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(),
                    );
                  default:
                    return ListView.builder(itemBuilder: (context, index) {
                      return Text("Her könnten ihre Jobanzeigen stehen");
                    });
                }
              } else {
                return Text(
                  "Error: ${snapshot.error}",
                  style: TextStyle(fontSize: 17, color: Colors.red),
                  textAlign: TextAlign.center,
                );
              }
            },
          ),
          initialData: [],
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AgrarGo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/landingpage',
        routes: {
          '/login': (context) => LoginPage(),
          '/home': (context) => HomeScreen(),
          '/test': (context) => TestScreen(),
          '/register': (context) => RegisterPage(),
          '/login': (context) => LoginPage(),
          '/who-are-you': (context) => WhoAreYou(),
          '/jobangebot-uebersicht': (context) => JobangebotUebersichtPage(),
          '/jobangebot': (context) => Jobangebot(),
          '/helfer-profil': (context) => HelferProfil(),
          '/landwirt-profil': (context) => LandwirtProfil(),
          '/helfer-uebersicht': (context) => HelferUebersichtPage(),
          '/add-edit-jobanzeige': (context) => AddEditJobanzeige(),
          '/add-hof': (context) => AddHofPage(),
          //'/chat': (context) => ChatPageLeon(),
          '/landingpage': (context) => LandingPageCh(),
          '/chat-users-page1': (context) => ChatUsersPage(),
        },
      ),
    );
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  static const routename = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // final Stream<QuerySnapshot> users =
  //   FirebaseFirestore.instance.collection('users').snapshots();
  final usersCollection = FirebaseFirestore.instance.collection('users');
  late bool landwirt;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        print(user);
        setState(() {});
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
    authControllerState?.reload();
    User? authControllerStateRead = ref.read(authControllerProvider);
    String? userID = ref.read(authControllerProvider.notifier).state?.uid;

    /// ALle User
    final userList = ref.watch(userModelFirestoreControllerProvider);
    print("userList: $userList");
    final userLoggedIn = UserProvider().getUserNameByUserID(userID, userList!);
    print("userLoggedIN: $userLoggedIn");
    final String? documentID =
        ref.read(authControllerProvider.notifier).state?.uid;

    return Scaffold(
      appBar: appBar(context: context, ref: ref, home: true),
      bottomNavigationBar:
          navigationBar(index: 0, context: context, ref: ref, home: true),
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
