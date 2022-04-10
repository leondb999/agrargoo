import 'package:agrargo/controllers/auth_controller.dart';
import 'package:agrargo/models/jobanzeige_model.dart';
import 'package:agrargo/widgets/firebase_widgets.dart';
import 'package:agrargo/widgets/layout_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as p;

import '../../../controllers/user_controller.dart';
import '../../../provider/user_provider.dart';

class HelferUebersichtPage extends ConsumerStatefulWidget {
  const HelferUebersichtPage({Key? key}) : super(key: key);
  static const routename = '/helfer-uebersicht';

  @override
  _HelferUebersichtPageState createState() => _HelferUebersichtPageState();
}

class _HelferUebersichtPageState extends ConsumerState<HelferUebersichtPage> {
  @override
  Widget build(BuildContext context) {
    User? authControllerState = ref.watch(authControllerProvider);

    ///Alle gespeicherten User in der Firestore Collection
    final userList = ref.watch(userModelFirestoreControllerProvider);
    print("userList123123: $userList");

    ///LoggedIn User
    String? userID = ref.read(authControllerProvider.notifier).state!.uid;
    final userHelferList = UserProvider().filterUserListByLandwirt(userList!);
    print("userHelferList: $userHelferList");

    return Scaffold(
      appBar: appBar(context: context, ref: ref, home: false),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar:
          navigationBar(index: 0, context: context, ref: ref, home: false),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Container(
              child: Center(
                  child: Text("Helfer hier unkompliziert suchen",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 35.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E6C49)))),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: userHelferList.isNotEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: userHelferList.length,
                          itemBuilder: (context, index) {
                            return helferCard(context, userHelferList[index]);
                          },
                        )
                      : Text("aktuell gibt es keine Jobanzeigen"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
