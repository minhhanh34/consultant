import 'dart:io';

import 'package:badges/badges.dart';
import 'package:camera/camera.dart';
import 'package:consultant/models/class_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class ClassDetail extends StatefulWidget {
  const ClassDetail({Key? key, required this.classRoom}) : super(key: key);
  final Class classRoom;

  @override
  State<ClassDetail> createState() => _ClassDetailState();
}

class _ClassDetailState extends State<ClassDetail>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;

  bool visibleTextField = false;

  FilePickerResult? filePickerResult;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.classRoom.name),
        bottom: TabBar(
          indicatorColor: Colors.orange,
          indicatorWeight: 5,
          controller: _controller,
          tabs: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Bài tập',
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Thành viên',
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Mã lớp: ${widget.classRoom.id}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(text: widget.classRoom.id),
                        );
                        if (!mounted) return;
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            const SnackBar(content: Text('Đã sao chép!')),
                          );
                      },
                      icon: const Icon(Icons.copy),
                    )
                  ],
                ),
              ),
              ListTile(
                onTap: () async {
                  setState(() {
                    visibleTextField = true;
                  });
                  return;
                },
                leading: const Icon(Icons.add_circle),
                title: const Text('Thêm bài tập mới'),
              ),
              Visibility(
                visible: visibleTextField,
                child: ListTile(
                  isThreeLine: true,
                  title: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
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
                    children: [
                      Visibility(
                        visible: filePickerResult != null,
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Stack(
                                children: [
                                  Chip(
                                    padding: const EdgeInsets.all(12),
                                    label:
                                        Text(filePickerResult?.names[0] ?? ''),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: InkWell(
                                      onTap: () {
                                        filePickerResult?.files.removeLast();
                                        if (filePickerResult?.count == 0) {
                                          filePickerResult = null;
                                        }
                                        setState(() {});
                                      },
                                      child: const CircleAvatar(
                                        radius: 12,
                                        child: Icon(Icons.close),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              setState(() {
                                visibleTextField = false;
                                filePickerResult = null;
                                _textController.clear();
                              });
                            },
                            child: const Text('Hủy'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('Thêm'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
