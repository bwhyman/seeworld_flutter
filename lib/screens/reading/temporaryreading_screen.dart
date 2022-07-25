import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeworld_flutter/constants/Theme.dart';
import 'package:seeworld_flutter/provider/dialog_provider.dart';
import 'package:seeworld_flutter/provider/ocr_provider.dart';
import 'package:seeworld_flutter/components/logger_utils.dart';
import 'package:seeworld_flutter/provider/tts_provider.dart';
import 'package:seeworld_flutter/provider/widget_provider.dart';

class TemporaryReadingScreen extends StatefulWidget {
  static const name = '/TemporaryReadingScreen';
  final String imagePath;
  const TemporaryReadingScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TemporaryReadingScreenState();
}

class _TemporaryReadingScreenState extends State<TemporaryReadingScreen> {
  final DialogProvider _dialogController = Get.put(DialogProvider());
  final WidgetProvider _widgetProvider = Get.put(WidgetProvider());
  final TtsProvider _ttsProvider = Get.put(TtsProvider());
  final _msg = ''.obs;
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
    _msg.value = result.isEmpty ? '对不起，请重新尝试' : result;
    _ttsProvider.speakContent(_msg.value);
    Get.back();
  }


  @override
  void dispose() {
    _ttsProvider.getTts().stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: _widgetProvider.getTitleAppbar('临时阅读'),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Obx(() => Text(
          _msg.value,
          style: const TextStyle(fontSize: UI.newsContentFontSize),
        )),
      ),
    );
  }
}