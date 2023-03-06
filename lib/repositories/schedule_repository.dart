import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consultant/repositories/repository_interface.dart';

import '../models/schedule.dart';

class ScheduleRepository extends Repository<Schedule> {
  final collection = FirebaseFirestore.instance.collection('schedules');

  @override
  Future<Schedule> create(Schedule item) async {
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
  Future<Schedule> getOne(String id) async {
    final snap = await collection.doc(id).get();
    snap.data()!['id'] = snap.id;
    return Schedule.fromJson(snap.data()!);
  }

  @override
  Future<List<Schedule>> list() async {
    final querySnaps = await collection.get();
    return querySnaps.docs.map((doc) {
      doc.data()['id'] = doc.id;
      return Schedule.fromJson(doc.data());
    }).toList();
  }

  @override
  Future<bool> update(String id, Schedule item) async {
    try {
      await collection.doc(id).update(item.toJson());
      return true;
    } catch (error) {
      log('error', error: error);
      return false;
    }
  }
}
