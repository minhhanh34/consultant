import 'package:consultant/repositories/schedule_repository.dart';

import '../models/schedule_model.dart';

class ScheduleService {
  ScheduleService(this._repository);
  final ScheduleRepository _repository;

  Future<List<Schedule>> fetchParentSchedules(String id) async {
    final scheduleDocs =
        await _repository.collection.where('parentId', isEqualTo: id).get();
    return scheduleDocs.docs.map((scheduleDoc) {
      return Schedule.fromJson(scheduleDoc.data() as Map<String, dynamic>)
          .copyWith(id: scheduleDoc.id);
    }).toList();
  }

  Future<List<Schedule>> fetchConsultantSchedules(String id) async {
    final scheduleDocs =
        await _repository.collection.where('consultantId', isEqualTo: id).get();
    return scheduleDocs.docs.map((scheduleDoc) {
      return Schedule.fromJson(scheduleDoc.data() as Map<String, dynamic>)
          .copyWith(id: scheduleDoc.id);
    }).toList();
  }

  Future<Schedule> createSchedule(Schedule schedule) async {
    return await _repository.create(schedule);
  }

  Future<Schedule> deleteSchedule(Schedule schedule) async {
    await _repository.delete(schedule.id!);
    return schedule;
  }

  Future<bool> update(Schedule schedule) async {
    return await _repository.update(schedule.id!, schedule);
  }
}
