import 'dart:io';
import 'dart:typed_data';
import 'package:agrargo/repositories/firestore_riverpod_repository.dart';
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
import '../../../controllers/user_controller.dart';
import '../../../main.dart';

class LandwirtProfil extends ConsumerStatefulWidget {
  const LandwirtProfil({Key? key}) : super(key: key);
  static const routename = '/landwirt-profil';

  @override
  _LandwirtProfilState createState() => _LandwirtProfilState();
}

class _LandwirtProfilState extends ConsumerState<LandwirtProfil> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ///User Collection
  final usersCollection = FirebaseFirestore.instance.collection('users');
  final jobAnzeigenCollection =
      FirebaseFirestore.instance.collection('jobAnzeigen');

  ///Hof Collection
  final hofCollection =
      FirebaseFirestore.instance.collection('höfe').snapshots();
  Image profilImage = Image.network(
    'https://db3pap003files.storage.live.com/y4mXTCAYwPu3CNX67zXxTldRszq9NrkI_VDjkf3ckAkuZgv9BBmPgwGfQOeR9KZ8-jKnj-cuD8EKl7H4vIGN-Lp8JyrxVhtpB_J9KfhV_TlbtSmO2zyHmJuf4Yl1zZmpuORX8KLSoQ5PFQXOcpVhCGpJOA_90u-D9P7p3O2NyLDlziMF_yZIcekH05jop5Eb56f?width=250&height=68&cropmode=none',
  );
  File? _photo;
  final ImagePicker _picker = ImagePicker();
  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        //uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

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
    // checkAuthentification();
    super.initState();
    Future.delayed(Duration(microseconds: 10), () async {
      String? userID = ref.read(authControllerProvider.notifier).state!.uid;

      final url = await FirebaseStorage.instance
          .ref()
          .child('$userID.jpg')
          .getDownloadURL();
      setState(
        () {
          profilImage = Image.network(url);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    ///Authentication State check: Logged In or Logged Out
    User? authControllerState = ref.watch(authControllerProvider);

    ///Alle gespeicherten User in der Firestore Collection
    final userList = ref.watch(userFireStoreControllerProvider);

    ///LoggedIn User
    String? userID = ref.read(authControllerProvider.notifier).state!.uid;
    final userLoggedIn =
        UserProvider().getUserNameByUserID(userID, userList!).first;

    print(
        "userLoggedIn: ${userLoggedIn.name} profilImageURL: ${userLoggedIn.profilImageURL}");

    /// UserProvider
    // var userModelProvider = p.Provider.of<UserProvider>(context);
    // print("userModelProvider: ${userModelProvider.name}");
    //var userList = p.Provider.of<List<UserModel>>(context);

    /// User Liste
    //  final userLoggedIn = UserProvider()
    //    .getUserNameByUserID(userID, p.Provider.of<List<UserModel>>(context));
    //print(
    //  "userLoggedIn: ${userLoggedIn.first.userID} profilImageURL: ${userLoggedIn.first.profilImageURL}");

    /// Hof Liste
    //   final hofListeFilteredByUserID = HofProvider()
    //     .getHofByUserID(userID, p.Provider.of<List<HofModel>>(context));
    /*if (hofListeFilteredByUserID.first.hofImageURL != null) {
      print(
          "hofListeFilteredByUserID.first.hofImageURL: ${hofListeFilteredByUserID.first.hofImageURL}");
    }*/

    ///Jobanzeigen Filtered by UserID
//    List<JobanzeigeModel> jobanzeigenListUser = JobanzeigeProvider()
    //      .getAnzeigeByUserID(
    //        userID, p.Provider.of<List<JobanzeigeModel>>(context));

    /// ---------------- Image ------------------------
/*
          final url = await FirebaseStorage.instance
              .ref()
              .child('$userID.jpg')
              .getDownloadURL();
          setState(
            () {
              profilImage = Image.network(url);
            },
          );
 */
    return Scaffold(
      appBar: appBar(context: context, ref: ref, home: false),
      bottomNavigationBar:
          navigationBar(index: 2, context: context, ref: ref, home: false),
      resizeToAvoidBottomInset: false,
      body: Container(
        child: authControllerState == null
            ? Text("Nothing to See")
            : Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.17,
                    color: Color(0xFF1f623c),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            color: Colors.yellow,
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(
                            color: Colors.blue,
                            child: Center(
                                child: userLoggedIn == null
                                    ? Text("No User found")
                                    : Text("${userLoggedIn.name}`s Profil",
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontFamily: 'Open Sans',
                                            fontSize: 50.0,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFffffff)))),
                          ),
                        ),
                        Row(
                          children: [
                            ///Todo implement function with Error handling for Error:   Error: [firebase_storage/object-not-found] No object exists at the desired reference. ||ALso, um zu prüfen, ob die URL eine valide URL ist
                            userLoggedIn.profilImageURL == null
                                ? Image.network(
                                    'https://db3pap003files.storage.live.com/y4mXTCAYwPu3CNX67zXxTldRszq9NrkI_VDjkf3ckAkuZgv9BBmPgwGfQOeR9KZ8-jKnj-cuD8EKl7H4vIGN-Lp8JyrxVhtpB_J9KfhV_TlbtSmO2zyHmJuf4Yl1zZmpuORX8KLSoQ5PFQXOcpVhCGpJOA_90u-D9P7p3O2NyLDlziMF_yZIcekH05jop5Eb56f?width=250&height=68&cropmode=none',
                                  )
                                : Image.network(userLoggedIn.profilImageURL!),
                            ElevatedButton(
                              child: Text("Upload Picture"),
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF9FB98B),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 20),
                                  textStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () async {
                                var picked =
                                    await FilePicker.platform.pickFiles();
                                if (picked != null) {
                                  String fileExtension =
                                      getFileExtension(picked.files.first.name);

                                  Uint8List fileBytes =
                                      picked.files.first.bytes!;
                                  FirebaseStorage storage =
                                      FirebaseStorage.instance;
                                  Reference reference =
                                      storage.ref("${userID}$fileExtension");
                                  await FirebaseStorage.instance
                                      .ref("$userID$fileExtension")
                                      .putData(fileBytes);

                                  String urlString =
                                      await reference.getDownloadURL();
                                  print("getDownloadURL(): $urlString");
                                  ref
                                      .watch(userFireStoreControllerProvider
                                          .notifier)
                                      .updateURL(userLoggedIn, urlString);
                                  //  'https://firebasestorage.googleapis.com/v0/b/agrargo-2571b.appspot.com/o/03a76017-1f2d-4abe-bef9-66212ceafd66.jpg?alt=media&token=f441ebdb-9bf0-4c90-b1db-436db3521e42',
                                  //"Hi",

                                }
                              },
                            ),
/*
                              ///Upload Button
                              ElevatedButton(
                                child: Text('UPLOAD PROFIL IMAGE'),
                                onPressed: () async {
                                  var picked =
                                      await FilePicker.platform.pickFiles();

                                  if (picked != null) {

                                    String fileExtension = getFileExtension(
                                        picked.files.first.name);

                                    Uint8List fileBytes =
                                        picked.files.first.bytes!;
                                    FirebaseStorage storage =
                                        FirebaseStorage.instance;

                                    Reference ref =
                                        storage.ref("${userID}$fileExtension");
                                    await FirebaseStorage.instance
                                        .ref("$userID$fileExtension")
                                        .putData(fileBytes);
                                    await ref.putData(fileBytes);
                                    String urlString =
                                        await ref.getDownloadURL();
                                    print("getDownloadURL(): $urlString");

                                    ///Save URL String to fireStore
                                    // String urlString =
                                    //       " https://firebasestorage.googleapis.com/v0/b/agrargo-2571b.appspot.com/o/03a76017-1f2d-4abe-bef9-66212ceafd66.jpg?alt=media&token=f441ebdb-9bf0-4c90-b1db-436db3521e42";
                                    print("URL String: $urlString");
                                    userModelProvider
                                        .changeHofImageURL(urlString);
                                    userModelProvider.userID = userID;
                                    userModelProvider.profilImageURL =
                                        urlString;
                                    userModelProvider.landwirt =
                                        userLoggedIn.first.landwirt;
                                    userModelProvider.email =
                                        userLoggedIn.first.email;

                                    userModelProvider.saveData();
                                    /*
                                    final url = await FirebaseStorage.instance
                                        .ref()
                                        .child('$userID.jpg')
                                        .getDownloadURL();
                                    setState(() {
                                      profilImage = Image.network(url);
                                    });*/
                                  }
                                },
                              ),
                              */
                          ],
                        ),

                        //     profilPictureExpanded(
                        //       'V8JgI2LTiJXYCWkhSvEg3lBXugv1.jpg'),
                      ],
                    ),
                  ),
/*
                  SizedBox(height: 30),

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
                                    primary: Color(0xFF9FB98B),
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
                                      return jobAnzeigeCard(
                                        context,
                                        jobanzeigenListUser[index],
                                        true,
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
*/
                ],
              ),
      ),
    );
  }
}
