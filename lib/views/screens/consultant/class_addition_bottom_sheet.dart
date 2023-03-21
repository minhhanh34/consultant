import 'package:consultant/cubits/consultant_cubits/consultant_home/consultant_home_cubit.dart';
import 'package:consultant/models/class_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/const.dart';
import '../../../models/subject_model.dart';

class ClassAdditionBottomSheet extends StatefulWidget {
  const ClassAdditionBottomSheet({Key? key}) : super(key: key);
  @override
  State<ClassAdditionBottomSheet> createState() =>
      _ClassAdditionBottomSheetState();
}

class _ClassAdditionBottomSheetState extends State<ClassAdditionBottomSheet> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  late TextEditingController _classNameController;
  late TextEditingController _subjectNameController;
  late TextEditingController _gradeController;

  @override
  void initState() {
    super.initState();
    _classNameController = TextEditingController();
    _subjectNameController = TextEditingController();
    _gradeController = TextEditingController();
  }

  @override
  void dispose() {
    _classNameController.dispose();
    _subjectNameController.dispose();
    _gradeController.dispose();
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
              children: [
                const SizedBox(height: 40),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.close),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Thêm lớp học',
                    style: Theme.of(context).textTheme.headline6,
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
                    validator: validate,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      hintText: 'Lớp',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(const Size(120, 40)),
                    ),
                    onPressed: () {
                      bool valid = _key.currentState?.validate() ?? false;
                      if (valid) {
                        context.read<ConsultantHomeCubit>().createClass(Class(
                            avtPath: defaultAvtPath,
                            consultantId: 'RsuE11mvohH5PtwAokg6',
                            consultantName: 'Minh Hạnh',
                            name: _classNameController.text,
                            studentSize: 0,
                            subject: Subject(
                              name: _classNameController.text,
                              grade: 8,
                              dates: const ['Thứ hai, Thứ tư, Thứ bảy'],
                              duration: 90,
                              price: 80000,
                              time: '16h',
                            )));
                        FocusManager.instance.primaryFocus?.unfocus();
                        context.pop();
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
}
