class UserModel {
  String? userID;
  String? name;
  String? email;
  bool? landwirt;

  UserModel({this.userID, this.name, this.email, this.landwirt});

  Map<String, dynamic> createMap() {
    return {
      'userID': userID,
      'name': name,
      'email': email,
      'landwirt': landwirt,
    };
  }

  UserModel.fromFirestore(Map<String, dynamic> firestoreMap, String documentID)
      : userID = documentID,
        name = firestoreMap['name'],
        email = firestoreMap['email'],
        landwirt = firestoreMap['landwirt'];
}
