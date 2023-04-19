import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consultant/repositories/repository_interface.dart';

import '../models/schedule_model.dart';

class ScheduleRepository extends Repository<Schedule> {
  final _collection =
      FirebaseFirestore.instance.collection('schedules');

  CollectionReference get collection => _collection;

  @override
  Future<Schedule> create(Schedule item) async {
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
  Future<Schedule> getOne(String id) async {
    final snap = await _collection.doc(id).get();
    snap.data()!['id'] = snap.id;
    return Schedule.fromJson(snap.data()!);
  }

  @override
  Future<List<Schedule>> list() async {
    final querySnaps = await _collection.get();
    return querySnaps.docs.map((doc) {
      return Schedule.fromJson(doc.data()).copyWith(id: doc.id);
    }).toList();
  }

  @override
  Future<bool> update(String id, Schedule item) async {
    try {
      await _collection.doc(id).update(item.toJson());
      return true;
    } catch (error) {
      log('error', error: error);
      return false;
    }
  }
}
