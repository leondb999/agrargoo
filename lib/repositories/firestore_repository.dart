import 'package:agrargo/models/hof_model.dart';
import 'package:agrargo/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/jobanzeige_model.dart';

///https://medium.com/analytics-vidhya/magic-of-flutter-provider-and-firestore-66f1a86903c3

class FireStoreService {
  FirebaseFirestore _db = FirebaseFirestore.instance;

/////////////////////////////////////////////// UserModel  ///////////////////////////////////////////////
  ///Get User
  Stream<List<UserModel>> getUserList() {
    final x = _db.collection(('users')).get().then((value) {
      value.docs.forEach((doc) {
        //   print("getUserList: ${doc.id} name: ${doc['name']}");
      });
    });
    return _db.collection(('users')).snapshots().map((snapshot) => snapshot.docs
        .map((doc) => UserModel.fromFirestore(doc.data(), doc.id))
        .toList());
  }

  ///Lösche User
  Future<void> removeUser(String userID) {
    return _db.collection('users').doc(userID).delete();
  }

  ///Speicher User
  Future<void> saveUser(UserModel userModel) {
    return _db
        .collection('users')
        .doc(userModel.userID)
        .set(userModel.createMap());
  }

  Future<void> updateUser(String userID, String profilImageURL) {
    return _db
        .collection('users')
        .doc(userID)
        .update({'profilImageURL': '$profilImageURL'});
  }

/////////////////////////////////////////////// JobanzeigeModel ///////////////////////////////////////////////
  ///Get alle Jobanzeigen
  Stream<List<JobanzeigeModel>> getJobanzeigenList() {
    final x = _db.collection(('jobAnzeigen')).get().then((value) {
      value.docs.forEach((doc) {
        //    print("getJobanzeigen: ${doc.id} titel: ${doc['titel']}");
      });
    });

    return _db.collection(('jobAnzeigen')).snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => JobanzeigeModel.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  ///Get Jobanzeige By Auftraggeber
  Stream<List<JobanzeigeModel>> getJobanzeigenByAuftraggeber(String userID) {
    final x = _db
        .collection(('jobAnzeigen'))
        .where('auftraggeberID', isEqualTo: userID)
        .get()
        .then((value) {
      value.docs.forEach((doc) {
        //  print(
        //       "getJobanzeigenByAuftraggeber: ${doc.id} titel: ${doc['titel']} auftraggeberID: ${doc['auftraggeberID']}");
      });
    });

    return _db
        .collection(('jobAnzeigen'))
        .where('auftraggeberID', isEqualTo: userID)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => JobanzeigeModel.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  ///Speicher Jobanzeige
  Future<void> saveJobanzeige(JobanzeigeModel anzeige) {
    return _db
        .collection('jobAnzeigen')
        .doc(anzeige.jobanzeigeID)
        .set(anzeige.createMap());
  }

  ///Lösche Jobanzeige
  Future<void> removeJobanzeige(String jobanzeigeID) {
    return _db.collection('jobAnzeigen').doc(jobanzeigeID).delete();
  }

/////////////////////////////////////////////// HofModel ///////////////////////////////////////////////
  ///Get Hof
  Stream<List<HofModel>> getHoefeList() {
    final x = _db.collection(('höfe')).get().then((value) {
      value.docs.forEach((doc) {
        // print("getHöfe: ${doc.id} name: ${doc['hofName']}");
      });
    });

    return _db.collection(('höfe')).snapshots().map((snapshot) => snapshot.docs
        .map((doc) => HofModel.fromFirestore(doc.data(), doc.id))
        .toList());
  }

  ///Speicher Hof
  Future<void> saveHof(HofModel hof) {
    return _db.collection('höfe').doc(hof.hofID).set(hof.createMap());
  }

  ///Lösche Hof
  Future<void> removeHof(String hofID) {
    return _db.collection('höfe').doc(hofID).delete();
  }
}
