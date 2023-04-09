import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consultant/main.dart';

import '../models/submission_model.dart';
import 'repository_with_subcollection.dart';

class ClassSubmissionRepository
    implements RepositoryWithSubCollection<Submission> {
  final _collection =
      FirebaseFirestore.instanceFor(app: app).collection('classes');
  final _subCollection = 'submissions';

  CollectionReference get collection => _collection;
  String get subCollection => _subCollection;
  @override
  Future<Submission> create(String id, Submission item) async {
    try {
      final ref = await _collection
          .doc(id)
          .collection(_subCollection)
          .add(item.toJson());
      item = item.copyWith(id: ref.id);
    } catch (error) {
      log('error', error: error);
    }
    return item;
  }

  @override
  Future<bool> delete(String id, String subId) async {
    try {
      await _collection.doc(id).collection(_subCollection).doc(subId).delete();
      return true;
    } catch (error) {
      log('error', error: error);
      return false;
    }
  }

  @override
  Future<Submission> getOne(String id, String subId) async {
    final snap =
        await _collection.doc(id).collection(_subCollection).doc(subId).get();
    snap.data()!['id'] = snap.id;
    return Submission.fromJson(snap.data()!);
  }

  @override
  Future<List<Submission>> list(String id) async {
    try {
      final querySnaps =
          await _collection.doc(id).collection(_subCollection).get();

      return querySnaps.docs.map((doc) {
        return Submission.fromJson(doc.data()).copyWith(id: doc.id);
      }).toList();
    } catch (error) {
      log('error', error: error);
      return [];
    }
  }

  @override
  Future<bool> update(String id, String subId, Submission item) async {
    try {
      await _collection
          .doc(id)
          .collection(_subCollection)
          .doc(subId)
          .update(item.toJson());
      return true;
    } catch (error) {
      log('error', error: error);
      return false;
    }
  }
}
