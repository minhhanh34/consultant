import 'package:consultant/cubits/settings/settings_cubit.dart';
import 'package:consultant/cubits/settings/settings_state.dart';
import 'package:consultant/models/parent_model.dart';
import 'package:consultant/views/components/center_circular_indicator.dart';
import 'package:consultant/views/components/circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class ParentInfoScreen extends StatelessWidget {
  const ParentInfoScreen({Key? key, required this.parent}) : super(key: key);
  final Parent parent;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin'),
        elevation: 0,
        actions: [
          BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              if (state is SettingsParentFetched) {
                final parent = state.parent;
                return IconButton(
                  onPressed: () => context.push('/ParentUpdate', extra: parent),
                  icon: const Icon(Icons.edit),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const CenterCircularIndicator();
          }
          if (state is SettingsParentFetched) {
            final parent = state.parent;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: RefreshIndicator(
                onRefresh: context.read<SettingsCubit>().refresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16.0),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Avatar(
                          imageUrl: parent.avtPath,
                          radius: 36.0,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ListTile(
                        minLeadingWidth: 36.0,
                        leading: const Icon(FontAwesomeIcons.addressCard),
                        title: Text(parent.name),
                      ),
                      ListTile(
                        minLeadingWidth: 36.0,
                        leading: const Icon(FontAwesomeIcons.phone),
                        title: Text(parent.phone),
                      ),
                      ListTile(
                        minLeadingWidth: 36.0,
                        leading: const Icon(FontAwesomeIcons.envelope),
                        title: Text(parent.email),
                      ),
                      ListTile(
                        minLeadingWidth: 36.0,
                        leading: const SizedBox(
                          width: 36.0,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(FontAwesomeIcons.locationDot),
                          ),
                        ),
                        title: Text(parent.address.city),
                        subtitle: Text(parent.address.district),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.topCenter,
                  child: Avatar(
                    imageUrl: parent.avtPath,
                    radius: 36.0,
                  ),
                ),
                const SizedBox(height: 16.0),
                ListTile(
                  minLeadingWidth: 36.0,
                  leading: const Icon(FontAwesomeIcons.addressCard),
                  title: Text(parent.name),
                ),
                ListTile(
                  minLeadingWidth: 36.0,
                  leading: const Icon(FontAwesomeIcons.phone),
                  title: Text(parent.phone),
                ),
                ListTile(
                  minLeadingWidth: 36.0,
                  leading: const Icon(FontAwesomeIcons.envelope),
                  title: Text(parent.email),
                ),
                ListTile(
                  minLeadingWidth: 36.0,
                  leading: const SizedBox(
                    width: 36.0,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(FontAwesomeIcons.locationDot),
                    ),
                  ),
                  title: Text(parent.address.city),
                  subtitle: Text(parent.address.district),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
