import 'dart:io';
import 'dart:math';
import 'dart:developer' as dev;
import 'package:consultant/models/exercise_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class FirebaseFirestoreService {
  Future<List<FileName>> createFolderFiles(
    String folderName,
    List<String?> paths,
  );
  String getRandomString(int length);
  Future<void> downloadFileAttach(String url);
  Future<void> deleteFiles(List<String> storageNames);
}

class FirebaseStorageServiceIml extends FirebaseFirestoreService {
  final ref = FirebaseStorage.instance.ref();
  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  @override
  Future<List<FileName>> createFolderFiles(
    String folderName,
    List<String?> paths,
  ) async {
    List<Reference> refs = [];
    List<String> urls = [];
    List<String> storageNames = [];
    List<FileName> fileNames = [];
    for (var path in paths) {
      if (path != null) {
        String randomName = getRandomString(20);
        storageNames.add(randomName);
        final uploadTask = await ref
            .child(folderName)
            .child(randomName)
            .putFile(File(path))
            .catchError((e) => dev.log('error', error: e));
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

  @override
  String getRandomString(int length) => String.fromCharCodes(
        Iterable.generate(
          length,
          (_) => _chars.codeUnitAt(
            _rnd.nextInt(_chars.length),
          ),
        ),
      );

  @override
  Future<void> downloadFileAttach(String url) async {}

  @override
  Future<void> deleteFiles(List<String> storageNames) async {
    try {
      for (var name in storageNames) {
        await ref.child('exercises').child(name).delete();
      }
    } catch (e) {
      dev.log('error', error: e);
    }
  }
}
