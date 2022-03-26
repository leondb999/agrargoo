import 'package:agrargo/models/user_model.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../models/user_model.dart ' as u;
import '../models/user_model.dart ';

class AuthService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  auth.User? _userFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }
    return user;
  }

  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((_userFromFirebase()));
  }
}
