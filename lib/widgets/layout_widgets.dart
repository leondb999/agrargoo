import 'package:agrargo/UI/login_riverpod/login.dart';
import 'package:agrargo/controllers/auth_controller.dart';
import 'package:agrargo/main.dart';
import 'package:agrargo/models/user_model.dart';
import 'package:agrargo/provider/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as p;
import 'package:agrargo/controllers/auth_controller.dart';

BottomNavigationBar navigationBar(int index, BuildContext context, User? user) {
  return BottomNavigationBar(
    items: [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
    ],
    currentIndex: index,
    selectedItemColor: Colors.amber[800],
    onTap: (index) {
      if (index == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
      if (index == 1) {
        if (user != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      }
    },
  );
}

AppBar appBar2(BuildContext context, WidgetRef ref) {
  User? user = ref.read(authControllerProvider);
  User? authControllerState = ref.watch(authControllerProvider);
  return AppBar(
    actions: [
      user != null

          ///Sign Out
          ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(100, 5),
                primary: Colors.green,
              ),
              onPressed: () {
                print("authControllerState Sign Out: $user");
                ref.read(authControllerProvider.notifier).signOut(context);
              },
              child: Text("Sign Out"),
            )
          : IconButton(
              splashColor: Colors.green,
              icon: Icon(
                Icons.login,
              ),
              onPressed: () {
                print("authControllerState Sign Out: $user");
                /*
                    context
                        .read(authControllerProvider.notifier)
                        .signInAnonym();
                 */
                user != null
                    ? Navigator.pushReplacementNamed(context, "/login")
                    : Navigator.pushReplacementNamed(context, "/login");
              },
            ),
    ],
  );
}

AppBar appBar({
  required BuildContext context,
  required WidgetRef ref,
}) {
  User? user = ref.read(authControllerProvider);
  String? userID = ref.read(authControllerProvider.notifier).state?.uid;
  var x = p.Provider.of<List<UserModel>>(context);
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
        height: 100,
        width: 100,
        child: IconButton(
          tooltip: 'Home',
          icon: Image.asset('Images/agrargo_logo_large.png'),
          /*
          Image.network(
              'https://db3pap003files.storage.live.com/y4mXTCAYwPu3CNX67zXxTldRszq9NrkI_VDjkf3ckAkuZgv9BBmPgwGfQOeR9KZ8-jKnj-cuD8EKl7H4vIGN-Lp8JyrxVhtpB_J9KfhV_TlbtSmO2zyHmJuf4Yl1zZmpuORX8KLSoQ5PFQXOcpVhCGpJOA_90u-D9P7p3O2NyLDlziMF_yZIcekH05jop5Eb56f?width=250&height=68&cropmode=none'),

           */
          iconSize: MediaQuery.of(context).size.height * 0.05,
          color: Color(0xFF9FB98B),
          padding: new EdgeInsets.only(right: 20.0),
          onPressed: () {
            Navigator.pushReplacementNamed(context, "/home");
          },
        ),
      ),
      /*SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
          child: Image.asset('Images/agrargo_logo_large.png')),
      */
      actions: <Widget>[
        ///Home Button
        IconButton(
          icon: const Icon(Icons.home_sharp),
          iconSize: MediaQuery.of(context).size.height * 0.05,
          color: Color(0xFF9FB98B),
          tooltip: 'Home',
          padding: new EdgeInsets.only(right: 20.0),
          onPressed: () {
            Navigator.pushReplacementNamed(context, "/home");
          },
        ),

        ///Chat Button
        IconButton(
          icon: const Icon(Icons.message_sharp),
          iconSize: MediaQuery.of(context).size.height * 0.05,
          color: Color(0xFF9FB98B),
          tooltip: 'Chat',
          padding: new EdgeInsets.only(right: 20.0),
          onPressed: () {
            //  Navigator.pushReplacementNamed(context, "/chat");
          },
        ),

        ///Profil Button
        IconButton(
          icon: const Icon(Icons.account_circle_sharp),
          iconSize: MediaQuery.of(context).size.height * 0.05,
          color: Color(0xFF9FB98B),
          tooltip: 'Profil',
          padding: new EdgeInsets.only(right: 20.0),
          onPressed: () {
            if (user != null) {
              ///User LoggedIn
              if (userModel.first.landwirt == true) {
                /// User ist ein Landwirt
                Navigator.pushReplacementNamed(context, "/landwirt-profil");
              } else {
                ///User ist kein Landwirt
                Navigator.pushReplacementNamed(context, "/helfer-profil");
              }
            } else {
              ///User ist ausgeloggt
              Navigator.pushReplacementNamed(context, "/who-are-you");
            }
          },
        ),
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
