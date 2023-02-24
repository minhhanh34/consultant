import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsContainer extends StatelessWidget {
  const SettingsContainer({super.key});

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
                'Settings',
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const CircleAvatar(
                radius: 24.0,
                child: FlutterLogo(),
              ),
              title: Text(
                'Consultant name',
                style: Theme.of(context).textTheme.headline6,
              ),
              subtitle: const Text('Profile'),
            ),
            const SizedBox(height: 20.0),
            const ListTile(
              minVerticalPadding: 24.0,
              leading: CircleAvatar(
                child: Icon(Icons.person_outline),
              ),
              title: Text('Profile'),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
            ),
            const ListTile(
              minVerticalPadding: 24.0,
              leading: CircleAvatar(
                child: Icon(Icons.notifications_outlined),
              ),
              title: Text('Notification'),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
            ),
            const ListTile(
              minVerticalPadding: 24.0,
              leading: CircleAvatar(
                child: Icon(Icons.privacy_tip_outlined),
              ),
              title: Text('Privacy'),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
            ),
            const ListTile(
              minVerticalPadding: 24.0,
              leading: CircleAvatar(
                child: Icon(Icons.settings_suggest_outlined),
              ),
              title: Text('General'),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
            ),
            const ListTile(
              minVerticalPadding: 24.0,
              leading: CircleAvatar(
                child: Icon(Icons.info_outline),
              ),
              title: Text('About us'),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
            ),
            ListTile(
              onTap: () => context.go('/Welcome'),
              minVerticalPadding: 24.0,
              leading: const CircleAvatar(
                child: Icon(Icons.logout_outlined),
              ),
              title: const Text('Log out'),
            )
          ],
        ),
      ),
    );
  }
}
