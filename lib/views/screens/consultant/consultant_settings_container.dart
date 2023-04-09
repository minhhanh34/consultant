import 'package:consultant/cubits/auth/auth_cubit.dart';
import 'package:consultant/cubits/auth/auth_state.dart';
import 'package:consultant/views/components/center_circular_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
          if (AuthCubit.currentUserId != null) {
            context
                .read<ConsultantSettingsCubit>()
                .fetchData(AuthCubit.currentUserId!);
          }
        }
        if (state is ConsultantSettingsFetched) {
          return BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthSignOuted) {
                context.go('/SignIn');
              }
            },
            child: ConsultantProfile(consultant: state.consultant),
          );
        }
        if (state is ConsultantSettingsLoading) {
          return const CenterCircularIndicator();
        }
        return const SizedBox();
      },
    );
  }
}
