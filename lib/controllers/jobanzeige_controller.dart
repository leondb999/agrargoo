import 'dart:async';

import 'package:agrargo/controllers/auth_controller.dart';
import 'package:agrargo/models/jobanzeige_model.dart';
import 'package:agrargo/models/user_model.dart';
import 'package:agrargo/repositories/firestore_user_model_riverpod_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/auth_repository.dart';
import '../repositories/firestore_jobanzeige_model_riverpod_repository.dart';

final jobanzeigeModelFirestoreControllerProvider = StateNotifierProvider<
    FirestoreJobanzeigeModelController, List<JobanzeigeModel>?>(
  (ref) =>
      FirestoreJobanzeigeModelController(ref.read)..getJobanzeigeModelList(),
);

class FirestoreJobanzeigeModelController
    extends StateNotifier<List<JobanzeigeModel>?> {
  final Reader _read;

  StreamSubscription<List<JobanzeigeModel?>>? _streamSubscription;

  FirestoreJobanzeigeModelController(this._read) : super(null) {
    _streamSubscription?.cancel();
    _streamSubscription = _read(fireJobanzeigeModelRepositoryProvider)
        .getJobanzeigeModels()
        .listen((jobanzeigeModel) {
      state = jobanzeigeModel;
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  void getJobanzeigeModelList() async {
    final jobanzeigeModelList =
        _read(fireUserModelRepositoryProvider).getUserModels();
  }
}
