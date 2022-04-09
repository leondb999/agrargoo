class JobanzeigeModel {
  String? jobanzeigeID;
  String? auftraggeberID;
  String? hofID;
  bool? status;
  String? titel;
  int? stundenLohn;

  JobanzeigeModel({
    this.jobanzeigeID,
    this.auftraggeberID,
    this.hofID,
    this.status,
    this.titel,
    this.stundenLohn,
  });

  Map<String, dynamic> createMap() {
    return {
      'jobanzeigeID': jobanzeigeID,
      'auftraggeberID': auftraggeberID,
      'hofID': hofID,
      'status': status,
      'titel': titel,
      'stundenLohn': stundenLohn,
    };
  }

  JobanzeigeModel.fromFirestore(
      Map<String, dynamic> firestoreMap, String documentID)
      : jobanzeigeID = documentID,
        auftraggeberID = firestoreMap['auftraggeberID'],
        hofID = firestoreMap['hofID'],
        status = firestoreMap['status'],
        titel = firestoreMap['titel'],
        stundenLohn = firestoreMap['stundenLohn'];
}
