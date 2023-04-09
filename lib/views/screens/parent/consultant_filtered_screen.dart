import 'package:consultant/cubits/filter/filter_cubit.dart';
import 'package:consultant/views/components/consultants_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubits/filter/filter_state.dart';

class ConsultantsFilteredScreen extends StatelessWidget {
  const ConsultantsFilteredScreen({Key? key, required this.filtered})
      : super(key: key);
  final List<String> filtered;
  @override
  Widget build(BuildContext context) {
    context.read<FilterCubit>().applyFilter(filtered);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          filtered.toString().substring(1, filtered.toString().length - 1),
        ),
        elevation: 0,
      ),
      body: BlocBuilder<FilterCubit, FilterState>(
        builder: (context, state) {
          if (state is FilterInitial) {
            context.read<FilterCubit>().applyFilter(filtered);
          }
          if (state is FilterLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is FilteredConsultants) {
            if (state.consultants.isEmpty) {
              return Center(
                child: Text(
                  'Không tìm thấy gia sư nào',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              );
            }
            return ConsultantOverview(consultants: state.consultants);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
