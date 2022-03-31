import 'package:agrargo/models/hof_model.dart';
import 'package:agrargo/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/jobanzeige_model.dart';

class FireStorageService {
  FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<Map<String, dynamic>>> getImageList() async {
    List<Map<String, dynamic>> files = [];
    final x = await _storage.ref().list();
    final List<Reference> allFiles = x.items;
    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();

      files.add({
        'url': fileUrl,
        'path': file.fullPath,
      });
    });

    return files;
  }
}
