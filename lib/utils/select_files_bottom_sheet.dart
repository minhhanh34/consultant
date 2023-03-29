
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SelectFilesBottomSheet {
  static Future<FilePickerResult?> select(BuildContext context) async {
    FilePickerResult? filePickerResult;

    await showModalBottomSheet(
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () async {
                  final router = GoRouter.of(context);
                  List<CameraDescription> cameras = await availableCameras();
                  router.push('/Camera', extra: cameras);
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
                  final router = GoRouter.of(context);
                  filePickerResult = await FilePicker.platform.pickFiles(
                    allowMultiple: true,
                  );
                  router.pop();
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
      },
    );
    return filePickerResult;
  }
}
