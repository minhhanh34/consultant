import 'package:consultant/cubits/auth/auth_cubit.dart';
import 'package:consultant/cubits/auth/auth_state.dart';
import 'package:consultant/cubits/settings/settings_cubit.dart';
import 'package:consultant/cubits/settings/settings_state.dart';
import 'package:consultant/views/components/center_circular_indicator.dart';
import 'package:consultant/views/components/circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SettingsContainer extends StatelessWidget {
  const SettingsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSignOuted) {
          context.go('/SignIn');
        }
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Cài đặt',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, state) {
                  if (state is SettingsInitial) {
                    context
                        .read<SettingsCubit>()
                        .fetchPatent(SettingsCubit.parentId);
                  }
                  if (state is SettingsLoading) {
                    return const CenterCircularIndicator();
                  }
                  if (state is SettingsParentFetched) {
                    return Column(
                      children: [
                        ListTile(
                          leading: Avatar(
                            imageUrl: state.parent.avtPath,
                            radius: 24.0,
                          ),
                          title: Text(
                            state.parent.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          subtitle: Text(state.parent.email),
                        ),
                        const SizedBox(height: 20.0),
                        ListTile(
                          onTap: () =>
                              context.push('/Info', extra: state.parent),
                          minVerticalPadding: 24.0,
                          leading: const CircleAvatar(
                            child: Icon(Icons.person_outline),
                          ),
                          title: const Text('Thông tin'),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded),
                        ),
                        const ListTile(
                          minVerticalPadding: 24.0,
                          leading: CircleAvatar(
                            child: Icon(Icons.notifications_outlined),
                          ),
                          title: Text('Thông báo'),
                          trailing: Icon(Icons.arrow_forward_ios_rounded),
                        ),
                        const ListTile(
                          minVerticalPadding: 24.0,
                          leading: CircleAvatar(
                            child: Icon(Icons.privacy_tip_outlined),
                          ),
                          title: Text('Riêng tư'),
                          trailing: Icon(Icons.arrow_forward_ios_rounded),
                        ),
                        const ListTile(
                          minVerticalPadding: 24.0,
                          leading: CircleAvatar(
                            child: Icon(Icons.settings_suggest_outlined),
                          ),
                          title: Text('Phổ biến'),
                          trailing: Icon(Icons.arrow_forward_ios_rounded),
                        ),
                        const ListTile(
                          minVerticalPadding: 24.0,
                          leading: CircleAvatar(
                            child: Icon(Icons.info_outline),
                          ),
                          title: Text('Về chúng tôi'),
                          trailing: Icon(Icons.arrow_forward_ios_rounded),
                        ),
                        ListTile(
                          onTap: () =>
                              context.read<AuthCubit>().signOut(context),
                          minVerticalPadding: 24.0,
                          leading: const CircleAvatar(
                            child: Icon(Icons.logout_outlined),
                          ),
                          title: const Text('Đăng xuất'),
                        )
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
