import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeworld_flutter/components/logger_utils.dart';
import 'package:seeworld_flutter/constants/Theme.dart';
import 'package:seeworld_flutter/controller/book_controller.dart';
import 'package:seeworld_flutter/provider/entity.dart';
import 'package:seeworld_flutter/provider/floatingbutton_provider.dart';
import 'package:seeworld_flutter/provider/widget_provider.dart';
import 'package:seeworld_flutter/provider/dialog_provider.dart';
import 'package:seeworld_flutter/provider/ocr_provider.dart';
import 'package:seeworld_flutter/provider/tts_provider.dart';
import 'package:seeworld_flutter/screens/reading/camera_screen.dart';

class ChapterScreen extends StatefulWidget {
  static const name = '/ChapterScreen';

  const ChapterScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  final WidgetProvider _widgetProvider = Get.put(WidgetProvider());
  final DialogProvider _dialogController = Get.put(DialogProvider());
  final BookController _bookController = Get.put(BookController());
  final OcrProvider _ocrProvider = Get.put(OcrProvider());
  final TextEditingController _editingController = TextEditingController();
  final TtsProvider _ttsProvider = Get.put(TtsProvider());
  final FloatingButtonProvider _floatingButtonProvider =
      Get.put(FloatingButtonProvider());
  final _chapter = Chapter(title: '', content: '').obs;
  final _isEdit = false.obs;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _chapter.value = Get.arguments as Chapter;
    _ttsProvider.speakContent(_chapter.value.content ?? '');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation:
          _floatingButtonProvider.getFloatingActionButtonLocation(),
      floatingActionButton: _floatingButtonProvider.getFloatingRecordButton(),
      appBar: _widgetProvider.getTitleAppbar(_chapter.value.title ?? '', items: [
        Obx(() {
          List<Widget> items = [
            _widgetProvider.getIconButton(
                !_isEdit.value
                    ? Icons.edit_note_outlined
                    : Icons.edit_off_outlined, onPressed: () {
              _isEdit.value = !_isEdit.value;
              _editingController.value =
                  _editingController.value.copyWith(text: _chapter.value.content);
            })
          ];
          if (_isEdit.value) {
            _ttsProvider.getTts().stop();
            items.add(_widgetProvider.getIconButton(
                Icons.document_scanner_outlined,
                onPressed: _camera));
            items.add(_widgetProvider.getIconButton(Icons.check,
                onPressed: _updateChapter));
          }
          return Row(children: items);
        })
      ]),
      body: GestureDetector(
        onDoubleTap: () => _ttsProvider.getTts().stop(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() => !_isEdit.value
              ? ListView(
                  shrinkWrap: true,
                  children: [
                    Text(
                      _chapter.value.content ?? '',
                      style: const TextStyle(fontSize: UI.newsContentFontSize),
                    )
                  ],
                )
              : Column(
                  children: [
                    Expanded(
                      child: TextFormField(
                        style: const TextStyle(
                            color: Colors.redAccent, fontSize: 18),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: _editingController,
                      ),
                    ),
                  ],
                )),
        ),
      ),
    );
  }

  _camera() async {
    _ttsProvider.getTts().stop();
    var imagePath = await Get.toNamed(CameraScreen.name, arguments: false);
    if (imagePath == null) {
      return;
    }
    _dialogController.showFullDialog('');
    String result = await _ocrProvider.send(imagePath);
    String r = _editingController.value.text + result;
    _editingController.value = _editingController.value.copyWith(text: r);
    _chapter.value.content = _editingController.value.text;
    Get.back();
  }

  _updateChapter() async {
    _chapter.value.content = _editingController.value.text;
    _ttsProvider.speakContent(_editingController.value.text);
    await _bookController.updateChapter(_chapter.value);
    _isEdit.value = false;
  }

  @override
  void dispose() {
    _editingController.dispose();
    _ttsProvider.getTts().stop();
    super.dispose();
  }
}
