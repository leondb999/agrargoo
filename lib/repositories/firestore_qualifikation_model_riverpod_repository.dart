import 'package:agrargo/main.dart';
import 'package:agrargo/exception/custom_exception.dart';
import 'package:agrargo/models/jobanzeige_model.dart';
import 'package:agrargo/models/qualifikation_model.dart';
import 'package:agrargo/models/user_model.dart';
import 'package:agrargo/provider/general_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../UI/pages/profil/helfer_profil_admin.dart';
import '../UI/pages/profil/landwirt_profil_admin.dart';

abstract class BaseFirestoreQualifikationModelRepository {
  List<QualifikationModel> getQualifikationModelsList2();
  Stream<List<QualifikationModel>> getQualifikationModelList();
}

///Riverpod Provider
final fireQualifikationModelRepositoryProvider =
    Provider<FireQualifikationModelRepository>(
        (ref) => FireQualifikationModelRepository(ref.read));

class FireQualifikationModelRepository
    implements BaseFirestoreQualifikationModelRepository {
  final Reader _read;
  const FireQualifikationModelRepository(this._read);

  @override
  List<QualifikationModel> getQualifikationModelsList2() {
    List<QualifikationModel> qualifikationsList = [];
    _read(firestoreProvider).collection('qualifikationen').get().then((value) {
      value.docs.forEach((doc) {
        QualifikationModel qualifikationModel = QualifikationModel(
            qualifikationName: doc['name'], qualifikationID: doc.id);
        qualifikationsList.add(qualifikationModel);
        //  print("qualifikationsList: ${qualifikationsList}");
      });
    });
    return qualifikationsList;
    /*  print("qualifikationsList: ${qualifikationsList.length}");
    try {
      return _read(firestoreProvider)
          .collection('qualifikationen')
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) =>
                    QualifikationModel.fromFirestore(doc.data(), doc.id))
                .toList(),
          );
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }*/

    throw UnimplementedError();
  }

  @override
  Stream<List<QualifikationModel>> getQualifikationModelList() {
    print("Stream<List<QualifikationModel>> getQualifikationModelList()");
    return _read(firestoreProvider)
        .collection('qualifikationen')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                  (doc) => QualifikationModel.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }
}
