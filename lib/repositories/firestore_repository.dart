import 'package:agrargo/models/hof_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agrargo/main.dart';
import 'package:agrargo/repositories/custom_exception.dart';
import 'package:agrargo/repositories/general_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/jobanzeige_model.dart';

///https://medium.com/analytics-vidhya/magic-of-flutter-provider-and-firestore-66f1a86903c3

class FireStoreService {
  FirebaseFirestore _db = FirebaseFirestore.instance;
/////////////////////////////////////////////// Jobanzeigen ///////////////////////////////////////////////
  ///get alle Jobanzeigen
  Stream<List<Jobanzeige>> getJobanzeigen() {
    final x = _db.collection(('jobAnzeigen')).get().then((value) {
      value.docs.forEach((doc) {
        print("getJobanzeigen: ${doc.id} titel: ${doc['titel']}");
      });
    });

    return _db.collection(('jobAnzeigen')).snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => Jobanzeige.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  /// Landwirt
  Stream<List<Jobanzeige>> getJobanzeigenByAuftraggeber(String userID) {
    final x = _db
        .collection(('jobAnzeigen'))
        .where('auftraggeberID', isEqualTo: userID)
        .get()
        .then((value) {
      value.docs.forEach((doc) {
        print(
            "getJobanzeigenByAuftraggeber: ${doc.id} titel: ${doc['titel']} auftraggeberID: ${doc['auftraggeberID']}");
      });
    });

    return _db
        .collection(('jobAnzeigen'))
        .where('auftraggeberID', isEqualTo: userID)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Jobanzeige.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  ///update
  Future<void> saveJobanzeige(Jobanzeige anzeige) {
    return _db
        .collection('jobAnzeigen')
        .doc(anzeige.jobanzeigeID)
        .set(anzeige.createMap());
  }

  Future<void> removeItem(String jobanzeigeID) {
    return _db.collection('jobAnzeigen').doc(jobanzeigeID).delete();
  }

/////////////////////////////////////////////// Hof ///////////////////////////////////////////////
  Stream<List<Hof>> getHoefe() {
    final x = _db.collection(('höfe')).get().then((value) {
      value.docs.forEach((doc) {
        print("getHöfe: ${doc.id} name: ${doc['hofName']}");
      });
    });

    return _db.collection(('höfe')).snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Hof.fromFirestore(doc.data(), doc.id))
        .toList());
  }

  Future<void> saveHof(Hof hof) {
    return _db.collection('höfe').doc(hof.hofID).set(hof.createMap());
  }
}
