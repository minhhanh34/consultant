// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:consultant/constants/consts.dart';
import 'package:equatable/equatable.dart';

import 'package:consultant/models/address_model.dart';

class Parent extends Equatable {
  final String? id;
  final String uid;
  final String name;
  final String phone;
  final String email;
  final Address address;
  final String avtPath;
  const Parent({
    this.id,
    required this.uid,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    this.avtPath = defaultAvtPath,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address.toJson(),
      'avtPath': avtPath,
    };
  }

  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      uid: json['uid'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      address: Address.fromJson(json['address']),
      avtPath: json['avtPath'],
    );
  }

  @override
  List<Object?> get props =>
      [id, name, phone, email, avtPath, address, ];

  Parent copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    Address? address,
    String? avtPath,
    String? uid,
  }) {
    return Parent(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      avtPath: avtPath ?? this.avtPath,
    );
  }
}
