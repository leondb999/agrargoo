import 'package:agrargo/models/hof_model.dart';
import 'package:agrargo/repositories/firestore_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class HofProvider with ChangeNotifier {
  final service = FireStoreService();
  var uuid = Uuid();

  String? hofID;
  String? besitzerID;
  String? hofName;
  String? standort;

  ///Getters
  String? get getHofID => hofID;
  String? get getBesitzerID => besitzerID;
  String? get getHofName => hofName;
  String? get getStandort => standort;

  void saveData() {
    if (hofID == null) {
      String? newID = uuid.v4();
      print("saveData() -- new jobanzeige ID:$newID ");
      var newHof = Hof(
        hofID: newID,
        besitzerID: getBesitzerID,
        hofName: getHofName,
        standort: getStandort,
      );
      service.saveHof(newHof);
    } else {
      var updateJobanzeige = Hof(
        hofID: getHofID,
        besitzerID: getBesitzerID,
        hofName: getHofName,
        standort: getStandort,
      );
    }
  }

  ///Filter Höfe nach Nutzer ID
  List<Hof> getHofByUserID(String? userID, List<Hof> hofListe) {
    List<Hof> filteredList = [];
    hofListe.forEach((hof) {
      if (hof.besitzerID == userID) {
        filteredList.add(hof);
      }
    });
    return filteredList;
  }
}
