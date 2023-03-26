import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Student extends Equatable {
  final String? id;
  final String name;
  final DateTime birthDay;
  final String address;
  final int grade;
  final String gender;
  const Student({
    this.id,
    required this.name,
    required this.birthDay,
    required this.address,
    required this.grade,
    required this.gender,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      name: json['name'],
      birthDay: (json['birthDay'] as Timestamp).toDate(),
      address: json['address'],
      grade: json['grade'],
      gender: json['gender'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'birthDay': birthDay,
      'address': address,
      'grade': grade,
      'gender': gender,
    };
  }

  Student copyWith({
    String? id,
    String? name,
    DateTime? birthDay,
    String? address,
    int? grade,
    String? gender,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      birthDay: birthDay ?? this.birthDay,
      address: address ?? this.address,
      grade: grade ?? this.grade,
      gender: gender ?? this.gender,
    );
  }

  @override
  List<Object?> get props => [name, birthDay, address, grade, gender];
}


