import 'package:consultant/views/components/consultant_card_info.dart';
import 'package:flutter/material.dart';

import '../../models/consultant_model.dart';

class ConsultantOverview extends StatelessWidget {
  const ConsultantOverview({super.key, required this.consultants, this.controller});
  final List<Consultant> consultants;
  final AnimationController? controller;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
      ),
      itemCount: consultants.length,
      itemBuilder: (context, index) {
        return ConsultantCardInfor(
          controller: controller,
          consultant: consultants[index],
          index: index,
        );
      },
    );
  }
}
