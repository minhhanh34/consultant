import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/student_model.dart';
import 'repository_with_subcollection.dart';

class ClassStudentRepository implements RepositoryWithSubCollection<Student> {
  final _collection = FirebaseFirestore.instance.collection('classes');
  final _subCollection = 'students';

  CollectionReference get collection => _collection;
  String get subCollection => _subCollection;
  @override
  Future<Student> create(String id, Student item) async {
    try {
      await _collection
          .doc(id)
          .collection(_subCollection)
          .doc(item.id)
          .set(item.toJson());
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
  Future<Student> getOne(String id, String subId) async {
    final snap =
        await _collection.doc(id).collection(_subCollection).doc(subId).get();
    snap.data()!['id'] = snap.id;
    return Student.fromJson(snap.data()!);
  }

  @override
  Future<List<Student>> list(String id) async {
    try {
      final querySnaps =
          await _collection.doc(id).collection(_subCollection).get();
      return querySnaps.docs.map((doc) {
        return Student.fromJson(doc.data()).copyWith(id: doc.id);
      }).toList();
    } catch (error) {
      log('error', error: error);
      return [];
    }
  }

  @override
  Future<bool> update(String id, String subId, Student item) async {
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
