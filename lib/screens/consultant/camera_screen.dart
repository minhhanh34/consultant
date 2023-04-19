import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key, required this.cameras});
  final List<CameraDescription> cameras;
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  late CameraController _controller;
  // late Future<void> _initializeCameraFuture;
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addObserver(this);
  //   _controller = CameraController(widget.cameras[0], ResolutionPreset.max);
  //   _initializeCameraFuture = _controller.initialize().then((value) {
  //     if (!mounted) return;
  //     setState(() {});
  //   }).catchError((error) {});
  // }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   final CameraController? cameraController = _controller;
  //   if (cameraController == null || !cameraController.value.isInitialized) {
  //     return;
  //   }
  //   if (state == AppLifecycleState.inactive) {
  //     cameraController.dispose();
  //   } else if (state == AppLifecycleState.resumed) {
  //     return;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return CameraPreview(
      _controller,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        verticalDirection: VerticalDirection.up,
        children: [
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () async {
              // try {
              //   await _initializeCameraFuture;
              //   final XFile file = await _controller.takePicture();
              // } catch (e) {
              //   print(e);
              // }
            },
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 56.0,
                height: 56.0,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => context.pop(),
            child: const Padding(
              padding: EdgeInsets.fromLTRB(16, 32, 0, 0),
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
