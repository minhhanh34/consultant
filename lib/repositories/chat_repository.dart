import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/message_model.dart';
import 'repository_with_subcollection.dart';

class ChatRepository implements RepositoryWithSubCollection<Message> {
  final _collection = FirebaseFirestore.instance.collection('chatrooms');
  final _subCollection = 'messages';

  CollectionReference get collection => _collection;
  String get subCollection => _subCollection;
  @override
  Future<Message> create(String id, Message item) async {
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
  Future<Message> getOne(String id, String subId) async {
    final snap =
        await _collection.doc(id).collection(_subCollection).doc(subId).get();
    snap.data()!['id'] = snap.id;
    return Message.fromJson(snap.data()!);
  }

  @override
  Future<List<Message>> list(String id) async {
    try {
      final querySnaps =
          await _collection.doc(id).collection(_subCollection).get();
      return querySnaps.docs.map((doc) {
        return Message.fromJson(doc.data()).copyWith(id: doc.id);
      }).toList();
    } catch (error) {
      log('error', error: error);
      return [];
    }
  }

  @override
  Future<bool> update(String id, String subId, Message item) async {
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
