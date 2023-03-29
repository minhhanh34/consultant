import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consultant/main.dart';

import '../models/exercise_model.dart';
import 'repository_with_subcollection.dart';

class ClassExerciseRepository implements RepositoryWithSubCollection<Exercise> {
  final _collection =
      FirebaseFirestore.instanceFor(app: app).collection('classes');
  final _subCollection = 'exercises';

  CollectionReference get collection => _collection;
  String get subCollection => _subCollection;
  @override
  Future<Exercise> create(String id, Exercise item) async {
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
  Future<Exercise> getOne(String id, String subId) async {
    final snap =
        await _collection.doc(id).collection(_subCollection).doc(subId).get();
    snap.data()!['id'] = snap.id;
    return Exercise.fromJson(snap.data()!);
  }

  @override
  Future<List<Exercise>> list(String id) async {
    try {
      final querySnaps = await _collection
          .doc(id)
          .collection(_subCollection)
          .orderBy('timeCreated', descending: true)
          .get();

      return querySnaps.docs.map((doc) {
        return Exercise.fromJson(doc.data()).copyWith(id: doc.id);
      }).toList();
    } catch (error) {
      log('error', error: error);
      return [];
    }
  }

  @override
  Future<bool> update(String id, String subId, Exercise item) async {
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
