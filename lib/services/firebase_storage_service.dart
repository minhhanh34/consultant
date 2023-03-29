import 'dart:io';
import 'dart:math';

import 'package:consultant/main.dart';
import 'package:consultant/models/exercise_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final ref = FirebaseStorage.instanceFor(app: app).ref();
  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  Future<List<FileName>> createExerciseFiles(List<String?> paths) async {
    List<Reference> refs = [];
    List<String> urls = [];
    List<String> storageNames = [];
    List<FileName> fileNames = [];
    for (var path in paths) {
      if (path != null) {
        String randomName = getRandomString(20);
        storageNames.add(randomName);
        final uploadTask =
            await ref.child('exercises').child(randomName).putFile(File(path));
        refs.add(uploadTask.ref);
      }
    }
    for (int i = 0; i < refs.length; i++) {
      final url = await refs[i].getDownloadURL();
      urls.add(url);
      fileNames.add(FileName(
          url: url, name: paths[i] ?? '', storageName: storageNames[i]));
    }
    return fileNames;
  }

  String getRandomString(int length) => String.fromCharCodes(
        Iterable.generate(
          length,
          (_) => _chars.codeUnitAt(
            _rnd.nextInt(_chars.length),
          ),
        ),
      );

  Future<void> downloadFileAttach(String url) async {}

  Future<void> deleteFiles(List<String> storageNames) async {
    for (var name in storageNames) {
      await ref.child('exercises').child(name).delete();
    }
  }
}
