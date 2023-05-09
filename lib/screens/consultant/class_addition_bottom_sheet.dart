import 'package:consultant/cubits/consultant_home/consultant_home_cubit.dart';
import 'package:consultant/models/class_model.dart';
import 'package:consultant/models/consultant_model.dart';
import 'package:consultant/repositories/parent_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../constants/consts.dart';
import '../../models/subject_model.dart';

class ClassAdditionBottomSheet extends StatefulWidget {
  const ClassAdditionBottomSheet({Key? key, required this.consultant})
      : super(key: key);
  final Consultant consultant;
  @override
  State<ClassAdditionBottomSheet> createState() =>
      _ClassAdditionBottomSheetState();
}

class _ClassAdditionBottomSheetState extends State<ClassAdditionBottomSheet> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  late TextEditingController _classNameController;
  late TextEditingController _subjectNameController;
  late TextEditingController _gradeController;
  late TextEditingController _durationController;
  late TextEditingController _priceController;
  late TextEditingController _parentIdController;
  TimeOfDay? time = const TimeOfDay(hour: 8, minute: 0);
  // List<bool> days = List.filled(7, false);

  bool isInvalid = false;

  List<Map> dayCheckBoxs = [
    {
      'weekDays': 0,
      'title': 'T2',
      'value': false,
    },
    {
      'weekDays': 1,
      'title': 'T3',
      'value': false,
    },
    {
      'weekDays': 2,
      'title': 'T4',
      'value': false,
    },
    {
      'weekDays': 3,
      'title': 'T5',
      'value': false,
    },
    {
      'weekDays': 4,
      'title': 'T6',
      'value': false,
    },
    {
      'weekDays': 5,
      'title': 'T7',
      'value': false,
    },
    {
      'weekDays': 6,
      'title': 'CN',
      'value': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _classNameController = TextEditingController();
    _subjectNameController = TextEditingController();
    _gradeController = TextEditingController();
    _durationController = TextEditingController();
    _priceController = TextEditingController();
    _parentIdController = TextEditingController();
  }

  @override
  void dispose() {
    _priceController.dispose();
    _durationController.dispose();
    _classNameController.dispose();
    _subjectNameController.dispose();
    _gradeController.dispose();
    _parentIdController.dispose();
    super.dispose();
  }

  String? validate(String? value) {
    if (value == null || value.isEmpty) return 'Không được bỏ trống';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 24,
        child: Form(
          key: _key,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.close),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Thêm lớp học',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _classNameController,
                    validator: validate,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      hintText: 'Tên lớp học',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _subjectNameController,
                    validator: validate,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      hintText: 'Tên môn học',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _gradeController,
                    validator: (value) {
                      String? result = validate(value);
                      if (result != null) return result;
                      if (int.tryParse(value!) == null) {
                        return 'Không họp lệ';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      hintText: 'Lớp',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _parentIdController,
                    validator: (value) {
                      return validate(value);
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      hintText: 'Mã phụ huynh',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Buổi học',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 2,
                    children: dayCheckBoxs.map((e) {
                      return Column(
                        children: [
                          Text(e['title']),
                          Checkbox(
                            value: e['value'],
                            onChanged: (value) {
                              setState(() {
                                e['value'] = value ?? e['value'];
                              });
                            },
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  leading: Text(
                    'Giờ học',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  title: Text(time?.format(context) ?? ''),
                  trailing: IconButton(
                    onPressed: () async {
                      time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      setState(() {});
                    },
                    icon: const Icon(Icons.timer_sharp, color: Colors.indigo),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Text(
                        'Thời gian',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(width: 8.0),
                      SizedBox(
                        width: 120,
                        height: 32,
                        child: TextFormField(
                          controller: _durationController,
                          // validator: (value) {
                          //   String? result = validate(value);
                          //   if (result != null) return result;
                          //   if (int.tryParse(_durationController.text) ==
                          //       null) {
                          //     return 'không hợp lệ';
                          //   }
                          //   return null;
                          // },
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        'phút',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Text(
                        'Giá(buổi)',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(width: 8.0),
                      SizedBox(
                        width: 120,
                        height: 32,
                        child: TextFormField(
                          controller: _priceController,
                          // validator: (value) {
                          //   String? result = validate(value);
                          //   if (result != null) return result;
                          //   if (double.tryParse(_durationController.text) ==
                          //       null) {
                          //     return 'không hợp lệ';
                          //   }
                          //   return null;
                          // },
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'vnd',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: isInvalid,
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'Thông tin chưa hợp lệ ',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 16,
                  ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all(
                          const Size(double.infinity, 48.0)),
                      fixedSize: MaterialStateProperty.all(const Size(120, 40)),
                    ),
                    onPressed: () async {
                      bool valid = _key.currentState?.validate() ?? false;
                      valid == valid && checkDurationAndPrice();
                      if (valid) {
                        final parentRepo = ParentRepository();
                        final snap = await parentRepo.collection
                            .doc(_parentIdController.text)
                            .get();
                        if (!snap.exists) {
                          setState(() {
                            isInvalid = true;
                          });
                          return;
                        }
                        if (!mounted) return;
                        context.read<ConsultantHomeCubit>().createClass(
                              Class(
                                parentId: _parentIdController.text,
                                studentIds: const [],
                                avtPath: defaultClassImageUrl,
                                consultantId: widget.consultant.id!,
                                consultantName: widget.consultant.name,
                                name: _classNameController.text,
                                studentSize: 0,
                                subject: Subject(
                                  name: _subjectNameController.text,
                                  grade: int.parse(_gradeController.text),
                                  weekDays: weekDays(),
                                  duration: int.parse(_durationController.text),
                                  price: double.parse(_priceController.text),
                                  time: time?.format(context) ?? '8:00',
                                ),
                              ),
                            );
                        FocusManager.instance.primaryFocus?.unfocus();
                        context.pop();
                      } else {
                        setState(() {
                          isInvalid = true;
                        });
                      }
                    },
                    child: const Text('Thêm'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<int> weekDays() {
    List<int> results = <int>[];
    for (var day in dayCheckBoxs) {
      if (day['value']) {
        results.add(day['weekDays']);
      }
    }
    return results;
  }

  bool checkDurationAndPrice() {
    if (_durationController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        int.tryParse(_durationController.text) != null &&
        double.tryParse(_priceController.text) != null) {
      return true;
    }
    return false;
  }
}
