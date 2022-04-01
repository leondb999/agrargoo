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
  Future<bool> updateProfilPicture(UserModel userModel, String url);
}

///Riverpod Provider
final fireUserModelRepositoryProvider = Provider<FireUserModelRepository>(
    (ref) => FireUserModelRepository(ref.read));

class FireUserModelRepository implements BaseFirestoreUserRepository {
  final Reader _read;

  const FireUserModelRepository(this._read);

  @override
  Stream<List<UserModel>> getUserModels() {
    return _read(firestoreProvider).collection('users').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => UserModel.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  @override
  Stream<List<UserModel>> get UserModels => throw UnimplementedError();

  @override
  Future<bool> updateProfilPicture(UserModel userModel, String url) async {
    try {
      _read(firestoreProvider)
          .collection('users')
          .doc(userModel.userID)
          .update({'profilImageURL': url});
      return true;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
    throw UnimplementedError();
  }
}
