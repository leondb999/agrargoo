import 'dart:async';

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

  Future<bool> signInEmail(
      BuildContext context, String email, String password) async {
    return await _read(authRepositoryProvider)
        .signInEmailAndPW(context, email, password);
  }

  void register(
    BuildContext context,
    String name,
    String email,
    String password,
    bool landwirt,
    DateTime birthDate,
    DateTime startDate,
    DateTime endDate,
    String profilImageURL,
  ) async {
    await _read(authRepositoryProvider).registerUserEmailAndPW(
      context,
      name,
      email,
      password,
      landwirt,
      birthDate,
      startDate,
      endDate,
      profilImageURL,
    );
  }

  void signOut(BuildContext context) async {
    await _read(authRepositoryProvider).signOut(context);
  }
}
