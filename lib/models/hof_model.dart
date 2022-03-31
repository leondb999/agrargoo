class HofModel {
  String? hofID;
  String? besitzerID;
  String? hofName;
  String? standort;
  String? hofImageURL;

  HofModel({
    this.hofID,
    this.besitzerID,
    this.hofName,
    this.standort,
    this.hofImageURL,
  });

  Map<String, dynamic> createMap() {
    return {
      'hofID': hofID,
      'besitzerID': besitzerID,
      'hofName': hofName,
      'standort': standort,
      'hofImageURL': hofImageURL,
    };
  }

  HofModel.fromFirestore(Map<String, dynamic> firestoreMap, String documentID)
      : hofID = documentID,
        besitzerID = firestoreMap['besitzerID'],
        hofName = firestoreMap['hofName'],
        standort = firestoreMap['standort'],
        hofImageURL = firestoreMap['hofImageURL'];
}
