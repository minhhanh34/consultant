import 'package:flutter/material.dart';

import '../../models/consultant.dart';

class ConsultantOverview extends StatelessWidget {
  const ConsultantOverview(this.consultants, {super.key});
  final List<Consultant> consultants;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: consultants.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const CircleAvatar(child: FlutterLogo()),
          title: Text(consultants[index].name),
          // subtitle: Text(consultants[index].address),
        );
      },
    );
  }
}
