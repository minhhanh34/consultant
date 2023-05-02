import 'package:consultant/models/address_model.dart';
import 'package:consultant/utils/libs_for_main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StudentUpdateInformation extends StatefulWidget {
  const StudentUpdateInformation({
    super.key,
    required this.student,
    this.isFirstUpdate = false,
  });
  final Student student;
  final bool isFirstUpdate;
  @override
  State<StudentUpdateInformation> createState() =>
      StudentUpdateInformationState();
}

class StudentUpdateInformationState extends State<StudentUpdateInformation> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late int grade;
  late String gender;
  late DateTime dayOfBirth;
  late String city;
  late String district;
  late double longitude;
  late double latitude;

  late TextEditingController dateController;

  @override
  void initState() {
    super.initState();
    String studentDayOfBirth = DateFormat('dd/MM/yyyy').format(
      widget.student.birthDay,
    );
    dateController = TextEditingController(text: studentDayOfBirth);
    name = widget.student.name;
    grade = widget.student.grade;
    gender = widget.student.gender;
    dayOfBirth = widget.student.birthDay;
    city = widget.student.address.city;
    district = widget.student.address.district;
    longitude = widget.student.address.geoPoint.longitude;
    latitude = widget.student.address.geoPoint.latitude;
  }

  final heightBox16 = const SizedBox(height: 16);
  final widthBox16 = const SizedBox(width: 16);

  String? _checkNullValiate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Không được bỏ trống';
    }
    return null;
  }

  InputDecoration _decorateWithLabel(String? label) {
    return InputDecoration(
      hintText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  void _submit(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    StudentHomeCubit cubit = context.read<StudentHomeCubit>();
    FormState? form = _formKey.currentState;
    bool? isValid = form?.validate();
    if (isValid == null || !isValid) return;
    form?.save();
    Student newStudent = widget.student.copyWith(
      name: name,
      address: Address(
        city: city,
        district: district,
        geoPoint: GeoPoint(latitude, longitude),
      ),
      birthDay: dayOfBirth,
      gender: gender,
      grade: grade,
    );
    if (await confirmDialog()) {
      await cubit.updateStudent(widget.student.id!, newStudent);
      if (!mounted) return;
      if (widget.isFirstUpdate) {
        context.go('/Student');
      } else {
        context.pop();
      }
    }
  }

  Future<bool> confirmDialog() async {
    const message = 'Bạn có chắc muốn cập nhật?';
    const yes = 'Có';
    const no = 'Không';
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: const Text(message),
              actions: [
                TextButton(
                  onPressed: () => GoRouter.of(context).pop(true),
                  child: const Text(yes),
                ),
                TextButton(
                  onPressed: () => GoRouter.of(context).pop(false),
                  child: const Text(no),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void _pickDate() async {
    DateTime initialDate = DateTime(2001);
    DateTime firstDate = DateTime(1990);
    DateTime lastDate = DateTime.now();
    DateTime? datePicked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (datePicked != null) {
      dayOfBirth = datePicked;
      dateController.text = DateFormat('dd/MM/yyyy').format(datePicked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    const updateInforLabel = 'Cập nhật thông tin';
    const nameLabel = 'Tên';
    const gradeLabel = 'Lớp';
    const genderLabel = 'Giới tính';
    const birthDayLabel = 'Ngày sinh';
    const cityLabel = 'Thành phố';
    const districtLabel = 'Huyện';
    const locationLabel = 'Vị trí trên bản đồ';
    const updateLabel = 'Cập nhật';
    const cancelLabel = 'Hủy';
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  heightBox16,
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      updateInforLabel,
                      style: textTheme.titleLarge,
                    ),
                  ),
                  heightBox16,
                  TextFormField(
                    initialValue: name,
                    validator: _checkNullValiate,
                    decoration: _decorateWithLabel(nameLabel),
                    onSaved: (value) => name = value!,
                  ),
                  heightBox16,
                  TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: grade.toString(),
                    validator: _checkNullValiate,
                    decoration: _decorateWithLabel(gradeLabel),
                    onSaved: (value) => grade = int.parse(value!),
                  ),
                  heightBox16,
                  TextFormField(
                    initialValue: gender,
                    validator: _checkNullValiate,
                    decoration: _decorateWithLabel(genderLabel),
                    onSaved: (value) => gender = value!,
                  ),
                  heightBox16,
                  TextFormField(
                    controller: dateController,
                    validator: _checkNullValiate,
                    readOnly: true,
                    decoration: _decorateWithLabel(birthDayLabel).copyWith(
                      suffixIcon: InkWell(
                        onTap: _pickDate,
                        child: const Icon(
                          Icons.calendar_month,
                          color: Colors.indigo,
                        ),
                      ),
                    ),
                  ),
                  heightBox16,
                  TextFormField(
                    initialValue: city,
                    validator: _checkNullValiate,
                    decoration: _decorateWithLabel(cityLabel),
                    onSaved: (value) => city = value!,
                  ),
                  heightBox16,
                  TextFormField(
                    initialValue: district,
                    validator: _checkNullValiate,
                    decoration: _decorateWithLabel(districtLabel),
                    onSaved: (value) => district = value!,
                  ),
                  heightBox16,
                  TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: '$longitude, $latitude',
                    validator: _checkNullValiate,
                    decoration: _decorateWithLabel(locationLabel),
                    onSaved: (value) {
                      longitude = double.parse(value!.split(',').first);
                      latitude = double.parse(value.split(',').last);
                    },
                  ),
                  heightBox16,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => context.pop(),
                        child: const Text(cancelLabel),
                      ),
                      widthBox16,
                      ElevatedButton(
                        onPressed: () => _submit(context),
                        child: const Text(updateLabel),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
