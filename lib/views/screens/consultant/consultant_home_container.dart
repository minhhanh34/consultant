import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubits/consultant_cubits/consultant_home/consultant_home_cubit.dart';
import '../../../cubits/consultant_cubits/consultant_home/consultant_home_state.dart';
import '../../components/center_circular_indicator.dart';
import 'class_tile.dart';
import '../../components/schedule_card.dart';
import 'class_addition_bottom_sheet.dart';

class ConsultantHomeContainer extends StatefulWidget {
  const ConsultantHomeContainer({
    super.key,
  });

  @override
  State<ConsultantHomeContainer> createState() =>
      _ConsultantHomeContainerState();
}

class _ConsultantHomeContainerState extends State<ConsultantHomeContainer>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ConsultantHomeCubit>();
    return SafeArea(
      child: BlocBuilder<ConsultantHomeCubit, ConsultantHomeState>(
        builder: (context, state) {
          if (state is ConsultantHomeInitial) {
            cubit.fetchData('RsuE11mvohH5PtwAokg6');
          }
          if (state is ConsultantHomeFetched) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).secondaryHeaderColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TabBar(
                      controller: _controller,
                      labelColor: Colors.white,
                      unselectedLabelColor:
                          Theme.of(context).unselectedWidgetColor,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Theme.of(context).primaryColor,
                      ),
                      tabs: const [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('Thời khóa biểu'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('Lớp học'),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _controller,
                    children: [
                      ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: state.schedules.length,
                        itemBuilder: (context, index) => ScheduleCard(
                          cancelLabel: 'Từ chối',
                          confirmLabel: 'Chấp nhận',
                          schedule: state.schedules[index],
                          cancel: () async => cubit.denySchedule(
                            state.schedules[index],
                          ),
                          undo: () => cubit.undoScheduleDeny(),
                        ),
                      ),
                      Column(
                        children: [
                          ListTile(
                            onTap: () {
                              showBottomSheet(
                                context: context,
                                builder: (context) =>
                                    ClassAdditionBottomSheet(consultant: state.consultant),
                              );
                            },
                            tileColor: Colors.grey.shade100,
                            leading: const Icon(Icons.add_circle),
                            title: Text(
                              'Thêm lớp học',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontSize: 18),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: state.classes.length,
                              itemBuilder: (context, index) {
                                return ClassTile(
                                  consultantClass: state.classes[index],
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            );
          }
          if (state is ConsultantHomeLoading) {
            return const CenterCircularIndicator();
          }
          return const CenterCircularIndicator();
        },
      ),
    );
  }
}
