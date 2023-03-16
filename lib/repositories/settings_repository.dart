import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consultant/main.dart';

import '../models/parent_model.dart';
import 'repository_interface.dart';

class SettingsRepository implements Repository<Parent> {
  final _collection = FirebaseFirestore.instanceFor(app: app).collection('parents');

  @override
  Future<Parent> create(Parent item) async {
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
  Future<Parent> getOne(String id) async {
    final snap = await _collection.doc(id).get();
    snap.data()!['id'] = snap.id;
    return Parent.fromJson(snap.data()!);
  }

  @override
  Future<List<Parent>> list() async {
    final querySnaps = await _collection.get();
    return querySnaps.docs.map((doc) {
      return Parent.fromJson(doc.data()).copyWith(id: doc.id);
    }).toList();
  }

  @override
  Future<bool> update(String id, Parent item) async {
    try {
      await _collection.doc(id).update(item.toJson());
      return true;
    } catch (error) {
      log('error', error: error);
      return false;
    }
  }
}
