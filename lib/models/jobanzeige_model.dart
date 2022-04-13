import 'package:cloud_firestore/cloud_firestore.dart';

class JobanzeigeModel {
  String? jobanzeigeID;
  String? auftraggeberID;
  String? hofID;
  bool? status;
  String? titel;
  String? beschreibung;
  int? stundenLohn;

  List<dynamic>? qualifikationList;
  DateTime? startDate;
  DateTime? endDate;

  JobanzeigeModel({
    this.jobanzeigeID,
    this.auftraggeberID,
    this.hofID,
    this.status,
    this.titel,
    this.beschreibung,
    this.stundenLohn,
    this.qualifikationList,
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> createMap() {
    return {
      'jobanzeigeID': jobanzeigeID,
      'auftraggeberID': auftraggeberID,
      'hofID': hofID,
      'status': status,
      'titel': titel,
      'beschreibung': beschreibung,
      'stundenLohn': stundenLohn,
      'qualifikationList': qualifikationList,
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  JobanzeigeModel.fromFirestore(
      Map<String, dynamic> firestoreMap, String documentID)
      : jobanzeigeID = documentID,
        auftraggeberID = firestoreMap['auftraggeberID'],
        hofID = firestoreMap['hofID'],
        status = firestoreMap['status'],
        titel = firestoreMap['titel'],
        beschreibung = firestoreMap['beschreibung'],
        stundenLohn = firestoreMap['stundenLohn'],
        qualifikationList = firestoreMap['qualifikationList'],
        startDate = DateTime.parse(
            (firestoreMap['startDate'] as Timestamp).toDate().toString()),
        endDate = DateTime.parse(
            (firestoreMap['endDate'] as Timestamp).toDate().toString());
}
