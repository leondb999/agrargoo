import 'package:agrargo/main.dart';
import 'package:agrargo/exception/custom_exception.dart';
import 'package:agrargo/models/hof_model.dart';
import 'package:agrargo/models/user_model.dart';
import 'package:agrargo/provider/general_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../UI/pages/profil/helfer_profil_admin.dart';
import '../UI/pages/profil/landwirt_profil_admin.dart';

abstract class BaseFirestoreHofModelRepository {
  Stream<List<HofModel>> getHofModels();
  Future<void> saveHof(HofModel hof);
  Future<void> removeHof(String hofID);
  List<HofModel> getHofModelByID(List<HofModel> hofModelList, String id);
}

///Riverpod Provider
final fireHofModelRepositoryProvider =
    Provider<FireHofModelRepository>((ref) => FireHofModelRepository(ref.read));

class FireHofModelRepository implements BaseFirestoreHofModelRepository {
  final Reader _read;
  const FireHofModelRepository(this._read);

  ///Get
  @override
  Stream<List<HofModel>> getHofModels() {
    return _read(firestoreProvider).collection('höfe').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => HofModel.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  ///Speichern
  @override
  Future<void> saveHof(HofModel hof) {
    return _read(firestoreProvider)
        .collection('höfe')
        .doc(hof.hofID)
        .set(hof.createMap());
  }

  ///Löschen
  @override
  Future<void> removeHof(String hofID) {
    return _read(firestoreProvider).collection('höfe').doc(hofID).delete();
  }

  @override
  List<HofModel> getHofModelByID(List<HofModel> hofModelList, String id) {
    List<HofModel> filteredList = [];
    if (hofModelList.isNotEmpty) {
      hofModelList.forEach((hof) {
        if (hof.hofID == id) {
          filteredList.add(hof);
        }
      });
    }
    return filteredList;
    throw UnimplementedError();
  }
}
