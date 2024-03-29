import 'dart:core';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consultant/cubits/auth/auth_cubit.dart';
import 'package:consultant/cubits/consultant_settings/consultant_settings_cubit.dart';
import 'package:consultant/models/consultant_model.dart';
import 'package:consultant/models/subject_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../constants/consts.dart';
import '../../constants/gender_types.dart';
import '../../models/exercise_model.dart';
import '../../services/firebase_storage_service.dart';

class ConsultantUpdateScreen extends StatefulWidget {
  const ConsultantUpdateScreen({
    super.key,
    this.consultant,
    this.isFirstUpdate = false,
  });
  final Consultant? consultant;
  final bool isFirstUpdate;
  @override
  State<ConsultantUpdateScreen> createState() => _ConsultantUpdateScreenState();
}

class _ConsultantUpdateScreenState extends State<ConsultantUpdateScreen> {
  final _key = GlobalKey<FormState>();
  final space16 = const SizedBox(height: 16.0);
  late final TextEditingController dateOfBirthTextController;

  late Consultant consultant;

  FilePickerResult? filePickerResult;
  bool avatarChanged = false;
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

  String? checkNullValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Không được bỏ trống';
    }
    return null;
  }

  late List<List<Map>> weekDaysList = [];

  List<Map> createNewDayCheckBoxs(Subject? subject) {
    return [
      {
        'weekDays': 0,
        'title': 'T2',
        'value': subject?.weekDays.contains(0) ?? false,
      },
      {
        'weekDays': 1,
        'title': 'T3',
        'value': subject?.weekDays.contains(1) ?? false,
      },
      {
        'weekDays': 2,
        'title': 'T4',
        'value': subject?.weekDays.contains(2) ?? false,
      },
      {
        'weekDays': 3,
        'title': 'T5',
        'value': subject?.weekDays.contains(3) ?? false,
      },
      {
        'weekDays': 4,
        'title': 'T6',
        'value': subject?.weekDays.contains(4) ?? false,
      },
      {
        'weekDays': 5,
        'title': 'T7',
        'value': subject?.weekDays.contains(5) ?? false,
      },
      {
        'weekDays': 6,
        'title': 'CN',
        'value': subject?.weekDays.contains(6) ?? false,
      },
    ];
  }

  Gender? valueForGender() {
    if (consultant.gender.toLowerCase() == 'nam') {
      return Gender.male;
    } else {
      return Gender.female;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.consultant != null) {
      consultant = widget.consultant!.copyWith();
      consultant.subjects.asMap().forEach((index, subject) {
        weekDaysList.insert(index, createNewDayCheckBoxs(subject));
      });
    } else {
      consultant = Consultant(uid: AuthCubit.uid!);
      weekDaysList.insert(0, createNewDayCheckBoxs(null));
    }
    dateOfBirthTextController = TextEditingController(
      text: DateFormat('dd/MM/yyyy')
          .format(consultant.birthDay ?? DateTime.now()),
    );
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
                  initialValue: consultant.name,
                  decoration: decorationWithLabel('Họ tên'),
                  validator: (value) {
                    return checkNullValidation(value);
                  },
                  onSaved: (newValue) =>
                      consultant = consultant.copyWith(name: newValue),
                ),
                space16,
                TextFormField(
                  initialValue: consultant.phone,
                  keyboardType: TextInputType.number,
                  decoration: decorationWithLabel('Số điện thoại'),
                  onSaved: (newValue) {
                    consultant = consultant.copyWith(phone: newValue);
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
                        final dateOfBirth = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now(),
                        );
                        if (dateOfBirth != null) {
                          dateOfBirthTextController.text =
                              DateFormat('dd/MM/yyyy').format(dateOfBirth);
                        }
                      },
                      child: const Icon(Icons.calendar_month),
                    ),
                  ),
                ),
                space16,
                DropdownButtonFormField<Gender>(
                  value: valueForGender(),
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
                      consultant = consultant.copyWith(gender: 'Nam');
                    }
                    if (newValue == Gender.female) {
                      consultant = consultant.copyWith(gender: 'Nữ');
                    }
                  },
                  decoration: decorationWithLabel('Giới tính'),
                ),
                space16,
                TextFormField(
                  initialValue: consultant.address.city,
                  decoration: decorationWithLabel('Thành phố/tỉnh'),
                  onSaved: (newValue) {
                    consultant = consultant.copyWith(
                        address: consultant.address.copyWith(city: newValue));
                  },
                ),
                space16,
                TextFormField(
                  initialValue: consultant.address.district,
                  decoration: decorationWithLabel('Quận/huyện'),
                  onSaved: (newValue) {
                    consultant = consultant.copyWith(
                        address:
                            consultant.address.copyWith(district: newValue));
                  },
                ),
                space16,
                TextFormField(
                  initialValue:
                      '${consultant.address.geoPoint.latitude}, ${consultant.address.geoPoint.longitude}',
                  decoration:
                      decorationWithLabel('Vị trí trên bản đồ').copyWith(
                    suffixIcon: InkWell(
                      onTap: () {},
                      child: const Icon(Icons.location_on),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (newValue) {
                    final lngLat = newValue?.split(',');
                    if (lngLat != null) {
                      final latitude = double.tryParse(lngLat.first);
                      final longitude = double.tryParse(lngLat.last);
                      if (latitude != null && longitude != null) {
                        consultant = consultant.copyWith(
                            address: consultant.address.copyWith(
                                geoPoint: GeoPoint(latitude, longitude)));
                      }
                    }
                  },
                ),
                space16,
                Text(
                  'Ảnh đại diện',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                space16,
                InkWell(
                  onTap: () {
                    builder(context) => Container(
                          margin: const EdgeInsets.all(16),
                          height: 120.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () async {
                                  List<CameraDescription> cameras =
                                      await availableCameras();
                                  if (!mounted) return;
                                  context.push('/Camera', extra: cameras);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.camera_alt, size: 32),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Máy ảnh',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  filePickerResult =
                                      await FilePicker.platform.pickFiles();
                                  if (!mounted) return;
                                  GoRouter.of(context).pop();
                                  setState(() {
                                    avatarChanged = true;
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.file_upload, size: 32),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Tải lên',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: builder,
                    );
                  },
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Builder(
                      builder: (context) {
                        if (consultant.avtPath != null &&
                            consultant.avtPath != defaultAvtPath &&
                            !avatarChanged) {
                          return CachedNetworkImage(
                            imageUrl: consultant.avtPath!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) {
                              return Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.white,
                                ),
                                child: const Center(
                                  child: Icon(Icons.image),
                                ),
                              );
                            },
                          );
                        }
                        if (filePickerResult?.files.isEmpty ?? true) {
                          return const Icon(Icons.add);
                        }
                        return Image.file(
                          File(filePickerResult!.files.first.path!),
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
                space16,
                for (int i = 0; i < consultant.subjects.length; i++)
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
                                if (consultant.subjects.length > 1) {
                                  setState(() {
                                    weekDaysList.removeAt(i);
                                    consultant.subjects.removeAt(i);
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
                        initialValue: consultant.subjects[i].name,
                        decoration: decorationWithLabel('Tên môn học'),
                        onSaved: (newValue) {
                          if (newValue != null) {
                            consultant.subjects[i] =
                                consultant.subjects[i].copyWith(name: newValue);
                          }
                        },
                        validator: (value) {
                          return checkNullValidation(value);
                        },
                      ),
                      space16,
                      TextFormField(
                        initialValue: consultant.subjects[i].grade.toString(),
                        keyboardType: TextInputType.number,
                        decoration: decorationWithLabel('Lớp'),
                        onSaved: (newValue) {
                          if (newValue != null) {
                            final grade = int.tryParse(newValue);
                            if (grade != null) {
                              consultant.subjects[i] =
                                  consultant.subjects[i].copyWith(grade: grade);
                            }
                          }
                        },
                        validator: (value) {
                          final result = checkNullValidation(value);
                          if (result != null) {
                            return result;
                          }
                          if (int.tryParse(value!) == null) {
                            return 'không hợp lệ';
                          }
                          return null;
                        },
                      ),
                      space16,
                      TextFormField(
                        initialValue:
                            consultant.subjects[i].duration.toString(),
                        keyboardType: TextInputType.number,
                        decoration:
                            decorationWithLabel('Thời lượng buổi học (phút)'),
                        onSaved: (newValue) {
                          if (newValue != null) {
                            final duration = int.tryParse(newValue);
                            if (duration != null) {
                              consultant.subjects[i] = consultant.subjects[i]
                                  .copyWith(duration: duration);
                            }
                          }
                        },
                        validator: (value) {
                          final result = checkNullValidation(value);
                          if (result != null) {
                            return result;
                          }
                          if (int.tryParse(value!) == null) {
                            return 'không hợp lệ';
                          }
                          return null;
                        },
                      ),
                      space16,
                      TextFormField(
                        initialValue: consultant.subjects[i].time,
                        validator: (value) {
                          return checkNullValidation(value);
                        },
                        onSaved: (newValue) {
                          if (newValue != null) {
                            consultant.subjects[i] =
                                consultant.subjects[i].copyWith(time: newValue);
                          }
                        },
                        decoration: decorationWithLabel('Giờ lên lớp'),
                      ),
                      space16,
                      TextFormField(
                        initialValue:
                            consultant.subjects[i].price.toInt().toString(),
                        keyboardType: TextInputType.number,
                        decoration: decorationWithLabel('Giá'),
                        onSaved: (newValue) {
                          if (newValue != null) {
                            final price = double.tryParse(newValue);
                            if (price != null) {
                              consultant.subjects[i] =
                                  consultant.subjects[i].copyWith(price: price);
                            }
                          }
                        },
                        validator: (value) {
                          final result = checkNullValidation(value);
                          if (result != null) {
                            return result;
                          }
                          if (double.tryParse(value!) == null) {
                            return 'không hợp lệ';
                          }
                          return null;
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
                                        List<int> weekDays = [];
                                        for (var weekDay in weekDaysList[i]) {
                                          if (weekDay['value'] == true) {
                                            weekDays.add(weekDay['weekDays']);
                                          }
                                        }
                                        consultant.subjects[i] =
                                            consultant.subjects[i].copyWith(
                                          weekDays: weekDays,
                                        );
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
                      consultant.subjects.add(
                        const Subject(
                          name: '',
                          grade: 0,
                          weekDays: [],
                          duration: 0,
                          price: 0,
                          time: '6h',
                        ),
                      );
                      // subjectCount++;
                      weekDaysList.insert(
                        consultant.subjects.length - 1,
                        createNewDayCheckBoxs(null),
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
                    onPressed: () async {
                      bool valid = _key.currentState?.validate() ?? false;
                      if (!valid) return;
                      _key.currentState?.save();
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const AlertDialog(
                            title: Text('Đang cập nhật'),
                            content: SizedBox(
                              width: 40,
                              height: 40,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          );
                        },
                      );
                      List<FileName>? fileNames;
                      if (filePickerResult != null &&
                          filePickerResult!.files.isNotEmpty) {
                        final storage = FirebaseStorageServiceIml();
                        fileNames = await storage.createFolderFiles(
                          'avatars',
                          filePickerResult!.paths,
                        );
                      }
                      consultant = consultant.copyWith(
                        avtPath: fileNames?.first.url,
                      );

                      // for (int k = 0; k < weekDaysList.length; k++) {
                      //   final subject = Subject(
                      //     name: consultant.subjects[k].name,
                      //     grade: int.parse(
                      //         consultant.subjects[k].grade.toString()),
                      //     weekDays: weekDaysList[k]
                      //         .where((element) {
                      //           return element['value'] == true;
                      //         })
                      //         .map((e) => e['weekDays'] as int)
                      //         .toList(),
                      //     duration: int.parse(
                      //         consultant.subjects[k].duration.toString()),
                      //     price: double.parse(
                      //         consultant.subjects[k].price.toString()),
                      //     time: consultant.subjects[k].time,
                      //   );
                      //   consultant.subjects.add(subject);
                      // }
                      // consultant = consultant.copyWith(
                      //   avtPath: getAvtPath(fileNames),
                      // );

                      if (!mounted) return;
                      await context
                          .read<ConsultantSettingsCubit>()
                          .updateConsultantInfo(
                              AuthCubit.currentUserId!, consultant);
                      if (!mounted) return;
                      context.pop();
                      if (widget.isFirstUpdate) {
                        context.go('/ConsultantHome');
                      } else {
                        context.pop();
                      }
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

  String getAvtPath(List<FileName>? fileNames) {
    if (fileNames != null) {
      return fileNames.first.url;
    }
    if (consultant.avtPath != null) {
      return consultant.avtPath!;
    }
    return defaultAvtPath;
  }
}
