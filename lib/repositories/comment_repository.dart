import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consultant/main.dart';
import 'package:consultant/repositories/repository_with_subcollection.dart';

import '../models/comment_model.dart';

class CommentRepository implements RepositoryWithSubCollection<Comment> {
  final _collection = FirebaseFirestore.instanceFor(app: app).collection('consultants');
  final _subCollection = 'comments';
  @override
  Future<Comment> create(String id, Comment item) async {
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
  Future<Comment> getOne(String id, String subId) async {
    final snap =
        await _collection.doc(id).collection(_subCollection).doc(subId).get();
    snap.data()!['id'] = snap.id;
    return Comment.fromJson(snap.data()!);
  }

  @override
  Future<List<Comment>> list(String id) async {
    try {
      final querySnaps =
          await _collection.doc(id).collection(_subCollection).get();
      return querySnaps.docs.map((doc) {
        return Comment.fromJson(doc.data()).copyWith(id: doc.id);
      }).toList();
    } catch (error) {
      log('error', error: error);
      return [];
    }
  }

  @override
  Future<bool> update(String id, String subId, Comment item) async {
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
