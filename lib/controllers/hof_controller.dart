import 'dart:async';
import 'package:agrargo/controllers/auth_controller.dart';
import 'package:agrargo/models/user_model.dart';
import 'package:agrargo/repositories/firestore_user_model_riverpod_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/hof_model.dart';
import '../repositories/firestore_hof_model_riverpod_repository.dart';

final hofModelFirestoreControllerProvider =
    StateNotifierProvider<FirestoreHofModelController, List<HofModel>?>(
  (ref) => FirestoreHofModelController(ref.read)..getHofModelList(),
);

class FirestoreHofModelController extends StateNotifier<List<HofModel>?> {
  final Reader _read;

  StreamSubscription<List<HofModel?>>? _streamSubscription;

  FirestoreHofModelController(this._read) : super(null) {
    _streamSubscription?.cancel();
    _streamSubscription =
        _read(fireHofModelRepositoryProvider).getHofModels().listen((hofModel) {
      state = hofModel;
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  void getHofModelList() async {
    final hofModelList = _read(fireHofModelRepositoryProvider).getHofModels();
  }
}
