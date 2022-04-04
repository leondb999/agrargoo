class QualifikationModel {
  final String? qualifikationName;
  final String? qualifikationID;

  QualifikationModel({
    this.qualifikationName,
    this.qualifikationID,
  });

  Map<String, dynamic> createMap() {
    return {
      'qualifikationName': qualifikationName,
      'qualifikationID': qualifikationID,
    };
  }

  QualifikationModel.fromFirestore(
      Map<String, dynamic> firestoreMap, String documentID)
      : qualifikationName = firestoreMap['qualifikationName'],
        qualifikationID = firestoreMap['qualifikationID'];
}
