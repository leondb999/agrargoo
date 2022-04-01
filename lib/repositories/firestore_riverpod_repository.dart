import 'package:agrargo/main.dart';
import 'package:agrargo/exception/custom_exception.dart';
import 'package:agrargo/models/user_model.dart';
import 'package:agrargo/provider/general_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../UI/pages/profil/6_a_helfer_profil.dart';
import '../UI/pages/profil/6_b_landwirt_profil.dart';

abstract class BaseFirestoreUserRepository {
  Stream<List<UserModel>> getUserModels();
}

final fireUserRepositoryProvider =
    Provider<FireUserRepository>((ref) => FireUserRepository(ref.read));

class FireUserRepository implements BaseFirestoreUserRepository {
  final Reader _read;

  const FireUserRepository(this._read);

  @override
  // TODO: implement allUserModels

  @override
  Stream<List<UserModel>> getUserModels() {
    return _read(firestoreProvider).collection('users').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => UserModel.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  @override
  // TODO: implement UserModels
  Stream<List<UserModel>> get UserModels => throw UnimplementedError();
}
