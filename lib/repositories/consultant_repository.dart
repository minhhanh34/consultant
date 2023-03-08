import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consultant/models/consultant.dart';
import 'package:consultant/repositories/repository_interface.dart';

class ConsultantRepository implements Repository<Consultant> {
  final _collection = FirebaseFirestore.instance.collection('consultants');

  @override
  Future<Consultant> create(Consultant item) async {
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
  Future<Consultant> getOne(String id) async {
    final snap = await _collection.doc(id).get();
    snap.data()!['id'] = snap.id;
    return Consultant.fromJson(snap.data()!);
  }

  @override
  Future<List<Consultant>> list() async {
    final querySnaps = await _collection.get();
    return querySnaps.docs.map((doc) {
      return Consultant.fromJson(doc.data()).copyWith(id: doc.id);
    }).toList();
  }

  @override
  Future<bool> update(String id, Consultant item) async {
    try {
      await _collection.doc(id).update(item.toJson());
      return true;
    } catch (error) {
      log('error', error: error);
      return false;
    }
  }
}
