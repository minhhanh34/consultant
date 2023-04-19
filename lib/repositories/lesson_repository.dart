import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/lesson.dart';
import 'repository_interface.dart';

class LessonRepository implements Repository<Lesson> {
  final _collection =
      FirebaseFirestore.instance.collection('lessons');

  CollectionReference get collection => _collection;

  @override
  Future<Lesson> create(Lesson item) async {
    try {
      final ref = await _collection.add(item.toJson());
      item = item.copyWith(id: ref.id);
    } catch (error) {
      log('error', error: error);
    }
    return item;
  }

  @override
  Future<bool> delete(String id) async {
    try {
      await _collection.doc(id).delete();
      return true;
    } catch (error) {
      log('error', error: error);
      return false;
    }
  }

  @override
  Future<Lesson?> getOne(String id) async {
    try {
      final snap = await _collection.doc(id).get();
      return Lesson.fromJson(snap.data()!).copyWith(id: snap.id);
    } catch (e) {
      log('error', error: e);
      return null;
    }
  }

  @override
  Future<List<Lesson>> list() async {
    final querySnaps = await _collection.get();
    return querySnaps.docs.map((doc) {
      return Lesson.fromJson(doc.data()).copyWith(id: doc.id);
    }).toList();
  }

  @override
  Future<bool> update(String id, Lesson item) async {
    try {
      await _collection.doc(id).update(item.toJson());
      return true;
    } catch (error) {
      log('error', error: error);
      return false;
    }
  }

}
