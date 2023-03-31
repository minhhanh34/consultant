import 'package:camera/camera.dart';
import 'package:consultant/models/class_model.dart';
import 'package:consultant/views/components/center_circular_indicator.dart';
import 'package:consultant/views/components/file_attach_chip.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../cubits/consultant_cubits/consultant_class/class_cubit.dart';
import '../../../models/exercise_model.dart';
import '../../../services/firebase_storage_service.dart';

class ExerciseAdditionBottomSheet extends StatefulWidget {
  const ExerciseAdditionBottomSheet(
      {super.key, required this.classRoom, required this.scaffoldKey});
  final Class classRoom;
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  State<ExerciseAdditionBottomSheet> createState() =>
      _ExerciseAdditionBottomSheetState();
}

class _ExerciseAdditionBottomSheetState
    extends State<ExerciseAdditionBottomSheet> {
  FilePickerResult? filePickerResult;
  late TextEditingController _textController;
  bool submissionEnabled = false;
  bool loading = false;
  DateTime dateDeadLine = DateTime.now();
  TimeOfDay timeDeadLine = TimeOfDay.now();
  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (loading) {
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: const CenterCircularIndicator(),
        );
      }
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Bài tập mới',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black),
                ),
              ),
              ListTile(
                isThreeLine: true,
                title: TextField(
                  controller: _textController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: const OutlineInputBorder(),
                    suffixIcon: InkWell(
                      onTap: () async {
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          context: context,
                          builder: (context) {
                            return Container(
                              margin: const EdgeInsets.all(16),
                              height: 120.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      List<CameraDescription> cameras =
                                          await availableCameras();
                                      if (!mounted) return;
                                      context.push('/Camera', extra: cameras);
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                          await FilePicker.platform.pickFiles(
                                        allowMultiple: true,
                                      );
                                      if (!mounted) return;
                                      context.pop();
                                      setState(() {});
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                          },
                        );
                      },
                      child: const Icon(Icons.link),
                    ),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: filePickerResult != null,
                      child: Wrap(
                        children: [
                          for (int i = 0;
                              i < (filePickerResult?.names.length ?? 0);
                              i++)
                            FileAttachChip(
                              onRemove: () {
                                if (filePickerResult?.count == 0) {
                                  filePickerResult = null;
                                }
                                setState(() {});
                              },
                              name: filePickerResult?.names[i] ?? '',
                            )
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      title: const Text('Nộp bài'),
                      trailing: Switch.adaptive(
                        value: submissionEnabled,
                        onChanged: (value) {
                          setState(() {
                            submissionEnabled = value;
                          });
                        },
                      ),
                    ),
                    Visibility(
                      visible: submissionEnabled,
                      child: ListTile(
                        leading: const Text(
                          'Hạn nộp',
                          style: TextStyle(fontSize: 16),
                        ),
                        title: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            DateFormat('dd/MM - hh:mm').format(dateDeadLine),
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () async {
                            dateDeadLine = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2025, 12, 12),
                                ) ??
                                dateDeadLine;
                            if (!mounted) return;
                            timeDeadLine = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ) ??
                                timeDeadLine;
                            dateDeadLine = dateDeadLine.copyWith(
                              hour: timeDeadLine.hour,
                              minute: timeDeadLine.minute,
                            );
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.calendar_month,
                            color: Colors.indigo,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            context.pop();
                          },
                          child: const Text('Hủy'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            widget.scaffoldKey.currentState?.setState(() {
                              loading = true;
                            });
                            List<FileName> fileNames = [];
                            final storageService = FirebaseStorageService();
                            if (filePickerResult != null) {
                              fileNames =
                                  await storageService.createFolderFiles(
                                'exercises',
                                filePickerResult!.paths,
                              );
                            }

                            if (!mounted) return;

                            for (int i = 0; i < fileNames.length; i++) {
                              fileNames[i] = fileNames[i].copyWith(
                                name: filePickerResult?.names[i] ?? '',
                              );
                            }
                            await context.read<ClassCubit>().createExercise(
                                  widget.classRoom.id!,
                                  Exercise(
                                    submissionEnabled: submissionEnabled,
                                    title: _textController.text,
                                    timeCreated: DateTime.now(),
                                    fileNames: fileNames,
                                    timeIsUp:
                                        submissionEnabled ? dateDeadLine : null,
                                  ),
                                );
                            if (!mounted) return;
                            widget.scaffoldKey.currentContext?.pop();
                          },
                          child: const Text('Thêm'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
