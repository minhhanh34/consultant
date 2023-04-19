import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consultant/models/address_model.dart';
import 'package:equatable/equatable.dart';

class Student extends Equatable {
  final String? id;
  final String uid;
  final String name;
  final DateTime birthDay;
  final Address address;
  final int grade;
  final String gender;
  final List<String> classIds;
  final String parentId;
  const Student({
    this.id,
    required this.parentId,
    required this.uid,
    required this.name,
    required this.birthDay,
    required this.address,
    required this.grade,
    required this.gender,
    this.classIds = const [],
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      uid: json['uid'],
      name: json['name'],
      birthDay: (json['birthDay'] as Timestamp).toDate(),
      address: Address.fromJson(json['address']),
      grade: json['grade'],
      gender: json['gender'] as String,
      classIds: (json['classIds'] as List).map((e) => e as String).toList(),
      parentId: json['parentId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'birthDay': birthDay,
      'address': address.toJson(),
      'grade': grade,
      'gender': gender,
      'classIds': classIds,
      'parentId': parentId,
    };
  }

  Student copyWith({
    String? id,
    String? name,
    DateTime? birthDay,
    Address? address,
    int? grade,
    String? gender,
    String? uid,
    List<String>? classIds,
    String? parentId,
  }) {
    return Student(
      uid: uid ?? this.uid,
      id: id ?? this.id,
      name: name ?? this.name,
      birthDay: birthDay ?? this.birthDay,
      address: address ?? this.address,
      grade: grade ?? this.grade,
      gender: gender ?? this.gender,
      classIds: classIds ?? this.classIds,
      parentId: parentId ?? this.parentId,
    );
  }

  @override
  List<Object?> get props =>
      [name, birthDay, address, grade, gender, uid, classIds, parentId];
}
