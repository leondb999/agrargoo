class QualifikationModel {
  final String? qualifikationName;

  QualifikationModel({
    this.qualifikationName,
  });

  Map<String, dynamic> createMap() {
    return {
      'qualifikationName': qualifikationName,
    };
  }

  QualifikationModel.fromFirestore(
      Map<String, dynamic> firestoreMap, String documentID)
      : qualifikationName = firestoreMap['qualifikationName'];
}
