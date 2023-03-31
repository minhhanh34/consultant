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
  const Student({
    this.id,
    required this.uid,
    required this.name,
    required this.birthDay,
    required this.address,
    required this.grade,
    required this.gender,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      uid: json['uid'],
      name: json['name'],
      birthDay: (json['birthDay'] as Timestamp).toDate(),
      address: Address.fromJson(json['address']),
      grade: json['grade'],
      gender: json['gender'] as String,
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
  }) {
    return Student(
      uid: uid ?? this.uid,
      id: id ?? this.id,
      name: name ?? this.name,
      birthDay: birthDay ?? this.birthDay,
      address: address ?? this.address,
      grade: grade ?? this.grade,
      gender: gender ?? this.gender,
    );
  }

  @override
  List<Object?> get props => [name, birthDay, address, grade, gender, uid];
}
