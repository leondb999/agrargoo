class Hof {
  String? hofID;
  String? besitzerID;
  String? hofName;
  String? standort;

  Hof({this.hofID, this.besitzerID, this.hofName, this.standort});

  Map<String, dynamic> createMap() {
    return {
      'hofID': hofID,
      'besitzerID': besitzerID,
      'hofName': hofName,
      'standort': standort,
    };
  }

  Hof.fromFirestore(Map<String, dynamic> firestoreMap, String documentID)
      : hofID = documentID,
        besitzerID = firestoreMap['besitzerID'],
        hofName = firestoreMap['hofName'],
        standort = firestoreMap['standort'];
}
