
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CameraChapterScreen extends StatefulWidget {
  static const name = "/CameraChapterScreen";
  final CameraDescription camera;
  const CameraChapterScreen({Key? key, required this.camera}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _CameraChapterScreenState();

}

class _CameraChapterScreenState extends State<CameraChapterScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          elevation: 0.0,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.black,
              statusBarIconBrightness: Brightness.light)),
      backgroundColor: Colors.transparent,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: CameraPreview(_controller),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        height: 95,
        width: 95,
        child: FloatingActionButton(
          onPressed: () async {
            try {
              await _initializeControllerFuture;
              final image = await _controller.takePicture();
              Get.back(result: image.path);
              //await Get.to(DisplayPictureScreen(imagePath: image.path));
            } catch (e) {}
          },
          backgroundColor: Colors.indigoAccent,
          child: const Icon(Icons.camera_alt_outlined, color: Colors.white,size: 50),
        ),
      ),
    );
  }

}