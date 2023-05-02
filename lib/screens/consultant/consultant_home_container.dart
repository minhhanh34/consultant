import 'package:consultant/utils/libs_for_main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../cubits/consultant_home/consultant_home_state.dart';
import '../../widgets/center_circular_indicator.dart';
import 'class_tile.dart';
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
    return SafeArea(
      child: BlocBuilder<ConsultantHomeCubit, ConsultantHomeState>(
        builder: (context, state) {
          // if (state is ConsultantHomeInitial) {
          //   cubit.initialize(context);
          // }
          if (state is ConsultantHomeFetched) {
            if (AuthCubit.infoUpdated == false) {
              context.go(
                '/ConsultantUpdate',
                extra: {
                  'consultant': state.consultant,
                  'isFirstUpdate': true,
                },
              );
              return const SizedBox();
            }
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
                      Builder(
                        builder: (context) {
                          if (state.classes.isEmpty) {
                            return Center(
                              child: Text(
                                'Chưa có thời khóa biểu',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            );
                          }
                          final now = DateTime.now();
                          final upcomingClass = state.classes
                              .where((sclass) =>
                                  sclass.subject.weekDays.contains(now.weekday))
                              .toList();
                          final screenSize = MediaQuery.of(context).size;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Visibility(
                                visible: upcomingClass.isNotEmpty,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    'Hôm nay',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ),
                              ),
                              ...upcomingClass.map(
                                (sclass) {
                                  return ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 32.0,
                                    ),
                                    minLeadingWidth: 24,
                                    leading: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16.0),
                                      child: Icon(
                                        FontAwesomeIcons.circle,
                                        size: 16,
                                      ),
                                    ),
                                    title: Text(sclass.name),
                                    subtitle: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          CupertinoIcons.timer,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(sclass.subject.time),
                                      ],
                                    ),
                                  );
                                },
                              ).toList(),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  'Tất cả',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                              Expanded(
                                child: RefreshIndicator(
                                  onRefresh: context
                                      .read<ConsultantHomeCubit>()
                                      .refresh,
                                  child: ListView.separated(
                                    separatorBuilder: (context, index) =>
                                        Divider(
                                      indent: screenSize.width * .05,
                                      color: Colors.grey,
                                      thickness: 1,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    itemCount: state.classes.length,
                                    itemBuilder: (context, index) {
                                      final sclass = state.classes[index];
                                      return ListTile(
                                        title: Text(
                                          sclass.name,
                                        ),
                                        subtitle:
                                            Text(sclass.subject.dateToString()),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      Column(
                        children: [
                          ListTile(
                            onTap: () {
                              showBottomSheet(
                                context: context,
                                builder: (context) => ClassAdditionBottomSheet(
                                    consultant: state.consultant),
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
                            child: Builder(builder: (context) {
                              if (state.classes.isEmpty) {
                                return Center(
                                  child: Text(
                                    'Chưa có lớp học nào',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                );
                              }
                              return RefreshIndicator(
                                onRefresh:
                                    context.read<ConsultantHomeCubit>().refresh,
                                child: ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  itemCount: state.classes.length,
                                  itemBuilder: (context, index) {
                                    return ClassTile(
                                      consultantClass: state.classes[index],
                                    );
                                  },
                                ),
                              );
                            }),
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
