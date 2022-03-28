import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/auth_controller.dart';

class TestScreen extends ConsumerStatefulWidget {
  const TestScreen({Key? key}) : super(key: key);
  static const routename = '/test';

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends ConsumerState<TestScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        print(user);
        Navigator.pushReplacementNamed(context, "/home");
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    checkAuthentification();

    super.initState();
    setState(() {});
  }

  Widget build(BuildContext context) {
    User? authControllerState = ref.watch(authControllerProvider);
    return Scaffold(
      body: SafeArea(
        child: Center(

            /// Prüfe, ob Nutzer eingeloggt ist (Zum Schutz, da man über die Url einfach auf z.B. http://localhost:56802/#/test gehen kann
            child: authControllerState == null
                ? Text("Nothing to see")
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.person),
                      Text(
                        "Uid: ${ref.read(authControllerProvider.notifier).state?.uid}",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        "Email: ${ref.read(authControllerProvider.notifier).state?.email}",
                        //'EMAIL: ${_currentUser.email}',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  )),
      ),
    );
  }
}
