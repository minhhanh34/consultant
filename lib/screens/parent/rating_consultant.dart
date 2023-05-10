import 'package:consultant/cubits/parent_class/parent_class_cubit.dart';
import 'package:consultant/utils/libs_for_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingConsultant extends StatefulWidget {
  const RatingConsultant({super.key, required this.classroom, this.comment});
  final Class classroom;
  final Comment? comment;
  @override
  State<RatingConsultant> createState() => _RatingConsultantState();
}

class _RatingConsultantState extends State<RatingConsultant> {
  late double rating;
  late double previousStateRate;
  late TextEditingController _controller;
  bool isChanging = false;
  late Comment? comment;
  @override
  void initState() {
    super.initState();
    comment = widget.comment?.copyWith();
    _controller = TextEditingController(text: comment?.content);
    rating = comment?.rate ?? 3;
    previousStateRate = rating;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Builder(
        builder: (context) {
          if (comment == null) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                RatingBar.builder(
                  initialRating: rating,
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
                    previousStateRate = this.rating;
                    this.rating = rating;
                  },
                ),
                RatingBarIndicator(
                  rating: rating,
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 50.0,
                  direction: Axis.vertical,
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
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () async {
                        final cubit = context.read<ParentClassCubit>();
                        final settingsCubit = context.read<SettingsCubit>();
                        final parent = settingsCubit.parent;
                        final newComment = await cubit.rateConsultant(
                          parent!.name,
                          parent.avtPath,
                          widget.classroom.consultantId,
                          rating,
                          _controller.text,
                          widget.classroom.parentId,
                        );
                        setState(() {
                          comment = newComment;
                          _controller.text = comment?.content ?? '';
                        });
                      },
                      child: const Text('Thêm đánh giá'),
                    ),
                  ),
                ),
              ],
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              RatingBar.builder(
                ignoreGestures: !isChanging,
                initialRating: rating,
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
                  previousStateRate = this.rating;
                  this.rating = rating;
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: isChanging
                    ? TextField(
                        controller: _controller,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Nội dung đánh giá',
                        ),
                      )
                    : Text(
                        comment!.content,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Visibility(
                        visible: isChanging,
                        child: OutlinedButton(
                          onPressed: () {
                            rating = widget.comment!.rate;
                            setState(() {
                              _controller.text = widget.comment?.content ?? '';
                              isChanging = false;
                              rating = previousStateRate;
                            });
                          },
                          child: const Text('Hủy'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () async {
                          if (isChanging) {
                            final cubit = context.read<ParentClassCubit>();
                            final newComment = comment!.copyWith(
                              rate: rating,
                              content: _controller.text,
                            );
                            await cubit.updateComment(
                              widget.classroom.consultantId,
                              comment!.id!,
                              widget.comment!.rate,
                              newComment,
                            );
                            comment = newComment;
                          }
                          setState(() {
                            isChanging = !isChanging;
                          });
                        },
                        child: Text(isChanging ? 'Xác nhận' : 'Sửa đánh giá'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
