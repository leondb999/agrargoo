import 'package:agrargo/models/user_model.dart';
import 'package:agrargo/repositories/firebase_storage_repository.dart';
import 'package:agrargo/repositories/firestore_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class UserProvider with ChangeNotifier {
  final service = FireStoreService();
  var uuid = Uuid();

  String? userID;
  String? name;
  String? email;
  bool? landwirt;
  String? profilImageURL;

  ///Getters
  String? get getUserID => userID;
  String? get getName => name;
  String? get getEmail => email;
  bool? get getLandwirt => landwirt;
  String? get getProfilImageURL => profilImageURL;

  ///Filter Höfe nach Nutzer ID
  List<UserModel> getUserNameByUserID(
      String? userID, List<UserModel> userList) {
    List<UserModel> filteredList = [];
    userList.forEach((user) {
      //  print("getUsernameByUserID: ${user.userID}");
      if (user.userID == userID) {
        filteredList.add(user);
      }
    });
    if (filteredList.isEmpty) return [];
    return filteredList;
  }

  void changeHofImageURL(String val) {
    profilImageURL = val;
    notifyListeners();
  }

  ///lade UserModel
  loadValues(UserModel userModel) {
    userID = userModel.userID;
    email = userModel.email;
    landwirt = userModel.landwirt;
    profilImageURL = userModel.profilImageURL;
  }

  ///Lösche User
  void removeData() {
    service.removeUser(userID!);
  }

  void saveData() {
    print("jobanzeigeID = $userID");

    var updateUserModel = UserModel(
      email: email,
      landwirt: landwirt,
      name: name,
      profilImageURL: profilImageURL,
      userID: userID,
    );
    service.saveUser(updateUserModel);
  }

  void updateUserProfilUrl() {
    print(
        "userID: $userID | profilImageURL: $profilImageURL | email: $email | landwirt: $landwirt");
    service.updateUser(userID!, profilImageURL!);
  }
}
