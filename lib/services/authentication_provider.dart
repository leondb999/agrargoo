import 'dart:html';

import 'package:agrargo/UI/login/login_page.dart';
import 'package:agrargo/UI/login/profile_page.dart';
import 'package:agrargo/widgets/navigation_bar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:agrargo/services/api_helpers.dart';
import 'package:provider/provider.dart';

class AuthenticationProvider {
  ///FirebaseAuth instance
  final FirebaseAuth firebaseAuth;

  ///Constuctor to initalize the FirebaseAuth instance
  AuthenticationProvider(this.firebaseAuth);

  ///Using Stream to listen to Authentication State
  Stream<User?> get authState => firebaseAuth.idTokenChanges();

  //............RUDIMENTARY METHODS FOR AUTHENTICATION................

  //SIGN UP METHOD
  Future<String> signUp(
      {required String email, required String password}) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return "Signed up!";
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
  }

  //SIGN IN METHOD
  Future<String> signIn(
      {required String email, required String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Signed in!";
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
  }

  //SIGN OUT METHOD
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
