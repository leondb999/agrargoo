import 'package:agrargo/main.dart';
import 'package:agrargo/exception/custom_exception.dart';
import 'package:agrargo/provider/general_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../UI/pages/profil/helfer_profil_admin.dart';
import '../UI/pages/profil/landwirt_profil_admin.dart';

abstract class BaseAuthRepository {
  Stream<User?> get authStateChanges;
  Future<void> signInAnonymously();
  Future<void> signInEmailAndPW(
      BuildContext context, String email, String password);
  Future<void> registerUserEmailAndPW(
    BuildContext context,
    String name,
    String email,
    String password,
    bool landwirt,
    DateTime birthDate,
    DateTime startDate,
    DateTime endDate,
  );
  Future<void> updateUserName(String name);
  User? getCurrentUser();
  Future<void> signOut(BuildContext context);
  Future<void> refreshUser();
}

///Firebase instance
final authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepository(ref.read));

class AuthRepository implements BaseAuthRepository {
  final Reader _read;

  const AuthRepository(this._read);

  @override
  Stream<User?> get authStateChanges =>
      _read(firebaseAuthProvider).authStateChanges();

  @override
  Future<void> signInAnonymously() async {
    try {
      await _read(firebaseAuthProvider).signInAnonymously();
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  User? getCurrentUser() {
    try {
      return _read(firebaseAuthProvider).currentUser;
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<void> signOut(BuildContext context) async {
    try {
      await _read(firebaseAuthProvider).signOut();
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<void> signInEmailAndPW(
      BuildContext context, String email, String password) async {
    try {
      await _read(firebaseAuthProvider)
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error Occured'),
          content: Text(e.toString()),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text("OK"))
          ],
        ),
      );
    }
  }

  @override
  Future<void> registerUserEmailAndPW(
    BuildContext context,
    String name,
    String email,
    String password,
    bool landwirt,
    DateTime birthDate,
    DateTime startDate,
    DateTime endDate,
  ) async {
    print("registerUserEmailAndPW");
    try {
      await _read(firebaseAuthProvider)
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((userCredential) async {
        userCredential.user!.updateDisplayName(name);
        //userCredential.user!.reload();

        User? user = userCredential.user;
        try {
          bool? success = await FirebaseFirestore.instance
              .collection('users')
              .doc(user?.uid)
              .set({
            'userID': user?.uid,
            'name': name,
            'email': email,
            'landwirt': landwirt,
            'birthDate': birthDate,
            'qualifikationList': [],
            'erfahrungen': "",
            'startDate': startDate,
            'endDate': endDate,
          }).then((value) {
            ///Landwirt Profil Page
            if (landwirt == true) {
              Navigator.pushNamed(
                context,
                LandwirtProfil.routename,
                arguments: {'landwirt': landwirt},
              );
            }

            ///Helfer Profil Page
            if (landwirt == false) {
              Navigator.pushNamed(
                context,
                HelferProfil.routename,
                arguments: {'landwirt': landwirt},
              );
            }
          });
          print("success: $success");
        } catch (e) {
          print("Error while register User in firestore: $e");
        }

        // Navigator.pop(context);
        //   Navigator.pushReplacementNamed(context, "/home");
      });
    } on FirebaseAuthException catch (e) {
      await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                  title: const Text('Error Occured'),
                  content: Text(e.toString()),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: const Text("OK"))
                  ]));
    } catch (e) {
      print(e);
    }
    throw UnimplementedError();
  }

  @override
  Future<void> updateUserName(String name) {
    // TODO: implement updateUserName
    throw UnimplementedError();
  }

  Future<void> refreshUser() async {
    await _read(firebaseAuthProvider).currentUser!.reload();
  }
}
