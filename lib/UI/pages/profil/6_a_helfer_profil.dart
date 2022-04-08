import 'dart:typed_data';

import 'package:age_calculator/age_calculator.dart';
import 'package:agrargo/UI/pages/add/edit_helfer_profil.dart';
import 'package:agrargo/controllers/auth_controller.dart';
import 'package:agrargo/controllers/qualifikation_controller.dart';
import 'package:agrargo/controllers/user_controller.dart';
import 'package:agrargo/models/qualifikation_model.dart';
import 'package:agrargo/repositories/firestore_qualifikation_model_riverpod_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:filter_list/filter_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

import '../../../models/user_model.dart';
import '../../../provider/general_providers.dart';
import '../../../provider/user_provider.dart';
import '../../../widgets/layout_widgets.dart';
import '../angebot/4_a_job_angebot_landwirt.dart';
import 'package:agrargo/enums/qualifikation_enums.dart';

class HelferProfil extends ConsumerStatefulWidget {
  const HelferProfil({Key? key}) : super(key: key);
  static const routename = '/helfer-profil';

  @override
  _HelferProfilState createState() => _HelferProfilState();
}

class _HelferProfilState extends ConsumerState<HelferProfil> {
  double progress = 0.0;

  ///Alle Qualifikationen Firebase
  List<QualifikationModel>? fireQualifikationList = [];

  ///Ausgewählte Qualifikationen Firebase
  List<QualifikationModel>? fireSelectedQualifikationList = [];

  ///Ausgewählte Qualifikationen setState(){}
  List<QualifikationModel>? selectedQualifikationList = [];

  UserModel _loggedInUser = UserModel();

  ///Get all Qualifikationen
  Future<List<QualifikationModel>> getAllQualifikationen() async {
    ///Alle Qualifikationen
    List<QualifikationModel> alleQualifikationenList = [];

    ///1. Hole alle Qualifikationen aus Firestore
    await FirebaseFirestore.instance
        .collection('qualifikationen')
        .get()
        .then((value) {
      value.docs.forEach((doc) {
        QualifikationModel quali = QualifikationModel(
            qualifikationID: doc.id, qualifikationName: doc['name']);
        alleQualifikationenList.add(quali);
      });
    });
    // print("all qualifikationModelList: $alleQualifikationenList");
    return alleQualifikationenList;
  }

  ///getSelectedQualifikation

  Future<List<QualifikationModel>> getSelectedQualifikation(
      UserModel userModel) async {
    ///Alle Qualifikationen
    List<QualifikationModel> alleQualifikationenList = [];

    ///Selected Qualifikationen
    List<QualifikationModel> selectedQualifikationenList = [];

    ///1. Hole alle Qualifikationen aus Firestore
    await FirebaseFirestore.instance
        .collection('qualifikationen')
        .get()
        .then((value) {
      value.docs.forEach((doc) {
        QualifikationModel quali = QualifikationModel(
            qualifikationID: doc.id, qualifikationName: doc['name']);
        alleQualifikationenList.add(quali);
      });
    });
    //  print("all qualifikationModelList: $alleQualifikationenList");

    ///2. Hole vom User selected qualifikationsIDs aus Firestore
    List<dynamic> userQualifikationIDList = [];
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.userID)
        .get()
        .then((value) {
      userQualifikationIDList = (value['qualifikationList']);
    });
    //  print("qualifikationIDSelectedList: ${userQualifikationIDList}");

    ///3. Filtere Liste aller Qualifikationen nach IDs
    if (userQualifikationIDList.isNotEmpty) {
      userQualifikationIDList.forEach((qualifikationID) {
        alleQualifikationenList.forEach((qualifikation) {
          if (qualifikationID == qualifikation.qualifikationID &&
              selectedQualifikationenList.contains(qualifikation) == false) {
            //  print("------------ add Qualifikation --------------- ");
            // print(" -> qualifikation:${qualifikation.qualifikationName}");
            selectedQualifikationenList.add(qualifikation);
          }
        });
      });
    }

    ///4. Return Selected Qualifikation aus Firestore
    //  print(
    //    "return: -> selectedQualifikationenList: ${selectedQualifikationenList}");
    return selectedQualifikationenList;
  }

  ///Select Qualifikationen
  void openFilterDialog(UserModel userLoggedIn) async {
    await FilterListDialog.display<QualifikationModel>(
      context,
      hideSelectedTextCount: true,
      themeData: FilterListThemeData(context),
      headlineText: 'Wähle Qualifikationen aus',
      height: 500,
      listData: fireQualifikationList!,
      selectedListData: selectedQualifikationList,
      choiceChipLabel: (item) {
        return item!.qualifikationName;
      },
      validateSelectedItem: (list, val) {
        return list!.contains(val);
      },
      controlButtons: [ContolButtonType.All, ContolButtonType.Reset],
      onItemSearch: (qualifikation, query) {
        /// When search query change in search bar then this method will be called
        ///
        /// Check if items contains query
        return qualifikation.qualifikationName!
            .toLowerCase()
            .contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        setState(() {
          selectedQualifikationList = List.from(list!);
          print(
              "---------------------------------------------------------------------------------------------------");
          print("selectedQualifikationList: $selectedQualifikationList");
          print(
              "---------------------------------------------------------------------------------------------------");
          List<String> qualifikationIDList = [];
          list.forEach((qualifikation) {
            if (qualifikationIDList.contains(qualifikation.qualifikationID) ==
                false) {
              qualifikationIDList.add(qualifikation.qualifikationID!);
            }
          });

          ref
              .watch(userModelFirestoreControllerProvider.notifier)
              .updateQualifikationen(userLoggedIn, qualifikationIDList);
        });

        Navigator.pop(context);
      },
    );
  }

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
              child: ElevatedButton(
                child: Text("Bild hochladen"),
                style: ElevatedButton.styleFrom(
                    primary: Color(0xFF9FB98B),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 25, 20, 4),
                      child: Container(
                        height: 60,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Name',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            border:
                                Border.all(width: 1.0, color: Colors.white70)),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.015),
                        Expanded(
                          flex: 1,
                          child: Text(""),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text(
                            "Name",
                            style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Open Sans',
                              fontSize: 23.0,
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
                            onPressed: () {},
                            child: Text(
                              "Bearbeiten",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xFF9FB98B)),
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
                          flex: 5,
                          child: Text(
                            "E-Mail",
                            style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Open Sans',
                              fontSize: 23.0,
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
                          flex: 5,
                          child: Text(
                            "Geburtsdatum",
                            style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Open Sans',
                              fontSize: 23.0,
                              color: Color(0xFF1f623c),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 10,
                          child: Text(
                            '${userLoggedIn.birthDate}',
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
                            onPressed: () {},
                            child: Text(
                              "Bearbeiten",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xFF9FB98B)),
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
                          flex: 5,
                          child: Text(
                            "Rechnungsadresse",
                            style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Open Sans',
                              fontSize: 23.0,
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
                            onPressed: () {},
                            child: Text(
                              "Bearbeiten",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xFF9FB98B)),
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(microseconds: 10), () async {
      //var qualiList = ref.read(qualifikationModelFirestoreControllerProvider);
      //print("qualifikationsListe: ${qualiList!}");
      ///Alle gespeicherten User in der Firestore Collection
      var userList =
          ref.read(userModelFirestoreControllerProvider.notifier).state;

      ///LoggedIn User
      String? userID = ref.watch(authControllerProvider.notifier).state!.uid;

      UserModel? userLoggedIn =
          UserProvider().getUserNameByUserID(userID, userList!).first;
      print("userLoggedIn name: ${userLoggedIn.name}");

      var listSelected = await getSelectedQualifikation(userLoggedIn);
      print("listSelected: $listSelected");
      fireQualifikationList = await getAllQualifikationen();
      print("fireQualifikationList: $fireQualifikationList");
      // print("fireQualifikationList: $fireQualifikationList");

      // fireSelectedQualifikationList = listSelected;
      /*
          fireSelectedQualifikationList!.forEach((selectedQualifikation) {
            fireQualifikationList!.forEach((qualifikation) {
              if (selectedQualifikation.qualifikationID ==
                  qualifikation.qualifikationID)
                selectedQualifikationList!.add(qualifikation);
            });
          });
          */

      setState(() {
        _loggedInUser = userLoggedIn;
      });
      if (userLoggedIn.qualifikationList != null) {
        userLoggedIn.qualifikationList!.forEach((qualifikationID) {
          fireQualifikationList!.forEach((qualifikation) {
            if (qualifikationID == qualifikation.qualifikationID &&
                fireSelectedQualifikationList!.contains(qualifikation) ==
                    false) {
              fireSelectedQualifikationList!.add(qualifikation);
            }
          });
        });
      }

      FirebaseFirestore.instance
          .collection('qualifikationen')
          .get()
          .then((value) {
        value.docs.forEach((doc) {
          QualifikationModel quali = QualifikationModel(
              qualifikationID: doc.id, qualifikationName: doc['name']);
          fireQualifikationList!.add(quali);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    User? authControllerState = ref.watch(authControllerProvider);
    authControllerState?.reload();
    User? authControllerStateRead = ref.read(authControllerProvider);

    //hab aus dem ? ein ! gemacht
    String? userID = ref.read(authControllerProvider.notifier).state!.uid;

    /// ALle User
    final userList = ref.watch(userModelFirestoreControllerProvider);
    // print("userList: $userList");
    print("userID: $userID");
    UserModel userLoggedIn =
        UserProvider().getUserNameByUserID(userID, userList!).first;
    print("userLoggedIn: $userLoggedIn");
    // getSelectedQualifikation(userLoggedIn);

    setState(() {
      _loggedInUser = userLoggedIn;
    });
/*
    Future.delayed(Duration(microseconds: 10), () async {
      var listALl = await getAllQualifikationen();
      var listSelected = await getSelectedQualifikation(userLoggedIn);
      setState(() {
        fireQualifikationList = listALl;
        fireSelectedQualifikationList = listSelected;

        fireSelectedQualifikationList!.forEach((selectedQualifikation) {
          fireQualifikationList!.forEach((qualifikation) {
            if (selectedQualifikation.qualifikationID ==
                qualifikation.qualifikationID)
              selectedQualifikationList!.add(qualifikation);
          });
        });
      });
      print(
          "userLoggedIn.qualifikationList: ${userLoggedIn.qualifikationList}");
    });
    */

    /*
    if (userLoggedIn.qualifikationList != null) {
      userLoggedIn.qualifikationList!.forEach((qualifikationID) {
        fireQualifikationList!.forEach((qualifikation) {
          if (qualifikationID == qualifikation.qualifikationID &&
              fireSelectedQualifikationList!.contains(qualifikation) == false) {
            print("hi");
            setState(() {
              fireSelectedQualifikationList!.add(qualifikation);
            });
          }
        });
      });
    }
*/
    print("selectedQualifikationList: ${fireSelectedQualifikationList}");
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                  Expanded(
                      child: SingleChildScrollView(
                    child: Column(children: [
                      Row(
                        children: <Widget>[
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.015),
                          Expanded(
                            flex: 4,
                            child: Column(
                              children: [
                                userLoggedIn.profilImageURL == null
                                    ? Image.network(
                                        'https://db3pap003files.storage.live.com/y4mXTCAYwPu3CNX67zXxTldRszq9NrkI_VDjkf3ckAkuZgv9BBmPgwGfQOeR9KZ8-jKnj-cuD8EKl7H4vIGN-Lp8JyrxVhtpB_J9KfhV_TlbtSmO2zyHmJuf4Yl1zZmpuORX8KLSoQ5PFQXOcpVhCGpJOA_90u-D9P7p3O2NyLDlziMF_yZIcekH05jop5Eb56f?width=250&height=68&cropmode=none',
                                      )
                                    : Image.network(
                                        userLoggedIn.profilImageURL!,
                                        width: 300,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                            // child: CircularProgressIndicator(),
                                            child: Container(
                                              height: 100.0,
                                              width: 100.0,
                                              child:
                                                  LiquidCircularProgressIndicator(
                                                value: progress / 100,
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                        Colors.green),
                                                backgroundColor: Colors.white,
                                                direction: Axis.vertical,
                                                center: Text(
                                                  "${progress.toInt()}%",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.black87,
                                                      fontSize: 25.0),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.015),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Column(children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  child: Text(
                                    "Das bin ich",
                                    style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontFamily: 'Open Sans',
                                      fontSize: 23.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1f623c),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.all(15.0),
                                      padding: const EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10)),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Text(
                                        '${userLoggedIn.name}, ${AgeCalculator.age(userLoggedIn.birthDate!).years} Jahre',
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontFamily: 'Open Sans',
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.normal,
                                          color: Color(0xFF000000),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.04),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Container(
                                      child: Text(
                                        "Qualifikationen",
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontFamily: 'Open Sans',
                                          fontSize: 23.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1f623c),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 40),
                                    TextButton(
                                      onPressed: () async {
                                        /*
                                        List<QualifikationModel> selectedList =
                                            await getSelectedQualifikation(
                                                _loggedInUser);
                                        List<QualifikationModel> allList =
                                            await getAllQualifikationen();
                                        */
                                        List<dynamic> userQualifikationIDList =
                                            [];
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(userID)
                                            .get()
                                            .then((value) {
                                          userQualifikationIDList =
                                              value['qualifikationList'];
                                        });
                                        var allList =
                                            await getAllQualifikationen();
                                        setState(() {
                                          fireQualifikationList = allList;
                                        });

                                        userQualifikationIDList
                                            .forEach((selectedID) {
                                          fireQualifikationList!
                                              .forEach((qualifikation) {
                                            if (qualifikation.qualifikationID ==
                                                selectedID) {
                                              if (selectedQualifikationList!
                                                      .contains(
                                                          qualifikation) ==
                                                  false) {
                                                setState(() {
                                                  selectedQualifikationList!
                                                      .add(qualifikation);
                                                });
                                              }
                                            }
                                          });
                                        });
                                        print(
                                            "selectedQualifikationList: $selectedQualifikationList");
                                        openFilterDialog(userLoggedIn);
                                      },
                                      child: Text(
                                        "Hinzufügen",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Color(0xFF9FB98B)),
                                      ),
                                      // color: Colors.blue,
                                    ),
                                  ],
                                ),
                              ),
                              /*        selectedQualifikationList!.isEmpty
                                  ? Text("No Qualifikation selected yet")
                                  : */

                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  height: 200,
                                  child: SingleChildScrollView(
                                    child:
                                        FutureBuilder<List<QualifikationModel>>(
                                            future: getSelectedQualifikation(
                                                _loggedInUser),
                                            builder: (context, snapshot) {
                                              print("future Builder");
                                              if (snapshot.hasData) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                } else {
                                                  List<QualifikationModel>?
                                                      data = snapshot.data;

                                                  print(
                                                      "snapshot: ${data!.first.qualifikationName}");

                                                  return Column(
                                                    children: [
                                                      data.isEmpty
                                                          ? Text(
                                                              "No qualifikationen selected yet")
                                                          : GridView.count(
                                                              shrinkWrap: true,
                                                              crossAxisCount: 7,
                                                              childAspectRatio:
                                                                  3,
                                                              children:
                                                                  data.map(
                                                                (qualifikation) {
                                                                  //      print("hello");
                                                                  return Container(
                                                                    margin: EdgeInsets
                                                                        .all(
                                                                            10),
                                                                    child: Text(
                                                                      "${qualifikation.qualifikationName}",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            20,
                                                                      ),
                                                                    ),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            border:
                                                                                Border.all(color: Colors.black)),
                                                                  );
                                                                },
                                                              ).toList()),
                                                    ],
                                                  );
                                                }
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    'Error while Loading Qualifikationen from Firestore');
                                              }
                                              return CircularProgressIndicator();
                                            }),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.04),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Container(
                                      child: Text(
                                        "Erfahrungen",
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontFamily: 'Open Sans',
                                          fontSize: 23.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1f623c),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 40),
                                    TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        "Bearbeiten",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Color(0xFF9FB98B)),
                                      ),
                                      // color: Colors.blue,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(5.0),
                                padding: const EdgeInsets.all(3.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                ),
                                child: Text(
                                    "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.",
                                    style: TextStyle(
                                        fontStyle: FontStyle.normal,
                                        fontFamily: 'Open Sans',
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.normal,
                                        color: Color(0xFF000000))),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.04),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Container(
                                      child: Text(
                                        "Verfügbarer Zeitraum",
                                        style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontFamily: 'Open Sans',
                                          fontSize: 23.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1f623c),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 40),
                                    TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        "Bearbeiten",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Color(0xFF9FB98B)),
                                      ),
                                      // color: Colors.blue,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.all(15.0),
                                      padding: const EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10)),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Text('14.05.2022',
                                          style: TextStyle(
                                              fontStyle: FontStyle.normal,
                                              fontFamily: 'Open Sans',
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.normal,
                                              color: Color(0xFF000000))),
                                    ),
                                    Text("-"),
                                    Container(
                                      margin: const EdgeInsets.all(15.0),
                                      padding: const EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10)),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Text('29.06.2022',
                                          style: TextStyle(
                                              fontStyle: FontStyle.normal,
                                              fontFamily: 'Open Sans',
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.normal,
                                              color: Color(0xFF000000))),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.05),
                            ]),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.015),
                        ],
                      ),
                    ]),
                  ))
                ],
              ),
      ),
    );
  }
}
