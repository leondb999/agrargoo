import 'package:agrargo/main.dart';
import 'package:agrargo/exception/custom_exception.dart';
import 'package:agrargo/models/hof_model.dart';
import 'package:agrargo/models/user_model.dart';
import 'package:agrargo/provider/general_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../UI/pages/profil/6_a_helfer_profil.dart';
import '../UI/pages/profil/6_b_landwirt_profil.dart';

abstract class BaseFirestoreHofModelRepository {
  Stream<List<HofModel>> getHofModels();
}

///Riverpod Provider
final fireHofModelRepositoryProvider =
    Provider<FireHofModelRepository>((ref) => FireHofModelRepository(ref.read));

class FireHofModelRepository implements BaseFirestoreHofModelRepository {
  final Reader _read;
  const FireHofModelRepository(this._read);

  @override
  Stream<List<HofModel>> getHofModels() {
    return _read(firestoreProvider).collection('höfe').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => HofModel.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }
}
