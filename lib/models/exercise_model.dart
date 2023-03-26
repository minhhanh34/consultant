// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consultant/services/downloader_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Exercise extends Equatable {
  final String? id;
  final String? title;
  final DateTime timeCreated;
  final DateTime? timeIsUp;
  final List<FileName>? fileNames;
  const Exercise({
    required this.timeCreated,
    this.id,
    this.title,
    this.timeIsUp,
    this.fileNames,
  });

  Exercise copyWith({
    String? id,
    String? title,
    DateTime? timeCreated,
    DateTime? timeIsUp,
    List<FileName>? fileNames,
  }) {
    return Exercise(
      id: id ?? this.id,
      title: title ?? this.title,
      timeCreated: timeCreated ?? this.timeCreated,
      timeIsUp: timeIsUp ?? this.timeIsUp,
      fileNames: fileNames ?? this.fileNames,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'timeCreated': timeCreated,
      'timeIsUp': timeIsUp,
      'fileNames': fileNames?.map((e) => e.toJson()).toList(),
    };
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      timeIsUp: (json['timeIsUp'] as Timestamp?)?.toDate(),
      timeCreated: (json['timeCreated'] as Timestamp).toDate(),
      title: json['title'] as String?,
      fileNames: (json['fileNames'] as List?)
          ?.map((e) => FileName.fromJson(e))
          .toList(),
    );
  }

  @override
  List<Object> get props => [id!, timeCreated];
}

class FileName extends Equatable {
  final String url;
  final String name;
  final String storageName;
  final DownloadState state;

  const FileName({
    required this.url,
    required this.name,
    required this.storageName,
    this.state = DownloadState.unDownload,
  });

  FileName copyWith({
    String? url,
    String? name,
    String? storageName,
    DownloadState? state,
  }) {
    return FileName(
      url: url ?? this.url,
      name: name ?? this.name,
      storageName: storageName ?? this.storageName,
      state: state ?? this.state,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'url': url,
      'name': name,
      'storageName': storageName,
    };
  }

  factory FileName.fromJson(Map<String, dynamic> json) {
    return FileName(
      url: json['url'] as String,
      name: json['name'] as String,
      storageName: json['storageName'] as String,
    );
  }



  @override
  List<Object?> get props => [url, name, storageName];
}
