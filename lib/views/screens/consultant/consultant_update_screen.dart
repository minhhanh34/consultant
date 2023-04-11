import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consultant/cubits/auth/auth_cubit.dart';
import 'package:consultant/cubits/consultant_cubits/consultant_home/consultant_home_cubit.dart';
import 'package:consultant/models/address_model.dart';
import 'package:consultant/models/consultant_model.dart';
import 'package:consultant/models/subject_model.dart';
import 'package:consultant/views/components/search_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ConsultantUpdateScreen extends StatefulWidget {
  const ConsultantUpdateScreen({super.key});

  @override
  State<ConsultantUpdateScreen> createState() => _ConsultantUpdateScreenState();
}

class _ConsultantUpdateScreenState extends State<ConsultantUpdateScreen> {
  final _key = GlobalKey<FormState>();
  final space16 = const SizedBox(height: 16.0);
  late final TextEditingController dateOfBirthTextController;

  final dropDownMenuItems = const [
    DropdownMenuItem(
      value: Gender.male,
      child: Text('Nam'),
    ),
    DropdownMenuItem(
      value: Gender.female,
      child: Text('Nữ'),
    ),
  ];
  final subjectAreaFields = <Widget>[];

  String name = '';
  String tel = '';
  DateTime? dateOfBirth;
  String? gender = '';
  String city = '';
  String district = '';
  double? longtitude;
  double? lattitude;
  List<Subject> subjects = [];
  int subjectCount = 1;
  String? checkNullValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Không được bỏ trống';
    }
    return null;
  }

  List<String> timeOnClass = [];
  List<String> subjectNames = [];
  List<String> grades = [];
  List<String> durations = [];
  List<String> prices = [];
  List<List<Map>> weekDaysList = [];

  List<Map> createNewDayCheckBoxs() {
    return [
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
  }

  @override
  void initState() {
    super.initState();
    dateOfBirthTextController = TextEditingController();
    weekDaysList.insert(0, createNewDayCheckBoxs());
  }

  @override
  void dispose() {
    dateOfBirthTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Cập nhật thông tin'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: decorationWithLabel('Họ tên'),
                  validator: (value) {
                    return checkNullValidation(value);
                  },
                  onSaved: (newValue) => name = newValue ?? name,
                ),
                space16,
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: decorationWithLabel('Số điện thoại'),
                  onSaved: (newValue) {
                    tel = newValue ?? tel;
                  },
                  validator: (value) {
                    final msg = checkNullValidation(value);
                    if (msg != null) {
                      return msg;
                    }
                    if (value?.length != 10) {
                      return 'Số điện thoại không hợp lệ';
                    }
                    return null;
                  },
                ),
                space16,
                TextFormField(
                  controller: dateOfBirthTextController,
                  readOnly: true,
                  validator: (value) {
                    return checkNullValidation(value);
                  },
                  decoration: decorationWithLabel('Ngày sinh').copyWith(
                    suffixIcon: InkWell(
                      onTap: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        dateOfBirth = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now(),
                        );
                        if (dateOfBirth != null) {
                          dateOfBirthTextController.text =
                              DateFormat('dd/MM/yyyy').format(dateOfBirth!);
                        }
                      },
                      child: const Icon(Icons.calendar_month),
                    ),
                  ),
                ),
                space16,
                DropdownButtonFormField(
                  items: dropDownMenuItems,
                  onChanged: (value) {},
                  validator: (value) {
                    if (value == null) {
                      return 'không được bỏ trống';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    if (newValue == Gender.male) {
                      gender = 'Nam';
                    }
                    if (newValue == Gender.female) {
                      gender = 'Nữ';
                    }
                  },
                  decoration: decorationWithLabel('Giới tính'),
                ),
                space16,
                TextFormField(
                  decoration: decorationWithLabel('Thành phố/tỉnh'),
                  onSaved: (newValue) {
                    city = newValue ?? city;
                  },
                ),
                space16,
                TextFormField(
                  decoration: decorationWithLabel('Quận/huyện'),
                  onSaved: (newValue) {
                    district = newValue ?? district;
                  },
                ),
                space16,
                TextFormField(
                  decoration:
                      decorationWithLabel('Vị trí trên bản đồ').copyWith(
                    suffixIcon: InkWell(
                      onTap: () {},
                      child: const Icon(Icons.location_on),
                    ),
                  ),
                  onSaved: (newValue) {
                    final lngLat = newValue?.split(',');
                    if (lngLat != null) {
                      longtitude = double.tryParse(lngLat.first);
                      lattitude = double.tryParse(lngLat.last);
                    }
                  },
                ),
                for (int i = 0; i < subjectCount; i++)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      space16,
                      Row(
                        children: [
                          Text(
                            'Môn học ${i + 1}',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Visibility(
                            visible: i != 0,
                            child: IconButton(
                              onPressed: () {
                                if (subjectCount > 1) {
                                  setState(() {
                                    subjectCount--;
                                    weekDaysList.removeAt(i);
                                  });
                                }
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                      space16,
                      TextFormField(
                        decoration: decorationWithLabel('Tên môn học'),
                        onSaved: (newValue) {
                          if (newValue != null) {
                            subjectNames.insert(i, newValue);
                          }
                        },
                        validator: (value) {
                          return checkNullValidation(value);
                        },
                      ),
                      space16,
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: decorationWithLabel('Lớp'),
                        onSaved: (newValue) {
                          if (newValue != null) {
                            grades.insert(i, newValue);
                          }
                        },
                        validator: (value) {
                          return checkNullValidation(value);
                        },
                      ),
                      space16,
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration:
                            decorationWithLabel('Thời lượng buổi học (phút)'),
                        onSaved: (newValue) {
                          if (newValue != null) {
                            durations.insert(i, newValue);
                          }
                        },
                        validator: (value) {
                          return checkNullValidation(value);
                        },
                      ),
                      space16,
                      TextFormField(
                        validator: (value) {
                          return checkNullValidation(value);
                        },
                        onSaved: (newValue) {
                          if (newValue != null) {
                            timeOnClass.insert(i, newValue);
                          }
                        },
                        decoration: decorationWithLabel('Giờ lên lớp'),
                      ),
                      space16,
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: decorationWithLabel('Giá'),
                        onSaved: (newValue) {
                          if (newValue != null) {
                            prices.insert(i, newValue);
                          }
                        },
                        validator: (value) {
                          return checkNullValidation(value);
                        },
                      ),
                      space16,
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'Buổi học',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Wrap(
                        spacing: 2,
                        children: [
                          for (int j = 0; j < 7; j++)
                            Column(
                              children: [
                                Text(weekDaysList[i][j]['title']),
                                Checkbox(
                                  value: weekDaysList[i][j]['value'],
                                  onChanged: (value) {
                                    setState(() {
                                      if (value != null) {
                                        weekDaysList[i][j]['value'] = value;
                                      }
                                    });
                                  },
                                ),
                              ],
                            )
                        ],
                      ),
                    ],
                  ),
                space16,
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  onTap: () {
                    setState(() {
                      subjectCount++;
                      weekDaysList.insert(
                        subjectCount - 1,
                        createNewDayCheckBoxs(),
                      );
                    });
                  },
                  minLeadingWidth: 8.0,
                  leading: const Icon(Icons.add),
                  title: const Text('Thêm môn học'),
                ),
                space16,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      bool valid = _key.currentState?.validate() ?? false;
                      if (!valid) return;
                      _key.currentState?.save();
                      for (int k = 0; k < subjectCount; k++) {
                        final subject = Subject(
                          name: subjectNames[k],
                          grade: int.parse(grades[k]),
                          weekDays: weekDaysList[k]
                              .where((element) {
                                return element['value'] == true;
                              })
                              .map((e) => e['weekDays'] as int)
                              .toList(),
                          duration: int.parse(durations[k]),
                          price: double.parse(prices[k]),
                          time: timeOnClass[k],
                        );
                        subjects.add(subject);
                      }
                      final consultant = Consultant(
                        uid: AuthCubit.uid!,
                        address: Address(
                          city: city,
                          district: district,
                          geoPoint: GeoPoint(lattitude!, longtitude!),
                        ),
                        birthDay: dateOfBirth,
                        gender: gender!,
                        name: name,
                        phone: tel,
                        subjects: subjects,
                      );
                      context.read<ConsultantHomeCubit>().updateConsultantInfo(
                          AuthCubit.currentUserId!, consultant);
                      context.pop();
                    },
                    child: const Text('Cập nhật'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration decorationWithLabel(String label) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      labelText: label,
      border: const OutlineInputBorder(),
    );
  }
}

