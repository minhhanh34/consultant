import 'package:consultant/cubits/parent_class/parent_class_cubit.dart';
import 'package:consultant/utils/libs_for_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../models/comment_model.dart';

class RatingConsultant extends StatefulWidget {
  const RatingConsultant({super.key, required this.classId, this.comment});
  final String classId;
  final Comment? comment;
  @override
  State<RatingConsultant> createState() => _RatingConsultantState();
}

class _RatingConsultantState extends State<RatingConsultant> {
  double rating = 3;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          RatingBar.builder(
            initialRating: 3,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              this.rating = rating;
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nội dung đánh giá',
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  final cubit = context.read<ParentClassCubit>();
                  // cubit.rateConsultant(classId, rate, content);
                },
                child: const Text('Thêm đánh giá'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
