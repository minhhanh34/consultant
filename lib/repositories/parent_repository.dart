import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consultant/repositories/repository_interface.dart';

import '../models/parent.dart';


class ParentRepository implements Repository<Parent> {
  final collection = FirebaseFirestore.instance.collection('parents');

  @override
  Future<Parent> create(Parent item) async {
    try {
      final ref = await collection.add(item.toJson());
      item = item.copyWith(id: ref.id);
    } catch (error) {
      log('error', error: error);
    }
    return item;
  }

  @override
  Future<bool> delete(String id) async {
    try {
      await collection.doc(id).delete();
      return true;
    } catch (error) {
      log('error', error: error);
      return false;
    }
  }

  @override
  Future<Parent> getOne(String id) async {
    final snap = await collection.doc(id).get();
    snap.data()!['id'] = snap.id;
    return Parent.fromJson(snap.data()!);
  }

  @override
  Future<List<Parent>> list() async {
    final querySnaps = await collection.get();
    return querySnaps.docs.map((doc) {
      doc.data()['id'] = doc.id;
      return Parent.fromJson(doc.data());
    }).toList();
  }

  @override
  Future<bool> update(String id, Parent item) async {
    try {
      await collection.doc(id).update(item.toJson());
      return true;
    } catch (error) {
      log('error', error: error);
      return false;
    }
  }
}
