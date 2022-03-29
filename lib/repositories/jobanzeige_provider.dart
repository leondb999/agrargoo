import 'package:agrargo/models/jobanzeige_model.dart';
import 'package:agrargo/repositories/firestore_repository.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class JobanzeigeProvider with ChangeNotifier {
  final service = FireStoreService();
  //get random IDs --> wichtig, um neue Jobanzeigen zu registrieren
  var uuid = Uuid();
  String? jobanzeigeID;
  String? auftraggeberID;
  String? hofID;
  bool? status;
  String? titel;

  /// Getters
  String? get getAuftraggeberID => auftraggeberID;
  String? get getHofID => hofID;
  bool? get getStatus => status;
  String? get getTitel => titel;

  ///ändere Titel
  void changeJobanzeigeTitel(String val) {
    titel = val;
    notifyListeners();
  }

  ///lade Jobanzeige
  loadValues(JobanzeigeModel jobanzeige) {
    jobanzeigeID = jobanzeige.jobanzeigeID;
    auftraggeberID = jobanzeige.auftraggeberID;
    hofID = jobanzeige.hofID;
    status = jobanzeige.status;
    titel = jobanzeige.titel;
  }

  void saveData() {
    if (jobanzeigeID == null) {
      String? newID = uuid.v4();
      print("saveData() -- new jobanzeige ID:$newID ");
      var newAnzeige = JobanzeigeModel(
        jobanzeigeID: newID,
        auftraggeberID: getAuftraggeberID,
        status: getStatus,
        hofID: getHofID,
        titel: getTitel,
      );
      service.saveJobanzeige(newAnzeige);
    } else {
      var updateJobanzeige = JobanzeigeModel(
        status: getStatus,
        auftraggeberID: getAuftraggeberID,
        jobanzeigeID: jobanzeigeID,
        hofID: getHofID,
        titel: getTitel,
      );
    }
  }

  ///Lösche Anzeige
  void removeData() {
    service.removeJobanzeige(jobanzeigeID!);
  }

  ///Filter Jobanzeigen by ID
  List<JobanzeigeModel> getAnzeigeByUserID(
      String? userID, List<JobanzeigeModel> jobAnzeigeList) {
    List<JobanzeigeModel> filteredList = [];
    jobAnzeigeList.forEach((anzeige) {
      if (anzeige.auftraggeberID == userID) {
        filteredList.add(anzeige);
      }
    });
    return filteredList;
  }
}
