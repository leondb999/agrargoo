import 'dart:async';

import 'package:agrargo/controllers/auth_controller.dart';
import 'package:agrargo/models/user_model.dart';
import 'package:agrargo/repositories/firestore_riverpod_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/auth_repository.dart';

final userFireStoreControllerProvider =
    StateNotifierProvider<FirestoreUserModelController, List<UserModel>?>(
  (ref) => FirestoreUserModelController(ref.read)..getUserModelList(),
);

class FirestoreUserModelController extends StateNotifier<List<UserModel>?> {
  final Reader _read;

  StreamSubscription<List<UserModel?>>? _streamSubscription;

  FirestoreUserModelController(this._read) : super(null) {
    _streamSubscription?.cancel();
    _streamSubscription =
        _read(fireUserRepositoryProvider).getUserModels().listen((userModel) {
      state = userModel;
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  void getUserModelList() async {
    final userModelList = _read(fireUserRepositoryProvider).getUserModels();
  }

  void getUserByID() {
    String? userID = _read(authControllerProvider.notifier).state!.uid;
  }
}
