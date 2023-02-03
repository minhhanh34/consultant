import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consultant/repositories/repository_interface.dart';

import '../models/student.dart';


class StudentRepository implements Repository<Student> {
  final collection = FirebaseFirestore.instance.collection('students');

  @override
  Future<Student> create(Student item) async {
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
  Future<Student> getOne(String id) async {
    final snap = await collection.doc(id).get();
    snap.data()!['id'] = snap.id;
    return Student.fromJson(snap.data()!);
  }

  @override
  Future<List<Student>> list() async {
    final querySnaps = await collection.get();
    return querySnaps.docs.map((doc) {
      doc.data()['id'] = doc.id;
      return Student.fromJson(doc.data());
    }).toList();
  }

  @override
  Future<bool> update(String id, Student item) async {
    try {
      await collection.doc(id).update(item.toJson());
      return true;
    } catch (error) {
      log('error', error: error);
      return false;
    }
  }
}
