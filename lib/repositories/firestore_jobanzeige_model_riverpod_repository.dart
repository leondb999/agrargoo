import 'package:agrargo/main.dart';
import 'package:agrargo/exception/custom_exception.dart';
import 'package:agrargo/models/jobanzeige_model.dart';
import 'package:agrargo/models/user_model.dart';
import 'package:agrargo/provider/general_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../UI/pages/profil/helfer_profil_admin.dart';
import '../UI/pages/profil/landwirt_profil_admin.dart';

abstract class BaseFirestoreJobanzeigeModelRepository {
  Stream<List<JobanzeigeModel>> getJobanzeigeModels();
  Future<void> saveJobanzeige(JobanzeigeModel anzeige);
  Future<void> removeJobanzeige(String jobanzeigeID);
  List<JobanzeigeModel> getJobanzeigeByID(
      List<JobanzeigeModel> jobanzeigeModelList, String id);
  Future<List<types.User>> getTypesUserByJobanzeigeID(String userID);
}

///Riverpod Provider
final fireJobanzeigeModelRepositoryProvider =
    Provider<FireJobanzeigeModelRepository>(
        (ref) => FireJobanzeigeModelRepository(ref.read));

class FireJobanzeigeModelRepository
    implements BaseFirestoreJobanzeigeModelRepository {
  final Reader _read;

  const FireJobanzeigeModelRepository(this._read);

  ///Get
  @override
  Stream<List<JobanzeigeModel>> getJobanzeigeModels() {
    return _read(firestoreProvider).collection('jobAnzeigen').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => JobanzeigeModel.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  ///Speichern
  @override
  Future<void> saveJobanzeige(JobanzeigeModel anzeige) {
    return _read(firestoreProvider)
        .collection('jobAnzeigen')
        .doc(anzeige.jobanzeigeID)
        .set(anzeige.createMap());
  }

  ///Löschen
  @override
  Future<void> removeJobanzeige(String jobanzeigeID) {
    return _read(firestoreProvider)
        .collection('jobAnzeigen')
        .doc(jobanzeigeID)
        .delete();
  }

  @override
  List<JobanzeigeModel> getJobanzeigeByID(
      List<JobanzeigeModel> jobanzeigeModelList, String id) {
    List<JobanzeigeModel> filteredList = [];

    if (jobanzeigeModelList.isNotEmpty) {
      jobanzeigeModelList.forEach((jobanzeige) {
        if (jobanzeige.jobanzeigeID == id) {
          filteredList.add(jobanzeige);
        }
      });
    }

    return filteredList;
    throw UnimplementedError();
  }

  Future<List<types.User>> getTypesUserByJobanzeigeID(String userID) async {
    List<types.User> filteredList = [];

    await FirebaseChatCore.instance.users().forEach((typeUsers) {
      typeUsers.forEach((typeUser) {
        // print("hi ${typeUser.id} == $userID");
        if (typeUser.id == userID) {
          // print("typeUser: $typeUser");
          filteredList.add(typeUser);
        }
      });
    });

    return filteredList;
  }
}
