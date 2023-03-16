import 'package:equatable/equatable.dart';

class Subject extends Equatable {
  final String name;
  final int grade;
  final double price;
  final int duration;
  final String time;
  final List<String> dates;

  const Subject({
    required this.name,
    required this.grade,
    required this.dates,
    required this.duration,
    required this.price,
    required this.time,
  });

  Subject copyWith({
    String? name,
    int? grade,
    double? price,
    int? duration,
    String? time,
    List<String>? dates,
  }) {
    return Subject(
      name: name ?? this.name,
      grade: grade ?? this.grade,
      dates: dates ?? this.dates,
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
      'dates': dates.map((date) => date.toString()).toList(),
    };
  }

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      name: json['name'],
      grade: json['grade'],
      dates: (json['dates'] as List).map((date) => date as String).toList(),
      duration: json['duration'],
      price: (json['price'] as num).toDouble(),
      time: json['time'],
    );
  }

  @override
  List<Object?> get props => [name, grade, price, duration, time, dates];

  String dateToString() {
    final str = dates.toString();
    return str.substring(1, str.length - 1);
  }
}
