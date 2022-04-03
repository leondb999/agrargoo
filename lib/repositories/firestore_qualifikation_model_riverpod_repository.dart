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

import '../UI/pages/profil/6_a_helfer_profil.dart';
import '../UI/pages/profil/landwirt_profil.dart';

abstract class BaseFirestoreQualifikationModelRepository {
  Stream<List<QualifikationModel>> getQualifikationModelsList();
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
  Stream<List<QualifikationModel>> getQualifikationModelsList() {
    List x = [];
    FirebaseFirestore.instance
        .collection('qualifikationen')
        .get()
        .then((value) {
      value.docs.forEach((doc) {
        print("name: ${doc['name']}");
      });
    });

    return _read(firestoreProvider)
        .collection('qualifikationen')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => QualifikationModel.fromFirestore(doc.data(), doc.id))
            .toList()
            .toList());
    throw UnimplementedError();
  }
}
