import 'dart:io';
import 'dart:typed_data';
import 'package:agrargo/controllers/hof_controller.dart';
import 'package:agrargo/repositories/firestore_user_model_riverpod_repository.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:path/path.dart' as path;
import 'package:agrargo/UI/pages/add/7_add_jobanzeige_landwirt.dart';
import 'package:agrargo/UI/pages/add/8_add_hof_page_landwirt.dart';
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
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart' as p;
import '../../../controllers/auth_controller.dart';
import '../../../controllers/jobanzeige_controller.dart';
import '../../../controllers/qualifikation_controller.dart';
import '../../../controllers/user_controller.dart';
import '../../../main.dart';
import '../../../repositories/firestore_hof_model_riverpod_repository.dart';
import '../../../repositories/firestore_qualifikation_model_riverpod_repository.dart';

class LandwirtProfil extends ConsumerStatefulWidget {
  const LandwirtProfil({Key? key}) : super(key: key);
  static const routename = '/landwirt-profil';
  @override
  _LandwirtProfilState createState() => _LandwirtProfilState();
}

class _LandwirtProfilState extends ConsumerState<LandwirtProfil> {
  /// Loading Process
  double progress = 0.0;
  /*
  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
      } else {
        print("checkAuthentification User: $user");
        Navigator.pushReplacementNamed(context, "/home");
      }
    });
  }
*/
  Widget _buildPopupDialog(
      BuildContext context, String userID, UserModel userLoggedIn) {
    return new AlertDialog(
      title: const Text(
        "Einstellungen",
        style: TextStyle(
          fontStyle: FontStyle.normal,
          fontFamily: 'Open Sans',
          fontSize: 23.0,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1f623c),
        ),
      ),
      content: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Center(
                child: Column(children: [
              ///Todo implement function with Error handling for Error:   Error: [firebase_storage/object-not-found] No object exists at the desired reference. ||ALso, um zu prüfen, ob die URL eine valide URL ist
              userLoggedIn.profilImageURL == null
                  ? Image.network(
                      'https://db3pap003files.storage.live.com/y4mXTCAYwPu3CNX67zXxTldRszq9NrkI_VDjkf3ckAkuZgv9BBmPgwGfQOeR9KZ8-jKnj-cuD8EKl7H4vIGN-Lp8JyrxVhtpB_J9KfhV_TlbtSmO2zyHmJuf4Yl1zZmpuORX8KLSoQ5PFQXOcpVhCGpJOA_90u-D9P7p3O2NyLDlziMF_yZIcekH05jop5Eb56f?width=250&height=68&cropmode=none',
                    )
                  : Image.network(
                      userLoggedIn.profilImageURL!,
                      width: 300,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          // child: CircularProgressIndicator(),
                          child: Container(
                            height: 100.0,
                            width: 100.0,
                            child: LiquidCircularProgressIndicator(
                              value: progress / 100,
                              valueColor: AlwaysStoppedAnimation(Colors.green),
                              backgroundColor: Colors.white,
                              direction: Axis.vertical,
                              center: Text(
                                "${progress.toInt()}%",
                                style: GoogleFonts.poppins(
                                    color: Colors.black87, fontSize: 25.0),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ])),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            Center(
              child: TextButton(
                child: Text(
                  "Bild hochladen",
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFFA7BB7B)),
                ),

                ///Todo implement CircularProgressindicator um dem Nutzer zu zeigen, dass das Profilbild grade am hochladen ist
                onPressed: () async {
                  var picked = await FilePicker.platform.pickFiles();
                  if (picked != null) {
                    String fileExtension =
                        getFileExtension(picked.files.first.name);

                    Uint8List fileBytes = picked.files.first.bytes!;
                    FirebaseStorage storage = FirebaseStorage.instance;
                    Reference reference =
                        storage.ref("${userID}$fileExtension");
                    UploadTask task = FirebaseStorage.instance
                        .ref("$userID$fileExtension")
                        .putData(fileBytes);
                    task.snapshotEvents.listen((event) {
                      var x = ((event.bytesTransferred.toDouble() /
                              event.totalBytes.toDouble()) *
                          100);
                      setState(() {
                        progress = x;
                      });
                    });
                    String urlString = await reference.getDownloadURL();
                    print("getDownloadURL(): $urlString");
                    ref
                        .watch(userModelFirestoreControllerProvider.notifier)
                        .updateURL(userLoggedIn, urlString);
                  }
                },
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                    Row(
                      children: <Widget>[
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.015),
                        Expanded(
                          flex: 1,
                          child: Text(""),
                        ),
                        Expanded(
                          flex: 6,
                          child: Text(
                            "Name",
                            style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontSize: 22.0,
                              color: Color(0xFF1f623c),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 10,
                          child: Text(
                            '${userLoggedIn.name}',
                            style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Open Sans',
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: TextButton(
                            ///Todo Bearbeiten
                            onPressed: () {
                              setState(() {
                                nameBearbeitenFieldController.text =
                                    userLoggedIn.name!;
                              });
                              openNameBearbeitenDialog(context, userLoggedIn);
                            },
                            child: Text(
                              "Bearbeiten",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xFFA7BB7B)),
                            ),
                            // color: Colors.blue,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(""),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Row(
                      children: <Widget>[
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.015),
                        Expanded(
                          flex: 1,
                          child: Text(""),
                        ),
                        Expanded(
                          flex: 6,
                          child: Text(
                            "E-Mail",
                            style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontSize: 22.0,
                              color: Color(0xFF1f623c),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 10,
                          child: Text(
                            '${userLoggedIn.email}',
                            style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Open Sans',
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(""),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Row(
                      children: <Widget>[
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.015),
                        Expanded(
                          flex: 1,
                          child: Text(""),
                        ),
                        Expanded(
                          flex: 6,
                          child: Text(
                            "Geburtsdatum",
                            style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontSize: 22.0,
                              color: Color(0xFF1f623c),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 10,
                          child: Text(
                            '${userLoggedIn.birthDate!.day}.${userLoggedIn.birthDate!.month}.${userLoggedIn.birthDate!.year}',
                            style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Open Sans',
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(""),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ]),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text(
            'Abbrechen',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  TextEditingController nameBearbeitenFieldController = TextEditingController();
  String nameBearbeitenText = "";

  ///AlertDialog um Erfahrungen zu bearbeiten
  Future<void> openNameBearbeitenDialog(
      BuildContext context, UserModel loggedInUser) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Edit Erfahrungen"),
            content: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: nameBearbeitenFieldController,
              decoration: InputDecoration(
                  hintText: "Beschreibe deine Erfahrungen als Helfer"),
              onChanged: (value) {
                setState(() {
                  nameBearbeitenText = value;
                });
              },
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text("Cancel"),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              ElevatedButton(
                child: Text("OK"),
                onPressed: () {
                  print("erfahrungenText: $nameBearbeitenText");
                  setState(() {
                    print("qualifikationIDList: $nameBearbeitenText");
                    ref
                        .watch(userModelFirestoreControllerProvider.notifier)
                        .updateName(loggedInUser, nameBearbeitenText);

                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    // checkAuthentification();
    super.initState();
/*
    Future.delayed(Duration(microseconds: 10), () async {
      String? userID = ref.read(authControllerProvider.notifier).state!.uid;

      final url = await FirebaseStorage.instance
          .ref()
          .child('$userID.jpg')
          .getDownloadURL();
      setState(() {});

    });*/
  }

  @override
  Widget build(BuildContext context) {
    ///Authentication State check: Logged In or Logged Out
    User? authControllerState = ref.watch(authControllerProvider);

    ///Alle gespeicherten User in der Firestore Collection
    final userList = ref.watch(userModelFirestoreControllerProvider);

    ///LoggedIn User
    String? userID = ref.read(authControllerProvider.notifier).state!.uid;
    final userLoggedIn =
        UserProvider().getUserNameByUserID(userID, userList!).first;

    /// Hof Liste
    final hofList = ref.watch(hofModelFirestoreControllerProvider);

    final hofListeFilteredByUserID =
        HofProvider().getHofByUserID(userID, hofList!);

    ///Jobanzeigen Filtered by UserID
    final jobanzeigeModelList =
        ref.watch(jobanzeigeModelFirestoreControllerProvider);
    List<JobanzeigeModel> jobanzeigenListUser =
        JobanzeigeProvider().getAnzeigeByUserID(userID, jobanzeigeModelList!);

    return Scaffold(
      appBar: appBar(context: context, ref: ref, home: false),
      bottomNavigationBar: navigationBar(index: 2, context: context, ref: ref),
      resizeToAvoidBottomInset: false,
      body: Container(
        child: authControllerState == null
            ? Text("Nothing to See")
            : Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                  Container(
                    width: MediaQuery.of(context).size.width * 20,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildPopupDialog(
                                    context, userID, userLoggedIn),
                          );
                        },
                      ),
                    ),
                  ),

                  ///File Picker https://camposha.info/flutter/flutter-filepicker/#gsc.tab=0

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
                                    primary: Color(0xFFA7BB7B),
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
                                context: context,
                                hof: hofListeFilteredByUserID[index],
                              );
                              //return Text("hi");
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
                    Expanded(flex: 1, child: Text("")),
                  ]),

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
                                      print(
                                          " jobanzeigenListUser[index],: ${jobanzeigenListUser[index].titel} stundenLohn: ${jobanzeigenListUser[index].stundenLohn}");
                                      return jobAnzeigeCard(
                                        context,
                                        jobanzeigenListUser[index],
                                        true,
                                        ref,
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
