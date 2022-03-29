import 'package:agrargo/models/user_model.dart';
import 'package:agrargo/repositories/firestore_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class UserProvider with ChangeNotifier {
  final service = FireStoreService();
  var uuid = Uuid();

  String? userID;
  String? email;
  bool? landwirt;

  ///Getters
  String? get getUserID => userID;
  String? get getEmail => email;
  bool? get getlandwirt => landwirt;

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
}
