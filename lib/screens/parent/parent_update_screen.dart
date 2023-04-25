import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consultant/constants/consts.dart';
import 'package:consultant/cubits/auth/auth_cubit.dart';
import 'package:consultant/cubits/settings/settings_cubit.dart';
import 'package:consultant/models/address_model.dart';
import 'package:consultant/models/exercise_model.dart';
import 'package:consultant/models/parent_model.dart';
import 'package:consultant/services/firebase_storage_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ParentUpdateScreen extends StatefulWidget {
  const ParentUpdateScreen({super.key, this.parent});
  final Parent? parent;
  @override
  State<ParentUpdateScreen> createState() => _ParentUpdateScreenState();
}

class _ParentUpdateScreenState extends State<ParentUpdateScreen> {
  final _key = GlobalKey<FormState>();

  final height16 = const SizedBox(height: 16.0);

  FilePickerResult? filePickerResult;

  String? name;
  String? email;
  String? tel;
  String? city;
  String? district;
  String? latitude;
  String? longitude;

  String? checkNullValidation(String? text) {
    if (text == null || text.isEmpty) {
      return 'Không được bỏ trống';
    }
    return null;
  }

  bool avatarChanged = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Cập nhật thông tin'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _key,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height16,
                TextFormField(
                  initialValue: widget.parent?.name,
                  decoration: decorationWithLabel('Tên'),
                  validator: checkNullValidation,
                  onSaved: (value) => name = value,
                ),
                height16,
                TextFormField(
                  initialValue: widget.parent?.email,
                  decoration: decorationWithLabel('Email'),
                  validator: checkNullValidation,
                  onSaved: (value) => email = value,
                ),
                height16,
                TextFormField(
                  initialValue: widget.parent?.phone,
                  decoration: decorationWithLabel('Số điện thoại'),
                  validator: checkNullValidation,
                  onSaved: (value) => tel = value,
                ),
                height16,
                TextFormField(
                  initialValue: widget.parent?.address.city,
                  decoration: decorationWithLabel('Thành phố/Tỉnh'),
                  validator: checkNullValidation,
                  onSaved: (value) => city = value,
                ),
                height16,
                TextFormField(
                  initialValue: widget.parent?.address.district,
                  decoration: decorationWithLabel('Quận/huyện'),
                  validator: checkNullValidation,
                  onSaved: (value) => district = value,
                ),
                height16,
                TextFormField(
                  initialValue:
                      '${widget.parent?.address.geoPoint.latitude}, ${widget.parent?.address.geoPoint.longitude}',
                  decoration: decorationWithLabel('Vị trí trên bản đồ'),
                  validator: checkNullValidation,
                  onSaved: (value) {
                    if (value != null) {
                      latitude = value.split(',').first;
                      longitude = value.split(',').last;
                    }
                  },
                ),
                height16,
                Text(
                  'Ảnh đại diện',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                height16,
                InkWell(
                  onTap: () {
                    builder(BuildContext context) => Container(
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
                                  final imagePicker = ImagePicker();
                                  final xFile = await imagePicker.pickImage(
                                    source: ImageSource.camera,
                                    preferredCameraDevice: CameraDevice.rear,
                                    imageQuality: 9,
                                  );
                                  if (xFile != null) {
                                    Uint8List bytes = await xFile.readAsBytes();
                                    final platformFile = PlatformFile(
                                      path: xFile.path,
                                      name: xFile.name,
                                      size: bytes.elementSizeInBytes,
                                    );
                                    filePickerResult?.files.add(platformFile);
                                    filePickerResult?.paths.add(xFile.path);
                                    setState(() {
                                      avatarChanged = true;
                                    });
                                  }
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
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  try {
                                    filePickerResult =
                                        await FilePicker.platform.pickFiles();
                                    if (!mounted) return;
                                    GoRouter.of(context).pop();
                                    setState(() {
                                      avatarChanged = true;
                                    });
                                  } catch (e) {
                                    log('error', error: e);
                                  }
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
                        if (widget.parent != null &&
                            widget.parent?.avtPath != defaultAvtPath &&
                            !avatarChanged) {
                          return CachedNetworkImage(
                            imageUrl: widget.parent!.avtPath,
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
                height16,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      bool valid = _key.currentState?.validate() ?? false;
                      if (!valid) return;
                      _key.currentState?.save();

                      List<FileName>? fileNames;
                      if (filePickerResult != null &&
                          filePickerResult!.files.isNotEmpty) {
                        final storage = FirebaseStorageServiceIml();
                        fileNames = await storage.createFolderFiles(
                          'avatars',
                          filePickerResult!.paths,
                        );
                      }

                      final parent = Parent(
                        uid: AuthCubit.uid!,
                        name: name!,
                        phone: tel!,
                        email: email!,
                        address: Address(
                          city: city!,
                          district: district!,
                          geoPoint: GeoPoint(
                            double.parse(latitude!),
                            double.parse(longitude!),
                          ),
                        ),
                        avtPath: getAvtPath(fileNames),
                      );
                      if (!mounted) return;
                      context.read<SettingsCubit>().updateParentInfo(
                            AuthCubit.currentUserId!,
                            parent,
                          );
                      context.pop();
                    },
                    child: const Text('Cập nhật'),
                  ),
                ),
                height16,
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getAvtPath(List<FileName>? fileNames) {
    if (fileNames != null) {
      return fileNames.first.url;
    }
    if (widget.parent != null) {
      return widget.parent!.avtPath;
    }
    return defaultAvtPath;
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
