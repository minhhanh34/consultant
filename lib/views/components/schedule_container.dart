import 'package:consultant/cubits/schedules/schedules_cubit.dart';
import 'package:consultant/cubits/schedules/schedules_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'schedule_card.dart';

class ScheduleContainer extends StatefulWidget {
  const ScheduleContainer({super.key});

  @override
  State<ScheduleContainer> createState() => _ScheduleContainerState();
}

class _ScheduleContainerState extends State<ScheduleContainer>
    with SingleTickerProviderStateMixin {
  late final TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(
      length: 3,
      vsync: this,
      animationDuration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Lịch hẹn',
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).secondaryHeaderColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              height: 48.0,
              child: TabBar(
                controller: controller,
                labelColor: Colors.white,
                unselectedLabelColor: Theme.of(context).unselectedWidgetColor,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Theme.of(context).primaryColor,
                ),
                tabs: const [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text('Sắp diễn ra'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text('Hoàn thành'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text('Đã hủy'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<ScheduleCubit, ScheduleState>(
                builder: (context, state) {
                  if (state is ScheduleInitial) {
                    context.read<ScheduleCubit>().fetchSchedules('123');
                  }
                  if (state is ScheduleLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is ScheduleFetched) {
                    return ListView.builder(
                      itemCount: state.schedules.length,
                      itemBuilder: (context, index) {
                        return ScheduleCard(
                          schedule: state.schedules[index],
                          cancel: () async => context
                              .read<ScheduleCubit>()
                              .cancelSchedule(state.schedules[index]),
                          undo: () =>
                              context.read<ScheduleCubit>().undoSchedule(),
                        );
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
