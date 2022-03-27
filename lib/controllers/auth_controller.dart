import 'dart:async';

import 'package:agrargo/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/auth_repository.dart';

final authControllerProvider = StateNotifierProvider<AuthController, User?>(
  (ref) => AuthController(ref.read)..getUser(),
);

class AuthController extends StateNotifier<User?> {
  final Reader _read;

  StreamSubscription<User?>? _authStateChangesSubscription;

  AuthController(this._read) : super(null) {
    _authStateChangesSubscription?.cancel();
    _authStateChangesSubscription = _read(authRepositoryProvider)
        .authStateChanges
        .listen((user) => state = user);
  }

  @override
  void dispose() {
    _authStateChangesSubscription?.cancel();
    super.dispose();
  }

  void getUser() async {
    final user = _read(authRepositoryProvider).getCurrentUser();
  }

  void signInAnonym() async {
    await _read(authRepositoryProvider).signInAnonymously();
  }

  void signInEmail(BuildContext context, String email, String password) async {
    await _read(authRepositoryProvider)
        .signInEmailAndPW(context, email, password);
  }

  void register(BuildContext context, String name, String email,
      String password, bool landwirt) async {
    await _read(authRepositoryProvider)
        .registerUserEmailAndPW(context, name, email, password, landwirt);
  }

  void signOut() async {
    await _read(authRepositoryProvider).signOut();
  }
}
