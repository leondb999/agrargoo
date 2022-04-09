class JobanzeigeModel {
  String? jobanzeigeID;
  String? auftraggeberID;
  String? hofID;
  bool? status;
  String? titel;
  int? stundenLohn;
  List<dynamic>? qualifikationList;

  JobanzeigeModel({
    this.jobanzeigeID,
    this.auftraggeberID,
    this.hofID,
    this.status,
    this.titel,
    this.stundenLohn,
    this.qualifikationList,
  });

  Map<String, dynamic> createMap() {
    return {
      'jobanzeigeID': jobanzeigeID,
      'auftraggeberID': auftraggeberID,
      'hofID': hofID,
      'status': status,
      'titel': titel,
      'stundenLohn': stundenLohn,
      'qualifikationList': qualifikationList,
    };
  }

  JobanzeigeModel.fromFirestore(
      Map<String, dynamic> firestoreMap, String documentID)
      : jobanzeigeID = documentID,
        auftraggeberID = firestoreMap['auftraggeberID'],
        hofID = firestoreMap['hofID'],
        status = firestoreMap['status'],
        titel = firestoreMap['titel'],
        stundenLohn = firestoreMap['stundenLohn'],
        qualifikationList = firestoreMap['qualifikationList'];
}
