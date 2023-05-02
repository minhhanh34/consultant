import 'package:consultant/utils/libs_for_main.dart';
import 'package:consultant/widgets/center_circular_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../cubits/analytics/analytics_cubit.dart';
import '../../cubits/analytics/analytics_state.dart';
import '../../models/lesson.dart';

class ConsultantAnalyticsScreen extends StatelessWidget {
  const ConsultantAnalyticsScreen({super.key, required this.consultant});
  final Consultant consultant;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống kê'),
        elevation: 0,
      ),
      body: BlocBuilder<AnalyticsCubit, AnalyticsState>(
        builder: (context, state) {
          final cubit = context.read<AnalyticsCubit>();
          if (state is AnalyticsInitial) {
            cubit.getAnalytics(consultant);
            return const SizedBox();
          }
          if (state is AnalyticsLoading) {
            return const CenterCircularIndicator();
          }
          if (state is AnalyticsFetched) {
            return AnalyticsContainer(
              finishedLessons: state.finishedLessons,
              unfinishedLessons: state.unfinishedLessons,
              price: state.price,
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class AnalyticsContainer extends StatelessWidget {
  const AnalyticsContainer({
    super.key,
    required this.finishedLessons,
    required this.unfinishedLessons,
    required this.price,
  });
  final double price;
  final List<Lesson> finishedLessons;
  final List<Lesson> unfinishedLessons;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    const lessonsCountLabel = 'Số buổi học';
    const finishedLessonsLabel = 'Số buổi học đã hoàn thành';
    const unfinishedLessonsLabel = 'Số buổi học chờ xác nhận';
    const expectedIncomeLabel = 'Thu nhập dự kiến';
    const realIncomeLabel = 'Thu nhập thực tế';
    final lessonsCount = finishedLessons.length + unfinishedLessons.length;
    final expectedIncome =
        NumberFormat.simpleCurrency(locale: 'vi').format(lessonsCount * price);
    final realIncome = NumberFormat.simpleCurrency(locale: 'vi')
        .format(finishedLessons.length * price);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            lessonsCountLabel,
            style: textTheme.titleLarge,
          ),
          trailing: Text(
            lessonsCount.toString(),
            style: textTheme.titleLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: ListTile(
            title: Text(
              finishedLessonsLabel,
              style: textTheme.titleMedium,
            ),
            trailing: Text(
              finishedLessons.length.toString(),
              style: textTheme.titleMedium,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: ListTile(
            title: Text(
              unfinishedLessonsLabel,
              style: textTheme.titleMedium,
            ),
            trailing: Text(
              unfinishedLessons.length.toString(),
              style: textTheme.titleMedium,
            ),
          ),
        ),
        ListTile(
          title: Text(
            expectedIncomeLabel,
            style: textTheme.titleLarge,
          ),
          trailing: Text(
            expectedIncome,
            style: textTheme.titleLarge,
          ),
        ),
        ListTile(
          title: Text(
            realIncomeLabel,
            style: textTheme.titleLarge,
          ),
          trailing: Text(
            realIncome,
            style: textTheme.titleLarge,
          ),
        ),
      ],
    );
  }
}
