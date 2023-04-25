
import '../models/schedule_model.dart';
import '../repositories/repository_interface.dart';

abstract class ScheduleService {
  Future<List<Schedule>> fetchParentSchedules(String id);
  Future<List<Schedule>> fetchConsultantSchedules(String id);
  Future<Schedule> createSchedule(Schedule schedule);
  Future<Schedule> deleteSchedule(Schedule schedule);
  Future<bool> update(Schedule schedule);
}

class ScheduleServiceIml extends ScheduleService {
  ScheduleServiceIml(this._repository);
  final Repository<Schedule> _repository;

  @override
  Future<List<Schedule>> fetchParentSchedules(String id) async {
    final scheduleDocs =
        await _repository.collection.where('parentId', isEqualTo: id).get();
    return scheduleDocs.docs.map((scheduleDoc) {
      return Schedule.fromJson(scheduleDoc.data() as Map<String, dynamic>)
          .copyWith(id: scheduleDoc.id);
    }).toList();
  }

  @override
  Future<List<Schedule>> fetchConsultantSchedules(String id) async {
    final scheduleDocs =
        await _repository.collection.where('consultantId', isEqualTo: id).get();
    return scheduleDocs.docs.map((scheduleDoc) {
      return Schedule.fromJson(scheduleDoc.data() as Map<String, dynamic>)
          .copyWith(id: scheduleDoc.id);
    }).toList();
  }

  @override
  Future<Schedule> createSchedule(Schedule schedule) async {
    return await _repository.create(schedule);
  }

  @override
  Future<Schedule> deleteSchedule(Schedule schedule) async {
    await _repository.delete(schedule.id!);
    return schedule;
  }

  @override
  Future<bool> update(Schedule schedule) async {
    return await _repository.update(schedule.id!, schedule);
  }
}
