import 'dart:async';

import 'package:agrargo/controllers/auth_controller.dart';
import 'package:agrargo/models/jobanzeige_model.dart';
import 'package:agrargo/models/qualifikation_model.dart';
import 'package:agrargo/models/user_model.dart';
import 'package:agrargo/repositories/firestore_qualifikation_model_riverpod_repository.dart';
import 'package:agrargo/repositories/firestore_user_model_riverpod_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../repositories/auth_repository.dart';
import '../repositories/firestore_jobanzeige_model_riverpod_repository.dart';

final qualifikationModelFirestoreControllerProvider = StateNotifierProvider<
    FirestoreQualifikationModelController, List<QualifikationModel>?>(
  (ref) => FirestoreQualifikationModelController(ref.read)
    ..getQualifikationModelList(),
);

class FirestoreQualifikationModelController
    extends StateNotifier<List<QualifikationModel>?> {
  final Reader _read;
  StreamSubscription<List<QualifikationModel?>>? _streamSubscription;

  FirestoreQualifikationModelController(this._read) : super(null) {
    _streamSubscription?.cancel();
    _streamSubscription = _read(fireQualifikationModelRepositoryProvider)
        .getQualifikationModelList()
        .listen((qualifikationModel) {
      state = qualifikationModel;
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  ///Get
  void getQualifikationModelList() {
    _read(fireQualifikationModelRepositoryProvider).getQualifikationModelList();
  }
}
