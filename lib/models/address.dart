// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final String city;
  final String district;
  final GeoPoint geoPoint;
  const Address({
    required this.city,
    required this.district,
    required this.geoPoint,
  });

  Address copyWith({
    String? city,
    String? district,
    GeoPoint? geoPoint,
  }) {
    return Address(
      city: city ?? this.city,
      district: district ?? this.district,
      geoPoint: geoPoint ?? this.geoPoint,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'city': city,
      'district': district,
      'geoPoint': geoPoint,
    };
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      city: json['city'] as String,
      district: json['district'] as String,
      geoPoint: json['geoPoint'],
    );
  }

  @override
  List<Object?> get props => [city, district, geoPoint];
}
