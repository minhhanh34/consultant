import 'package:equatable/equatable.dart';

class Parent extends Equatable {
  final String? id;
  final String name;
  final String phone;
  final String email;

  const Parent({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
  });

  Parent copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
  }) {
    return Parent(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
    };
  }

  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
    );
  }

  @override
  List<Object?> get props => [id, name, phone, email];
}
