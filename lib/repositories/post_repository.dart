import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/post_model.dart';
import 'repository_interface.dart';

class PostRepository implements Repository<Post> {
  final _collection =
      FirebaseFirestore.instance.collection('posts');
  
  @override
  CollectionReference get collection => _collection;

  @override
  Future<Post> create(Post item) async {
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
  Future<Post> getOne(String id) async {
    final snap = await _collection.doc(id).get();
    snap.data()!['id'] = snap.id;
    return Post.fromJson(snap.data()!);
  }

  @override
  Future<List<Post>> list() async {
    final querySnaps = await _collection.orderBy('time', descending: true).get();
    return querySnaps.docs.map((doc) {
      return Post.fromJson(doc.data()).copyWith(id: doc.id);
    }).toList();
  }

  @override
  Future<bool> update(String id, Post item) async {
    try {
      await _collection.doc(id).update(item.toJson());
      return true;
    } catch (error) {
      log('error', error: error);
      return false;
    }
  }
}
