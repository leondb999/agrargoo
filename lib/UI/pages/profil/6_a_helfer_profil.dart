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
  List<QualifikationModel>? selectedQualifikationList = [];
  List<QualifikationModel> qualifikationList = [];
//  List<QualifikationModel> qualiList = [];
  List<QualifikationModel>? qualifList = [];
  UserModel _loggedInUser = UserModel();

  ///Select Qualifikationen
  void openFilterDialog() async {
    await FilterListDialog.display<QualifikationModel>(
      context,
      hideSelectedTextCount: true,
      themeData: FilterListThemeData(context),
      headlineText: 'Wähle Qualifikationen aus',
      height: 500,
      listData: qualifikationList,
      selectedListData: selectedQualifikationList,
      choiceChipLabel: (item) => item!.qualifikationName,
      validateSelectedItem: (list, val) => list!.contains(val),
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
          print("selectedQualifikationList2: $selectedQualifikationList");
          List<String> qualifikationIDList = [];
          selectedQualifikationList!.forEach((qualifikation) {
            qualifikationIDList.add(qualifikation.qualifikationID!);
          });
          ref
              .watch(userModelFirestoreControllerProvider.notifier)
              .updateQualifikationen(_loggedInUser, qualifikationIDList);
        });
        Navigator.pop(context);
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(microseconds: 10), () async {
      //var qualiList = ref.read(qualifikationModelFirestoreControllerProvider);
      //print("qualifikationsListe: ${qualiList!}");
      FirebaseFirestore.instance
          .collection('qualifikationen')
          .get()
          .then((value) {
        value.docs.forEach((doc) {
          // print("doc: ${doc['name']}");
          QualifikationModel quali = QualifikationModel(
              qualifikationID: doc.id, qualifikationName: doc['name']);
          qualifikationList.add(quali);
          //   print("qualifikationList: ${quali.qualifikationName}");
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    User? authControllerState = ref.watch(authControllerProvider);
    // print("hi");
    //print("qualifikationList: $qualifikationList");
    /*  List<QualifikationModel> qualiList = ref
        .watch(fireQualifikationModelRepositoryProvider)
        .getQualifikationModelsList();
    print("qualiList: ${qualiList}"); */
    // print("qualiList: ${qualiList}");
    ///Qualifikationen
//    final qualiList = ref.watch(qualifikationModelFirestoreControllerProvider);
    //  if (qualiList != null) {
    //  print("qualiList: ${qualiList.first.qualifikationName}");
    //}

    ///Alle gespeicherten User in der Firestore Collection
    final userList = ref.watch(userModelFirestoreControllerProvider);

    ///LoggedIn User
    String? userID = ref.read(authControllerProvider.notifier).state!.uid;
    // print("userID: $userID");
    UserModel userLoggedIn =
        UserProvider().getUserNameByUserID(userID, userList!).first;
    setState(() {
      _loggedInUser = userLoggedIn;
    });
    // print("userLoggedIn2: ${userLoggedIn.birthDate}");
    // print("userLoggedIn2: ${userLoggedIn.qualifikationList!.first}");
    userLoggedIn.qualifikationList!.forEach((qualifikationID) {
      //    print("userLoggedIn2 qualifikationID: $qualifikationID");
      qualifikationList.forEach((qualifikation) {
        // print(qualifikation.qualifikationName);
        if (qualifikationID == qualifikation.qualifikationID &&
            selectedQualifikationList!.contains(qualifikation) == false) {
          //  print("-------------");
          //print("add: ${qualifikation.qualifikationName}");
          // setState(() {
          selectedQualifikationList!.add(qualifikation);
          //});
          //  print("-------------");
        }
      });
      //   print("selectedQualifikationList: $selectedQualifikationList");
    });

    return Scaffold(
      appBar: appBar(context: context, ref: ref, home: false),
      bottomNavigationBar:
          navigationBar(index: 2, context: context, ref: ref, home: false),
      resizeToAvoidBottomInset: false,
      body: Column(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.17,
          color: Color(0xFF1f623c),
          child: Center(
            child: Text(
              "${userLoggedIn.name}",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontFamily: 'Open Sans',
                fontSize: 50.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFFffffff),
              ),
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.015),
        Expanded(
            child: SingleChildScrollView(
          child: Column(children: [
            Row(
              children: <Widget>[
                SizedBox(width: MediaQuery.of(context).size.width * 0.015),
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
                                            color: Colors.black87,
                                            fontSize: 25.0),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015),
                    ],
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Column(children: [
                    ///Upload Profil Picture Button
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: EdgeInsets.only(top: 35.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            var picked = await FilePicker.platform.pickFiles();
                            if (picked != null) {
                              String fileExtension =
                                  getFileExtension(picked.files.first.name);

                              Uint8List fileBytes = picked.files.first.bytes!;
                              FirebaseStorage storage =
                                  FirebaseStorage.instance;
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
                              String urlString =
                                  await reference.getDownloadURL();
                              print("getDownloadURL(): $urlString");
                              ref
                                  .watch(userModelFirestoreControllerProvider
                                      .notifier)
                                  .updateURL(userLoggedIn, urlString);
                            }
                          },
                          child: Text('Upload Profil Picture'),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF9FB98B),
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 20),
                            textStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),

                    ///Bearbeiten Button
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: EdgeInsets.only(top: 35.0),
                        child: ElevatedButton(
                          child: Text('Bearbeiten'),
                          onPressed: () {
                            // Navigator.pushNamed(
                            // context, EditHelfer.routename);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF9FB98B),
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 20),
                            textStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
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
                                border: Border.all(color: Colors.black)),
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
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
                            onPressed: openFilterDialog,
                            child: Text(
                              "Add",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue),
                            ),
                            // color: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                    selectedQualifikationList!.isEmpty
                        ? Text("No Qualifikation selected yet")
                        : Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              height: 200,
                              child: SingleChildScrollView(
                                child: GridView.count(
                                  shrinkWrap: true,
                                  crossAxisCount: 7,
                                  childAspectRatio: 3,
                                  children: selectedQualifikationList!.map(
                                    (qualifikation) {
                                      return Container(
                                        margin: EdgeInsets.all(10),
                                        child: Text(
                                          "${qualifikation.qualifikationName}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black)),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                            ),
                          ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
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
                        )),
                    Text(
                      "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr.",
                      style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontFamily: 'Open Sans',
                        fontSize: 20.0,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF000000),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
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
                        )),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.all(15.0),
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: Text('14.05.2022',
                                style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontFamily: 'Open Sans',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF000000))),
                          ),
                          Container(
                            margin: const EdgeInsets.all(15.0),
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  ]),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.015),
              ],
            ),
            Divider(
              indent: 16,
              endIndent: 16,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          ]),
        ))
      ]),
    );
  }
}
