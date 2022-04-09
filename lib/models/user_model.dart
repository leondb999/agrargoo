import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firebase.dart';

class UserModel {
  String? userID;
  String? name;
  String? email;
  bool? landwirt;
  String? profilImageURL;
  DateTime? birthDate;
  List<dynamic>? qualifikationList;
  String? erfahrungen;
  DateTime? startDate;
  DateTime? endDate;
  UserModel({
    this.userID,
    this.name,
    this.email,
    this.landwirt,
    this.profilImageURL,
    this.birthDate,
    this.qualifikationList,
    this.erfahrungen,
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> createMap() {
    return {
      'userID': userID,
      'name': name,
      'email': email,
      'landwirt': landwirt,
      'profilImageURL': profilImageURL,
      'birthDate': birthDate,
      'erfahrungen': erfahrungen,
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  UserModel.fromFirestore(Map<String, dynamic> firestoreMap, String documentID)
      : userID = documentID,
        name = firestoreMap['name'],
        email = firestoreMap['email'],
        landwirt = firestoreMap['landwirt'],
        profilImageURL = firestoreMap['profilImageURL'],
        birthDate = DateTime.parse(
            (firestoreMap['birthDate'] as Timestamp).toDate().toString()),
        qualifikationList = firestoreMap['qualifikationList'],
        erfahrungen = firestoreMap['erfahrungen'],
        startDate = DateTime.parse(
            (firestoreMap['startDate'] as Timestamp).toDate().toString()),
        endDate = DateTime.parse(
            (firestoreMap['endDate'] as Timestamp).toDate().toString());
}
