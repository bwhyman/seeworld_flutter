import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:seeworld_flutter/provider/dialog_provider.dart';
import 'package:seeworld_flutter/provider/ocr_provider.dart';
import 'package:seeworld_flutter/components/logger_utils.dart';
import 'package:seeworld_flutter/provider/tts_provider.dart';
import 'package:seeworld_flutter/provider/appbar_provider.dart';

class TakePictureScreen extends StatefulWidget {
  static const name = "/takepicture";
  final CameraDescription camera;

  const TakePictureScreen({Key? key, required this.camera}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
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
              await Get.to(DisplayPictureScreen(imagePath: image.path));
            } catch (e) {}
          },
          backgroundColor: Colors.indigoAccent,
          child: const Icon(Icons.camera_alt_outlined, color: Colors.white,size: 50),
        ),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => DisplayPictureScreenState();
}

class DisplayPictureScreenState extends State<DisplayPictureScreen> {
  final DialogProvider _dialogController = Get.put(DialogProvider());
  final AppBarProvider _appBarProvider = Get.put(AppBarProvider());
  final TtsProvider _ttsProvider = Get.put(TtsProvider());
  String _msg = '';
  final OcrProvider _ocrUtils = Get.put(OcrProvider());
  @override
  void initState() {
    super.initState();
    _send();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _dialogController.showFullDialog('');
    });
  }

  _send() async {
    String result = await _ocrUtils.send(widget.imagePath);
    File(widget.imagePath).deleteSync();
    _msg = result;
    _ttsProvider.getTts().speak(_msg);
    Get.back();
    setState(() {});
    //
  }


  @override
  void dispose() {
    _ttsProvider.getTts().stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: _appBarProvider.getTitleAppbar('临时阅读'),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          _msg,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
