import 'package:consultant/models/parent_model.dart';
import 'package:consultant/views/components/circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ParentInfoScreen extends StatelessWidget {
  const ParentInfoScreen({Key? key, required this.parent}) : super(key: key);
  final Parent parent;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin'),
        elevation: 0,
      ),
      body: Padding(
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
              title: Text(parent.name),
            ),
            ListTile(
              minLeadingWidth: 36.0,
              leading: const SizedBox(
                width: 36.0,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(FontAwesomeIcons.addressCard),
                ),
              ),
              title: Text(parent.address.city),
              subtitle: Text(parent.address.district),
              trailing: Icon(
                FontAwesomeIcons.locationDot,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
