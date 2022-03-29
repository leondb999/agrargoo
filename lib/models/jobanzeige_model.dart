class Jobanzeige {
  String? jobanzeigeID;
  String? auftraggeberID;
  String? hofID;
  bool? status;
  String? titel;

  Jobanzeige(
      {this.jobanzeigeID,
      this.auftraggeberID,
      this.hofID,
      this.status,
      this.titel});

  Map<String, dynamic> createMap() {
    return {
      'jobanzeigeID': jobanzeigeID,
      'auftraggeberID': auftraggeberID,
      'hofID': hofID,
      'status': status,
      'titel': titel,
    };
  }

  Jobanzeige.fromFirestore(Map<String, dynamic> firestoreMap, String documentID)
      : jobanzeigeID = documentID,
        auftraggeberID = firestoreMap['auftraggeberID'],
        hofID = firestoreMap['hofID'],
        status = firestoreMap['status'],
        titel = firestoreMap['titel'];
}
