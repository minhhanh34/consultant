import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Consultant extends Equatable {
  final String? id;
  final String name;
  final DateTime birthDay;
  final String address;
  final List<String> subjects;
  const Consultant({
    this.id,
    required this.name,
    required this.birthDay,
    required this.address,
    required this.subjects,
  });

  factory Consultant.fromJson(Map<String, dynamic> json) {
    return Consultant(
      name: json['name'],
      birthDay: (json['birthDay'] as Timestamp).toDate(),
      address: json['address'],
      subjects: (json['subjects'] as List)
          .map((subject) => subject as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'birthDay': birthDay,
      'address': address,
      'subjects': subjects,
    };
  }

  Consultant copyWith({
    String? id,
    String? name,
    DateTime? birthDay,
    String? address,
    List<String>? subjects,
  }) {
    return Consultant(
      name: name ?? this.name,
      birthDay: birthDay ?? this.birthDay,
      address: address ?? this.address,
      subjects: subjects ?? this.subjects,
    );
  }

  @override
  List<Object?> get props => [name, birthDay, address, subjects];
}
