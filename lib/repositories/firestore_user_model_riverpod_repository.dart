import 'package:agrargo/main.dart';
import 'package:agrargo/exception/custom_exception.dart';
import 'package:agrargo/models/user_model.dart';
import 'package:agrargo/provider/general_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../UI/pages/profil/6_a_helfer_profil.dart';
import '../UI/pages/profil/landwirt_profil.dart';

abstract class BaseFirestoreUserModelRepository {
  Stream<List<UserModel>> getUserModels();
  Future<bool> updateProfilPicture(UserModel userModel, String url);
  Stream<List<UserModel>> getUserByID(String id);
}

///Riverpod Provider
final fireUserModelRepositoryProvider = Provider<FireUserModelRepository>(
    (ref) => FireUserModelRepository(ref.read));

class FireUserModelRepository implements BaseFirestoreUserModelRepository {
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

  Stream<List<UserModel>> getUserByID(String id) {
    return _read(firestoreProvider)
        .collection('users')
        .where('userID', isEqualTo: id)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UserModel.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
    /*
    List<UserModel> userModelList = [];
    await _read(firestoreProvider)
        .collection('users')
        .snapshots()
        .map((snapshot) {
      print("snapshot: $snapshot");
      snapshot.docs.map((doc) {
        UserModel user = UserModel.fromFirestore(doc.data(), doc.id);
        userModelList.add(user);
        // return UserModel.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
    print("userModelList: $userModelList");
    return userModelList;

     */
  }

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

  Future<bool> updateQualifikationList(
      UserModel userModel, List<String> qualifikationList) async {
    try {
      _read(firestoreProvider)
          .collection('users')
          .doc(userModel.userID)
          .update({
        'qualifikationList': qualifikationList,
      });
      return true;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
    throw UnimplementedError();
  }
}
