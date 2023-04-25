import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/class_model.dart';
import 'repository_interface.dart';

class ClassRepository implements Repository<Class> {
  final _collection = FirebaseFirestore.instance.collection('classes');

  @override
  CollectionReference get collection => _collection;

  @override
  Future<Class> create(Class item) async {
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
  Future<Class> getOne(String id) async {
    final snap = await _collection.doc(id).get();
    return Class.fromJson(snap.data()!).copyWith(id: snap.id);
  }

  @override
  Future<List<Class>> list() async {
    final querySnaps = await _collection.get();
    return querySnaps.docs.map((doc) {
      return Class.fromJson(doc.data()).copyWith(id: doc.id);
    }).toList();
  }

  @override
  Future<bool> update(String id, Class item) async {
    try {
      await _collection.doc(id).update(item.toJson());
      return true;
    } catch (error) {
      log('error', error: error);
      return false;
    }
  }
}
