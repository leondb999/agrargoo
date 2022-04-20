import 'dart:typed_data';

import 'package:agrargo/UI/login_riverpod/login.dart';
import 'package:agrargo/UI/pages/1_landing_page_christina.dart';
import 'package:agrargo/UI/pages/2_who_are_you.dart';
import 'package:agrargo/UI/pages/chat/5_chat.dart';
import 'package:agrargo/UI/pages/chat/users_page_leon.dart';
import 'package:agrargo/UI/pages/profil/helfer_profil_admin.dart';
import 'package:agrargo/UI/pages/profil/landwirt_profil_admin.dart';
import 'package:agrargo/controllers/auth_controller.dart';
import 'package:agrargo/controllers/user_controller.dart';
import 'package:agrargo/main.dart';
import 'package:agrargo/models/user_model.dart';
import 'package:agrargo/provider/user_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as p;
import 'package:agrargo/controllers/auth_controller.dart';
import 'package:agrargo/UI/pages/profil/landwirt_profil_admin.dart' as l;

import '../UI/pages/chat/chat_leon.dart';
import '../UI/pages/uebersichten/3_a_jobangebote_uebersicht_helfer.dart';
import '../UI/pages/uebersichten/3_b_helfer_übersicht_landwirt.dart';

BottomNavigationBar navigationBar({
  required int index,
  required BuildContext context,
  required WidgetRef ref,
  required bool home,
  //required bool helfer,
}) {
  User? user = ref.read(authControllerProvider);

  /// ALle User
  final userList = ref.watch(userModelFirestoreControllerProvider);

  ///Logged In User
  String? userID = ref.read(authControllerProvider.notifier).state?.uid;

  final userModel = UserProvider().getUserNameByUserID(userID, userList!);
  print("userModel: $userModel");

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
      if (home == true) {
        switch (index) {

          ///Home Page
          case 0:
            Navigator.of(context).pushNamed(JobangebotUebersichtPage.routename);
            break;

          ///Profil Page
          case 1:
            /*
            if (user != null) {
              Navigator.of(context).pushNamed(HomeScreen.routename);
            } else {
              Navigator.of(context).pushNamed(WhoAreYou.routename);
            }
            */

            if (user != null) {
              ///User LoggedIn
              if (userModel.first.landwirt == true) {
                print("profil Index ");

                /// User ist ein Landwirt
                Navigator.of(context).pushNamed(LandwirtProfil.routename);
              } else {
                ///User ist kein Landwirt
                Navigator.of(context).pushNamed(HelferProfil.routename);
              }
            } else {
              ///User ist ausgeloggt

              Navigator.pushNamed(
                context,
                LoginPage.routename,
                arguments: {'landwirt': false},
              );

              //Navigator.of(context).pushNamed(WhoAreYou.routename);
            }
            break;
        }
      } else {
        switch (index) {

          ///Home Page
          case 0:
            if (user != null) {
              ///User LoggedIn
              if (userModel.first.landwirt == true) {
                /// User ist ein Landwirt
                Navigator.of(context).pushNamed(HelferUebersichtPage.routename);
              } else {
                ///User ist kein Landwirt
                Navigator.of(context)
                    .pushNamed(JobangebotUebersichtPage.routename);
              }
            } else {
              ///User ist ausgeloggt
              Navigator.of(context)
                  .pushNamed(JobangebotUebersichtPage.routename);
            }
            break;

          ///Chat Page
          case 1:
            if (user != null) {
              ///User ist eingeloggt
              Navigator.of(context).pushNamed(ChatUsersPage.routename);
            } else {
              ///User ist ausgeloggt
              // Navigator.of(context).pushNamed(WhoAreYou.routename);

              Navigator.pushNamed(
                context,
                LoginPage.routename,
                arguments: {'landwirt': false},
              );
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
              //Navigator.of(context).pushNamed(WhoAreYou.routename);

              Navigator.pushNamed(
                context,
                LoginPage.routename,
                arguments: {'landwirt': false},
              );
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
  // print("user: $user");
  return AppBar(
      iconTheme: IconThemeData(
        color: Color(0xFF9FB98B), //change your color here
      ),
      automaticallyImplyLeading: false,
      toolbarHeight: MediaQuery.of(context).size.height * 0.09,
      backgroundColor: Colors.white,

      ///Home Button
      title: Container(
        child: IconButton(
          tooltip: 'Helfer Übersicht',
          icon: Image.network(
              "https://firebasestorage.googleapis.com/v0/b/agrargo-2571b.appspot.com/o/logo_large.png?alt=media&token=d4af03b7-4191-495c-8d63-946be214fff8"),
          iconSize: MediaQuery.of(context).size.height * 0.2,
          color: Color(0xFF9FB98B),
          onPressed: () {
            if (user != null) {
              ///User LoggedIn
              if (userModel.first.landwirt == true) {
                /// User ist ein Landwirt
                Navigator.of(context).pushNamed(HelferUebersichtPage.routename);
              } else {
                ///User ist kein Landwirt
                Navigator.of(context)
                    .pushNamed(JobangebotUebersichtPage.routename);
              }
            } else {
              ///User ist ausgeloggt
              Navigator.of(context).pushNamed(LandingPageCh.routename);
            }
          },
        ),
      ),
      actions: <Widget>[
        ///Home Button

        user != null

            ///Sign Out Button
            ? /*ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(95, 5), primary: Colors.white),
                onPressed: () {
                  //  print("authControllerState Sign Out: $user");
                  ref.read(authControllerProvider.notifier).signOut(context);
                  Navigator.pushNamed(context, LandingPageCh.routename);
                },
                child: Text("Ausloggen",
                    style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber[800])),
              )*/
            IconButton(
                tooltip: 'Ausloggen',
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LandingPageCh()),
                      (route) => false);
                },
                icon: Icon(Icons.logout),
                color: Colors.amber[800],
              )
            : SizedBox(),
      ]);
}

Expanded profilPictureExpanded(String image) {
  return Expanded(
      flex: 1,
      child: Container(
        color: Colors.red,
        child: FutureBuilder(
          future: FirebaseStorage.instance.ref().child(image).getDownloadURL(),
          builder: (context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                  height: 50, width: 50, child: CircularProgressIndicator());
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return Container(
                  height: 300,
                  width: 300,
                  child: Image.network(snapshot.data!));
            }
            return Text("No Image");
          },
        ),
      ));
}

String getFileExtension(String fileName) {
  return "." + fileName.split('.').last;
}

///Upload Button
ElevatedButton addProfilImageButton(String userID) {
  return ElevatedButton(
    child: Text('UPLOAD FILE'),
    onPressed: () async {
      var picked = await FilePicker.platform.pickFiles();

      if (picked != null) {
        print("fileName: ${picked.files.first.name}");
        String fileExtension = getFileExtension(picked.files.first.name);
        print("FileType: $fileExtension");
        Uint8List fileBytes = picked.files.first.bytes!;
        await FirebaseStorage.instance
            .ref("$userID$fileExtension")
            .putData(fileBytes);
      }
    },
  );
}
