import 'dart:typed_data';

import 'package:age_calculator/age_calculator.dart';
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
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../models/user_model.dart';
import '../../../provider/general_providers.dart';
import '../../../provider/user_provider.dart';
import '../../../widgets/layout_widgets.dart';
import '../angebot/4_a_job_angebot_landwirt.dart';
import 'package:table_calendar/table_calendar.dart';

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
  String erfahrungenText = "";
  DateTimeRange? selectedDateRange;

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
        print("doc: $doc");
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
        print("docselected: $doc");
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

  TextEditingController erfahrungsFieldController = TextEditingController();

  ///AlertDialog um Erfahrungen zu bearbeiten
  Future<void> openErfahrungenDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Edit Erfahrungen"),
            content: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: erfahrungsFieldController,
              decoration: InputDecoration(
                  hintText: "Beschreibe deine Erfahrungen als Helfer"),
              onChanged: (value) {
                setState(() {
                  erfahrungenText = value;
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
                  print("erfahrungenText: ${erfahrungenText}");
                  setState(() {
                    print("qualifikationIDList: $erfahrungenText");
                    ref
                        .watch(userModelFirestoreControllerProvider.notifier)
                        .updateErfahrungen(_loggedInUser, erfahrungenText);

                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
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
          print("selectedQualifikasationLisast: $selectedQualifikationList");
          print(
              "---------------------------------------------------------------------------------------------------");
          List<String> qualifikationIDList = [];
          list.forEach((qualifikation) {
            if (qualifikationIDList.contains(qualifikation.qualifikationID) ==
                false) {
              qualifikationIDList.add(qualifikation.qualifikationID!);
            }
          });
          print("qualifikationIDList: $qualifikationIDList");
          ref
              .watch(userModelFirestoreControllerProvider.notifier)
              .updateQualifikationen(userLoggedIn, qualifikationIDList);
        });

        Navigator.pop(context);
        setState(() {
          selectedQualifikationList = [];
        });
      },
    );
  }

  ///PopUp Einstellungen
  Widget _buildEinstellungenAlertDialog(
      BuildContext context, String userID, UserModel userLoggedIn) {
    return new AlertDialog(
      insetPadding: EdgeInsets.all(100),
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
              child: Column(
                children: [
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
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.green),
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
                ],
              ),
            ),
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
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
                            onPressed: () {},
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

  ///Date Range Picker
  void _showDateRangePicker(
      UserModel userLoggedIn, DateTime startDate, DateTime endDate) async {
    print("userLoggedIn.startDate: ${userLoggedIn.startDate}");
    final DateTimeRange? result = await showDateRangePicker(
      //  initialEntryMode: DatePickerEntryMode.calendar,
      context: context,
      initialDateRange: userLoggedIn.startDate == DateTime(1700)
          ? DateTimeRange(
              start: DateTime.now(),
              end: DateTime.now(),
            )
          : DateTimeRange(
              start: userLoggedIn.startDate!, end: userLoggedIn.endDate!),
      firstDate: DateTime(2022, 1, 1),
      lastDate: DateTime(2030, 12, 31),
      currentDate: DateTime.now(),
      saveText: 'Done',
    );

    if (result != null) {
      // Rebuild the UI
      print("result DateRage.start: ${result.start.toString()}");
      setState(() {
        selectedDateRange = result;
        ref
            .watch(userModelFirestoreControllerProvider.notifier)
            .updateVerfuegbarerZeitraum(userLoggedIn, result.start, result.end);

        print("selectedDateRange: $selectedDateRange");
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(microseconds: 10), () async {
      ///Alle User
      var userList =
          ref.read(userModelFirestoreControllerProvider.notifier).state;

      ///Filter Alle User nach LoggedIn User
      String? userID = ref.watch(authControllerProvider.notifier).state!.uid;
      UserModel? userLoggedIn =
          UserProvider().getUserNameByUserID(userID, userList!).first;

      fireQualifikationList = await getAllQualifikationen();

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

    String? userID = ref.read(authControllerProvider.notifier).state!.uid;

    /// ALle User
    final userList = ref.watch(userModelFirestoreControllerProvider);
    print("userID: $userID");

    ///Filter alle User
    UserModel userLoggedIn =
        UserProvider().getUserNameByUserID(userID, userList!).first;

    ///Todo when reloading and press ok without adding something new to Erfahrungen --> Inhalt wird gelöscht in der DB
    setState(() {
      _loggedInUser = userLoggedIn;
    });

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
                                _buildEinstellungenAlertDialog(
                                    context, userID, userLoggedIn),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: <Widget>[
                              SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.015),
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
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent?
                                                        loadingProgress) {
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
                                                    backgroundColor:
                                                        Colors.white,
                                                    direction: Axis.vertical,
                                                    center: Text(
                                                      "${progress.toInt()}%",
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color: Colors
                                                                  .black87,
                                                              fontSize: 25.0),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.015),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Column(
                                  children: [
                                    ///Das bin ich
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

                                    ///Name & Alter des Users
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
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10)),
                                              border: Border.all(
                                                  color: Colors.grey),
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
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.04),

                                    ///Qualifikationen
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
                                              List<dynamic>
                                                  userQualifikationIDList = [];
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
                                                  if (qualifikation
                                                          .qualifikationID ==
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
                                              print("hi");
                                              print(
                                                  "selectedQualifikationList: $selectedQualifikationList");
                                              openFilterDialog(userLoggedIn);
                                            },
                                            child: Text(
                                              "Bearbeiten",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Color(0xFFA7BB7B)),
                                            ),
                                            // color: Colors.blue,
                                          ),
                                        ],
                                      ),
                                    ),

                                    ///Future Builder Qualifikationen Abfrage

                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: SingleChildScrollView(
                                          child:
                                              FutureBuilder<
                                                      List<QualifikationModel>>(
                                                  future:
                                                      getSelectedQualifikation(
                                                          _loggedInUser),
                                                  builder: (context, snapshot) {
                                                    print("future Builder");
                                                    if (snapshot.hasData) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        );
                                                      } else {
                                                        List<QualifikationModel>?
                                                            data =
                                                            snapshot.data;

                                                        print(
                                                            "snapshot: ${data!.first.qualifikationName}");

                                                        return Column(
                                                            children: [
                                                              data.isEmpty
                                                                  ? Text(
                                                                      "Noch keine Qualifikationen ausgewählt")
                                                                  : GridView.count(
                                                                      shrinkWrap: true,
                                                                      crossAxisCount: 4,
                                                                      childAspectRatio: 4 / 2,
                                                                      children: data.map(
                                                                        (qualifikation) {
                                                                          //      print("hello");
                                                                          return Container(
                                                                            margin:
                                                                                const EdgeInsets.symmetric(horizontal: 17, vertical: 4),
                                                                            padding:
                                                                                const EdgeInsets.symmetric(vertical: 4, horizontal: 3),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                                                                              border: Border.all(color: Colors.grey),
                                                                            ),
                                                                            child:
                                                                                Text(
                                                                              "${qualifikation.qualifikationName}",
                                                                              style: TextStyle(
                                                                                fontStyle: FontStyle.normal,
                                                                                fontFamily: 'Open Sans',
                                                                                fontSize: 20.0,
                                                                                fontWeight: FontWeight.normal,
                                                                                color: Color(0xFF000000),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      ).toList()),
                                                            ]);
                                                      }
                                                    } else {
                                                      Text(
                                                        "Noch keine Qualifikationen ausgewählt!!",
                                                      );
                                                    }

                                                    if (snapshot.hasError) {
                                                      return Text(
                                                          'Error while Loading Qualifikationen from Firestore');
                                                    }
                                                    return CircularProgressIndicator();
                                                  }),
                                        ),
                                      ),
                                    ),

                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.04),

                                    ///Erfahrungen
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
                                            onPressed: () {
                                              print("Edit Erfahrungen");
                                              print(
                                                  "DateTime(0): ${DateTime(0)}");

                                              setState(() {
                                                // erfahrungsFieldController
                                                //erfahrungenText = value;
                                                erfahrungsFieldController.text =
                                                    _loggedInUser.erfahrungen!;
                                              });
                                              openErfahrungenDialog(context);
                                            },
                                            child: Text(
                                              "Bearbeiten",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Color(0xFFA7BB7B)),
                                            ),
                                            // color: Colors.blue,
                                          ),
                                        ],
                                      ),
                                    ),

                                    ///Erfahrungen Abfrage
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                          margin: const EdgeInsets.all(5.0),
                                          padding: const EdgeInsets.all(3.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10)),
                                          ),
                                          child: _loggedInUser
                                                  .erfahrungen!.isNotEmpty
                                              ? Text(
                                                  "${_loggedInUser.erfahrungen}",
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontFamily: 'Open Sans',
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Color(0xFF000000)))
                                              : Text(
                                                  "Keine Erfahrungen bis jetzt eingetragen",
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontFamily: 'Open Sans',
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color:
                                                          Color(0xFF000000)))),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04,
                                    ),

                                    ///Verfügbarer Zeitraum
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
                                            onPressed: () {
                                              _showDateRangePicker(
                                                userLoggedIn,
                                                userLoggedIn.startDate!,
                                                userLoggedIn.endDate!,
                                              );
                                            },
                                            child: Text(
                                              "Bearbeiten",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Color(0xFFA7BB7B)),
                                            ),
                                            // color: Colors.blue,
                                          ),
                                        ],
                                      ),
                                    ),

                                    ///StartDate & endDate Abfrage
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                              margin:
                                                  const EdgeInsets.all(15.0),
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10),
                                                    bottomRight:
                                                        Radius.circular(10)),
                                                border: Border.all(
                                                    color: Colors.grey),
                                              ),

                                              ///startDate
                                              child: Text(
                                                  userLoggedIn.startDate !=
                                                          DateTime(1700)
                                                      ? "${userLoggedIn.startDate!.day}.${userLoggedIn.startDate!.month}.${userLoggedIn.startDate!.year}"
                                                      : "No Startdate selected",
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontFamily: 'Open Sans',
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color:
                                                          Color(0xFF000000)))),
                                          Text("-"),
                                          Container(
                                            margin: const EdgeInsets.all(15.0),
                                            padding: const EdgeInsets.all(3.0),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10)),
                                              border: Border.all(
                                                  color: Colors.grey),
                                            ),

                                            ///endDate
                                            child: Text(
                                                userLoggedIn.endDate !=
                                                        DateTime(1700)
                                                    ? "${userLoggedIn.endDate!.day}.${userLoggedIn.endDate!.month}.${userLoggedIn.endDate!.year}"
                                                    : "No Enddate selected",
                                                style: TextStyle(
                                                    fontStyle: FontStyle.normal,
                                                    fontFamily: 'Open Sans',
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Color(0xFF000000))),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        width: 300,
                                        child: TableCalendar(
                                          rangeStartDay: DateTime.utc(
                                              userLoggedIn.startDate!.year,
                                              userLoggedIn.startDate!.month,
                                              userLoggedIn.startDate!.day),
                                          rangeEndDay: DateTime.utc(
                                              userLoggedIn.endDate!.year,
                                              userLoggedIn.endDate!.month,
                                              userLoggedIn.endDate!.day),
                                          firstDay: DateTime.utc(2010, 10, 16),
                                          lastDay: DateTime.utc(2030, 3, 14),
                                          focusedDay: DateTime.now(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.015),
                            ],
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
