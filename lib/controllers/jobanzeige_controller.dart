import 'dart:async';

import 'package:agrargo/controllers/auth_controller.dart';
import 'package:agrargo/models/jobanzeige_model.dart';
import 'package:agrargo/models/user_model.dart';
import 'package:agrargo/repositories/firestore_user_model_riverpod_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

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
  var uuid = Uuid();
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

  ///Get
  void getJobanzeigeModelList() async {
    _read(fireJobanzeigeModelRepositoryProvider).getJobanzeigeModels();
  }

  void getJobanzeigeByID(
      List<JobanzeigeModel> jobanzeigeModelList, String jobanzeigeID) async {
    _read(fireJobanzeigeModelRepositoryProvider)
        .getJobanzeigeByID(jobanzeigeModelList, jobanzeigeID);
  }

  ///Speichern
  void saveJobanzeige(JobanzeigeModel anzeige) {
    if (anzeige.jobanzeigeID == null) {
      anzeige.jobanzeigeID = uuid.v4();
    }
    _read(fireJobanzeigeModelRepositoryProvider).saveJobanzeige(anzeige);
  }

  ///Löschen
  void removeJobanzeige(String jobanzeigeID) {
    _read(fireJobanzeigeModelRepositoryProvider).removeJobanzeige(jobanzeigeID);
  }
}
