import 'package:equatable/equatable.dart';

import '../utils/week_day_mixin.dart';

class Subject extends Equatable with WeekDayMixin {
  final String name;
  final int grade;
  final double price;
  final int duration;
  final String time;
  final List<int> weekDays;

  const Subject({
    required this.name,
    required this.grade,
    required this.weekDays,
    required this.duration,
    required this.price,
    required this.time,
  });

  Subject copyWith(
      {String? name,
      int? grade,
      double? price,
      int? duration,
      String? time,
      List<int>? weekDays}) {
    return Subject(
      name: name ?? this.name,
      grade: grade ?? this.grade,
      weekDays: weekDays ?? this.weekDays,
      duration: duration ?? this.duration,
      price: price ?? this.price,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'grade': grade,
      'price': price,
      'duration': duration,
      'time': time,
      'weekDays': weekDays,
    };
  }

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      name: json['name'],
      grade: json['grade'],
      weekDays: (json['weekDays'] as List).map((date) => date as int).toList(),
      duration: json['duration'],
      price: (json['price'] as num).toDouble(),
      time: json['time'],
    );
  }

  @override
  List<Object?> get props => [name, grade, price, duration, time, weekDays];

  String dateToString() {
    final str = weekDays.map((day) => convertWeekDay(day)).toString();
    return str.substring(1, str.length - 1);
  }
}
