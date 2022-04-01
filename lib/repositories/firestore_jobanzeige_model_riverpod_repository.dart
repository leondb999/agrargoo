import 'package:agrargo/main.dart';
import 'package:agrargo/exception/custom_exception.dart';
import 'package:agrargo/models/jobanzeige_model.dart';
import 'package:agrargo/models/user_model.dart';
import 'package:agrargo/provider/general_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../UI/pages/profil/6_a_helfer_profil.dart';
import '../UI/pages/profil/6_b_landwirt_profil.dart';

abstract class BaseFirestoreJobanzeigeModelRepository {
  Stream<List<JobanzeigeModel>> getJobanzeigeModels();
}

///Riverpod Provider
final fireJobanzeigeModelRepositoryProvider =
    Provider<FireJobanzeigeModelRepository>(
        (ref) => FireJobanzeigeModelRepository(ref.read));

class FireJobanzeigeModelRepository
    implements BaseFirestoreJobanzeigeModelRepository {
  final Reader _read;

  const FireJobanzeigeModelRepository(this._read);

  @override
  Stream<List<JobanzeigeModel>> getJobanzeigeModels() {
    return _read(firestoreProvider).collection('jobAnzeigen').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => JobanzeigeModel.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }
}
