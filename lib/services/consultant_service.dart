import 'package:consultant/repositories/repository_interface.dart';
import 'package:consultant/repositories/repository_with_subcollection.dart';
import 'package:consultant/utils/libs_for_main.dart';
import 'package:flutter/material.dart';

import '../constants/gender_types.dart';

abstract class ConsultantService {
  Future<List<Consultant>> getConsultants();
  Future<List<Consultant>> getPopularConsultants();
  Future<List<Comment>> getComments(String id);
  Future<List<Consultant>> applyFilter(List<String> filter);
  Future<Consultant> get(String id);
  Future<Consultant> getConsultantByUid(String uid);
  Future<bool> update(String id, Consultant consultant);
  Future<List<Consultant>> query(
    List<String> subjects,
    RangeValues priceRange,
    Gender gender,
    RangeValues rateRange,
    RangeValues classRange,
    String location,
  );
}

class ConsultantServiceIml extends ConsultantService {
  final Repository<Consultant> _repository;
  final RepositoryWithSubCollection<Comment> _commentRepository;

  ConsultantServiceIml(this._repository, this._commentRepository);

  @override
  Future<List<Consultant>> getConsultants() async {
    return await _repository.list();
  }

  @override
  Future<List<Consultant>> getPopularConsultants() async {
    final docSnaps = await _repository.collection
        .orderBy('rate', descending: true)
        .limit(4)
        .get();
    return docSnaps.docs.map((docSnap) {
      return Consultant.fromJson(docSnap.data() as Map<String, dynamic>)
          .copyWith(id: docSnap.id);
    }).toList();
  }

  @override
  Future<List<Comment>> getComments(String id) async {
    final cmts = await _commentRepository.list(id);
    return cmts;
  }

  @override
  Future<List<Consultant>> applyFilter(List<String> filter) async {
    filter = filter.map((element) => element.toLowerCase()).toList();
    final consultants = await _repository.list();
    final filteredConsultants = consultants.where((consultant) {
      for (var sub in consultant.subjects) {
        if (filter.every((element) =>
            element.toLowerCase().contains(sub.name.toLowerCase()))) {
          return true;
        }
      }
      return false;
    }).toList();
    return filteredConsultants;
  }

  @override
  Future<Consultant> get(String id) async {
    return await _repository.getOne(id) as Consultant;
  }

  @override
  Future<Consultant> getConsultantByUid(String uid) async {
    final snap =
        await _repository.collection.where('uid', isEqualTo: uid).get();
    return Consultant.fromJson(snap.docs.first.data() as Map<String, dynamic>)
        .copyWith(id: snap.docs.first.id);
  }

  @override
  Future<bool> update(String id, Consultant consultant) async {
    bool result = await _repository.update(id, consultant);
    if (result) {
      const secureStorage = FlutterSecureStorage(
          aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ));
      await secureStorage.write(key: 'infoUpdated', value: 'true');
      await AuthCubit.userCredential?.user?.updatePhotoURL('old');
      AuthCubit.setInfoUpdated = true;
    }
    return result;
  }

  @override
  Future<List<Consultant>> query(
    List<String> subjects,
    RangeValues priceRange,
    Gender gender,
    RangeValues rateRange,
    RangeValues classRange,
    String location,
  ) async {
    final consultants = await _repository.list();
    return consultants.where((consultant) {
      return consultant.match(
        subjects,
        priceRange,
        gender,
        rateRange,
        classRange,
        location,
      );
    }).toList();
  }
}
