import 'dart:async';

import 'package:agrargo/controllers/auth_controller.dart';
import 'package:agrargo/models/user_model.dart';
import 'package:agrargo/repositories/firestore_user_model_riverpod_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/auth_repository.dart';

final userModelFirestoreControllerProvider =
    StateNotifierProvider<FirestoreUserModelController, List<UserModel>?>(
  (ref) => FirestoreUserModelController(ref.read)..getUserModelList(),
);

class FirestoreUserModelController extends StateNotifier<List<UserModel>?> {
  final Reader _read;

  StreamSubscription<List<UserModel?>>? _streamSubscription;

  FirestoreUserModelController(this._read) : super(null) {
    _streamSubscription?.cancel();
    _streamSubscription = _read(fireUserModelRepositoryProvider)
        .getUserModels()
        .listen((userModel) {
      state = userModel;
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  void getUserByID() {
    String? userID = _read(authControllerProvider.notifier).state!.uid;
  }

  void getUserModelList() async {
    final userModelList =
        _read(fireUserModelRepositoryProvider).getUserModels();
  }

  void updateURL(UserModel userModel, String url) async {
    bool success = await _read(fireUserModelRepositoryProvider)
        .updateProfilPicture(userModel, url);
  }
}