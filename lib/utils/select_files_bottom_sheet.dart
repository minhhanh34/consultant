import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class SelectFilesBottomSheet {
  static FilePickerResult? filePickerResult;
  static picking() async {
    final imagePicker = ImagePicker();
    final file = await imagePicker.pickImage(source: ImageSource.camera);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    filePickerResult = FilePickerResult([
      PlatformFile(
        path: file.path,
        name: file.name,
        size: bytes.lengthInBytes,
      ),
    ]);
  }

  static Future<FilePickerResult?> select(
      {required BuildContext context, bool withDialog = true}) async {
    if (!withDialog) {
      await picking();
    } else {
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
                    await picking();
                    router.pop();
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
    }
    return filePickerResult;
  }
}
