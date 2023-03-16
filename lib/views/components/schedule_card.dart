import 'package:consultant/cubits/app/app_state.dart';
import 'package:consultant/cubits/consultant_cubits/consultant_home/consultant_home_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/const.dart';
import '../../models/schedule_model.dart';
import 'circle_avatar.dart';

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({
    Key? key,
    required this.schedule,
    required this.cancel,
    required this.undo,
    this.cancelLabel = 'Hủy',
    this.confirmLabel = 'Đặt lại',
  }) : super(key: key);

  final Schedule schedule;
  final AsyncValueGetter<bool> cancel;
  final VoidCallback undo;
  final String cancelLabel;
  final String confirmLabel;

  String translateState(ScheduleStates state) {
    if (state == ScheduleStates.upComing) {
      return 'Sắp tới';
    }
    if (state == ScheduleStates.canceled) {
      return 'Đã hủy';
    }
    if(state == ScheduleStates.completed) {
      return 'Đã hoàn thành';
    }
    if(state == ScheduleStates.confirmed) {
      return 'Đã xác nhận';
    } 
    return 'Chờ xác nhận';
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Thông tin',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            children: [
              ListTile(
                title: Text(schedule.consultantName),
                subtitle: Text(schedule.subjectName),
                trailing: Container(
                  width: 48.0,
                  height: 48.0,
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: const Avatar(
                    imageUrl: defaultAvtPath,
                    radius: 24.0,
                  ),
                ),
              ),
              const Divider(
                color: Colors.grey,
                indent: 24.0,
                endIndent: 24.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          color: Theme.of(context).hintColor,
                        ),
                        Text(
                          '${schedule.dateTime.day}/${schedule.dateTime.month}/${schedule.dateTime.year}',
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.watch_later_rounded,
                          color: Theme.of(context).hintColor,
                        ),
                        Text(
                            '${schedule.dateTime.hour}:${schedule.dateTime.minute} ${schedule.dateTime.isUtc ? 'AM' : 'PM'}'),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.fiber_manual_record,
                          color: Colors.green,
                          size: 14,
                        ),
                        Text(translateState(schedule.state)),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 8.0,
                          right: 8.0,
                          bottom: 8.0,
                        ),
                        height: 42.0,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: InkWell(
                          onTap: () async {
                            bool result = await cancel();
                            if (result) {
                              scaffoldMessenger
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  SnackBar(
                                    content: const Text('Đã hủy lịch hẹn'),
                                    action: SnackBarAction(
                                      label: 'Hoàn tác',
                                      onPressed: () => undo(),
                                    ),
                                  ),
                                );
                            }
                          },
                          child: Center(
                            child: Text(
                              cancelLabel,
                              style: Theme.of(context).primaryTextTheme.button,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => context
                            .read<ConsultantHomeCubit>()
                            .confirmSchedule(
                              schedule.copyWith(state: ScheduleStates.confirmed),
                            ),
                        child: Container(
                          margin: const EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                            bottom: 8.0,
                          ),
                          height: 42.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme
                                ?.primary,
                          ),
                          child: Center(
                            child: Text(
                              confirmLabel,
                              style: Theme.of(context).primaryTextTheme.button,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
