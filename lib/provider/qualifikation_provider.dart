import 'package:agrargo/models/qualifikation_model.dart';
import 'package:agrargo/models/user_model.dart';
import 'package:agrargo/repositories/firebase_storage_repository.dart';
import 'package:agrargo/repositories/firestore_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class QualifikationProvider with ChangeNotifier {
  ///Filter QualifikationModelList by IDList in jobanzeige
  List<QualifikationModel> filterQualifikationenByID(
    List<dynamic> idList,
    List<QualifikationModel> allQualifikationModelList,
  ) {
    List<QualifikationModel> filtered = [];
    idList.forEach((id) {
      allQualifikationModelList.forEach((qualifikation) {
        if (qualifikation.qualifikationID == id) {
          print("qualifikation: ${qualifikation.qualifikationName}");

          if (filtered.contains(qualifikation) == false) {
            filtered.add(qualifikation);
          }
        }
      });
    });
    return filtered;
  }
}
