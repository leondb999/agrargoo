import 'package:agrargo/UI/login_riverpod/login.dart';
import 'package:agrargo/UI/pages/2_who_are_you.dart';
import 'package:agrargo/UI/pages/5_chat.dart';
import 'package:agrargo/UI/pages/helfer/6_a_helfer_profil.dart';
import 'package:agrargo/UI/pages/landwirt/6_b_landwirt_profil.dart';
import 'package:agrargo/controllers/auth_controller.dart';
import 'package:agrargo/main.dart';
import 'package:agrargo/models/user_model.dart';
import 'package:agrargo/provider/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as p;
import 'package:agrargo/controllers/auth_controller.dart';

BottomNavigationBar navigationBar(
    {required int index,
    required BuildContext context,
    required WidgetRef ref,
    required bool home}) {
  User? user = ref.read(authControllerProvider);
  String? userID = ref.read(authControllerProvider.notifier).state?.uid;
  final userModel = UserProvider()
      .getUserNameByUserID(userID, p.Provider.of<List<UserModel>>(context));
  print("user: $user");
  return BottomNavigationBar(
    items: home
        ? [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
          ]
        : [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
          ],
    currentIndex: index,
    selectedItemColor: Colors.amber[800],
    onTap: (index) {
      print("index $index");
      if (home == true) {
        switch (index) {

          ///Home Page
          case 0:
            Navigator.of(context).pushNamed(HomeScreen.routename);
            break;

          ///Profil Page
          case 1:
            if (user != null) {
              ///User LoggedIn
              if (userModel.first.landwirt == true) {
                /// User ist ein Landwirt
                Navigator.of(context).pushNamed(LandwirtProfil.routename);
              } else {
                ///User ist kein Landwirt
                Navigator.of(context).pushNamed(HelferProfil.routename);
              }
            } else {
              ///User ist ausgeloggt
              Navigator.of(context).pushNamed(WhoAreYou.routename);
            }
            break;
        }
      } else {
        switch (index) {

          ///Home Page
          case 0:
            Navigator.of(context).pushNamed(HomeScreen.routename);
            break;

          ///Chat Page
          case 1:
            if (user != null) {
              ///User ist eingeloggt
              Navigator.of(context).pushNamed(Chat.routename);
            } else {
              ///User ist ausgeloggt
              Navigator.of(context).pushNamed(WhoAreYou.routename);
            }
            break;

          ///Profil Page
          case 2:
            if (user != null) {
              ///User LoggedIn
              if (userModel.first.landwirt == true) {
                /// User ist ein Landwirt
                Navigator.of(context).pushNamed(LandwirtProfil.routename);
              } else {
                ///User ist kein Landwirt
                Navigator.of(context).pushNamed(HelferProfil.routename);
              }
            } else {
              ///User ist ausgeloggt
              Navigator.of(context).pushNamed(WhoAreYou.routename);
            }

            break;
        }
      }
    },
  );
}

AppBar appBar({
  required BuildContext context,
  required WidgetRef ref,
  bool? home,
}) {
  User? user = ref.read(authControllerProvider);
  String? userID = ref.read(authControllerProvider.notifier).state?.uid;

  final userModel = UserProvider()
      .getUserNameByUserID(userID, p.Provider.of<List<UserModel>>(context));
  print("user: $user");
  return AppBar(
      iconTheme: IconThemeData(
        color: Color(0xFF9FB98B), //change your color here
      ),
      toolbarHeight: MediaQuery.of(context).size.height * 0.09,
      backgroundColor: Colors.white,

      ///Home Button
      title: Container(
        child: IconButton(
          tooltip: 'Helfer Übersicht',
          icon: Image.asset('Images/agrargo_logo_large.png'),
          /*
          Image.network(
              'https://db3pap003files.storage.live.com/y4mXTCAYwPu3CNX67zXxTldRszq9NrkI_VDjkf3ckAkuZgv9BBmPgwGfQOeR9KZ8-jKnj-cuD8EKl7H4vIGN-Lp8JyrxVhtpB_J9KfhV_TlbtSmO2zyHmJuf4Yl1zZmpuORX8KLSoQ5PFQXOcpVhCGpJOA_90u-D9P7p3O2NyLDlziMF_yZIcekH05jop5Eb56f?width=250&height=68&cropmode=none'),

           */
          iconSize: MediaQuery.of(context).size.height * 0.05,
          color: Color(0xFF9FB98B),
          padding: new EdgeInsets.only(right: 20.0),
          onPressed: () {
            Navigator.of(context).pushNamed(HomeScreen.routename);
          },
        ),
      ),
      /*SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
          child: Image.asset('Images/agrargo_logo_large.png')),
      */
      actions: <Widget>[
        ///Home Button

        user != null

            ///Sign Out Button
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(100, 5), primary: Colors.green),
                onPressed: () {
                  print("authControllerState Sign Out: $user");
                  ref.read(authControllerProvider.notifier).signOut(context);
                },
                child: Text("Sign Out"),
              )
            : SizedBox(),
      ]);
}
