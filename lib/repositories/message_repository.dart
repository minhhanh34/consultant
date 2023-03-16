import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consultant/main.dart';

import '../models/chat_room_model.dart';
import 'repository_interface.dart';

class MessageRepository extends Repository<ChatRoom> {
  final _collection =
      FirebaseFirestore.instanceFor(app: app).collection('chatrooms');

  CollectionReference get collection => _collection;

  @override
  Future<ChatRoom> create(ChatRoom item) async {
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
  Future<ChatRoom> getOne(String id) async {
    final snap = await _collection.doc(id).get();
    snap.data()!['id'] = snap.id;
    return ChatRoom.fromJson(snap.data()!);
  }

  @override
  Future<List<ChatRoom>> list() async {
    final querySnaps = await _collection.get();
    return querySnaps.docs.map((doc) {
      return ChatRoom.fromJson(doc.data()).copyWith(id: doc.id);
    }).toList();
  }

  @override
  Future<bool> update(String id, ChatRoom item) async {
    try {
      await _collection.doc(id).update(item.toJson());
      return true;
    } catch (error) {
      log('error', error: error);
      return false;
    }
  }
}
