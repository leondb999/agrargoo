import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/auth_controller.dart';
import '../../main.dart';

class LandwirtProfil extends ConsumerStatefulWidget {
  const LandwirtProfil({Key? key}) : super(key: key);
  static const routename = '/landwirtprofil';

  @override
  _LandwirtProfilState createState() => _LandwirtProfilState();
}

class _LandwirtProfilState extends ConsumerState<LandwirtProfil> {
  final usersCollection = FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
      body: Container(
        child: Text("Landwirt Profil"),
      ),
    );
  }
}
