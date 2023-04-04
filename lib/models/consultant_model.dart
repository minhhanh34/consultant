import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consultant/models/address_model.dart';
import 'package:consultant/models/comment_model.dart';
import 'package:consultant/models/subject_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../views/components/search_bottom_sheet.dart';

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
  final String gender;

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
    this.gender = 'Nam',
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
      gender: json['gender'],
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
      'gender': gender,
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
    String? gender,
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
      gender: gender ?? this.gender,
    );
  }

  @override
  List<Object?> get props =>
      [uid, name, birthDay, address, subjects, phone, gender];

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

  bool match(
    List<String> subjects,
    RangeValues priceRange,
    Gender gender,
    RangeValues rateRange,
    RangeValues classRange,
    String location,
  ) {
    if (!checkSubject(subjects)) return false;
    if (!checkPriceRange(priceRange)) return false;
    if (!checkGender(gender)) return false;
    if (!checkRateRange(rateRange)) return false;
    if (!checkClassRange(classRange)) return false;
    if (!checkLocation(location)) return false;
    return true;
  }

  bool checkSubject(List<String> subjects) {
    final subjectNams =
        this.subjects.map((subject) => subject.name.toLowerCase()).toList();
    final lowerCaseSubjects = subjects.map((e) => e.toLowerCase()).toList();
    for (var element in subjectNams) {
      if (lowerCaseSubjects.contains(element)) {
        return true;
      }
    }
    return false;
  }

  bool checkPriceRange(RangeValues priceRange) {
    final prices = subjects.map((subject) => subject.price).toList();
    for (var price in prices) {
      if (price >= priceRange.start && price <= priceRange.end) {
        return true;
      }
    }
    return false;
  }

  bool checkGender(Gender gender) {
    if (gender == Gender.all) return true;
    final exchangedGender = extractGender(gender);
    if (exchangedGender.toLowerCase() == this.gender.toLowerCase()) {
      return true;
    }
    return false;
  }

  String extractGender(Gender gender) {
    if (gender == Gender.male) return 'Nam';
    if (gender == Gender.female) return 'Nữ';
    return 'Tất cả';
  }

  bool checkRateRange(RangeValues rateRange) {
    if (rate == null) return false;
    if (rate! >= rateRange.start && rate! <= rateRange.end) return true;
    return false;
  }

  bool checkClassRange(RangeValues classRange) {
    final grades = subjects.map((subject) => subject.grade).toList();
    for (var grade in grades) {
      if (grade >= classRange.start && grade <= classRange.end) return true;
    }
    return false;
  }

  bool checkLocation(String location) {
    if (location == 'Tất cả') return true;
    if (address.city.toLowerCase() == location.toLowerCase()) return true;
    return false;
  }
}
