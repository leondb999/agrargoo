import 'package:agrargo/UI/login_riverpod/login.dart';
import 'package:agrargo/UI/pages/chat/5_chat.dart';
import 'package:agrargo/UI/pages/chat/chat_leon.dart';
import 'package:agrargo/controllers/jobanzeige_controller.dart';
import 'package:agrargo/models/jobanzeige_model.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controllers/auth_controller.dart';
import '../../../controllers/hof_controller.dart';
import '../../../controllers/user_controller.dart';
import '../../../models/user_model.dart';
import '../../../provider/user_provider.dart';
import '../../../repositories/firestore_hof_model_riverpod_repository.dart';
import '../../../repositories/firestore_jobanzeige_model_riverpod_repository.dart';
import '../../../widgets/layout_widgets.dart';

class Jobangebot extends ConsumerStatefulWidget {
  static const routename = '/jobangebot';

  Jobangebot();

  @override
  _JobangebotState createState() => _JobangebotState();
}

class _JobangebotState extends ConsumerState<Jobangebot> {
  final usersCollection = FirebaseFirestore.instance.collection('users');
  String _jobanzeigeID = "";
  List<types.User> typesUserList = [];
  String auftraggeberID = "";
  var routeData;

  void _handlePressed(types.User otherUser, BuildContext context) async {
    //final room = await FirebaseChatCore.instance.createRoom(otherUser);
    //ChatPageLeon.room = await FirebaseChatCore.instance.createRoom(otherUser);
    final userList = ref.watch(userModelFirestoreControllerProvider);
    final userModel =
        UserProvider().getUserNameByUserID(otherUser.id, userList!).first;

    if (userModel.profilImageURL != null) {
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

    if (userModel.profilImageURL == null) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChatPageLeon(
            friendName: "${userModel.name}",
            friendId: "${userModel.userID}",
          ),
        ),
      );
    }

    @override
    void initState() {
      // TODO: implement initState
      super.initState();
      Future.delayed(Duration(microseconds: 10), () async {
        ///Get jobanzeigeID form Route
        routeData =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

        setState(() {
          _jobanzeigeID = routeData['jobanzeige_ID'];
          auftraggeberID = routeData['auftraggeberID'];
        });
        print("routeData: $routeData");
        String? userID = ref.read(authControllerProvider.notifier).state?.uid;
        print("auftraggeberID: $auftraggeberID");
        await FirebaseChatCore.instance.users().forEach((typeUsers) {
          typeUsers.forEach((typeUser) {
            print("typeUser.id ${typeUser.id}");
            if (typeUser.id == auftraggeberID) {
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
      print("typesUserList: $typesUserList");

      ///Get LoggedIn User
      User? authControllerState = ref.watch(authControllerProvider);

      ///Get all Jobanzeigen
      final jobanzeigeModelList =
          ref.watch(jobanzeigeModelFirestoreControllerProvider);

      ///Filtere JobanzeigenListe nach ID
      final jobanzeige = ref
          .watch(fireJobanzeigeModelRepositoryProvider)
          .getJobanzeigeByID(jobanzeigeModelList!, _jobanzeigeID)
          .first;
      print("auftraggeberID: ${jobanzeige.auftraggeberID}");
      final typeUser = ref
          .watch(fireJobanzeigeModelRepositoryProvider)
          .getTypesUserByJobanzeigeID(jobanzeige.auftraggeberID!);
      print("typeUser: $typeUser");

      ///Get all HofModels
      var hofModelList = ref.watch(hofModelFirestoreControllerProvider);

      ///Get Hof by ID
      final hof = ref
          .watch(fireHofModelRepositoryProvider)
          .getHofModelByID(hofModelList!, jobanzeige.hofID!)
          .first;
      if (jobanzeige.titel != null) {
        print(
            "jobanzeige: titel: ${jobanzeige.titel}, hofName: ${hof.hofName} standort: ${hof.standort}");
      }
      return Scaffold(
        appBar: appBar(context: context, ref: ref, home: false),
        resizeToAvoidBottomInset: false,
        bottomNavigationBar:
            navigationBar(index: 0, context: context, ref: ref, home: false),
        body: Column(children: [
          Column(children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.015),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Icon(
                    Icons.place,
                    color: Colors.black,
                    size: 20.0,
                  ),
                  SizedBox(width: 3),
                  Text("${hof.standort}",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF000000))),
                ]),
                Row(
                  children: [
                    Icon(
                      Icons.date_range,
                      color: Colors.black,
                      size: 20.0,
                    ),
                    SizedBox(width: 3),
                    Text(
                        "${jobanzeige.startDate!.day}.${jobanzeige.startDate!.month}.${jobanzeige.startDate!.year} - ${jobanzeige.endDate!.day}.${jobanzeige.endDate!.month}.${jobanzeige.endDate!.year}",
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF000000)))
                  ],
                )
              ],
            ),
          ]),
          SizedBox(height: MediaQuery.of(context).size.height * 0.015),
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: [
                Row(
                  children: <Widget>[
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Expanded(
                      flex: 6,
                      child: Column(children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.015),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              child: Text("${jobanzeige.titel}",
                                  style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontFamily: 'Open Sans',
                                      fontSize: 23.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1f623c))),
                            )),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.015),
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
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("${jobanzeige.beschreibung}",
                                style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontFamily: 'Open Sans',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF000000))),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.07),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              child: Text("Besondere Qualifikationen",
                                  style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontFamily: 'Open Sans',
                                      fontSize: 23.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1f623c))),
                            )),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.all(15.0),
                                padding: const EdgeInsets.all(7.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: Text('Traktor-Führerschein',
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
                            height: MediaQuery.of(context).size.height * 0.05),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              height: 36,
                              child: Text("Stundenlohn",
                                  style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontFamily: 'Open Sans',
                                      fontSize: 23.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1f623c))),
                            )),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.all(15.0),
                                padding: const EdgeInsets.all(7.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: Text('${jobanzeige.stundenLohn} €',
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
                      ]),
                    ),
                    Expanded(
                      flex: 4,
                      child: Column(children: [
                        Image.network(
                          '${hof.hofImageURL}',
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.15),
                        Container(
                            margin: const EdgeInsets.all(15.0),
                            padding: const EdgeInsets.all(7.0),

                            ///Bewerben Button
                            child: ElevatedButton(
                              child: Text('Bewerben'),
                              onPressed: () {
                                ///TODO Implement Navigation to Jobangebot
                                ///User Logged In
                                authControllerState != null
                                    ? _handlePressed(
                                        typesUserList.first, context)
                                    : Navigator.pushNamed(
                                        context,
                                        LoginPage.routename,
                                        arguments: {'landwirt': false},
                                      );
                                print("typesUserList: ${typesUserList.first}");
                                /*
                              void _handlePressed(types.User otherUser,
                                  BuildContext context) async {
                                final room = await FirebaseChatCore.instance
                                    .createRoom(otherUser);

                                /// 'createdAt': FieldValue.serverTimestamp(),
                                Navigator.of(context).pop();
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ChatPageLeon(
                                      room: room,
                                    ),
                                  ),
                                );
                              }



                                  ? Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => Chat()))
                                  :
                              */
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF9FB98B),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 20),
                                  textStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            )),
                      ]),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
