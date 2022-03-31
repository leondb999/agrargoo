import 'package:firebase/firebase.dart';

class UserModel {
  String? userID;
  String? name;
  String? email;
  bool? landwirt;
  String? profilImageURL;

  UserModel({
    this.userID,
    this.name,
    this.email,
    this.landwirt,
    this.profilImageURL,
  });

  Map<String, dynamic> createMap() {
    return {
      'userID': userID,
      'name': name,
      'email': email,
      'landwirt': landwirt,
      'profilImageURL': profilImageURL,
    };
  }

  UserModel.fromFirestore(Map<String, dynamic> firestoreMap, String documentID)
      : userID = documentID,
        name = firestoreMap['name'],
        email = firestoreMap['email'],
        landwirt = firestoreMap['landwirt'],
        profilImageURL = firestoreMap['profilImageURL'];
}
