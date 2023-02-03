import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Consultant extends Equatable {
  final String? id;
  final String name;
  final DateTime birthDay;
  final String address;
  const Consultant({
    this.id,
    required this.name,
    required this.birthDay,
    required this.address,
  });

  factory Consultant.fromJson(Map<String, dynamic> json) {
    return Consultant(
      name: json['name'],
      birthDay: (json['birthDay'] as Timestamp).toDate(),
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'birthDay': birthDay,
      'address': address,
    };
  }

  Consultant copyWith({
    String? id,
    String? name,
    DateTime? birthDay,
    String? address,
  }) {
    return Consultant(
      name: name ?? this.name,
      birthDay: birthDay ?? this.birthDay,
      address: address ?? this.address,
    );
  }

  @override
  List<Object?> get props => [name, birthDay, address];
}
