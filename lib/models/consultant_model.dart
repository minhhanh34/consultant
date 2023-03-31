import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consultant/models/address_model.dart';
import 'package:consultant/models/comment_model.dart';
import 'package:consultant/models/subject_model.dart';
import 'package:equatable/equatable.dart';

class Consultant extends Equatable {
  final String? id;
  final String uid;
  final String name;
  final DateTime? birthDay;
  final Address address;
  final String phone;
  final List<Subject> subjects;
  final double? rate;
  final int? raters;
  final String? avtPath;
  final List<Comment> comments = [];

  void setComments(List<Comment> comments) {
    this.comments
      ..clear()
      ..addAll(comments);
  }

  Consultant({
    required this.uid,
    this.id,
    this.rate,
    this.raters,
    this.avtPath,
    this.phone = '',
    this.name = '',
    this.birthDay,
    this.address = const Address(
      city: '',
      district: '',
      geoPoint: GeoPoint(0, 0),
    ),
    this.subjects = const [],
  });

  factory Consultant.fromJson(Map<String, dynamic> json) {
    return Consultant(
      uid: json['uid'],
      raters: json['raters'],
      rate: (json['rate'] as num?)?.toDouble(),
      phone: json['phone'],
      name: json['name'],
      birthDay: (json['birthDay'] as Timestamp?)?.toDate(),
      address: Address.fromJson(json['address']),
      subjects: (json['subjects'] as List)
          .map((subject) => Subject.fromJson(subject))
          .toList(),
      avtPath: json['avtPath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'birthDay': birthDay,
      'address': address.toJson(),
      'subjects': subjects.map((subject) => subject.toJson()).toList(),
      'phone': phone,
      'rate': rate,
      'raters': raters,
      'avtPath': avtPath,
    };
  }

  Consultant copyWith({
    String? id,
    String? name,
    DateTime? birthDay,
    Address? address,
    List<Subject>? subjects,
    String? phone,
    double? rate,
    int? raters,
    String? avtPath,
    String? uid,
  }) {
    return Consultant(
      uid: uid ?? this.uid,
      id: id ?? this.id,
      avtPath: avtPath ?? this.avtPath,
      rate: rate ?? this.rate,
      raters: raters ?? this.raters,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      birthDay: birthDay ?? this.birthDay,
      address: address ?? this.address,
      subjects: subjects ?? this.subjects,
    );
  }

  @override
  List<Object?> get props => [uid, name, birthDay, address, subjects, phone];

  String subjectsToString() {
    StringBuffer str = StringBuffer();
    for (int i = 0; i < subjects.length; i++) {
      if (i == subjects.length - 1) {
        str.write(subjects[i].name);
        break;
      }
      str.write('${subjects[i].name}, ');
    }
    return str.toString();
  }
}
