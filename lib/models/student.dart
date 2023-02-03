import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Student extends Equatable {
  final String? id;
  final String name;
  final DateTime birthDay;
  final String address;
  final int grade;
  const Student({
    this.id,
    required this.name,
    required this.birthDay,
    required this.address,
    required this.grade,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      name: json['name'],
      birthDay: (json['birthDay'] as Timestamp).toDate(),
      address: json['address'],
      grade: json['grade'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'birthDay': birthDay,
      'address': address,
      'grade': grade,
    };
  }

  Student copyWith({
    String? id,
    String? name,
    DateTime? birthDay,
    String? address,
    int? grade,
  }) {
    return Student(
      name: name ?? this.name,
      birthDay: birthDay ?? this.birthDay,
      address: address ?? this.address,
      grade: grade ?? this.grade,
    );
  }

  @override
  List<Object?> get props => [name, birthDay, address, grade];
}
