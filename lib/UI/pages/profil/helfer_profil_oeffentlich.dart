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
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
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
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../chat/5_chat.dart';
import '../chat/chat_leon.dart';

class HelferProfilOeffentlich extends ConsumerStatefulWidget {
  const HelferProfilOeffentlich({Key? key}) : super(key: key);
  static const routename = '/helfer-profil-oeffentlich';

  @override
  _HelferProfilOeffentlichState createState() =>
      _HelferProfilOeffentlichState();
}

class _HelferProfilOeffentlichState
    extends ConsumerState<HelferProfilOeffentlich> {
  double progress = 0.0;
  var routeData;
  String userID = "";
  List<types.User> typesUserList = [];

  void _handlePressed(types.User otherUser, BuildContext context) async {
    ChatPageLeon.room = await FirebaseChatCore.instance.createRoom(otherUser);
    final userList = ref.watch(userModelFirestoreControllerProvider);
    final userModel =
        UserProvider().getUserNameByUserID(otherUser.id, userList!).first;

    /// 'createdAt': FieldValue.serverTimestamp(),
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatPageLeon(
          friendName: "${userModel.name}",
          friendId: "${userModel.userID}",
          friendImage: "${userModel.profilImageURL}",
        ),
      ),
    );
  }

  ///Alle Qualifikationen Firebase
  List<QualifikationModel>? fireQualifikationList = [];

  ///Ausgewählte Qualifikationen Firebase
  List<QualifikationModel>? fireSelectedQualifikationList = [];

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(microseconds: 10), () async {
      var routeData2 =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      setState(() {
        routeData = routeData2;
        userID = routeData['userID'];
      });
      await FirebaseChatCore.instance.users().forEach((typeUsers) {
        typeUsers.forEach((typeUser) {
          print("typeUser.id ${typeUser.id}");
          if (typeUser.id == userID) {
            print("typeUser12: $typeUser");
            setState(() {
              typesUserList.add(typeUser);
            });
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("routeData: $routeData");
    print("userID: $userID");

    /// ALle User
    final userList = ref.watch(userModelFirestoreControllerProvider);
    print("userID: $userID");

    ///Filter alle User
    UserModel selectedHelferModel =
        UserProvider().getUserNameByUserID(userID, userList!).first;
    print("selectedHelferModel: ${selectedHelferModel.name}");

    return Scaffold(
      appBar: appBar(context: context, ref: ref, home: false),
      bottomNavigationBar:
          navigationBar(index: 0, context: context, ref: ref, home: false),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.015),
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          selectedHelferModel.profilImageURL == null
                              ? Image.network(
                                  'https://db3pap003files.storage.live.com/y4mXTCAYwPu3CNX67zXxTldRszq9NrkI_VDjkf3ckAkuZgv9BBmPgwGfQOeR9KZ8-jKnj-cuD8EKl7H4vIGN-Lp8JyrxVhtpB_J9KfhV_TlbtSmO2zyHmJuf4Yl1zZmpuORX8KLSoQ5PFQXOcpVhCGpJOA_90u-D9P7p3O2NyLDlziMF_yZIcekH05jop5Eb56f?width=250&height=68&cropmode=none',
                                )
                              : Image.network(
                                  selectedHelferModel.profilImageURL!,
                                  width: 300,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      // child: CircularProgressIndicator(),
                                      child: Container(
                                        height: 100.0,
                                        width: 100.0,
                                        child: LiquidCircularProgressIndicator(
                                          value: progress / 100,
                                          valueColor: AlwaysStoppedAnimation(
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
                              height:
                                  MediaQuery.of(context).size.height * 0.015),
                          Container(
                              margin: const EdgeInsets.all(15.0),
                              padding: const EdgeInsets.all(7.0),

                              ///Bewerben Button
                              child: ElevatedButton(
                                child: Text('Helfer anschreiben'),
                                onPressed: () {
                                  ///TODO Navigieren zu Person
                                  ///User Logged In

                                  _handlePressed(typesUserList.first, context);
                                  print(
                                      "typesUserList: ${typesUserList.first}");
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Color(0xFFA7BB7B),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 20),
                                    textStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              )),
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
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: Text(
                                    '${selectedHelferModel.name}, ${AgeCalculator.age(selectedHelferModel.birthDate!).years} Jahre',
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
                                  MediaQuery.of(context).size.height * 0.03),

                          ///Qualifikationen
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                ///Qualifikationen
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
                              ],
                            ),
                          ),

                          ///Future Builder Qualifikationen Abfrage
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: SingleChildScrollView(
                                child: FutureBuilder<List<QualifikationModel>>(
                                    future: getSelectedQualifikation(
                                        selectedHelferModel),
                                    builder: (context, snapshot) {
                                      print("future Builder");
                                      if (snapshot.hasData) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else {
                                          List<QualifikationModel>? data =
                                              snapshot.data;

                                          print(
                                              "snapshot: ${data!.first.qualifikationName}");

                                          return Column(
                                            children: [
                                              data.isEmpty
                                                  ? Text(
                                                      "No qualifikationen selected yet")
                                                  : GridView.count(
                                                      shrinkWrap: true,
                                                      crossAxisCount: 4,
                                                      childAspectRatio: 4 / 2,
                                                      children: data.map(
                                                        (qualifikation) {
                                                          //      print("hello");
                                                          return Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        17,
                                                                    vertical:
                                                                        4),
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical: 4,
                                                                    horizontal:
                                                                        3),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          10)),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                "${qualifikation.qualifikationName}",
                                                                style:
                                                                    TextStyle(
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontFamily:
                                                                      'Open Sans',
                                                                  fontSize:
                                                                      20.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color: Color(
                                                                      0xFF000000),
                                                                ),
                                                              ),
                                                            ),
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
                              height:
                                  MediaQuery.of(context).size.height * 0.03),

                          ///Erfahrungen
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
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
                          ),

                          ///Erfahrungen des Users
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
                                  ),
                                  child: Text(
                                    '${selectedHelferModel.erfahrungen}',
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
                                  MediaQuery.of(context).size.height * 0.03),

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
                              ],
                            ),
                          ),

                          ///StartDate & endDate Abfrage
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

                                    ///startDate
                                    child: Text(
                                        selectedHelferModel.startDate !=
                                                DateTime(1700)
                                            ? "${selectedHelferModel.startDate!.day}.${selectedHelferModel.startDate!.month}.${selectedHelferModel.startDate!.year}"
                                            : "No Startdate selected",
                                        style: TextStyle(
                                            fontStyle: FontStyle.normal,
                                            fontFamily: 'Open Sans',
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.normal,
                                            color: Color(0xFF000000)))),
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

                                  ///endDate
                                  child: Text(
                                      selectedHelferModel.endDate !=
                                              DateTime(1700)
                                          ? "${selectedHelferModel.endDate!.day}.${selectedHelferModel.endDate!.month}.${selectedHelferModel.endDate!.year}"
                                          : "No Enddate selected",
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
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 300,
                              child: TableCalendar(
                                rangeStartDay: DateTime.utc(
                                    selectedHelferModel.startDate!.year,
                                    selectedHelferModel.startDate!.month,
                                    selectedHelferModel.startDate!.day),
                                rangeEndDay: DateTime.utc(
                                    selectedHelferModel.endDate!.year,
                                    selectedHelferModel.endDate!.month,
                                    selectedHelferModel.endDate!.day),
                                firstDay: DateTime.utc(2010, 10, 16),
                                lastDay: DateTime.utc(2030, 3, 14),
                                focusedDay: DateTime.now(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
        ],
      ),
    );
  }
}
