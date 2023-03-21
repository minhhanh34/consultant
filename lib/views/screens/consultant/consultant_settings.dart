import 'package:consultant/views/components/center_circular_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubits/consultant_cubits/consultant_settings/consultant_settings_cubit.dart';
import '../../../cubits/consultant_cubits/consultant_settings/consultant_settings_state.dart';
import 'consultant_profile.dart';

class ConsultantSettingsContainer extends StatelessWidget {
  const ConsultantSettingsContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConsultantSettingsCubit, ConsultantSettingsState>(
      builder: (context, state) {
        if (state is ConsultantSettingsInitial) {
          context
              .read<ConsultantSettingsCubit>()
              .fetchData('RsuE11mvohH5PtwAokg6');
        }
        if (state is ConsultantSettingsFetched) {
          return ConsultantProfile(consultant: state.consultant);
        }
        if (state is ConsultantSettingsLoading) {
          return const CenterCircularIndicator();
        }
        return const SizedBox();
      },
    );
  }
}
